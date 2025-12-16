Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD8347BCB;
	Tue, 16 Dec 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888140; cv=none; b=AVIFQ1uSnMMSSCDgcup+nXkQe3vDl+rqPGmk43c28YhjbfFy5sfMxT1K/0yoP2VU+pgLgjMWzKdvrofkp9Zup3iOBpJwL8zFWqdFzdtTQ1NRkeIJItkxgp0whE89271eiaTQgUn4OC68PsFiZbX//vOJ+FKHMNqROXDFniLT23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888140; c=relaxed/simple;
	bh=A6sDys5xKP56x6t3ScvMETaST1L7F6TYeEaMalKPrbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JI7XHp9dwJCPS1Hcbj9armWFm4x/v5JMpZiNokYO6NmQFQSlGPCx+LUFBbWpMfpba8yrOF98voH/Ofwg9mMFq36Jg9JIiL+gCuPABPdCbERW3J6IESSDk6L5B5nTJqEIVbqZJNWyOFvqjD321kznNe3eWJWIPCeruF1MqDc+gVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBn9gjXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBn9gjXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C311C4CEF1;
	Tue, 16 Dec 2025 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888140;
	bh=A6sDys5xKP56x6t3ScvMETaST1L7F6TYeEaMalKPrbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBn9gjXPpsia4cgMOYyxm3aocN89RlqodDJHNWLCFgUfv58jHk5OP1fXDg1kR62wS
	 UIGJf2ePcvEd2PCz6NYfx0DCi530Jl84USegcCxQwvIFs4RFHndFoq6WMRK+r4FW3r
	 R/+ycv0t43keNTDLMP+mCw/yG3Xz6DZ0VJQG/3sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/614] fs: refactor file timestamp update logic
Date: Tue, 16 Dec 2025 12:13:31 +0100
Message-ID: <20251216111417.460129247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3cd9a42f1b5e34d3972237cbf8541af60844cbd4 ]

Currently the two high-level APIs use two helper functions to implement
almost all of the logic.  Refactor the two helpers and the common logic
into a new file_update_time_flags routine that gets the iocb flags or
0 in case of file_update_time passed so that the entire logic is
contained in a single function and can be easily understood and modified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20251120064859.2911749-2-hch@lst.de
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7f30e7a42371 ("fs: lift the FMODE_NOCMTIME check into file_update_time_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 54 +++++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cff1d3af0d577..540f4a28c202d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2322,10 +2322,12 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
-static int inode_needs_update_time(struct inode *inode)
+static int file_update_time_flags(struct file *file, unsigned int flags)
 {
+	struct inode *inode = file_inode(file);
 	struct timespec64 now, ts;
-	int sync_it = 0;
+	int sync_mode = 0;
+	int ret = 0;
 
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
@@ -2335,29 +2337,23 @@ static int inode_needs_update_time(struct inode *inode)
 
 	ts = inode_get_mtime(inode);
 	if (!timespec64_equal(&ts, &now))
-		sync_it |= S_MTIME;
-
+		sync_mode |= S_MTIME;
 	ts = inode_get_ctime(inode);
 	if (!timespec64_equal(&ts, &now))
-		sync_it |= S_CTIME;
-
+		sync_mode |= S_CTIME;
 	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
-		sync_it |= S_VERSION;
+		sync_mode |= S_VERSION;
 
-	return sync_it;
-}
-
-static int __file_update_time(struct file *file, int sync_mode)
-{
-	int ret = 0;
-	struct inode *inode = file_inode(file);
+	if (!sync_mode)
+		return 0;
 
-	/* try to update time settings */
-	if (!mnt_get_write_access_file(file)) {
-		ret = inode_update_time(inode, sync_mode);
-		mnt_put_write_access_file(file);
-	}
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
 
+	if (mnt_get_write_access_file(file))
+		return 0;
+	ret = inode_update_time(inode, sync_mode);
+	mnt_put_write_access_file(file);
 	return ret;
 }
 
@@ -2377,14 +2373,7 @@ static int __file_update_time(struct file *file, int sync_mode)
  */
 int file_update_time(struct file *file)
 {
-	int ret;
-	struct inode *inode = file_inode(file);
-
-	ret = inode_needs_update_time(inode);
-	if (ret <= 0)
-		return ret;
-
-	return __file_update_time(file, ret);
+	return file_update_time_flags(file, 0);
 }
 EXPORT_SYMBOL(file_update_time);
 
@@ -2406,7 +2395,6 @@ EXPORT_SYMBOL(file_update_time);
 static int file_modified_flags(struct file *file, int flags)
 {
 	int ret;
-	struct inode *inode = file_inode(file);
 
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2415,17 +2403,9 @@ static int file_modified_flags(struct file *file, int flags)
 	ret = file_remove_privs_flags(file, flags);
 	if (ret)
 		return ret;
-
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
-
-	ret = inode_needs_update_time(inode);
-	if (ret <= 0)
-		return ret;
-	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
-
-	return __file_update_time(file, ret);
+	return file_update_time_flags(file, flags);
 }
 
 /**
-- 
2.51.0



