Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDB52980C2;
	Mon, 12 May 2025 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073207; cv=none; b=Z2lW8OahFCG/F5wC6CxJefqtr6JZjGUDBslUwlRCvkAmWRL6LSZcrbit3eatUOId+zGN0wwM2JDSaCgxtlQWbsdSBpN3TRcDTQ7NkFC2L6sTA0rQg5zqKuSrIarrhHKH9Pl2/VegV2SD+cvoxmyoMiSgaTawl36dBjuBMO5HEE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073207; c=relaxed/simple;
	bh=OZ1gd6sNFMKkkTTlCyq/9miZBJSBXEvZf9/h4RWOdlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjndepALYNaPk1EF0FfVT1xpq+1WK5hm2N0Vs6P+ZEtdCFYzIcLTLVT8A0Zk85WHg657johShar5PgiYPjFhulCneDxSY6mzaA7rIRNtNe0GjWIeu22D9zHaGk1W8jEq/MoK2IBgrN+R6ZIlXpMRD/4vmCNbVbOmagVQxux6iKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mONzR8Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mONzR8Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E020C4CEE7;
	Mon, 12 May 2025 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073206;
	bh=OZ1gd6sNFMKkkTTlCyq/9miZBJSBXEvZf9/h4RWOdlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mONzR8DvNes3QWGD63iDlpmU7ILYgwQ5/GoDiWsH20ZZMZgsNkyUb2AeEwzFCe9X1
	 KYbOTUZD/CmU0S0RYDbT+p1UfuIpIZJwgne35GSnJ8ay+pzQvn/nP0OObVrkopXxEq
	 6V0V9X0ci2cMTwp/WxDkFVOu1hOPi0VpyEBnr8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 162/184] arm64: insn: Add support for encoding DSB
Date: Mon, 12 May 2025 19:46:03 +0200
Message-ID: <20250512172048.410870514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit 63de8abd97ddb9b758bd8f915ecbd18e1f1a87a0 upstream.

To generate code in the eBPF epilogue that uses the DSB instruction,
insn.c needs a heler to encode the type and domain.

Re-use the crm encoding logic from the DMB instruction.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |    1 
 arch/arm64/lib/insn.c         |   60 +++++++++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 23 deletions(-)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -693,6 +693,7 @@ u32 aarch64_insn_gen_cas(enum aarch64_in
 }
 #endif
 u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type);
+u32 aarch64_insn_gen_dsb(enum aarch64_insn_mb_type type);
 u32 aarch64_insn_gen_mrs(enum aarch64_insn_register result,
 			 enum aarch64_insn_system_register sysreg);
 
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2014-2016 Zi Shen Lim <zlim.lnx@gmail.com>
  */
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/printk.h>
@@ -1471,48 +1472,61 @@ u32 aarch64_insn_gen_extr(enum aarch64_i
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
 


