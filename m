Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9F32BDC0E;
	Sat, 12 Sep 2026 08:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200096; cv=none; b=kph2rlQVge+8SEUAxeDivw2URoMcWwMw39QxbIolNOf92tZefax1YxveY0vsToktTRueDKMfyqRa7w5U5TCW8YPGmYxRUk8dXqf2U/66Ft7pjzpVG2XRFTnzCpMMUQ4jDtoud23PnH6FYKrbq9qbQf4GKDMGeO2dmsnQWWIhxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200096; c=relaxed/simple;
	bh=ig1Df7JJNgQbRcOiGg6A7gTc4lTl7HXWYPjJlHxTcOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDEeOxhbMLWbttOu0phSaLpJlSNK6dwm9xEE3rLWRoxDcyqDt2JgvYZNzDbF83I2drd/rkY2KQeOV+ZHa65B6jij3F5GltX17dqt/lhWZmsYeN83uIXT+Nn83xI6V1FGUxjeqWOgKHP+OEaTH4pBX+fsB1JDlNhFI631RQ5yaho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01fHr+gp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01fHr+gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5B81F000FF;
	Sat, 12 Sep 2026 08:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200095;
	bh=RpEvQLiQftjalSQ4JfiyuP4L415Ud2xk5M5E2yHhwIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01fHr+gp2vdzJoakxJ/NQs5dX0BGwIzPJPjYJ+ajCApvuCSaaYSVFdkzrSYn0eJpW
	 2NBbCObFlKQ5yKFTf6rCy4zpa2w+IeATflCpOfuR7UunxTWFXgmz+sdQIRQs5uCgiW
	 yY3yo78KcG13DPPjIwOtTtKrKoirtEhNxbkS4KSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0719/1815] clk: mediatek: mt8135: Fix inverted gate control for devapc_ck
Date: Sat, 12 Sep 2026 08:41:09 +0200
Message-ID: <20260912065705.777206784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



