Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E311F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9C4C433C7;
	Fri, 21 Jul 2023 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965514;
	bh=YgpXDRRUZrfpBZxoQxOtzY8NnZyuqv3dexrwk9GBsRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcvziLDGDxvtLQiPiIioKhii5pdWgze3JO5qQIuwQ2QoDY3in/pQrXoDyLUkw/4v3
	 iszC7ZLKRWC4Sg8g7TWmiFntiv2ar9kZb1Bw86xG+PtDUlXn+SbHZ8hnXFq3gieKJD
	 jeX9GqtQaKmCH5H4GcweK4lCyIq0FSB4ttnxBAn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/532] ARM: 9303/1: kprobes: avoid missing-declaration warnings
Date: Fri, 21 Jul 2023 17:58:42 +0200
Message-ID: <20230721160615.661815210@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1b9c3ddcec6a55e15d3e38e7405e2d078db02020 ]

checker_stack_use_t32strd() and kprobe_handler() can be made static since
they are not used from other files, while coverage_start_registers()
and __kprobes_test_case() are used from assembler code, and just need
a declaration to avoid a warning with the global definition.

arch/arm/probes/kprobes/checkers-common.c:43:18: error: no previous prototype for 'checker_stack_use_t32strd'
arch/arm/probes/kprobes/core.c:236:16: error: no previous prototype for 'kprobe_handler'
arch/arm/probes/kprobes/test-core.c:723:10: error: no previous prototype for 'coverage_start_registers'
arch/arm/probes/kprobes/test-core.c:918:14: error: no previous prototype for '__kprobes_test_case_start'
arch/arm/probes/kprobes/test-core.c:952:14: error: no previous prototype for '__kprobes_test_case_end_16'
arch/arm/probes/kprobes/test-core.c:967:14: error: no previous prototype for '__kprobes_test_case_end_32'

Fixes: 6624cf651f1a ("ARM: kprobes: collects stack consumption for store instructions")
Fixes: 454f3e132d05 ("ARM/kprobes: Remove jprobe arm implementation")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/probes/kprobes/checkers-common.c | 2 +-
 arch/arm/probes/kprobes/core.c            | 2 +-
 arch/arm/probes/kprobes/opt-arm.c         | 2 --
 arch/arm/probes/kprobes/test-core.c       | 2 +-
 arch/arm/probes/kprobes/test-core.h       | 4 ++++
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/probes/kprobes/checkers-common.c b/arch/arm/probes/kprobes/checkers-common.c
index 4d720990cf2a3..eba7ac4725c02 100644
--- a/arch/arm/probes/kprobes/checkers-common.c
+++ b/arch/arm/probes/kprobes/checkers-common.c
@@ -40,7 +40,7 @@ enum probes_insn checker_stack_use_imm_0xx(probes_opcode_t insn,
  * Different from other insn uses imm8, the real addressing offset of
  * STRD in T32 encoding should be imm8 * 4. See ARMARM description.
  */
-enum probes_insn checker_stack_use_t32strd(probes_opcode_t insn,
+static enum probes_insn checker_stack_use_t32strd(probes_opcode_t insn,
 		struct arch_probes_insn *asi,
 		const struct decode_header *h)
 {
diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index 9bcae72dda440..3bd017f6e256a 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -233,7 +233,7 @@ singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
  * kprobe, and that level is reserved for user kprobe handlers, so we can't
  * risk encountering a new kprobe in an interrupt handler.
  */
-void __kprobes kprobe_handler(struct pt_regs *regs)
+static void __kprobes kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *p, *cur;
 	struct kprobe_ctlblk *kcb;
diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index c78180172120f..e20304f1d8bc9 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -145,8 +145,6 @@ __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
 	}
 }
 
-extern void kprobe_handler(struct pt_regs *regs);
-
 static void
 optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 {
diff --git a/arch/arm/probes/kprobes/test-core.c b/arch/arm/probes/kprobes/test-core.c
index c562832b86272..171c7076b89f4 100644
--- a/arch/arm/probes/kprobes/test-core.c
+++ b/arch/arm/probes/kprobes/test-core.c
@@ -720,7 +720,7 @@ static const char coverage_register_lookup[16] = {
 	[REG_TYPE_NOSPPCX]	= COVERAGE_ANY_REG | COVERAGE_SP,
 };
 
-unsigned coverage_start_registers(const struct decode_header *h)
+static unsigned coverage_start_registers(const struct decode_header *h)
 {
 	unsigned regs = 0;
 	int i;
diff --git a/arch/arm/probes/kprobes/test-core.h b/arch/arm/probes/kprobes/test-core.h
index f1d5583e7bbbb..7054d9fae2ea0 100644
--- a/arch/arm/probes/kprobes/test-core.h
+++ b/arch/arm/probes/kprobes/test-core.h
@@ -454,3 +454,7 @@ void kprobe_thumb32_test_cases(void);
 #else
 void kprobe_arm_test_cases(void);
 #endif
+
+void __kprobes_test_case_start(void);
+void __kprobes_test_case_end_16(void);
+void __kprobes_test_case_end_32(void);
-- 
2.39.2



