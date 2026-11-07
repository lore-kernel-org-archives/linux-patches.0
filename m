Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062664;
	b=MyQIVIE75WmZTCRY50rhzsY3LP1cipuVy4LC/CjaUcwN4iXIGxByX7uO39APp0Rc++GP
	 34lN1qCixVVnmwAmUStinMPkDuGst0flHT+8MHcouHoSvDaUmxOpNzOxsfT4/I3P0B1yi
	 QkGCkSWzheTqtJ9Y3SgtSCSmA1GEs4Xrx56iF6nn7rZrSxGHVdAnL1lK3ifLDUmv6CFCo
	 U8Q+ASxR9/KuxGkSdyEIJC4shdSIsANhH2hVDTiRRuJZ1e2YVjtmXkegYfmyB2ul15bYq
	 /kv2JgN0iQWNe0/pyRynQlSYvtOMgSkR0pxDxXtYAVHdoBJLfq3TXUIz+BTSHdgxkww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/YgG1n2hAb5OfaRU3dbwBiaYEEOl3VLSSZQ0oe80PM=;
	b=Ecnra5IOH3Y2oD/ZEyiCYC2fddecEHtyrCzrsy1BfPo46IG6Lm7O+MbStiUts7YOMKcM
	 OkpuAkmac3Nv6yopCGXpY8UTjafBqdilG0u6qjPfX8U2AG4i1v7Jz8TRry5QvItt2+0Cd
	 fyFSynbmEPadUXXf+54JzqEB9fth8ZfDgD6bZY+iaVjg0el7sYHk31Hqx79rBFwMcG9W5
	 e8yZcXKp7DbKaVyhsrKvtYUcgqokccu7PgPq9nID6ZXJRfV+t7F6XI7mfsBl6R1mdxOqg
	 65fMdQSwmk4UkOss5HzAjlkISzOVELfXGGmyi1u8Sd3O/+og1sAhjSLCn+d734UoF3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obPcQs12;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576A6606A33F;
	Sat,  7 Nov 2026 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obPcQs12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066601F0089F;
	Sat,  7 Nov 2026 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062664;
	bh=V/YgG1n2hAb5OfaRU3dbwBiaYEEOl3VLSSZQ0oe80PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obPcQs12hnc2yh76B4xFjAQLOwqmimuznrPcGLl4RSJZvcoxEEj6miUXj4LsyFl4h
	 A4bsLRstjJtdmJbwGn5C00jTmSgTrBasnxcjiEfEh1AQJa3x+39ytuVJ/HsyUr0BDF
	 MwJt35nDmyjsoaqJTbCss5JiqMbm2YKibojik8MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1489/1536] LoongArch: Fix bitmask corruption in update_bp_registers()
Date: Sat,  7 Nov 2026 08:58:25 -0500
Message-ID: <20261107135039.679402207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 30c52672bf456decf675c11f3c65acd73a6bcca8 ]

In update_bp_registers(), when disabling a LOAD or STORE watchpoint,
the code attempts to clear the bit of LoadEn or StoreEn by using the
standard bit-clearing pattern.

However, due to the omission of parentheses, the bitwise NOT operator
'~' takes higher precedence than the left shift operator '<<'. Then:
(1) ~0x1 << MWPnCFG3_LoadEn evaluates to "(~0x1) << 8 = 0xFFFFFE00",
(2) ~0x1 << MWPnCFG3_StoreEn evaluates to "(~0x1) << 9 = 0xFFFFFC00",
that incorrectly clears all configuration fields in the lower 8 bits.

These fields in the lower 8 bits contain critical configurations such
as DSOnly (bit 0), PLV0-PLV3 privilege levels (bits 1-4), and LCL (bit
7). Writing back these corrupted values severely breaks configuration
isolation and ruins the hardware watchpoint states.

Add parentheses to ensure the correct evaluation order, so that only
the targeted LoadEn/StoreEn bit is cleared while preserving the other
crucial configuration bits in the lower 8 bits.

Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5 ("LoongArch: Add hardware breakpoints/watchpoints support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/hw_breakpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index deeb2f9795705..bd891b3808a6b 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -468,9 +468,9 @@ static void update_bp_registers(struct pt_regs *regs, int enable, int type)
 			} else {
 				ctrl = read_wb_reg(CSR_CFG_CTRL, i, 1);
 				if (info->ctrl.type == LOONGARCH_BREAKPOINT_LOAD)
-					ctrl &= ~0x1 << MWPnCFG3_LoadEn;
+					ctrl &= ~(0x1 << MWPnCFG3_LoadEn);
 				if (info->ctrl.type == LOONGARCH_BREAKPOINT_STORE)
-					ctrl &= ~0x1 << MWPnCFG3_StoreEn;
+					ctrl &= ~(0x1 << MWPnCFG3_StoreEn);
 				write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl);
 			}
 			regs->csr_prmd &= ~CSR_PRMD_PWE;
-- 
2.53.0



