Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389AF3BFAE0;
	Fri,  4 Sep 2026 05:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498850; cv=none; b=MOBHwYePxA8r4tHW9vDAKomCstkczNZTJAyzzVQ7wVrLXRI26wNUaGMq+VQ9lWYAveIrTxtshZnZzGlTXhKAm+kVpiASBY7ILI2R+krTPh9oqvMxFeRKKUJHCXxX4rfiyxnoRPudUu903szH701UG2PpU4xosmMkAvhnKDHsxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498850; c=relaxed/simple;
	bh=/wtz1AX030dRagQIKqbnUvH/MqIYsaY+Vy/yQq0nyGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFK9hs6dxQnecInAHsjPvQxtqn/qDXYP+iWSy6AMjPhdmGSppC6M2Z9hhqmebpVs6XzAIU8B8RglhTiQ241NtR7j/E+w6E5bFQa1sNPR7VaM8d1sYZ7uxJcyGcLgFZANxlvpL+f2ZYGE6mAKUbd1Q7FN4xpJCz6RfIEzs1ri0XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlTycZSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlTycZSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943231F00A3D;
	Fri,  4 Sep 2026 05:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498849;
	bh=JsnjRRA4QKQieG/aCbSCG3nDUfXshhl+bsrvgs+EjbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlTycZSDM2qV74opdQnRMfdwFlqkf5LSX2rRv8N11wkEuEo6vGcSkB4zgrNETqrkW
	 7MA2m2HEchFhsxXCQ+BewSUkR71r0765lCrzh3HVsGGz9lukDfbPcXcREBEOA+f+JX
	 B6Fx7sqfCGn2yghIrkPnG76ZHaMeibc96FYFoETo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 208/713] NFSD: Prevent post-shutdown use-after-free in unlock_filesystem
Date: Fri,  4 Sep 2026 06:52:56 +0200
Message-ID: <20260904045808.479358030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 292d915d3ba6fd15eeb88351fa10581683073109 upstream.

Writing a filesystem path to /proc/fs/nfsd/unlock_filesystem runs
nfsd4_cancel_copy_by_sb() before nfsd_mutex is held and before the
handler confirms that nn->nfsd_serv is set. Once nfsd has shut down,
nfs4_state_destroy_net() has freed nn->conf_id_hashtbl but left the
pointer intact, so the cancel helper iterates freed slab memory as an
array of struct list_head and then dereferences a bogus nfs4_client
when it takes clp->async_lock. A local administrator holding
CAP_SYS_ADMIN can reach this use-after-free by stopping the server and
then writing to unlock_filesystem; KASAN reports a slab-use-after-free
read in nfsd4_cancel_copy_by_sb().

nfsd4_revoke_states() walks the same state tables and for that reason
already runs only under nfsd_mutex with nn->nfsd_serv confirmed
present. Move the async COPY cancel into that protected section so
every NFSv4 state-table walker on this path observes a running server.
Async copies exist only while the server runs, so gating the cancel on
nn->nfsd_serv loses nothing.

Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Fixes: 3daab3112f03 ("nfsd: cancel async COPY operations when admin revokes filesystem state")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260613-unlock-filesystem-uaf-v1-1-462b9bec8c84@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -296,14 +296,15 @@ static ssize_t write_unlock_fs(struct fi
 	 * 2.  Is that directory a mount point, or
 	 * 3.  Is that directory the root of an exported file system?
 	 */
-	nfsd4_cancel_copy_by_sb(netns(file), path.dentry->d_sb);
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
 	mutex_lock(&nfsd_mutex);
 	nn = net_generic(netns(file), nfsd_net_id);
-	if (nn->nfsd_serv)
+	if (nn->nfsd_serv) {
+		nfsd4_cancel_copy_by_sb(netns(file), path.dentry->d_sb);
 		nfsd4_revoke_states(nn, path.dentry->d_sb);
-	else
+	} else {
 		error = -EINVAL;
+	}
 	mutex_unlock(&nfsd_mutex);
 
 	path_put(&path);


