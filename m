Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3279D1D049A;
	Wed,  2 Oct 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876398; cv=none; b=vEtkVcMx7rVExiLXg2GwAZ4NDoQKAZeuGDaucrfvBiULFO4SO0O5QHQC38FAk+M00JaXFP58/B+bGxj94oTAKEjL35G/8vLjhDJ6fuK9Y4mqzKaHFrdMzaE6uGWgFqDRQRlQ21Ji2D0012l105mk6ukqe07+qY5R6mKQkQlThhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876398; c=relaxed/simple;
	bh=S2JbjjXBqHg8Og6y0pFZQstAWVncrEfvHd0IIbCWep4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+E61VxRZbdhP5lE7yDxSWuqfFLt0773krpbq9XbL7s3KTc7BbGfzuCpfNobqbjrPU321OXb/SLHL4XIuOiM206Mzu8aiMZPWgI9tj9Xqr0AQZWZdNfi5e6kCg/9vjfTmjMuiAzDQanK8nmpIoDLhhroaPSp41JzVpzogZIdSYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNKzpQd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNKzpQd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD696C4CEC5;
	Wed,  2 Oct 2024 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876398;
	bh=S2JbjjXBqHg8Og6y0pFZQstAWVncrEfvHd0IIbCWep4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNKzpQd2kls72sqUboceZjnO2ztTOVM8253e4unwvXq5wa8SYoPqG99lP+U1dvsxa
	 8sAz5o6xsc9/+wpi4k5ANwfOADqqcNLGmpBokcW46wsd+wh6fdiHvyIBqjQ/mdtnLu
	 GzfIM/8QmjHPGqPGhaJPIwkQ9rxCCW3cs607/gqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 431/695] nfsd: fix initial getattr on write delegation
Date: Wed,  2 Oct 2024 14:57:09 +0200
Message-ID: <20241002125839.667098813@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bf92e5008b17f935a6de8b708551e02c2294121c ]

At this point in compound processing, currentfh refers to the parent of
the file, not the file itself. Get the correct dentry from the delegation
stateid instead.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 29c11714ac3db..fe06779ea527a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5912,6 +5912,28 @@ static void nfsd4_open_deleg_none_ext(struct nfsd4_open *open, int status)
 	}
 }
 
+static bool
+nfs4_delegation_stat(struct nfs4_delegation *dp, struct svc_fh *currentfh,
+		     struct kstat *stat)
+{
+	struct nfsd_file *nf = find_rw_file(dp->dl_stid.sc_file);
+	struct path path;
+	int rc;
+
+	if (!nf)
+		return false;
+
+	path.mnt = currentfh->fh_export->ex_path.mnt;
+	path.dentry = file_dentry(nf->nf_file);
+
+	rc = vfs_getattr(&path, stat,
+			 (STATX_SIZE | STATX_CTIME | STATX_CHANGE_COOKIE),
+			 AT_STATX_SYNC_AS_STAT);
+
+	nfsd_file_put(nf);
+	return rc == 0;
+}
+
 /*
  * The Linux NFS server does not offer write delegations to NFSv4.0
  * clients in order to avoid conflicts between write delegations and
@@ -5947,7 +5969,6 @@ nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	int cb_up;
 	int status = 0;
 	struct kstat stat;
-	struct path path;
 
 	cb_up = nfsd4_cb_channel_good(oo->oo_owner.so_client);
 	open->op_recall = false;
@@ -5983,20 +6004,16 @@ nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	memcpy(&open->op_delegate_stateid, &dp->dl_stid.sc_stateid, sizeof(dp->dl_stid.sc_stateid));
 
 	if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE) {
-		open->op_delegate_type = NFS4_OPEN_DELEGATE_WRITE;
-		trace_nfsd_deleg_write(&dp->dl_stid.sc_stateid);
-		path.mnt = currentfh->fh_export->ex_path.mnt;
-		path.dentry = currentfh->fh_dentry;
-		if (vfs_getattr(&path, &stat,
-				(STATX_SIZE | STATX_CTIME | STATX_CHANGE_COOKIE),
-				AT_STATX_SYNC_AS_STAT)) {
+		if (!nfs4_delegation_stat(dp, currentfh, &stat)) {
 			nfs4_put_stid(&dp->dl_stid);
 			destroy_delegation(dp);
 			goto out_no_deleg;
 		}
+		open->op_delegate_type = NFS4_OPEN_DELEGATE_WRITE;
 		dp->dl_cb_fattr.ncf_cur_fsize = stat.size;
 		dp->dl_cb_fattr.ncf_initial_cinfo =
 			nfsd4_change_attribute(&stat, d_inode(currentfh->fh_dentry));
+		trace_nfsd_deleg_write(&dp->dl_stid.sc_stateid);
 	} else {
 		open->op_delegate_type = NFS4_OPEN_DELEGATE_READ;
 		trace_nfsd_deleg_read(&dp->dl_stid.sc_stateid);
-- 
2.43.0



