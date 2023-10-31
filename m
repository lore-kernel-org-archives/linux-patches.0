Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451342135A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7gNsDBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B481AC433C7;
	Tue, 31 Oct 2023 17:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774495;
	bh=Kc6KtWFbDRWvVjw5ddXN7F4+GuFmvRdRpynx/lYwCa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7gNsDBWftsPdFSg5aryv4ltUwws6PO0WTN443MIx4PrFpNz5GpcI7rctHpxVtlSD
	 v3MgSAguXVFZUKrNbz6Zru26/DLHThXBeyQXUGDBkww/fOm/m/d+kP2xvS67sAZFZY
	 ZcUje7w0UAUAN/HB6dgo0NCPzzKc7q6rh/NhcXKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.5 031/112] nfsd: lock_rename() needs both directories to live on the same fs
Date: Tue, 31 Oct 2023 18:00:32 +0100
Message-ID: <20231031165902.308023777@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1aee9158bc978f91701c5992e395efbc6da2de3c upstream.

... checking that after lock_rename() is too late.  Incidentally,
NFSv2 had no nfserr_xdev...

Fixes: aa387d6ce153 "nfsd: fix EXDEV checking in rename"
Cc: stable@vger.kernel.org # v3.9+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1781,6 +1781,12 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (!flen || isdotent(fname, flen) || !tlen || isdotent(tname, tlen))
 		goto out;
 
+	err = (rqstp->rq_vers == 2) ? nfserr_acces : nfserr_xdev;
+	if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
+		goto out;
+	if (ffhp->fh_export->ex_path.dentry != tfhp->fh_export->ex_path.dentry)
+		goto out;
+
 retry:
 	host_err = fh_want_write(ffhp);
 	if (host_err) {
@@ -1812,12 +1818,6 @@ retry:
 	if (ndentry == trap)
 		goto out_dput_new;
 
-	host_err = -EXDEV;
-	if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
-		goto out_dput_new;
-	if (ffhp->fh_export->ex_path.dentry != tfhp->fh_export->ex_path.dentry)
-		goto out_dput_new;
-
 	if ((ndentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK) &&
 	    nfsd_has_cached_files(ndentry)) {
 		close_cached = true;


