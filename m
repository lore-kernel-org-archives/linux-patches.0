Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7E503BD4;
	Tue, 13 Oct 2026 12:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893423; cv=none; b=U8nJhutuj9//PHGzUH9KTDcvrUdwqYoTmpJY+n/a7ZRPMtk0FHze5YCSQKdC1aEb5lIvoTjwSms1TZuCT97z9ZdB+eOk/dOvUdxEb633vA6d6s+rOuT9V+d5lu/uibqpZ4g08PXnAL3KTKHgWK9hHW6OIt+KZSoYLNNTFqI/NKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893423; c=relaxed/simple;
	bh=IdF0yQzlWabAR9TDgohcXrxJwOicStM7/GA2FqITnyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA/bK3iX2bhkT9oGn2nHJfMwHtX1hmSEgiw2tP/GXuuYgXTFWYjpv/z1UM00o/R8VOlHv36dSsvr1icSwYztit9HqjbEuZaMXlOx1GpMHC8QMHGD9ks+XFO+/FMZytooZRXtv+Oy84CY2o3h9phO3VpGP8dmIsyWtA2w4pw9+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjJDRmrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjJDRmrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554BA1F0089A;
	Tue, 13 Oct 2026 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893420;
	bh=1fJoYoNyqjrDyVOBofG0o9sQBvyikQ1qEGtkswRTVYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjJDRmrwTV/5+JdK11BIiaPVlm3eaYOOBj6QYjB1ZAvpOJGRuLrmhM9FPpJzZcMvC
	 HkTyqoKayRxCwHTwYjdZjD4+MuxGNC8oRgqQonqHuXIBSXuOMnfMX63Ig7ZJ0bQ4Sx
	 zfxOFz2yPwhNY2YSqAumqtiGbUK7UVCCrLDHkOsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/621] papr-hvpipe: convert papr_hvpipe_dev_create_handle() to FD_PREPARE()
Date: Tue, 13 Oct 2026 13:33:18 +0200
Message-ID: <20261013112925.679743162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6d3789d347a7af5c4b0b2da3af47b8d9da607ab2 ]

Fixes a UAF for src_info as well.

Link: https://patch.msgid.link/20251123-work-fd-prepare-v4-33-b6efa1706cfd@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a4f0846ee6c ("pseries/papr-hvpipe: Fix race with interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c | 39 +++++---------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr-hvpipe.c b/arch/powerpc/platforms/pseries/papr-hvpipe.c
index 431f6a3da4c5a..3d8672642c251 100644
--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -484,10 +484,7 @@ static const struct file_operations papr_hvpipe_handle_ops = {
 
 static int papr_hvpipe_dev_create_handle(u32 srcID)
 {
-	struct hvpipe_source_info *src_info;
-	struct file *file;
-	long err;
-	int fd;
+	struct hvpipe_source_info *src_info __free(kfree) = NULL;
 
 	spin_lock(&hvpipe_src_list_lock);
 	/*
@@ -511,20 +508,13 @@ static int papr_hvpipe_dev_create_handle(u32 srcID)
 	src_info->tsk = current;
 	init_waitqueue_head(&src_info->recv_wqh);
 
-	fd = get_unused_fd_flags(O_RDONLY | O_CLOEXEC);
-	if (fd < 0) {
-		err = fd;
-		goto free_buf;
-	}
-
-	file = anon_inode_getfile("[papr-hvpipe]",
-			&papr_hvpipe_handle_ops, (void *)src_info,
-			O_RDWR);
-	if (IS_ERR(file)) {
-		err = PTR_ERR(file);
-		goto free_fd;
-	}
+	FD_PREPARE(fdf, O_RDONLY | O_CLOEXEC,
+		   anon_inode_getfile("[papr-hvpipe]", &papr_hvpipe_handle_ops,
+				      (void *)src_info, O_RDWR));
+	if (fdf.err)
+		return fdf.err;
 
+	retain_and_null_ptr(src_info);
 	spin_lock(&hvpipe_src_list_lock);
 	/*
 	 * If two processes are executing ioctl() for the same
@@ -533,22 +523,11 @@ static int papr_hvpipe_dev_create_handle(u32 srcID)
 	 */
 	if (hvpipe_find_source(srcID)) {
 		spin_unlock(&hvpipe_src_list_lock);
-		err = -EALREADY;
-		goto free_file;
+		return -EALREADY;
 	}
 	list_add(&src_info->list, &hvpipe_src_list);
 	spin_unlock(&hvpipe_src_list_lock);
-
-	fd_install(fd, file);
-	return fd;
-
-free_file:
-	fput(file);
-free_fd:
-	put_unused_fd(fd);
-free_buf:
-	kfree(src_info);
-	return err;
+	return fd_publish(fdf);
 }
 
 /*
-- 
2.53.0



