Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063737;
	b=2ndKT3L49WlUTvxfVG3dLgGIYIrnWGwCAa/N6KNlLTExcRzz0551wuQF/nlwy3XoqTFk
	 FuZHeL3eEVl072gc1XuhaqY/R+8khYWzRO31a8Z+HH7MjMxGtIMCzjQzDdqqntgK9EfKc
	 ElxKkZaAcOQDFrVllnamV5hUiL2l/nQAZYDiEB6oKnIr/e1P3nNVs1fyv5VGnMHQlsJFY
	 uqw78tY3tr/nPwES/NHTw9ZBMsgZEDLCNPp8MG5VOxjHrQwp5CYPs/KkvBd7nrSwzTrHt
	 Na/g49bML40PS0OkluCI0Rytm19OT8Cw0gRCF43LDuQcYZQz7hp0ptvOGLl5vdRXqIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0Vx+ZV2fr3YdUZi1wSGOeS6YpQn7PXZ2CTfNwRBMM0=;
	b=nSwTGajXo8DZxsi/iD0v/rNn8wREffTmGmffLc/ql0LdEqlxNxUaQFazyEgU/vZwXc7s
	 ndbEEjDPRCg1rEEn2ANgllH7FpeXOT0Fgfq50sH1d0EiskO0C23in4Lnj4/Vyy+yfn9Mi
	 q/3vef8hC1OyEGw+pL+eWOlr9rPfziHHpY8jotpbJppZ9krIFi3576d+tqAfHwxERXee+
	 dzxZdbINQMF+fjceFuY2k0jTwTBURFM4MZ2f7MczyvJZGLUTs7OXN2OTA0TMSTTyhmO2a
	 OMwGxfAXHX9HrZ8iEO0xTQL54Tchg+CXvs4DefPqDo+7KMIqSNSEwyttcITMIyOds8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrqtWwXe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7BB606A32D;
	Sat,  7 Nov 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrqtWwXe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B691F0089F;
	Sat,  7 Nov 2026 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063736;
	bh=f0Vx+ZV2fr3YdUZi1wSGOeS6YpQn7PXZ2CTfNwRBMM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrqtWwXefBaBTkQ7qyz20tiSzezh4k/S9s38ww26gKEYa8QP8wU5BoSobxmVy9wGl
	 sq5cZUhokz5chhCu1NtEFQSm4bFUIm9qul+oVV5L7IQlG3krasvd+bzLASPaH32fWG
	 Yh4B7nn83oICyOu5KQr4f8x8LzWVLISz+lPBfHgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 806/869] LoongArch: Fix bitmask corruption in update_bp_registers()
Date: Sat,  7 Nov 2026 08:58:08 -0500
Message-ID: <20261107134920.285488715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



