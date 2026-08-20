Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A147887F;
	Thu, 20 Aug 2026 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247118; cv=none; b=dTmLz9/hClklZ//U2g4j2CsDqRLF8M9U1j2iGNhlHqLruFcnX7tRGUqWP1665LtP8YI44H1GBQXuQjEFGDqIl8FPe+iA4xoxY92fx1pkE7SoevhWYOVmkzjrrqaLlq08Q0pS5hDWwmpaT7Y6G/XmGmEscg+8Md0/er/utoBnBeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247118; c=relaxed/simple;
	bh=A90MgT9LDH9fpvFC+Ir3BKb9DeauvCYkxD9DA2rOePg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUfOkLTRa27oxikfED5Hiz9NXi9g/5UXqvs8XfmVju7CMLfuKs5rMNt2q47Q7WlirDwcvgoDIEMzhCOEKpmNhYKst/iTjYAfUdP+UoJABytfyeOSBk4IoZ7+Vbm/BYBzAs6IbzxlNTHEPt7YB5IbVPRV/1dEskrzac6w8Y8MUpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEfjimjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEfjimjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B631F000E9;
	Thu, 20 Aug 2026 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247117;
	bh=nLuYD57HxJMf01/KFZMOj3HdiGxCTZ990DMgY/0qWug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEfjimjGpNAJltcwL1UYqzLGy6PLwN+mxYlROAZqIZWhy1KGuikKSCN43O60uFn0R
	 gth0n30rAq7teNzINVBnjCzP8oE+wuRyFM5UNar+c+3D0SM5VtEMHVBGzVOEP0+RgN
	 d2idAIl3ZZOuNMbQtNvytN5vseUpirt9EbFy2cAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/220] fsnotify, lsm: Decouple fsnotify from lsm
Date: Thu, 20 Aug 2026 16:55:46 +0200
Message-ID: <20260820145228.165172852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 1cda52f1b4611f4daa9d89e69d9428fb4137dc3f ]

Currently, fsnotify_open_perm() is called from security_file_open().
This is a a bit unexpected and creates otherwise unnecessary dependency
of CONFIG_FANOTIFY_ACCESS_PERMISSIONS on CONFIG_SECURITY. Fix this by
calling fsnotify_open_perm() directly.

Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241013002248.3984442-1-song@kernel.org
Stable-dep-of: db1856ea9196 ("binfmt_misc: restore write access when removing an entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/Kconfig |    1 -
 fs/open.c                  |    4 ++++
 security/security.c        |    9 +--------
 3 files changed, 5 insertions(+), 9 deletions(-)

--- a/fs/notify/fanotify/Kconfig
+++ b/fs/notify/fanotify/Kconfig
@@ -15,7 +15,6 @@ config FANOTIFY
 config FANOTIFY_ACCESS_PERMISSIONS
 	bool "fanotify permissions checking"
 	depends on FANOTIFY
-	depends on SECURITY
 	default n
 	help
 	   Say Y here is you want fanotify listeners to be able to make permissions
--- a/fs/open.c
+++ b/fs/open.c
@@ -940,6 +940,10 @@ static int do_dentry_open(struct file *f
 	if (error)
 		goto cleanup_all;
 
+	error = fsnotify_open_perm(f);
+	if (error)
+		goto cleanup_all;
+
 	error = break_lease(file_inode(f), f->f_flags);
 	if (error)
 		goto cleanup_all;
--- a/security/security.c
+++ b/security/security.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/kernel_read_file.h>
 #include <linux/lsm_hooks.h>
-#include <linux/fsnotify.h>
 #include <linux/mman.h>
 #include <linux/mount.h>
 #include <linux/personality.h>
@@ -3214,13 +3213,7 @@ int security_file_receive(struct file *f
  */
 int security_file_open(struct file *file)
 {
-	int ret;
-
-	ret = call_int_hook(file_open, file);
-	if (ret)
-		return ret;
-
-	return fsnotify_open_perm(file);
+	return call_int_hook(file_open, file);
 }
 
 /**


