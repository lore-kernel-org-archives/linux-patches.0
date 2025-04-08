Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC0227EBD;
	Tue,  8 Apr 2025 11:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112213; cv=none; b=d08hgyuBI1MIL4hpvtivk6WBuOgsx2eCsfeABmSrDWqrhi+BuTdfyP8psZJRehNRXle+8R0umXyNt+9l95V7WIXzO9ccD+HA6ZQT77mnpOzVUzbQbpD8PRnzPsX1H7PleW0eqm45A7U9kRNfxYsF8vMBAuRGu3v9Off4ViIXYNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112213; c=relaxed/simple;
	bh=a4nIaeQ8Kep0mS7vPnZwwVXXqEzQAGQd1UMxO9adHJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czDz+TYa5rR1R/fAxUqeK4B5xbtOD17AnmIJIoWAs58r51NptHrKEOUP38wQSgIndFk/UQPgqkhVQ/O4K5aVaM3K2NWvXnwwvHODM6kwc8t32+3smBl7ufdvPmMgGOaBQ3PfkUJDFQ8v7gPvoY7/ehLPd6fQYOURGQVkSZEjOIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGrnsQYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGrnsQYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C416C4CEE5;
	Tue,  8 Apr 2025 11:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112213;
	bh=a4nIaeQ8Kep0mS7vPnZwwVXXqEzQAGQd1UMxO9adHJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGrnsQYf5ogwz1GujJsQJxdaTEvUArtWhfWSiHy6U0a/vCrZx77d0giFxuR81SaQC
	 Aj7FnpmwXgCgPnYaoudbtliGCyqxcGSaNHwu8yfatd+Cv3ewGBfYhoUxfWYHFc17Du
	 uhEDKXzty9iSjfTMv8w/6VgxSeWAjcKAdn5cr9+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 6.14 680/731] uprobes/x86: Harden uretprobe syscall trampoline check
Date: Tue,  8 Apr 2025 12:49:37 +0200
Message-ID: <20250408104930.084971030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit fa6192adc32f4fdfe5b74edd5b210e12afd6ecc0 upstream.

Jann reported a possible issue when trampoline_check_ip returns
address near the bottom of the address space that is allowed to
call into the syscall if uretprobes are not set up:

   https://lore.kernel.org/bpf/202502081235.5A6F352985@keescook/T/#m9d416df341b8fbc11737dacbcd29f0054413cbbf

Though the mmap minimum address restrictions will typically prevent
creating mappings there, let's make sure uretprobe syscall checks
for that.

Fixes: ff474a78cef5 ("uprobe: Add uretprobe syscall to speed up return probe")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250212220433.3624297-1-jolsa@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/uprobes.c |   14 +++++++++-----
 include/linux/uprobes.h   |    2 ++
 kernel/events/uprobes.c   |    2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -357,19 +357,23 @@ void *arch_uprobe_trampoline(unsigned lo
 	return &insn;
 }
 
-static unsigned long trampoline_check_ip(void)
+static unsigned long trampoline_check_ip(unsigned long tramp)
 {
-	unsigned long tramp = uprobe_get_trampoline_vaddr();
-
 	return tramp + (uretprobe_syscall_check - uretprobe_trampoline_entry);
 }
 
 SYSCALL_DEFINE0(uretprobe)
 {
 	struct pt_regs *regs = task_pt_regs(current);
-	unsigned long err, ip, sp, r11_cx_ax[3];
+	unsigned long err, ip, sp, r11_cx_ax[3], tramp;
+
+	/* If there's no trampoline, we are called from wrong place. */
+	tramp = uprobe_get_trampoline_vaddr();
+	if (unlikely(tramp == UPROBE_NO_TRAMPOLINE_VADDR))
+		goto sigill;
 
-	if (regs->ip != trampoline_check_ip())
+	/* Make sure the ip matches the only allowed sys_uretprobe caller. */
+	if (unlikely(regs->ip != trampoline_check_ip(tramp)))
 		goto sigill;
 
 	err = copy_from_user(r11_cx_ax, (void __user *)regs->sp, sizeof(r11_cx_ax));
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -39,6 +39,8 @@ struct page;
 
 #define MAX_URETPROBE_DEPTH		64
 
+#define UPROBE_NO_TRAMPOLINE_VADDR	(~0UL)
+
 struct uprobe_consumer {
 	/*
 	 * handler() can return UPROBE_HANDLER_REMOVE to signal the need to
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2180,8 +2180,8 @@ void uprobe_copy_process(struct task_str
  */
 unsigned long uprobe_get_trampoline_vaddr(void)
 {
+	unsigned long trampoline_vaddr = UPROBE_NO_TRAMPOLINE_VADDR;
 	struct xol_area *area;
-	unsigned long trampoline_vaddr = -1;
 
 	/* Pairs with xol_add_vma() smp_store_release() */
 	area = READ_ONCE(current->mm->uprobes_state.xol_area); /* ^^^ */


