Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E61F4180;
	Wed, 19 Feb 2025 08:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954755; cv=none; b=GGa7Utf3vSoevj468b+sHBQubnH5NldYvPuB9x9L2f934boUYD6m/1l6YjJ0a+UbwmIqKPXJHnk2GdjWh8YD+OjEXiJL76udnV2jecUYesvLwL5o2xNMPsPQyYZMjawOoOF61cpAhYlIsxjC86HnhiYj01t/hbq1mGg//dMUpwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954755; c=relaxed/simple;
	bh=pn/YfHLqq9oL96NazJAYa11ZL4cbva1wY8g3t2CCKcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGImU8kA4NMMpClbEF27Rf0GtGL7tWcGZHwb/7lnGD1ZUylv2jJCJXEzC8p7qY6+6QfLa/eqhwDvoeW6U3YCC5w7nhB+2ucGYnAIO9DlS/N23LMLOkfEKCRwWbs1DrcQhxhUVH71D5y/SZ6zKlOww5oJE0EpV/M5uGCql8wCh9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cv1PGMgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cv1PGMgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD92C4CEE8;
	Wed, 19 Feb 2025 08:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954754;
	bh=pn/YfHLqq9oL96NazJAYa11ZL4cbva1wY8g3t2CCKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cv1PGMgEJZ0uXK/d7/0UvK2jhpPpjE7KHBzsaF8fZ97g0l4902LBSts5wP+W2esny
	 5hQRKCGt2U61vY+L3RWmk7ySmtQErT2+1MN5/H47u6nb51ZJeD9PQTBIBUCnHtEjGW
	 dScD6twNps2IBb3HcyP85+UtK5OfcHRh0pNgpkK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/230] pinctrl: cy8c95x0: Avoid accessing reserved registers
Date: Wed, 19 Feb 2025 09:25:22 +0100
Message-ID: <20250219082601.905607653@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5096ccdd459ea..05224808d92be 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -330,14 +330,14 @@ static int cypress_get_pin_mask(struct cy8c95x0_pinctrl *chip, unsigned int pin)
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
@@ -346,8 +346,11 @@ static bool cy8c95x0_readable_register(struct device *dev, unsigned int reg)
 
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
@@ -355,6 +358,7 @@ static bool cy8c95x0_writeable_register(struct device *dev, unsigned int reg)
 	case CY8C95X0_DEVID:
 		return false;
 	case 0x24 ... 0x27:
+	case 0x31 ... 0x3f:
 		return false;
 	default:
 		return true;
-- 
2.39.5



