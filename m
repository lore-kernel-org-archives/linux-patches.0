Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1231A841F;
	Wed, 19 Feb 2025 08:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953919; cv=none; b=n/aii2PcXQhC2CFOTY+Vm29eai5+LpNJ8nBZIui0cpaugUnBwXbYvplPrBa6fcADyyvo17mpmK+VmYhFN665GN1Z2b8Vap2WUIJdQFfICGT6e0HfI13MLJEkk8k7fAZb0jU4bnAat5QRiWd3R18H2Y2KbxusDxNaFXCSRP+rXY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953919; c=relaxed/simple;
	bh=VWSTMkCxXz+r7w5OeZzrMYvL03kEnuwjH1T52x6p4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr67rCL+lUNiPaqgA60CtCO4p1EODrh42Imc4me3Lvujq1YjbSwwctF4MkuTSNSW7NjZi+WdfuUdjxde7rTWicaRM+6nwHiF6ji4h+MuHbCl9bwwDsnlmlqjB3qu/NBrFBoFmfDeIBYW2HhVnVMSWNhlboUPBqMX7SzTygKvgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSY3mKzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSY3mKzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA978C4CEEC;
	Wed, 19 Feb 2025 08:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953919;
	bh=VWSTMkCxXz+r7w5OeZzrMYvL03kEnuwjH1T52x6p4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSY3mKzQLo2CCU8qNHlAHLoDgmAR2d2/BF85pLrlPEaWAYdAXz0nJB0gYDxuDpRHd
	 wfacwRjAaTppvDbduDi6biYrMWPGQCjeQQ3brgIajFS/iJFXwlrzX4Cn4pzwecDGa9
	 W1xrzo92lf1S00Sfp9L+ACSHO1tKnPq5XHluaz5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 008/274] pinctrl: cy8c95x0: Avoid accessing reserved registers
Date: Wed, 19 Feb 2025 09:24:22 +0100
Message-ID: <20250219082609.860806385@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3fbe3fe28764455e4fc3578afb9765f46f9ce93d ]

The checks for vrtual registers in the cy8c95x0_readable_register()
and cy8c95x0_writeable_register() are not aligned and broken.

Fix that by explicitly avoiding reserved registers to be accessed.

Fixes: 71e4001a0455 ("pinctrl: pinctrl-cy8c95x0: Fix regcache")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250203131506.3318201-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 5c6bcbf6c3377..c787a9aadfdfb 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -328,14 +328,14 @@ static int cypress_get_pin_mask(struct cy8c95x0_pinctrl *chip, unsigned int pin)
 static bool cy8c95x0_readable_register(struct device *dev, unsigned int reg)
 {
 	/*
-	 * Only 12 registers are present per port (see Table 6 in the
-	 * datasheet).
+	 * Only 12 registers are present per port (see Table 6 in the datasheet).
 	 */
-	if (reg >= CY8C95X0_VIRTUAL && (reg % MUXED_STRIDE) < 12)
-		return true;
+	if (reg >= CY8C95X0_VIRTUAL && (reg % MUXED_STRIDE) >= 12)
+		return false;
 
 	switch (reg) {
 	case 0x24 ... 0x27:
+	case 0x31 ... 0x3f:
 		return false;
 	default:
 		return true;
@@ -344,8 +344,11 @@ static bool cy8c95x0_readable_register(struct device *dev, unsigned int reg)
 
 static bool cy8c95x0_writeable_register(struct device *dev, unsigned int reg)
 {
-	if (reg >= CY8C95X0_VIRTUAL)
-		return true;
+	/*
+	 * Only 12 registers are present per port (see Table 6 in the datasheet).
+	 */
+	if (reg >= CY8C95X0_VIRTUAL && (reg % MUXED_STRIDE) >= 12)
+		return false;
 
 	switch (reg) {
 	case CY8C95X0_INPUT_(0) ... CY8C95X0_INPUT_(7):
@@ -353,6 +356,7 @@ static bool cy8c95x0_writeable_register(struct device *dev, unsigned int reg)
 	case CY8C95X0_DEVID:
 		return false;
 	case 0x24 ... 0x27:
+	case 0x31 ... 0x3f:
 		return false;
 	default:
 		return true;
-- 
2.39.5



