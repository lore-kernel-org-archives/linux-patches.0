Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C637730569C;
	Fri, 15 May 2026 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862324; cv=none; b=K9/JpNT0rkjk05RMoqb9wNm8fowE/FdPtKwP1UEF7l89kR676GFLmum9fd9IqLPqieL/sivARq+hImNoZfcGqbgYY2FbZm22i06v6WmntPa8ntT1izy1IDwcM1unNksKSOcU5MFuLJq00Z9LgLqwGcOS4Utj2ILXDtRGc1Osl88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862324; c=relaxed/simple;
	bh=YK6Hi5gT53dwwsPrlVuCXumVCFKVn8LIzr5IRBNXWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTkkdgSy3hyhXirdG7RlsfERz+08DS98ySySHiav4qyq9b88U+ZB5d+DBgwTXARKnb+k/o7cpes95b5DgQBJvq9eaBom5tK4K2DorxOJOV33eFzp9X+ZDiWui8pbITEAurS3Zl0bqA6mUWAVPUMo5SJWkhCTJZY1ibF0D4ZQ7e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/98wi2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/98wi2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD78C2BCB0;
	Fri, 15 May 2026 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862324;
	bh=YK6Hi5gT53dwwsPrlVuCXumVCFKVn8LIzr5IRBNXWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/98wi2nakjX/w9oUzlD4gLUm/QT4/XE3xnPuVKOVKT5LnRGVq2FOl9So5amGK1BN
	 Y/YpdN3beyz1tRByCSFdA1vlKd+5JKQgsgdynwiiQfNU2flCsHLdO1tGdTXpgZmSCH
	 gppvZQDSC6WOaebXk4yenZjOhH35wqYuy1w4kxBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/188] papr-hvpipe: convert papr_hvpipe_dev_create_handle() to FD_PREPARE()
Date: Fri, 15 May 2026 17:49:37 +0200
Message-ID: <20260515154700.798003472@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c |   39 ++++++---------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -484,10 +484,7 @@ static const struct file_operations papr
 
 static int papr_hvpipe_dev_create_handle(u32 srcID)
 {
-	struct hvpipe_source_info *src_info;
-	struct file *file;
-	long err;
-	int fd;
+	struct hvpipe_source_info *src_info __free(kfree) = NULL;
 
 	spin_lock(&hvpipe_src_list_lock);
 	/*
@@ -511,20 +508,13 @@ static int papr_hvpipe_dev_create_handle
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
@@ -533,22 +523,11 @@ static int papr_hvpipe_dev_create_handle
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


