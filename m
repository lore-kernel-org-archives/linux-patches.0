Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58374149001;
	Tue, 18 Jun 2024 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714905; cv=none; b=QJ+qFEPY1J1NkmbR3DGvTuMK7ZSyJC6Wfow3EMdeKdxr1hNoOt18zNqZaTd8Z4XgYR8EY0ceebyAmDBDAxf5uEq1Kzo2vomsxoBRg9GcvEwY4e1sYFCIijHyaoax1xLXAWTHtFWZAhntpI6+uMTetRtVsRuYxRrtbo469TrnPbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714905; c=relaxed/simple;
	bh=J/8hIFClL2sV0Hv6avqbZXZs9ugO+I7YdAsDA5Iths4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQUY5BBiA/0LdUmq7p+1rJf0A9ZTqi+CpNawtfSITXzYBZhnnrpwwK80fsdmKdDR7Ro3rwqetCnsE5+7O22mKCYkz8y4lvUwDL/zkuBvRuyuXFi95yTf/7PKSaOhX+pe7SnKL/BZcWRyk/e0wKMP2Stw6yPa880pLTyXs6R7l6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pptzAyvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pptzAyvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20B1C3277B;
	Tue, 18 Jun 2024 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714905;
	bh=J/8hIFClL2sV0Hv6avqbZXZs9ugO+I7YdAsDA5Iths4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pptzAyvh2jMG11BJSk7PaJSQkaEEVFxBhnNyotscUwk8nMiNuQLEOWZwyIx1GzbDc
	 EMsdDRpvfTPH1no31eZv2KiDFTrtzJcQAwRWqfxCAYlnQmOpeJGw1ZsbPrrCkE58gP
	 6L3N3jQLHcGL817CHSeSey6Y6CHoEDEr3SWrlEz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/770] file: Replace ksys_close with close_fd
Date: Tue, 18 Jun 2024 14:29:41 +0200
Message-ID: <20240618123412.217010450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 1572bfdf21d4d50e51941498ffe0b56c2289f783 ]

Now that ksys_close is exactly identical to close_fd replace
the one caller of ksys_close with close_fd.

[1] https://lkml.kernel.org/r/20200818112020.GA17080@infradead.org
Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lkml.kernel.org/r/20201120231441.29911-22-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/dev-ioctl.c    |  5 +++--
 include/linux/syscalls.h | 12 ------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
index 322b7dfb4ea01..5bf781ea6d676 100644
--- a/fs/autofs/dev-ioctl.c
+++ b/fs/autofs/dev-ioctl.c
@@ -4,9 +4,10 @@
  * Copyright 2008 Ian Kent <raven@themaw.net>
  */
 
+#include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/compat.h>
-#include <linux/syscalls.h>
+#include <linux/fdtable.h>
 #include <linux/magic.h>
 #include <linux/nospec.h>
 
@@ -289,7 +290,7 @@ static int autofs_dev_ioctl_closemount(struct file *fp,
 				       struct autofs_sb_info *sbi,
 				       struct autofs_dev_ioctl *param)
 {
-	return ksys_close(param->ioctlfd);
+	return close_fd(param->ioctlfd);
 }
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0bc3dd86f9e50..1ea422b1a9f1c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1320,18 +1320,6 @@ static inline long ksys_ftruncate(unsigned int fd, loff_t length)
 	return do_sys_ftruncate(fd, length, 1);
 }
 
-extern int close_fd(unsigned int fd);
-
-/*
- * In contrast to sys_close(), this stub does not check whether the syscall
- * should or should not be restarted, but returns the raw error codes from
- * close_fd().
- */
-static inline int ksys_close(unsigned int fd)
-{
-	return close_fd(fd);
-}
-
 extern long do_sys_truncate(const char __user *pathname, loff_t length);
 
 static inline long ksys_truncate(const char __user *pathname, loff_t length)
-- 
2.43.0



