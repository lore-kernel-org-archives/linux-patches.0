Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC0B42A9B;
	Tue, 27 May 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367682; cv=none; b=kRViaPH7Tmj7aWZvxF/Ra95ArWBMtV+VBo45F1rTaSP6Mxm7Ir+FgoSksRa4cs6Fl3vm2l9VFdouuWlXoH/KJ8w0fJIMNvyVPHrFC5QO+I/kvmiMWYFknU1cO9w5HtO8HCNTg8mszcZjDrcfHx6QZLd+El/VJxfbLEQfb1Kk2C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367682; c=relaxed/simple;
	bh=+HRNbPEfrX87RRQ+U90pn1OEL8ab833WoxS9Gu5uAtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo6rjRg8uist1L/ib+NnkETior+wniHFiGEKhxGxCu+sB25wjKIjjZyKfaxpHOqxHs6C8phhxqFIkLxBjDWxflusD9gkdrfoP6BfUvNXh51KSBGbiJCHrjL6bxjJ2ckYlGzH+1tai6eFAIa2Jg0laCvsfWwRKI6x/V5ZKuCr9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efEtE3k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efEtE3k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA0AC4CEE9;
	Tue, 27 May 2025 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367682;
	bh=+HRNbPEfrX87RRQ+U90pn1OEL8ab833WoxS9Gu5uAtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efEtE3k/4UrYeWivhSvblG5qXvAtaBD/W44IBE2dMqcj7dQtnDaspuCvcCQ9/32FI
	 aeQZTtzLlVUXt1A7cZvamOMZOfiReMke64/AfFD2KlLk3KdFs0xJODPT47Qx9gQmmG
	 WJJq4SddLFaR+7p6jcIkYqchHx1+N6bfV7fSUHVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 465/783] x86/boot: Mark start_secondary() with __noendbr
Date: Tue, 27 May 2025 18:24:22 +0200
Message-ID: <20250527162532.075706307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 93f16a1ab78ca56e3cd997d1ea54c214774781ac ]

The handoff between the boot stubs and start_secondary() are before IBT is
enabled and is definitely not subject to kCFI. As such, suppress all that for
this function.

Notably when the ENDBR poison would become fatal (ud1 instead of nop) this will
trigger a tripple fault because we haven't set up the IDT to handle #UD yet.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20250207122546.509520369@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 3 ++-
 include/linux/objtool.h   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3d5069ee297bf..463634b138bbb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -229,7 +229,7 @@ static void ap_calibrate_delay(void)
 /*
  * Activate a secondary processor.
  */
-static void notrace start_secondary(void *unused)
+static void notrace __noendbr start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* except direct CPU state initialization
@@ -314,6 +314,7 @@ static void notrace start_secondary(void *unused)
 	wmb();
 	cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
 }
+ANNOTATE_NOENDBR_SYM(start_secondary);
 
 /*
  * The bootstrap kernel entry code has set these up. Save them for
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index c722a921165ba..3ca965a2ddc80 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -128,7 +128,7 @@
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
-#define __ASM_ANNOTATE(label, type)
+#define __ASM_ANNOTATE(label, type) ""
 #define ASM_ANNOTATE(type)
 #else
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
@@ -147,6 +147,8 @@
  * these relocations will never be used for indirect calls.
  */
 #define ANNOTATE_NOENDBR		ASM_ANNOTATE(ANNOTYPE_NOENDBR)
+#define ANNOTATE_NOENDBR_SYM(sym)	asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOENDBR))
+
 /*
  * This should be used immediately before an indirect jump/call. It tells
  * objtool the subsequent indirect jump/call is vouched safe for retpoline
-- 
2.39.5



