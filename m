Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7221C5D7F;
	Wed, 19 Mar 2025 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394842; cv=none; b=cmDn1J87SjjSmpPy8UGSRmJi+JVwYUSd26yBrlEdmj2+YuuKBTT5gOEc6iAggU09xfT5RYDlXe2LYChYTQr1p8PtOoGoMlkuxhN9eoAoz0/McLnsVluSmztz5dbEqanJrT2+BLEc2KEdsNkuvxnUFQt38rPrK/uCP7cZB3bhVXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394842; c=relaxed/simple;
	bh=XiZn48SqV4tf3IhjMbBhuAVSFlKbdbcMtrvZt5tPezY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEdQ0jtAxJNOFxFLAJ9Cl4rgEDFvg+VRFSm9MrC+cl0m5jhoXFsVQ5j1fwquu3CGtYvdkadv68/EL4GUqNeGfy9dPu7sn+Or8/v7C9fSklWwk2Cs15NGfLwpldDx1Ud61sX46QDwC9xVPXr2h6aarakEnxi96vLU3xWqTb78fmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sv8QF2Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sv8QF2Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F163AC4CEEC;
	Wed, 19 Mar 2025 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394842;
	bh=XiZn48SqV4tf3IhjMbBhuAVSFlKbdbcMtrvZt5tPezY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sv8QF2SsjJsjY1sBRG/B0FuWNMsE/osSiiNdTzVNgh8WeBsyu80lQsoT8sn6fFDl8
	 C0BxDzxS2KiK1lY99ee9b16vtfnOWP7+C9ZJ66W0FEpx3Qg8eKr54nrVQOh3Y4MeOw
	 tTE3JbH1OPZiDgdSgdqJnP9KVMtGAa41zmRu0fcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 006/241] pinctrl: bcm281xx: Fix incorrect regmap max_registers value
Date: Wed, 19 Mar 2025 07:27:56 -0700
Message-ID: <20250319143027.853119955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 68283c1cb573143c0b7515e93206f3503616bc10 ]

The max_registers value does not take into consideration the stride;
currently, it's set to the number of the last pin, but this does not
accurately represent the final register.

Fix this by multiplying the current value by 4.

Fixes: 54b1aa5a5b16 ("ARM: pinctrl: Add Broadcom Capri pinctrl driver")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/20250207-bcm21664-pinctrl-v1-2-e7cfac9b2d3b@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
index 73dbf29c002f3..cf6efa9c0364a 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -974,7 +974,7 @@ static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = BCM281XX_PIN_VC_CAM3_SDA,
+	.max_register = BCM281XX_PIN_VC_CAM3_SDA * 4,
 };
 
 static int bcm281xx_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.39.5



