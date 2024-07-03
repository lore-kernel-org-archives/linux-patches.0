Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B94516F8F5;
	Wed,  3 Jul 2024 11:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006220; cv=none; b=EQDUaT+hhC8eMpORZAhEOfVSLOQAVzqlMl/y2bxgyZyc8o+eO6iZoZ9tSlrM8fEICx/wLn4yxi08o58m0oDa/a/p1xOuhXBYRYz0sQwJaWWG7KRkmPGM4SUUpcBlli+pUko89Ohv3g5Ymq26+85LK5+WDQ4hbshCq+4ZwryYzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006220; c=relaxed/simple;
	bh=jfZbH4ZcaaG4WTFUevzgg+BIxnEQ7R+/tCJZm3T290M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2DfYHBly8/4D/XgFASz0/3dn+HQ7fSWjpXG+8IyVYa+FaRNCWsK1bWTxvyHA0Xl/c6v095Qxw3D6eMgz7VKaLNBKNKD8AqA10uD7SXAty1fDSGRMn6sXpiGwAxrJQb11XARZoDiMms7L9QROJbwgGJqkN1r/RqI3dcGzgEDS8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLfPNajv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLfPNajv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB7BC2BD10;
	Wed,  3 Jul 2024 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006220;
	bh=jfZbH4ZcaaG4WTFUevzgg+BIxnEQ7R+/tCJZm3T290M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLfPNajvaN2mBQFOtPWM7QSHEhsg6g7pjZi/Drbp6E5NrEDS0dRAfxH43stAs9njr
	 xVG0MMTnyZ+/Z8hWsfTo9JrfDaW0OtTXBiZoKVFP20uiwi1+8py0OAyZuD4vaXArp4
	 pR/i7CVMFP5JhucF6EwsBZAMX3Nonhf7PbzCSkDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 340/356] ftruncate: pass a signed offset
Date: Wed,  3 Jul 2024 12:41:16 +0200
Message-ID: <20240703102925.974369002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -590,7 +590,7 @@ asmlinkage long compat_sys_fstatfs(unsig
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
@@ -453,7 +453,7 @@ asmlinkage long sys_fstatfs(unsigned int
 asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz,
 				struct statfs64 __user *buf);
 asmlinkage long sys_truncate(const char __user *path, long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_ftruncate(unsigned int fd, off_t length);
 #if BITS_PER_LONG == 32
 asmlinkage long sys_truncate64(const char __user *path, loff_t length);
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);


