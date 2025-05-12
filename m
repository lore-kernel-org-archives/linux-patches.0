Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63251A08CA;
	Mon, 12 May 2025 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072206; cv=none; b=rKieD4XKu4Lpl2UlD5V8KfEx2KsdjjgHml/EknT5Ub38uxWB3wchD8Xa92MToxnZd1njWESY0HcLUTMEupoqB1lxNvEpa2pV65jPEi94TFn5tlEPN5lNXHl0XS/t4fQ5KLkBp2XjVPI0P5KtoKTq5FL0I8K73FL75BzbbHYwN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072206; c=relaxed/simple;
	bh=em2ICtvT8Su2mznLks5GNO/JEvlJNxcv0J63PtJNb34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtKYiRRJ9cQeJJFmctdu+9J/VbxdGiRnJWHMP96p/30wrM1MpchZu26X+CxgXgexcOfEwZ1Lr+SWtd65iRAusYQavkRcQ64y89FAJSm+2on4UPMuAoTIbAcYBcW3tWSZT/p3m+v2WiTdP12qjpiAOnojfmfZpEfkSHryb818NaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05rO1lJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05rO1lJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C26C4CEE7;
	Mon, 12 May 2025 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072206;
	bh=em2ICtvT8Su2mznLks5GNO/JEvlJNxcv0J63PtJNb34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05rO1lJpNTgqNKCyP+fhT6MJPQYn4IAxpeCPEow7uw/7J0mZCcL60fWottR5QgU+T
	 NZxsqK3NkLuCRMQ3mwzIK3KDrIP8pXXzcmKnwmzbpRa63nRdz02Il/b5NAOrRVEV/Y
	 JJKzYgvnDYTw75lMB91JwGehZsY5t7kTeRohWHW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong Li <zong.li@sifive.com>,
	Nylon Chen <nylon.chen@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 160/197] riscv: misaligned: Add handling for ZCB instructions
Date: Mon, 12 May 2025 19:40:10 +0200
Message-ID: <20250512172050.898823596@linuxfoundation.org>
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
index 4354c87c0376f..dde5d11dc1b50 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -88,6 +88,13 @@
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
@@ -431,6 +438,13 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
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
@@ -530,6 +544,9 @@ static int handle_scalar_misaligned_store(struct pt_regs *regs)
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



