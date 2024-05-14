Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEFD1E495;
	Tue, 14 May 2024 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687088; cv=none; b=WYdaeBbjPeJpOClGA0y9/dPhgs+lohAOtyhf5x/7liBRcbxyO37zeTjkh5NfKLTnwEGCqpYcQw2PgnGUCgOxLmr2ml9QZrf9LDSpj0q5LnxEVL5PYJ/xehiDtg2tz3O6gyVW7hrJ8MJ3y8/nqvQ9x3dSKpc4oX+PydwUe7oRJAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687088; c=relaxed/simple;
	bh=mIlNwmqxm029vz2M5KUue75BszwG+gtYHtoneyYsOR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkD2+FLClNf+O2wmVB+0E6D6h+jJqZxg2lkaYYaG/vTrwgUbWIyzLXC7+kn06QMop2aLI0PgChBR7EcwrZL+5pw8anc96QZDdi1xnSCk98SyDU8uLex9K/KX5i1RGBaX042/FsF4Ppf6RHN0Knob9tPdiBakUv66gRlIYfBb4l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To5nXFxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To5nXFxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EA7C2BD10;
	Tue, 14 May 2024 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687088;
	bh=mIlNwmqxm029vz2M5KUue75BszwG+gtYHtoneyYsOR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To5nXFxSIqKfHcZzusHiGiIs8CGvikmFU/FblqnybVhQ9/Ys7/X3DnbSG3sSQbsGU
	 orMbRFZBZSmW32Q4+usOZw0+yrFPLDmLa4MyVykRXFPoV2Ztsj6mLNWiUxhwYKRrMl
	 a3i3mLV6VVN+6dLT3pp8gCLG9GeveRnrxhoBKzPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Sean Wang <sean.wang@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/84] pinctrl: mediatek: Fix fallback call path
Date: Tue, 14 May 2024 12:20:10 +0200
Message-ID: <20240514100953.906547249@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 81bd1579b43e0e285cba667399f1b063f1ce7672 ]

Some SoCs, eg. mt8183, are using a pinconfig operation bias_set_combo.
The fallback path in mtk_pinconf_adv_pull_set() should also try this
operation.

Fixes: cafe19db7751 ("pinctrl: mediatek: Backward compatible to previous Mediatek's bias-pull usage")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Acked-by: Sean Wang <sean.wang@kernel.org>
Link: https://lore.kernel.org/r/20201228090425.2130569-1-hsinyi@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 634d652aed671..5ef372e702709 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -877,6 +877,10 @@ int mtk_pinconf_adv_pull_set(struct mtk_pinctrl *hw,
 			err = hw->soc->bias_set(hw, desc, pullup);
 			if (err)
 				return err;
+		} else if (hw->soc->bias_set_combo) {
+			err = hw->soc->bias_set_combo(hw, desc, pullup, arg);
+			if (err)
+				return err;
 		} else {
 			return -ENOTSUPP;
 		}
-- 
2.43.0



