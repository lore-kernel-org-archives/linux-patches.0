Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E836C1A08CA;
	Mon, 12 May 2025 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072239; cv=none; b=NXIOQkth9PaRqZtvaBuz5HD8jfzWW5nWeLEWw2aN1/iyWFI3SuiYepuZn73h0ZRdVPMZ4Q8iwhehWT05hYnaoUQBQ0W+Urx2e97D0Yi/JUTek/p+y75gDr7CwyXZKx7BRsKTokvaAHMJ9yrO0DJtOdHEabYWYnBnLylexguXfw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072239; c=relaxed/simple;
	bh=67nEbj7V8QZL5Wnt9hNRdiYVdq003O8D02GpBKogCY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh8xrJKeQjZmPPSqvlRIS5w/tr8B8mTLENp+pDpYOpg1pHIViZEieG5GIk3TptDdGyKgClQMwDvDEgdZsUZ43lRx/0LX43I5sNsg3Ca8a32ge1IUiHYfdgGsWrswgOxcL8viHHz4Y6K2XgSTO3hN3vPt5LegQHEFt72PVLtHz8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaJ4qfgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaJ4qfgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E07EC4CEE7;
	Mon, 12 May 2025 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072238;
	bh=67nEbj7V8QZL5Wnt9hNRdiYVdq003O8D02GpBKogCY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaJ4qfgGTqmuQZk6U8YYCS3Y44YKX7NrCmuLRI4FLX3RtcWaEdE4ZufH9KsCtM6tp
	 1ky5AOJregspaGU2Lb5zIFki1io/80RJdS68ksGsi7csE9chDTDaSZPmbl6nY197QG
	 d6JpvgktJav4VG7qV2VpmfW/vomsClHiCZ+YqMBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.14 178/197] arm64: insn: Add support for encoding DSB
Date: Mon, 12 May 2025 19:40:28 +0200
Message-ID: <20250512172051.636489626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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
@@ -698,6 +698,7 @@ u32 aarch64_insn_gen_cas(enum aarch64_in
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
 


