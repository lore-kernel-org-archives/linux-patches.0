Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A9175562;
	Wed,  3 Jul 2024 10:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003695; cv=none; b=uugrVrV4TYAQA57aTc8tCwZyV6X051XXjeWuP5Jqy9PAfn3fff/T+D8FtzBCXB0ea3DMHaN2eWU0wjdpPN1Ede65df62s1IVMcOs0BjfHH+69Fd026jQ/EXMQvMCyAOJe6jlBFWaOA6cjvLt2qXv5emSBJoQ8E3ta3e20zRAFWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003695; c=relaxed/simple;
	bh=qrONrSR5EUtAlyb+llc7GLvRW2OQuFQzEAkdjqv8VNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovgBafWPwgKNxz0keDUfyXrB9bu9IRN0Eu8rS0l5fEAVTree9gzhZ7e6WKGG72blcceQ7M1+DPs35VPF9ETTbftFs1r6FLPiciJbcJARGIhci1BEAad/ZCOppWWEkiBrh1YgQXbTofoO12slXvdJQcsiskz5KrpcRt34MCf08Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL6QZVSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL6QZVSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E24DC2BD10;
	Wed,  3 Jul 2024 10:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003695;
	bh=qrONrSR5EUtAlyb+llc7GLvRW2OQuFQzEAkdjqv8VNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL6QZVSnyEfO1A5GUIcx0Twu01r8gp70HgWCnUUzM6uPNWfQO8HrVLrR87rR/GDvw
	 FMobqPi/a08Q5idEs0Ml18I3I26qTzyUHaNYcjXLM1ffe9AQ1+jBUHVcIViLmU41uY
	 0spHUYRszZ1AdnfS1gWIPKVmuLF36sSALQ+j/6CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 134/139] ftruncate: pass a signed offset
Date: Wed,  3 Jul 2024 12:40:31 +0200
Message-ID: <20240703102835.494036300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -598,7 +598,7 @@ asmlinkage long compat_sys_fstatfs(unsig
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
@@ -404,7 +404,7 @@ asmlinkage long sys_fstatfs(unsigned int
 asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz,
 				struct statfs64 __user *buf);
 asmlinkage long sys_truncate(const char __user *path, long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_ftruncate(unsigned int fd, off_t length);
 #if BITS_PER_LONG == 32
 asmlinkage long sys_truncate64(const char __user *path, loff_t length);
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);


