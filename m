Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A780019DF67;
	Thu,  6 Jun 2024 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683495; cv=none; b=SywaiqdvtbzMDBHsDaIQYkxqFazvsxwjrLp3NxLkjtruibPsCg3jU9UQ9Adg3uedwkFkI3TyGencQGPGLi7D4oPUSqbp4gXeot5BGgbgNir2KztYfRVX2ezs+WKFp0rYu9/y8uA4ckNiVSvOERX4CWmmRvN3ekG7bG5CvItiYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683495; c=relaxed/simple;
	bh=B6R8cB+6+aPykAsd5tgnUHX2UlbL81Qr+vXFjkiao/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEZdTfpUv4L/Z3W5fUSt1aRsKtmpjAwx8zQOVjyRGZWfK/ewsVBITURp1/ByDekK+vvD21ueivyiWHQ3v3nWrOxlqViX8c1tgv47WKn9NkKOQ3fzcDf4+Rx4ediq/dhwhBj2Ilf6HYM2xq0eN7Yd09cohwcZXHNUA4B2ySbpHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMVxzr3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMVxzr3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8793BC2BD10;
	Thu,  6 Jun 2024 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683495;
	bh=B6R8cB+6+aPykAsd5tgnUHX2UlbL81Qr+vXFjkiao/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMVxzr3wJFDfR0hRK9khGYMhYRESyJwsWAUaL5xgM2JG8A3RDeGEqaEZjTvWxoDZD
	 sQiBwpNaNFyn0mEOR/AxalfbtrUgxp/zhhv8aZI6mq9kMOx+dkV3J0V9r+7ch025OK
	 OH9ae01Xo670uHANxL5AjCKr/CN/Tw9lm2O6tHo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 438/744] ovl: add helper ovl_file_modified()
Date: Thu,  6 Jun 2024 16:01:50 +0200
Message-ID: <20240606131746.528729378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit c002728f608183449673818076380124935e6b9b ]

A simple wrapper for updating ovl inode size/mtime, to conform
with ovl_file_accessed().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 8be4dc050d1ed..9fd88579bfbfb 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -235,6 +235,12 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 	return ret;
 }
 
+static void ovl_file_modified(struct file *file)
+{
+	/* Update size/mtime */
+	ovl_copyattr(file_inode(file));
+}
+
 static void ovl_file_accessed(struct file *file)
 {
 	struct inode *inode, *upperinode;
@@ -290,10 +296,8 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
 	if (iocb->ki_flags & IOCB_WRITE) {
-		struct inode *inode = file_inode(orig_iocb->ki_filp);
-
 		kiocb_end_write(iocb);
-		ovl_copyattr(inode);
+		ovl_file_modified(orig_iocb->ki_filp);
 	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
@@ -403,7 +407,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     ovl_iocb_to_rwf(ifl));
 		file_end_write(real.file);
 		/* Update size */
-		ovl_copyattr(inode);
+		ovl_file_modified(file);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -489,7 +493,7 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 	file_end_write(real.file);
 	/* Update size */
-	ovl_copyattr(inode);
+	ovl_file_modified(out);
 	revert_creds(old_cred);
 	fdput(real);
 
@@ -570,7 +574,7 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(inode);
+	ovl_file_modified(file);
 
 	fdput(real);
 
@@ -654,7 +658,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(inode_out);
+	ovl_file_modified(file_out);
 
 	fdput(real_in);
 	fdput(real_out);
-- 
2.43.0



