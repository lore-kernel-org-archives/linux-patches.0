Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036997;
	b=KDCNIVdVQzbu1Kc0udGd557C/Uo/7iDZzLLTKQWHnB8yexHOwNKsyxwhrFd8QJ6hqyM6
	 5PpGHN+so7ZgQrjIHquu8ulYbC6EMph2bNf0NG6VpyKbQD4RR3GjAoADGAXm2e7WMtSjB
	 vxxWP0fznYm5ssV9GzVEDeLs5ijAsEZ+F/2cSpatjDYETc6iPj5JqBZTLf3AQazDd4NfK
	 755dBFLXwrYxbYqCjopWKeDV3wqvEOJzjPgVT0e0vvL2XLrP5Y8NveANTKS26R8il+Rse
	 +2Q+aUZTuEd3PDBpwdVQ9fZ2YEFo+SJBMi5xJGS02n5d2lW1CJ5fInemdjWnZX2iplw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1fnKJPgYnIlhf/PZnc+DCjMwkElF5ME/uBSNsLx1JI=;
	b=zsYhLJLZvXsjIPXftJQy/Zo1zSnV4/cSGyFDOKR0GdgUxvqMNTNgTUGmCfuLS8wVeclJ
	 w2xb84PuJ1rHwXOxEgpxSdIW9ajiYfUexSOtLG4Rv7mDoGvOJWpwW2H0fOjmV5PtUxEJQ
	 5qqM17cFYVNUtoN0q+MJPlkwHCxv+txQrBTM1AZY87fk+Eo2ZcaecoSisCYSThPaDG2up
	 websW1QpqlfSOY+HxB84c9akVnTkVEwNdD2xOflqsGhX7M4Njy01tSFfsphZFWRMLSDb5
	 xEhBbBHwvjv548hfv0/MM1MUON6jRy5JP1NZFhKxJFh6yIpguj2i0F19ispfUeSOq7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iAaFg3cg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56F9606A32A;
	Wed, 18 Nov 2026 21:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iAaFg3cg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42231F000C5;
	Wed, 18 Nov 2026 21:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036997;
	bh=m1fnKJPgYnIlhf/PZnc+DCjMwkElF5ME/uBSNsLx1JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAaFg3cg96wezn/M/nTbFB3tWrAC2hY06NsY2xyezdccrYWZrIWtms4i+M10MPtkw
	 2DtiH/H4Y45vsme7ACaMsQtYvvAm28rbvWpeibM17KO+SEG5ZZc47gKWelk6zwTnlL
	 lG9nmC3UICYaJV/iON/QkcsmC2r1Ob3ILqlKZUbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1258/3318] LoongArch: Fix bitmask corruption in update_bp_registers()
Date: Wed, 18 Nov 2026 15:31:20 +0100
Message-ID: <20261118150357.942247813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



