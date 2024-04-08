Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157B3A1C7;
	Mon,  8 Apr 2024 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584771; cv=none; b=hK74Gqe3X4XcvZqP3IxiFDOYATLyn61ui0xlahKp7laHWuyTjx+80gkELSVPiVj9yDxnC60RYKJIcS/HnXkLyOQ+ITipxTVcP6jcId1MPd4f6esvV6v83Jr/DKHhLAotwc116Se5JJIS6k86oZcOIfFX5UtqaVt4qSxzgKaAG30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584771; c=relaxed/simple;
	bh=mQvjYA/AuZqwUULOr/rqZHD6/PMZhI9QQfc0QamtRyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaHBbvD0lnrdFgswvtOt53SUYYdbwq3eLTFAqOh8p8SQfXIPCEdijhIGy57E40A6VZkK1ZAhJ0FVOWZZmFFifGPO37Au4A9cYKx9qKQ5kQJMkZ1n0Qd1sA4OpGYTD1KneyyEvioHNEAIquOOw+I1BagYW0i7Lqri4u0vvitvEDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0owBTDKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0owBTDKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DACC433F1;
	Mon,  8 Apr 2024 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584770;
	bh=mQvjYA/AuZqwUULOr/rqZHD6/PMZhI9QQfc0QamtRyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0owBTDKAUpMwHso8wWz1FZutmnipO/6gxJAh5bcaPBpYMpspDufm3LlgpB8fVmquV
	 yjB2dF45zLv6NVFil9jTLhuRd+JRArDZO60A0WJFjOxCsLGwt+GmIGX7onGlLCZtlV
	 ZkWceSSsB+a/cyRgUv8oGwaoYR/wS8zg4QYz+Qks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyang Xue <bxue@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 521/690] nfsd: dont hand out delegation on setuid files being opened for write
Date: Mon,  8 Apr 2024 14:56:27 +0200
Message-ID: <20240408125418.523805995@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 826b67e6376c2a788e3a62c4860dcd79500a27d5 ]

We had a bug report that xfstest generic/355 was failing on NFSv4.0.
This test sets various combinations of setuid/setgid modes and tests
whether DIO writes will cause them to be stripped.

What I found was that the server did properly strip those bits, but
the client didn't notice because it held a delegation that was not
recalled. The recall didn't occur because the client itself was the
one generating the activity and we avoid recalls in that case.

Clearing setuid bits is an "implicit" activity. The client didn't
specifically request that we do that, so we need the server to issue a
CB_RECALL, or avoid the situation entirely by not issuing a delegation.

The easiest fix here is to simply not give out a delegation if the file
is being opened for write, and the mode has the setuid and/or setgid bit
set. Note that there is a potential race between the mode and lease
being set, so we test for this condition both before and after setting
the lease.

This patch fixes generic/355, generic/683 and generic/684 for me. (Note
that 355 fails only on v4.0, and 683 and 684 require NFSv4.2 to run and
fail).

Reported-by: Boyang Xue <bxue@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 628e564e530bf..773971a75b62d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5439,6 +5439,23 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	return 0;
 }
 
+/*
+ * We avoid breaking delegations held by a client due to its own activity, but
+ * clearing setuid/setgid bits on a write is an implicit activity and the client
+ * may not notice and continue using the old mode. Avoid giving out a delegation
+ * on setuid/setgid files when the client is requesting an open for write.
+ */
+static int
+nfsd4_verify_setuid_write(struct nfsd4_open *open, struct nfsd_file *nf)
+{
+	struct inode *inode = file_inode(nf->nf_file);
+
+	if ((open->op_share_access & NFS4_SHARE_ACCESS_WRITE) &&
+	    (inode->i_mode & (S_ISUID|S_ISGID)))
+		return -EAGAIN;
+	return 0;
+}
+
 static struct nfs4_delegation *
 nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 		    struct svc_fh *parent)
@@ -5472,6 +5489,8 @@ nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	spin_lock(&fp->fi_lock);
 	if (nfs4_delegation_exists(clp, fp))
 		status = -EAGAIN;
+	else if (nfsd4_verify_setuid_write(open, nf))
+		status = -EAGAIN;
 	else if (!fp->fi_deleg_file) {
 		fp->fi_deleg_file = nf;
 		/* increment early to prevent fi_deleg_file from being
@@ -5512,6 +5531,14 @@ nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	if (status)
 		goto out_unlock;
 
+	/*
+	 * Now that the deleg is set, check again to ensure that nothing
+	 * raced in and changed the mode while we weren't lookng.
+	 */
+	status = nfsd4_verify_setuid_write(open, fp->fi_deleg_file);
+	if (status)
+		goto out_unlock;
+
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
 	if (fp->fi_had_conflict)
-- 
2.43.0



