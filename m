Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C351214A84;
	Sat, 12 Sep 2026 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216343; cv=none; b=PWOIOjneZDuPCa+0wykn+2IvScrfFRUd1/vi96xmCLJVCmNKWn/uIipiV38Me+KlMFWzwSGCSmh3G/7cz5/4AUUjnL/OBFg3lELlo7Rhv84dXDxfCqmODV62sammiM0v6vJ+9aoIE8IbJDi1VtMzeA8tGhJEhDrrSNtnghMx8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216343; c=relaxed/simple;
	bh=cgI8Cbt8FTbFfJP6+9DfRoyTjqx0eUE8CTYnXgO8i34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqQ/EYcvyxn6tlq0k6mXuGFwA79vgQQVi6b6qkgNysD+XLwQViaWfWcgOHi1wtujR4jJgWqM3rcl1AZBCYE4bwRI7NARTuMe1du1HMAHXOcCAIyzjVSVMfWmwuEJApBnYx/CaJD24bF02widyZfNRV2ym5J/KODoKv8XLM6clGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjRj3HG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjRj3HG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30391F000FF;
	Sat, 12 Sep 2026 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216341;
	bh=/KW2qpDSh0KBCUHx3cBf/k7R+8DxAOBMTRB4KN0rLI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjRj3HG6ANTGu3roedlsdkGWUfIq8MDgJQpEBMysDtcoujezg8a6ZClhxijw2Sjne
	 UBK57rNKEup+WaSqaNn9ckQRbduIDCZw8jLtY/7OyMZMKxDKzNokTxKipaDrsTrZ7Z
	 94ZzKgy/Ct02buQLPXZIWQm2kKBoOyQrr+Tz90j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0717/1376] clk: mediatek: mt8135: Fix inverted gate control for devapc_ck
Date: Sat, 12 Sep 2026 08:52:23 +0200
Message-ID: <20260912065623.522343562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit fd0e3e4edea6a3e4da91be608ca2fb9b348f9e32 ]

The devapc_ck (CLK_INFRA_DEVAPC) on MT8135 is currently using
"mtk_clk_gate_ops_setclr". However, checking the downstream kernel reveals
that this clock is configured with set:enable and clr:disable making
"mtk_clk_gate_ops_setclr_inv" the appropriate choice.
But, it is strange that some downstream kernels are not like that.

Amazon: INV
ChromiumOS (early): not INV
ChromiumOS 3.16 to 3.18-revew-v2: INV
ChromiumOS 3.18-review-v3 and later (sent to kernel.org): not INV

Link: https://github.com/amazon-oss/android_kernel_amazon_mt8135/blob/e2b2163a8ec4a7c8d961c89003a15b4ba0f0e371/arch/arm/mach-mt8135/mt_clkmgr.c#L1022-L1028
Link: https://github.com/mtk09422/chromiumos-third_party-kernel-mediatek/blob/4b624ee66e65d5dcd43fca36b313086efae8922a/arch/arm/boot/dts/mt8135-clocks.dtsi#L944-L948
Link: https://github.com/mtk09422/chromiumos-third_party-kernel-mediatek/blob/decd80c01d0dbe9f3afa8ff72273b5618b418180/drivers/clk/mediatek/clk-mt8135.c#L881-L882
Link: https://github.com/mtk09422/chromiumos-third_party-kernel-mediatek/blob/9b6f06cb7637100aa1a42e1fc351b36b384a1c54/drivers/clk/mediatek/clk-mt8135.c#L450
Fixes: a8aede794843 ("clk: mediatek: Add basic clocks for Mediatek MT8135.")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8135.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt8135.c b/drivers/clk/mediatek/clk-mt8135.c
index 084e48a554c26..1d20e15608f77 100644
--- a/drivers/clk/mediatek/clk-mt8135.c
+++ b/drivers/clk/mediatek/clk-mt8135.c
@@ -409,6 +409,9 @@ static const struct mtk_gate_regs infra_cg_regs = {
 	GATE_MTK_FLAGS(_id, _name, _parent, &infra_cg_regs, _shift,	\
 		       &mtk_clk_gate_ops_setclr, CLK_IS_CRITICAL)
 
+#define GATE_ICG_INV(_id, _name, _parent, _shift)	\
+	GATE_MTK(_id, _name, _parent, &infra_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
+
 static const struct mtk_gate infra_clks[] = {
 	GATE_DUMMY(CLK_DUMMY, "infra_dummy"),
 	GATE_ICG(CLK_INFRA_PMIC_WRAP, "pmic_wrap_ck", "axi_sel", 23),
@@ -419,7 +422,7 @@ static const struct mtk_gate infra_clks[] = {
 	GATE_ICG(CLK_INFRA_CPUM, "cpum_ck", "cpum_tck_in", 15),
 	GATE_ICG_AO(CLK_INFRA_M4U, "m4u_ck", "mem_sel", 8),
 	GATE_ICG(CLK_INFRA_MFGAXI, "mfgaxi_ck", "axi_sel", 7),
-	GATE_ICG(CLK_INFRA_DEVAPC, "devapc_ck", "axi_sel", 6),
+	GATE_ICG_INV(CLK_INFRA_DEVAPC, "devapc_ck", "axi_sel", 6),
 	GATE_ICG(CLK_INFRA_AUDIO, "audio_ck", "aud_intbus_sel", 5),
 	GATE_ICG(CLK_INFRA_MFG_BUS, "mfg_bus_ck", "axi_sel", 2),
 	GATE_ICG(CLK_INFRA_SMI, "smi_ck", "smi_sel", 1),
-- 
2.53.0



