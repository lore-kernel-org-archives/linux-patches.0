Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF016F8F5;
	Wed,  3 Jul 2024 11:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006229; cv=none; b=Ndh4iOrXPpw3mW1jjLOmUhGYV4HdrEcaev1P42beXBQXjvCZim1ul3ytybY52rUuCMvmnk/v/uGIEMFelWUiI7WqmIdoQlIam/9dNTat7BXdnakVn8XQCI3LLCwJRUfNI10g6U7YtOp9kxCboX4poJX7jeBH9ETUHq5ow6yel00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006229; c=relaxed/simple;
	bh=6RPgY8tdEqOSLKvTBaW+LgxIkm6HpAlM/bZ4BNSZ/NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IInkibORsgtfEsbgHxsEsJyvBgak1pPSMWOWVMrbmNZt/XfT7AVzRpzRC8A9wFWG0OTyjLY1AkqfZ57qbLT2Aj91zRcGDrURI1tTATYfCg/D9CQrI1/Mvmw96pvYIyNrUyz3ijqtyeRbWjEVrDFVnZPTjBIi/WZjoKwoWsQcXHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZZ5PDja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZZ5PDja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5319C2BD10;
	Wed,  3 Jul 2024 11:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006229;
	bh=6RPgY8tdEqOSLKvTBaW+LgxIkm6HpAlM/bZ4BNSZ/NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZZ5PDjaIPxR7E/Hz7FOXdzmFxP8wdSxfUiODDdftkbueelmhRMgIsWj/yUdihsKi
	 Vr6XAtMv35u+u7gAJ0j/df96EsPf3/FYIssbkaUfAZ2WIkDhy2WVgNV2NGf7OkB0z2
	 fZZcuq1WhvMDBHDNesV6wYgJEz40rrKbLpRdz+Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/356] syscalls: fix sys_fanotify_mark prototype
Date: Wed,  3 Jul 2024 12:41:18 +0200
Message-ID: <20240703102926.049821813@linuxfoundation.org>
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
index fed3d440b6548..b8037a46ff41d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -959,9 +959,15 @@ asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
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



