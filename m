Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AEE1BE226;
	Tue,  2 Jul 2024 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941169; cv=none; b=eysPHt998aXSLmeg38Gk8dobP90Tbsn8r59cwP6XsWZzSy1srh4jAcLwbaCDTKCXJjYHlNz8vza7BenYcnFoQtHTKOosBXs/6OvY8tiED7KxezGnIGAFe5lwuydHXyQUvgDWIbwO+t/JtYcMygCyb1kzY3Z3IFgGyfC15yNsnc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941169; c=relaxed/simple;
	bh=a1m2am5bt7gbR7fgz1znbWivIVe2g6teE58WxKUiPUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5t4WT01C2j6NDN9800Lqrmtd+mwV+rwRnPSMO9QtuAfXA9TRP7mQesunmFZM5Tq7reqmA/mflOz1xnMHiYYzLyugOp0AXrFWS/MY4Ve3b5wwMSlvkSahX7EVI6iOvJ15E92H06My8iV/XsKlzJ1OLsNAa5EeS14IAKbmdV962g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0npvdmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0npvdmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F2FC4AF0A;
	Tue,  2 Jul 2024 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941169;
	bh=a1m2am5bt7gbR7fgz1znbWivIVe2g6teE58WxKUiPUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0npvdmRvYcw++yDYIQj0cTBMHfae7wmBNPlaASzPxqk9jH+NGW4Ym8X1CGF1h16J
	 +rwsnHvL5vqT+UCv5SdBTK46Asz5moG1WF6/RCZ4BfzwbhrbAhh26bPM6n0bpC2vDl
	 v1qNiYhqA/QPZtNYNq8J7n0mubYCU+K4feYwkawo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/163] syscalls: fix sys_fanotify_mark prototype
Date: Tue,  2 Jul 2024 19:04:23 +0200
Message-ID: <20240702170238.702993799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 705977c1b2b2b..36c592e43d652 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -840,9 +840,15 @@ asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
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



