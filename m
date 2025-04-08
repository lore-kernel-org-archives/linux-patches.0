Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B4B263C6D;
	Tue,  8 Apr 2025 11:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110286; cv=none; b=gkZHc9/kR+5IjDPPbplkfiHRmYiACytHKrfwJtGWfuJbNC3ZxvUbauCdb2R/QpMdqlBhd2E9lQawvvo+cRPgYlCBgibmFeDFem2b3xwrWHrNKie2cq4kWuOMXGtX56cTjPnNOZTOouIqPUEfSEgJ+QtLKWP7sUFwr4YBL00kmrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110286; c=relaxed/simple;
	bh=6ATjT0yLeKdvZIXThykkegjWNiUyQxonx1DHc4p8NW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIDQQ1S/j6o5nvI9wPHdFTAbSA5snYFb5AfS6cAtJIZLfVDHWcwUE5b9kj9FdnaKleLZZTrjuGxm60aHxS+V3tw6ktUYZwgbFNQgevIk2AthfyYcZWwN4/mWU2ZZ7XqPp8ibV7fXInzGTZjVyoEeDJZUlJGxKpKU07F/gurgtMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghN8jNwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghN8jNwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FB7C4CEE5;
	Tue,  8 Apr 2025 11:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110286;
	bh=6ATjT0yLeKdvZIXThykkegjWNiUyQxonx1DHc4p8NW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghN8jNwjyeL5X5UvVDOBFI1Ro8tKwbI6bnqNSnHwfQoq/XTrDcTxhT/25Svqhq27E
	 W5M/HrflSGFFH4nt3BnQpn1hUDgG78s0HUOZiyUxM+VvSNyVbIk0kVvlkcFUH3naNS
	 MyU4Hev0WYNiEIfvCFUIBotGwEqSmssgTyZFU1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 001/731] fs: support O_PATH fds with FSCONFIG_SET_FD
Date: Tue,  8 Apr 2025 12:38:18 +0200
Message-ID: <20250408104914.292623372@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0ff053b98a0f039e52c2bd8d0cb38f2831edfaf5 ]

Let FSCONFIG_SET_FD handle O_PATH file descriptors. This is particularly
useful in the context of overlayfs where layers can be specified via
file descriptors instead of paths. But userspace must currently use
non-O_PATH file desriptors which is often pointless especially if
the file descriptors have been created via open_tree(OPEN_TREE_CLONE).

Link: https://lore.kernel.org/r/20250210-work-overlayfs-v2-1-ed2a949b674b@kernel.org
Fixes: a08557d19ef41 ("ovl: specify layers via file descriptors")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/autofs_i.h | 2 ++
 fs/fsopen.c          | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index 77c7991d89aac..23cea74f9933b 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -218,6 +218,8 @@ void autofs_clean_ino(struct autofs_info *);
 
 static inline int autofs_check_pipe(struct file *pipe)
 {
+	if (pipe->f_mode & FMODE_PATH)
+		return -EINVAL;
 	if (!(pipe->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
 	if (!S_ISFIFO(file_inode(pipe)->i_mode))
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 094a7f510edfe..1aaf4cb2afb29 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -453,7 +453,7 @@ SYSCALL_DEFINE5(fsconfig,
 	case FSCONFIG_SET_FD:
 		param.type = fs_value_is_file;
 		ret = -EBADF;
-		param.file = fget(aux);
+		param.file = fget_raw(aux);
 		if (!param.file)
 			goto out_key;
 		param.dirfd = aux;
-- 
2.39.5



