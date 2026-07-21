Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2768D46D54B;
	Tue, 21 Jul 2026 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648684; cv=none; b=DCj1UzaNfhFXUH+FSIojVLFMm/8AiCLRgW7VZS1W6rDX4F+jczyHQ9CVDOja5oo5bcMKw8O7m+Ug7AQb2oA+OlqsopKHjgnLvGeF47tN6ggADjPh9ACEbS/Dzdx6m5CZMdAaHGBVAWwm60YP1SP8e1+b1Isazl3s12smzP6Q5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648684; c=relaxed/simple;
	bh=fWNaeVyyCpViXnSAlmocR7oVk6mGbxqoMj76RFS1FMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRDY2y9Dv9q3HseqgAG4DwfhDB7l7bp2AlTBNYYmwTJmSFN9DlF7utu1irnnKBUnms8HYZYrA6pdlVtcorQ0tBfToScOJJAbP0NsO3fIee1oDqAvUl2RjCIMWSOwM+24hA1vQdup8rU13Vch6anGqoNOmzVu4TPRCdJ2xyHCzEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oeY7tDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oeY7tDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC721F00A3A;
	Tue, 21 Jul 2026 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648682;
	bh=Vt15SJ4DgiTXBx4wyztaSVX5KJTX0WUWwNC/Da+9h5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oeY7tDCOV3TOCN5ePW2E5II95q94fAdhYTqdVCcoDx/Nk/YCYs1m+dwAOt2NhyOF
	 ddlAMop/k1XiVknh+ieCoYoo0ArbZGnLuuOIPlxWiNVz3/LoCyeEU6cMnN5uXg1CA8
	 Zk3IE962JryIsMEGrKAh6KzT84EdlbMsLTLYvBmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0292/2077] pinctrl: spacemit: fix NULL check in spacemit_pin_set_config
Date: Tue, 21 Jul 2026 16:59:25 +0200
Message-ID: <20260721152559.563088773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit 09c816e5c4d3a8d6d6e4b7537433e5e98505d934 ]

spacemit_pin_set_config() looks up the per-pin descriptor with
spacemit_get_pin() then checks the wrong variable for failure:

	const struct spacemit_pin *spin = spacemit_get_pin(pctrl, pin);
	...
	if (!pin)
		return -EINVAL;

	reg = spacemit_pin_to_reg(pctrl, spin->pin);

pin is an unsigned int pin id, where 0 (GPIO_0 / gmac0_rxdv on K3) is a
valid pin, so rejecting it here drops the PAD config write for the first
pin of every group. On K3 Pico-ITX the GMAC RGMII group lists pin 0 as
its first entry, so its drive-strength / bias configuration was silently
ignored.

The intended guard is against spacemit_get_pin() returning NULL when the
pin id isn't in the SoC's pin table. Check spin instead, which both
restores PAD setup for pin 0 and prevents a NULL deref on spin->pin.

Fixes: a83c29e1d145 ("pinctrl: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/spacemit/pinctrl-k1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/spacemit/pinctrl-k1.c b/drivers/pinctrl/spacemit/pinctrl-k1.c
index b0be62b1c8161d..95024e2bb5a587 100644
--- a/drivers/pinctrl/spacemit/pinctrl-k1.c
+++ b/drivers/pinctrl/spacemit/pinctrl-k1.c
@@ -795,7 +795,7 @@ static int spacemit_pin_set_config(struct spacemit_pinctrl *pctrl,
 	void __iomem *reg;
 	unsigned int mux;
 
-	if (!pin)
+	if (!spin)
 		return -EINVAL;
 
 	reg = spacemit_pin_to_reg(pctrl, spin->pin);
-- 
2.53.0



