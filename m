Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06E3FB1B;
	Mon, 23 Jun 2025 21:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715834; cv=none; b=pamX2FT67LYbrFTDM6xReQZ18Z7Uma7PnATYcvFBfgb9SMLGsW2d/bAFflAG2kY82Z1IbkhZkmTwdPKHJtmRT2Z7LBjYU5F3wXuOQQpCkVDB+HQ1GEWW5TCRxH950+ZR9UmmUO5JmTtjnpfxL9d3yE/1alMr2qzlEh4B0RI0oSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715834; c=relaxed/simple;
	bh=SBHqrhxb/aY35DdQUN5rR08OCqH2ZpFT5co97P3ok2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI+txGO43KYnKvYAdHBY/KbjgGKS7cLvYpEDwA8i4u7OD/kbGg1oqREnhQ0+XPBNToB21px+l6kqdE/gW+6yrSIzeraQ18Y4qzDJR6eG2jLi5r50y3Nwil04L588etcIn/6A7LNqWtsiCspWip/VVHJGtxXG9tSEIFoa2J9RI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdv9KPwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdv9KPwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CB1C4CEEA;
	Mon, 23 Jun 2025 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715834;
	bh=SBHqrhxb/aY35DdQUN5rR08OCqH2ZpFT5co97P3ok2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdv9KPwLq0sLDaMfwlnnwTnfiwCOpWR/2DWQxPHT0Gdzrr/y4cXYgQpQxEjQwmngz
	 83YJ4J0F3CK9UxLY6y6NfHbyuiIzNhtujWEpnaUw6Q3okQ4KQRkP8AkAJclee342bK
	 0Or15eOZZcu4q+QLIrYx5mPZXqf/uMaZTCP6xLuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 325/355] arm64: insn: Add support for encoding DSB
Date: Mon, 23 Jun 2025 15:08:46 +0200
Message-ID: <20250623130636.527434207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit 63de8abd97ddb9b758bd8f915ecbd18e1f1a87a0 ]

To generate code in the eBPF epilogue that uses the DSB instruction,
insn.c needs a heler to encode the type and domain.

Re-use the crm encoding logic from the DMB instruction.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |    1 
 arch/arm64/kernel/insn.c      |   60 +++++++++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 23 deletions(-)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -584,6 +584,7 @@ u32 aarch64_insn_gen_cas(enum aarch64_in
 }
 #endif
 u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type);
+u32 aarch64_insn_gen_dsb(enum aarch64_insn_mb_type type);
 
 s32 aarch64_get_branch_offset(u32 insn);
 u32 aarch64_set_branch_offset(u32 insn, s32 offset);
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2014-2016 Zi Shen Lim <zlim.lnx@gmail.com>
  */
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
@@ -1810,47 +1811,60 @@ u32 aarch64_insn_gen_extr(enum aarch64_i
 	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RM, insn, Rm);
 }
 
-u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type)
+static u32 __get_barrier_crm_val(enum aarch64_insn_mb_type type)
 {
-	u32 opt;
-	u32 insn;
-
 	switch (type) {
 	case AARCH64_INSN_MB_SY:
-		opt = 0xf;
-		break;
+		return 0xf;
 	case AARCH64_INSN_MB_ST:
-		opt = 0xe;
-		break;
+		return 0xe;
 	case AARCH64_INSN_MB_LD:
-		opt = 0xd;
-		break;
+		return 0xd;
 	case AARCH64_INSN_MB_ISH:
-		opt = 0xb;
-		break;
+		return 0xb;
 	case AARCH64_INSN_MB_ISHST:
-		opt = 0xa;
-		break;
+		return 0xa;
 	case AARCH64_INSN_MB_ISHLD:
-		opt = 0x9;
-		break;
+		return 0x9;
 	case AARCH64_INSN_MB_NSH:
-		opt = 0x7;
-		break;
+		return 0x7;
 	case AARCH64_INSN_MB_NSHST:
-		opt = 0x6;
-		break;
+		return 0x6;
 	case AARCH64_INSN_MB_NSHLD:
-		opt = 0x5;
-		break;
+		return 0x5;
 	default:
-		pr_err("%s: unknown dmb type %d\n", __func__, type);
+		pr_err("%s: unknown barrier type %d\n", __func__, type);
 		return AARCH64_BREAK_FAULT;
 	}
+}
+
+u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type)
+{
+	u32 opt;
+	u32 insn;
+
+	opt = __get_barrier_crm_val(type);
+	if (opt == AARCH64_BREAK_FAULT)
+		return AARCH64_BREAK_FAULT;
 
 	insn = aarch64_insn_get_dmb_value();
 	insn &= ~GENMASK(11, 8);
 	insn |= (opt << 8);
 
+	return insn;
+}
+
+u32 aarch64_insn_gen_dsb(enum aarch64_insn_mb_type type)
+{
+	u32 opt, insn;
+
+	opt = __get_barrier_crm_val(type);
+	if (opt == AARCH64_BREAK_FAULT)
+		return AARCH64_BREAK_FAULT;
+
+	insn = aarch64_insn_get_dsb_base_value();
+	insn &= ~GENMASK(11, 8);
+	insn |= (opt << 8);
+
 	return insn;
 }


