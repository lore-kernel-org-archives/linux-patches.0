Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8BA168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1705C433D2;
	Mon, 22 May 2023 19:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784174;
	bh=JFB4wNMYrRhPcP3j9agwZ9FSBmoFLwrEKiv6gd4YiYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDES8DC+5Fql5dbgqz4bfw9n7/ve/K1Now/NZnTskddwevVA+h7gC56Jmr/oAtguM
	 f3HeHatEmyn68eTQmtjQZxqbGr1TjFgGVkXwyq+37sdfa96ZRpobJthhCDAmlSAtw5
	 ht6LOYI4mqc0Ipylbn92GBFuoNZM6zURYA2y99/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Gao <zegao@tencent.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 287/292] rethook, fprobe: do not trace rethook related functions
Date: Mon, 22 May 2023 20:10:44 +0100
Message-Id: <20230522190413.120987197@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ze Gao <zegao2021@gmail.com>

commit 571a2a50a8fc546145ffd3bf673547e9fe128ed2 upstream.

These functions are already marked as NOKPROBE to prevent recursion and
we have the same reason to blacklist them if rethook is used with fprobe,
since they are beyond the recursion-free region ftrace can guard.

Link: https://lore.kernel.org/all/20230517034510.15639-5-zegao@tencent.com/

Fixes: f3a112c0c40d ("x86,rethook,kprobes: Replace kretprobe with rethook on x86")
Signed-off-by: Ze Gao <zegao@tencent.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/Makefile |    2 ++
 arch/s390/kernel/Makefile         |    1 +
 arch/x86/kernel/Makefile          |    1 +
 3 files changed, 4 insertions(+)

--- a/arch/riscv/kernel/probes/Makefile
+++ b/arch/riscv/kernel/probes/Makefile
@@ -4,3 +4,5 @@ obj-$(CONFIG_KPROBES)		+= kprobes_trampo
 obj-$(CONFIG_KPROBES_ON_FTRACE)	+= ftrace.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o decode-insn.o simulate-insn.o
 CFLAGS_REMOVE_simulate-insn.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_rethook.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_rethook_trampoline.o = $(CC_FLAGS_FTRACE)
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -10,6 +10,7 @@ CFLAGS_REMOVE_ftrace.o		= $(CC_FLAGS_FTR
 
 # Do not trace early setup code
 CFLAGS_REMOVE_early.o		= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_rethook.o		= $(CC_FLAGS_FTRACE)
 
 endif
 
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -17,6 +17,7 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_sev.o = -pg
+CFLAGS_REMOVE_rethook.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n


