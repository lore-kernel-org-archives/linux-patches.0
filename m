Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7EF297A62;
	Mon, 12 May 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073047; cv=none; b=VOwp3Yfkr3anN9RiEBDwXVDSlP49BFA3y6uhNQe9HsYjBTqqVhMVpiE8VD5i3yeMFoECezu5hEzsZ2vEqMXBiUhqNIcxnjDyw/FbiC0eqYpx+vBi12C/o+ZNsFUMKmGW98VdpWFJ/DtPd1t6qkOk6J1ZPsyOU2zpnplGVeKG0gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073047; c=relaxed/simple;
	bh=7AdmamawxFHQVl9sNZyBGg7z72bkK+K1M5B0fw/WG7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyMsaoxZyFi6xHogDfyERreNIaeSxyoXVI2+i0aTNjdRZaqALj4ob2+qar+rSQ7BxE3E/9/qM/nIB9cwxFc462OdT8Ik7j9Jt4YoMC044/y7COyPjnFt/rXaz6bahRzXNGl4MjAyk8PJnYT8lz/W+BBetzcKeARKY/OnZRwvwVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLELGVwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLELGVwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D5C4CEE7;
	Mon, 12 May 2025 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073046;
	bh=7AdmamawxFHQVl9sNZyBGg7z72bkK+K1M5B0fw/WG7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLELGVwVC1UmcO8rA7v7ESzh9yG2gZhwdH5psuKpkaR7fomWYvCLF41LEYIMGw4+0
	 F6+scQcs9H3H9qdU0+yeYsudEfhkl9A1zJf/1lAaeCtUtOI4F+XBPWCCTypkuS41cx
	 YjrW8vD4+wsogf3iINktVtzDR/ADainjdUt2Ba+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong Li <zong.li@sifive.com>,
	Nylon Chen <nylon.chen@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/184] riscv: misaligned: Add handling for ZCB instructions
Date: Mon, 12 May 2025 19:45:39 +0200
Message-ID: <20250512172047.434221281@linuxfoundation.org>
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

From: Nylon Chen <nylon.chen@sifive.com>

[ Upstream commit eb16b3727c05ed36420c90eca1e8f0e279514c1c ]

Add support for the Zcb extension's compressed half-word instructions
(C.LHU, C.LH, and C.SH) in the RISC-V misaligned access trap handler.

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Nylon Chen <nylon.chen@sifive.com>
Fixes: 956d705dd279 ("riscv: Unaligned load/store handling for M_MODE")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250411073850.3699180-2-nylon.chen@sifive.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 9a80a12f6b48f..d14bfc23e315b 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -87,6 +87,13 @@
 #define INSN_MATCH_C_FSWSP		0xe002
 #define INSN_MASK_C_FSWSP		0xe003
 
+#define INSN_MATCH_C_LHU		0x8400
+#define INSN_MASK_C_LHU			0xfc43
+#define INSN_MATCH_C_LH			0x8440
+#define INSN_MASK_C_LH			0xfc43
+#define INSN_MATCH_C_SH			0x8c00
+#define INSN_MASK_C_SH			0xfc43
+
 #define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
 
 #if defined(CONFIG_64BIT)
@@ -405,6 +412,13 @@ int handle_misaligned_load(struct pt_regs *regs)
 		fp = 1;
 		len = 4;
 #endif
+	} else if ((insn & INSN_MASK_C_LHU) == INSN_MATCH_C_LHU) {
+		len = 2;
+		insn = RVC_RS2S(insn) << SH_RD;
+	} else if ((insn & INSN_MASK_C_LH) == INSN_MATCH_C_LH) {
+		len = 2;
+		shift = 8 * (sizeof(ulong) - len);
+		insn = RVC_RS2S(insn) << SH_RD;
 	} else {
 		regs->epc = epc;
 		return -1;
@@ -504,6 +518,9 @@ int handle_misaligned_store(struct pt_regs *regs)
 		len = 4;
 		val.data_ulong = GET_F32_RS2C(insn, regs);
 #endif
+	} else if ((insn & INSN_MASK_C_SH) == INSN_MATCH_C_SH) {
+		len = 2;
+		val.data_ulong = GET_RS2S(insn, regs);
 	} else {
 		regs->epc = epc;
 		return -1;
-- 
2.39.5



