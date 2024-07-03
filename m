Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75F17DA3A;
	Wed,  3 Jul 2024 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005138; cv=none; b=mp0S0PsVVX985PzGRk19p4yB/OBtSxoTOqgOzJHdgTvlBYa+i4IvPbAkodEtcVEqLbidYI8tFjr2IXDsMAecY0bqvuurBPeIOjv7Yu8+rSmwbIorEW3nyc5b0fhbVSSFDijFlK5x3Fh/wtRa5G4AoU3KJWQF4mIBrcYwnD4JjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005138; c=relaxed/simple;
	bh=MrQQe9BBX1hRZKI/pShzIpcV5F+WRBLohGtT6s7CHts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzOaz8ay+GPxK8PIWxFTi/2E2MzM9djnlBOfpUyiIgkGUS45/ysmCyEIXQb2c00XqkLLbBEB/EMFUs1gJrYHNwK4jUScZceCQajhek+ni9lKf2Cd7w5lrFOrpp2SswyWKAzcgt+sUate/coBHXl6aY2zKOBkbaT8jRt64Yrpf3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRFCEqGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRFCEqGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987FBC2BD10;
	Wed,  3 Jul 2024 11:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005138;
	bh=MrQQe9BBX1hRZKI/pShzIpcV5F+WRBLohGtT6s7CHts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRFCEqGXP5jZF9mTLpUpTXQpaIxtPdsQvSV4kI+N1UhJz0VbKo2lahkhWLRtP+11b
	 cHiYRE7e9HZ9PblEQt/895gdY7mK6L+Cryh9d3Fr+1QnmAFATa+CQil5tcBhUmOUdD
	 uyJg7q4JI09Mtf4T09vd6/HTgjwUcTDUs2Hj6CWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 274/290] ftruncate: pass a signed offset
Date: Wed,  3 Jul 2024 12:40:55 +0200
Message-ID: <20240703102914.499482567@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 4b8e88e563b5f666446d002ad0dc1e6e8e7102b0 upstream.

The old ftruncate() syscall, using the 32-bit off_t misses a sign
extension when called in compat mode on 64-bit architectures.  As a
result, passing a negative length accidentally succeeds in truncating
to file size between 2GiB and 4GiB.

Changing the type of the compat syscall to the signed compat_off_t
changes the behavior so it instead returns -EINVAL.

The native entry point, the truncate() syscall and the corresponding
loff_t based variants are all correct already and do not suffer
from this mistake.

Fixes: 3f6d078d4acc ("fix compat truncate/ftruncate")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c                |    4 ++--
 include/linux/compat.h   |    2 +-
 include/linux/syscalls.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -200,13 +200,13 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
+SYSCALL_DEFINE2(ftruncate, unsigned int, fd, off_t, length)
 {
 	return do_sys_ftruncate(fd, length, 1);
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(ftruncate, unsigned int, fd, compat_ulong_t, length)
+COMPAT_SYSCALL_DEFINE2(ftruncate, unsigned int, fd, compat_off_t, length)
 {
 	return do_sys_ftruncate(fd, length, 1);
 }
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -527,7 +527,7 @@ asmlinkage long compat_sys_fstatfs(unsig
 asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz,
 				     struct compat_statfs64 __user *buf);
 asmlinkage long compat_sys_truncate(const char __user *, compat_off_t);
-asmlinkage long compat_sys_ftruncate(unsigned int, compat_ulong_t);
+asmlinkage long compat_sys_ftruncate(unsigned int, compat_off_t);
 /* No generic prototype for truncate64, ftruncate64, fallocate */
 asmlinkage long compat_sys_openat(int dfd, const char __user *filename,
 				  int flags, umode_t mode);
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -445,7 +445,7 @@ asmlinkage long sys_fstatfs(unsigned int
 asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz,
 				struct statfs64 __user *buf);
 asmlinkage long sys_truncate(const char __user *path, long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_ftruncate(unsigned int fd, off_t length);
 #if BITS_PER_LONG == 32
 asmlinkage long sys_truncate64(const char __user *path, loff_t length);
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);


