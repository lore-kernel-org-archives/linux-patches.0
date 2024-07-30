Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15371A6166;
	Tue, 30 Jul 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358049; cv=none; b=ExmfByyZDEOu2oRf4/CiBUU+INDeyyUYC/7qhR4ijvP6ZEtc/uFJqs1kjZNPog8jJhN2Jnuf04Vomzd46MdfK5osl4y+c2fAMeC90II7AEWIVKgoTyf6Sw8tNv7u35Xq7tUFn0MaJ+9LggUbJ2o+uRPkjRGCUSFSbZdDEpV3dfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358049; c=relaxed/simple;
	bh=yxZ/QvOFh/EXWVikLmOyTtbzX48m+3KhMFjD0tR3cOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7Ql4AMXPzRMBqPAey2uRpya+LZk0oZgapZrM4giC8a566OV2S4iTEi4hEbFAyp8WdSZA2/H2+iZSqv0ibeGJlXdWiBNqj1eoaaBqFxraPl1hZLuEu58HKbpNy6vYtDo5hDz6aDx9Rm25MXLHc9C81zuUEiBfOgFGSYPy2okyr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8a1pxOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8a1pxOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C6C32782;
	Tue, 30 Jul 2024 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358049;
	bh=yxZ/QvOFh/EXWVikLmOyTtbzX48m+3KhMFjD0tR3cOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8a1pxOPy3ZoJQFEnPovq6Lw2LqRy46u5VHplUdOaoFb0VEfQw0VPknNvXqpzcMJZ
	 jb5x/9zTKyX/RntDWKHvcIGzHsKZeqEORRKjThoLPQ9jyzOEkImDnEPJA2E/TSHW8I
	 VHY1wvyujsEXayikanyczou4b32kewpykEAj92cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 306/809] x86/shstk: Make return uprobe work with shadow stack
Date: Tue, 30 Jul 2024 17:43:02 +0200
Message-ID: <20240730151736.685236949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 1713b63a07a28a475de94664f783b4cfd2e4fa90 ]

Currently the application with enabled shadow stack will crash
if it sets up return uprobe. The reason is the uretprobe kernel
code changes the user space task's stack, but does not update
shadow stack accordingly.

Adding new functions to update values on shadow stack and using
them in uprobe code to keep shadow stack in sync with uretprobe
changes to user stack.

Link: https://lore.kernel.org/all/20240611112158.40795-2-jolsa@kernel.org/

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Fixes: 488af8ea7131 ("x86/shstk: Wire in shadow stack interface")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/shstk.h |  2 ++
 arch/x86/kernel/shstk.c      | 11 +++++++++++
 arch/x86/kernel/uprobes.c    |  7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/shstk.h b/arch/x86/include/asm/shstk.h
index 42fee8959df7b..896909f306e30 100644
--- a/arch/x86/include/asm/shstk.h
+++ b/arch/x86/include/asm/shstk.h
@@ -21,6 +21,7 @@ unsigned long shstk_alloc_thread_stack(struct task_struct *p, unsigned long clon
 void shstk_free(struct task_struct *p);
 int setup_signal_shadow_stack(struct ksignal *ksig);
 int restore_signal_shadow_stack(void);
+int shstk_update_last_frame(unsigned long val);
 #else
 static inline long shstk_prctl(struct task_struct *task, int option,
 			       unsigned long arg2) { return -EINVAL; }
@@ -31,6 +32,7 @@ static inline unsigned long shstk_alloc_thread_stack(struct task_struct *p,
 static inline void shstk_free(struct task_struct *p) {}
 static inline int setup_signal_shadow_stack(struct ksignal *ksig) { return 0; }
 static inline int restore_signal_shadow_stack(void) { return 0; }
+static inline int shstk_update_last_frame(unsigned long val) { return 0; }
 #endif /* CONFIG_X86_USER_SHADOW_STACK */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 6f1e9883f0742..9797d4cdb78a2 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -577,3 +577,14 @@ long shstk_prctl(struct task_struct *task, int option, unsigned long arg2)
 		return wrss_control(true);
 	return -EINVAL;
 }
+
+int shstk_update_last_frame(unsigned long val)
+{
+	unsigned long ssp;
+
+	if (!features_enabled(ARCH_SHSTK_SHSTK))
+		return 0;
+
+	ssp = get_user_shstk_addr();
+	return write_user_shstk_64((u64 __user *)ssp, (u64)val);
+}
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 6c07f6daaa227..6402fb3089d26 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1076,8 +1076,13 @@ arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs
 		return orig_ret_vaddr;
 
 	nleft = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
-	if (likely(!nleft))
+	if (likely(!nleft)) {
+		if (shstk_update_last_frame(trampoline_vaddr)) {
+			force_sig(SIGSEGV);
+			return -1;
+		}
 		return orig_ret_vaddr;
+	}
 
 	if (nleft != rasize) {
 		pr_err("return address clobbered: pid=%d, %%sp=%#lx, %%ip=%#lx\n",
-- 
2.43.0



