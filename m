Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80FE3FFFAF;
	Tue, 21 Jul 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655954; cv=none; b=S7oIn3lT/xRFAemhTpZCdYK9AGa5dQpCqY2C1qgL4UDSkGGR8f8bQXLcQG0VSG/WXwYASrY59K+t1Mx+PJeFHb7ADsvcGXzOev2tQEhporoxmZ+BWOqDdQvvBno0S7wGWSfwP55wsegCeDK3Rr1WqHmykPN55SeobcwjzKJImvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655954; c=relaxed/simple;
	bh=+QV1xnHuDjvhAu7mBVU6KPzKMIooQAIXqCJ1gpW2Icw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgTq7Rgc3W+9lb61DolC16WVWNPIWzu5PQ4j6lT6TPSGrT1RFzONtoIkEFvjwMh91wLb3dRy1zgtopkUcEMPOJrQjvHEK+w4t6AgyukWOVLWkvxarWbt54T87Ippgqy+hR7feLqIz7iDCIudkSdbT8osYfITHwDa841gCn/nxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BikxNN0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BikxNN0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B2B1F000E9;
	Tue, 21 Jul 2026 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655953;
	bh=KpVVPjfvPe+/3W+YxAIdDDG5YykyVc5ndKE66Ie+NhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BikxNN0JjzQJEAnjUcmd74gnPKG+vZzdeNWQqYBCBFAkAJSXIo5OPMscv0VUU2V7+
	 U1DhzoMkTXcuAFcmSFzQ8VZH2wELKP0MW7skPc7Oj3laIhzWXe9O4PsaSajc+7w6n8
	 xxKXqm2UHMA081enlR1PSZMatNtWb4oKIMTS68/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0205/1611] pinctrl: spacemit: fix NULL check in spacemit_pin_set_config
Date: Tue, 21 Jul 2026 17:05:21 +0200
Message-ID: <20260721152519.579670005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33af9b5791c110..8d797bf24b7784 100644
--- a/drivers/pinctrl/spacemit/pinctrl-k1.c
+++ b/drivers/pinctrl/spacemit/pinctrl-k1.c
@@ -609,7 +609,7 @@ static int spacemit_pin_set_config(struct spacemit_pinctrl *pctrl,
 	void __iomem *reg;
 	unsigned int mux;
 
-	if (!pin)
+	if (!spin)
 		return -EINVAL;
 
 	reg = spacemit_pin_to_reg(pctrl, spin->pin);
-- 
2.53.0



