Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAB22264A3;
	Fri,  4 Sep 2026 05:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500553; cv=none; b=tDVcKhJsq3JgEmWK9ny80VOYAE9dTtVlKEkQjXkkYUaIqVgLc314poNpvPf12eiMxHXoRbbrNNjEsmPfofN2maD43R8MZq/9LYffTjo4ZtxjOOTKJawEV9G5HxPWqDcc9RKXAXVIVwQ4KkHT0qA5tflt36exG6d0PdugxsKsn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500553; c=relaxed/simple;
	bh=nBls42ohAMFEUs+w2MdSfqyFbnHjtSctc7x3Iz1BGPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtIW2jVhHBtCdV3QkcSeMQR25NwNSKMuuRk5rGcxy+ci2ayw05m7BzL21qKdXo4zVKQIkkZwSn1q2dimYDk0vy0zmbiG/Qa1ikBO1FqbJ1Pa0sAiqvbPJgX7s+BzAE1mKdLNOY/wFBEAf2yHJDPHoJo1tvdOzw0v4Ho2C4lfY6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVATLZcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVATLZcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A0D1F00A3D;
	Fri,  4 Sep 2026 05:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500552;
	bh=JXFiZOLjiTUbq4gPNNg5g+dL5m8h6PoSGm6vd+TsBPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVATLZcjmoyuLQlJjz2Qns1wDPB3y/vmtlnbsFQkFJ4pEnlCXLXRlfPN3qvWfkDVD
	 mhm+PcaiWLTJoa8rsuKlwiuw8DQw/LVNlgf6tzfVnSCyckIcfJbNMEz/nYVYUjlmyo
	 HVQcEsxt/4+VVS+kGyANrF9jHM+SRQIWrQzu7Wqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 097/552] NFS/localio: fix ref leak on nfs_uuid_add_file failure
Date: Fri,  4 Sep 2026 06:54:14 +0200
Message-ID: <20260904045750.095579133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit ca018c19e0ba38975e5ddc3ef8117d5b734313aa upstream.

When nfs_uuid_add_file() races with nfs_uuid_put() tearing down
uuid->net, it returns -ENXIO without publishing nfl->nfs_uuid via
rcu_assign_pointer().  nfs_open_local_fh() then enters its error
branch and only releases the slot's file ref and its paired net
ref plus its own entry-time net ref, while the close path is a
no-op:

    nfs_close_local_fh()
      nfs_uuid = rcu_dereference(nfl->nfs_uuid);
      if (!nfs_uuid) { rcu_read_unlock(); return; }  /* always */

nfsd_open_local_fh() returns localio holding a caller-owned +1
nfsd_file reference (from nfsd_file_get() after
nfsd_file_acquire_local()) and an entry-time nfsd_net reference
(from its first nfsd_net_try_get()) embedded as nf->nf_net.  Both
are leaked on the failure path, pinning one nfsd_file (and the
underlying struct file, dentry, inode) and one nfsd_net_ref per
occurrence, which blocks nfsd_net and netns teardown.

Fix by releasing the caller-owned file ref and its net ref through
the existing helper, using a stack-local RCU pointer so the helper
can xchg it out, then returning -ENXIO so callers do not
dereference a localio whose slot has been cleared:

    struct nfsd_file __rcu *tmp = RCU_INITIALIZER(localio);

    nfs_to_nfsd_file_put_local(pnf);
    nfs_to_nfsd_file_put_local(&tmp);
    localio = ERR_PTR(-ENXIO);

The trailing nfs_to_nfsd_net_put(net) continues to release the
outer net ref, so all three nfsd_net_try_get() increments are
balanced on the error branch.

Fixes: fdd015de7679 ("NFS/localio: nfs_uuid_put() fix races with nfs_open/close_local_fh()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-3-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs_common/nfslocalio.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -292,8 +292,22 @@ struct nfsd_file *nfs_open_local_fh(nfs_
 	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt, cred,
 					     nfs_fh, pnf, fmode);
 	if (!IS_ERR(localio) && nfs_uuid_add_file(uuid, nfl) < 0) {
-		/* Delete the cached file when racing with nfs_uuid_put() */
+		/*
+		 * Delete the cached file when racing with nfs_uuid_put().
+		 * Since nfl->nfs_uuid was never published via
+		 * rcu_assign_pointer(), nfs_close_local_fh() will early-return
+		 * and cannot clean up after us.  Drop the slot's file ref and
+		 * its paired net ref, then drop the caller-owned nfsd_file ref
+		 * (+1) and the entry-time nfsd_net ref carried via nf->nf_net,
+		 * and return -ENXIO so the caller never dereferences the
+		 * now-cleared localio.
+		 */
+		struct nfsd_file __rcu *tmp =
+			(struct nfsd_file __force __rcu *)localio;
+
 		nfs_to_nfsd_file_put_local(pnf);
+		nfs_to_nfsd_file_put_local(&tmp);
+		localio = ERR_PTR(-ENXIO);
 	}
 	nfs_to_nfsd_net_put(net);
 


