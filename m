Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D7C1BD4EA;
	Tue,  2 Jul 2024 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941614; cv=none; b=mPj+jMQ2iPR4ZsfL1S8oAWkNzgh91UYNfjBpa0qB5mz/aI+afRTr4aO58UNV3fOqoq0Uyqk9bFaSmy692TnjaSjjKP6n0iP7pFZGRW1wculOy7/QIEG5qAXAKzcioxERlH1nqlUcycmR1OvRuHjNq2jVVTDgCokwr6PBzy3U7Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941614; c=relaxed/simple;
	bh=XiWcoWcvVkByW1g8QdNhl84e9PASqfP76rMajF2qBrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+8E0dCvxlInqqWA4WOjDT1T2I8rq3g3t1oPuBpi8NWnSmgsIuvHNfSuuZEttCdzBoaDfnBtrIr7zq4M2u6kt8mYfVf0Pgu3O0t+1tS0bn4/crP6PZbHJ+YmVRSnypttGs2zVO6q0xjI1zM4G8d/YYpeCKNZv/glMn+tvsDBXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEEC5WY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEEC5WY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D691C4AF0A;
	Tue,  2 Jul 2024 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941614;
	bh=XiWcoWcvVkByW1g8QdNhl84e9PASqfP76rMajF2qBrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEEC5WY21rKrcZskHslvBljuJtz9TjVVpuQWZWEsSEL200vAOND8rGbfCx4KDQq3d
	 NihPh/PTl4mQkU5qJ5VmtDVz9/WhASVri7mdkBQ4Bv7hJFvutaGAnnzfCjqogZ8pZf
	 +KeQRXrusDoC1QUtFA0cdyEhPjQg6a9E8skRYdXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/128] syscalls: fix sys_fanotify_mark prototype
Date: Tue,  2 Jul 2024 19:05:17 +0200
Message-ID: <20240702170230.608226659@linuxfoundation.org>
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

[ Upstream commit 63e2f40c9e3187641afacde4153f54b3ee4dbc8c ]

My earlier fix missed an incorrect function prototype that shows up on
native 32-bit builds:

In file included from fs/notify/fanotify/fanotify_user.c:14:
include/linux/syscalls.h:248:25: error: conflicting types for 'sys_fanotify_mark'; have 'long int(int,  unsigned int,  u32,  u32,  int,  const char *)' {aka 'long int(int,  unsigned int,  unsigned int,  unsigned int,  int,  const char *)'}
 1924 | SYSCALL32_DEFINE6(fanotify_mark,
      | ^~~~~~~~~~~~~~~~~
include/linux/syscalls.h:862:17: note: previous declaration of 'sys_fanotify_mark' with type 'long int(int,  unsigned int,  u64,  int, const char *)' {aka 'long int(int,  unsigned int,  long long unsigned int,  int,  const char *)'}

On x86 and powerpc, the prototype is also wrong but hidden in an #ifdef,
so it never caused problems.

Add another alternative declaration that matches the conditional function
definition.

Fixes: 403f17a33073 ("parisc: use generic sys_fanotify_mark implementation")
Cc: stable@vger.kernel.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/syscalls.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ea36e53e3125c..dcce762b48fac 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -960,9 +960,15 @@ asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
 				const struct rlimit64 __user *new_rlim,
 				struct rlimit64 __user *old_rlim);
 asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags);
+#if defined(CONFIG_ARCH_SPLIT_ARG64)
+asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
+                                unsigned int mask_1, unsigned int mask_2,
+				int dfd, const char  __user * pathname);
+#else
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+#endif
 asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
 				      struct file_handle __user *handle,
 				      int __user *mnt_id, int flag);
-- 
2.43.0



