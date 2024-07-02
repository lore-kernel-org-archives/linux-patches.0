Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8363D;
	Tue,  2 Jul 2024 17:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941604; cv=none; b=aOmD6kz4UdMx38QZwRjv4KRwFTZDpua6CbsqLUuWOh7TIC5HDpNt1YNh6d0HmrWAQUwqbTZ6y5eUhgmPrNeNPHZSbDrDsBVF+qqzEN3aLeo9TrOgYm3+3QV8X7irpj7PJfyu9U5LY95LyxuoBQL1MeTWzqiT8X1Z+BaSVwzlCws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941604; c=relaxed/simple;
	bh=eHEx9U8sDa+eTQp0Snl7kPgbnYEqQFWmxfPvMFMpy7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV1sX8GsZwoviLUFxArSJRfqzFe2dOElkOQ1CLBwgUUOl8QsspewnmOYV17Kig3+CK6/lZAHXg1MDTmN7umf12IqKW2auL232zOVtYR6T0+EuBYvvCxUZaLOLVXfHKhSLO32YXGvDO3E0pzplLzSCG3qb00PijMdI3jNBu4HYew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/6TC9wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/6TC9wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D983C116B1;
	Tue,  2 Jul 2024 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941603;
	bh=eHEx9U8sDa+eTQp0Snl7kPgbnYEqQFWmxfPvMFMpy7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/6TC9wYaUdlxBLRmK6EflAT5DQtpio20KAKjkah7+blH6I/tBQU8zhuJCuXRAGrr
	 7I6e3r6VR0wlrGFN/s7dBU+3jm6uG6AXTpJU9qjfRXdNglOyCvZmAqQO7C439L4a9N
	 qpcIP53dckrv0aLGgarpbtcgyGwXQhWvP9Av0EzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 114/128] ftruncate: pass a signed offset
Date: Tue,  2 Jul 2024 19:05:15 +0200
Message-ID: <20240702170230.532618313@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -199,13 +199,13 @@ out:
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
@@ -621,7 +621,7 @@ asmlinkage long compat_sys_fstatfs(unsig
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
@@ -450,7 +450,7 @@ asmlinkage long sys_fstatfs(unsigned int
 asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz,
 				struct statfs64 __user *buf);
 asmlinkage long sys_truncate(const char __user *path, long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_ftruncate(unsigned int fd, off_t length);
 #if BITS_PER_LONG == 32
 asmlinkage long sys_truncate64(const char __user *path, loff_t length);
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);


