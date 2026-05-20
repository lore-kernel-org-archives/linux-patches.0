Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B129B8D0;
	Wed, 20 May 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299672; cv=none; b=LilWa0c3oh6v68sSP39oRSWPu2Zt4ndftnvU5+Lko7j2ZPn8Hl2M6b0MRqvqlTZB7bQqF6QW65RZZgctdAZPwEJuxWgotomKyKo5mSjM7NMbSP7GWScEsHB+lpGgKE3eHiyrvXw9aRksjhUHhb03GJ4SHn7n/nXDsAYch1sOCSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299672; c=relaxed/simple;
	bh=uekfo9rqdrr752cZCkEzOKzN6vGcq5lJNshTKYfksDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WysSmvJQwYjEweDy2SjzdX4mL3JnjJkgcSEFdQPxuAlwp1/z6KDVIt9Nrz4qvcWDKYxCN3DUeXAkeXDJC5Lnhz/Yjokf3BxUYL00wUxZD2FmfsxIIcEzEGLWN3qelTB4Z/JbSdTtpBaejPbIAgstefoce9T8O3ahiXZHZAv9qNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCooq1ha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCooq1ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4E51F000E9;
	Wed, 20 May 2026 17:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299671;
	bh=zgDRGJd+Y6SnLt8wM1T7QO8jD51TA92KUgcsgVH8Dgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCooq1haG/4wA2a6QxVHf+pi0PWfoLmuSAEkSeLppZdszXxpYhE/4/96JFVAMT5be
	 aqzyn3ydheWHuQ3ktr2YzVZJ7f1X4u2ItBlQHa5dVuL5I+jS/UQDxJfpKNthM74xmj
	 CLPjzZgV7Ed59XEc7h529H9ExzbmdNiq9EvsvSkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 861/957] Revert "papr-hvpipe: convert papr_hvpipe_dev_create_handle() to FD_PREPARE()"
Date: Wed, 20 May 2026 18:22:24 +0200
Message-ID: <20260520162153.237639959@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

This reverts commit 09c15bbbed533903e600660ea09098b3b0524f48.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c | 39 +++++++++++++++-----
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr-hvpipe.c b/arch/powerpc/platforms/pseries/papr-hvpipe.c
index 3d8672642c251..431f6a3da4c5a 100644
--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -484,7 +484,10 @@ static const struct file_operations papr_hvpipe_handle_ops = {
 
 static int papr_hvpipe_dev_create_handle(u32 srcID)
 {
-	struct hvpipe_source_info *src_info __free(kfree) = NULL;
+	struct hvpipe_source_info *src_info;
+	struct file *file;
+	long err;
+	int fd;
 
 	spin_lock(&hvpipe_src_list_lock);
 	/*
@@ -508,13 +511,20 @@ static int papr_hvpipe_dev_create_handle(u32 srcID)
 	src_info->tsk = current;
 	init_waitqueue_head(&src_info->recv_wqh);
 
-	FD_PREPARE(fdf, O_RDONLY | O_CLOEXEC,
-		   anon_inode_getfile("[papr-hvpipe]", &papr_hvpipe_handle_ops,
-				      (void *)src_info, O_RDWR));
-	if (fdf.err)
-		return fdf.err;
+	fd = get_unused_fd_flags(O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		err = fd;
+		goto free_buf;
+	}
+
+	file = anon_inode_getfile("[papr-hvpipe]",
+			&papr_hvpipe_handle_ops, (void *)src_info,
+			O_RDWR);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto free_fd;
+	}
 
-	retain_and_null_ptr(src_info);
 	spin_lock(&hvpipe_src_list_lock);
 	/*
 	 * If two processes are executing ioctl() for the same
@@ -523,11 +533,22 @@ static int papr_hvpipe_dev_create_handle(u32 srcID)
 	 */
 	if (hvpipe_find_source(srcID)) {
 		spin_unlock(&hvpipe_src_list_lock);
-		return -EALREADY;
+		err = -EALREADY;
+		goto free_file;
 	}
 	list_add(&src_info->list, &hvpipe_src_list);
 	spin_unlock(&hvpipe_src_list_lock);
-	return fd_publish(fdf);
+
+	fd_install(fd, file);
+	return fd;
+
+free_file:
+	fput(file);
+free_fd:
+	put_unused_fd(fd);
+free_buf:
+	kfree(src_info);
+	return err;
 }
 
 /*
-- 
2.53.0



