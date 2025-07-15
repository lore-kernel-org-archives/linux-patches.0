Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBC2E498B;
	Tue, 15 Jul 2025 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586822; cv=none; b=tGtAfrWGhlQ1p8P7JnCXMAQ3BX/Hvy4lY2PoS1a23g0g0rUGvmd9EcW/tqZ+iJA95WK2+yjIt5bl1zIOJCsphGuePSKH7F901GTyhTYyn6KCo46+0vUj360wy1Y1wjtIm7i/3P9gEVLXY++CjSEa+/TWS0JiWPbr/Rr6oqOEorQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586822; c=relaxed/simple;
	bh=EkTxdINWGfb5A5jVWlmWJsmqAqFnEghR9gL/3Ti9mw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quJW8iSxc/toNmbq5JylsODavxzL4Zu4OTmpP+EhuAZrRaMl5YMTDhAO0YmGmBQv6erDp15BhZOTBwCNv4cw0fYUYodEUIfxJv9RaNh8RnJPqadg0DQkIg/bfNVr4D6NQ0vCcG0FdT1rqjIN3H8qdCB6O3F7aI/jOPbWLly+qSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL6ByHIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL6ByHIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7DCC4CEE3;
	Tue, 15 Jul 2025 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586822;
	bh=EkTxdINWGfb5A5jVWlmWJsmqAqFnEghR9gL/3Ti9mw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL6ByHIVRZab6Clq2Ap2upwrikGh3+AAbCuGnL38ywDLxsf+YWNHglVcwdPud/qJD
	 4JynYLewTdZkFJtLODToWZ/4MpGa8vjlZjvxx6X9ny6mEZ6RscnC4aS74tHwDbw9D4
	 AI9OgY8z/inlSMkYpNbU/UdWv8CKRwIQrUhvr1Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 020/192] pinctrl: amd: Clear GPIO debounce for suspend
Date: Tue, 15 Jul 2025 15:11:55 +0200
Message-ID: <20250715130815.675517915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8ff4fb276e2384a87ae7f65f3c28e1e139dbb3fe ]

soc-button-array hardcodes a debounce value by means of gpio_keys
which uses pinctrl-amd as a backend to program debounce for a GPIO.

This hardcoded value doesn't match what the firmware intended to be
programmed in _AEI. The hardcoded debounce leads to problems waking
from suspend. There isn't appetite to conditionalize the behavior in
soc-button-array or gpio-keys so clear it when the system suspends to
avoid problems with being able to resume.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hansg@kernel.org>
Fixes: 5c4fa2a6da7fb ("Input: soc_button_array - debounce the buttons")
Link: https://lore.kernel.org/linux-input/mkgtrb5gt7miyg6kvqdlbu4nj3elym6ijudobpdi26gp4xxay5@rsa6ytrjvj2q/
Link: https://lore.kernel.org/linux-input/20250625215813.3477840-1-superm1@kernel.org/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/20250627150155.3311574-1-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 1d7fdcdec4c85..bf55d1b4db67b 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -934,6 +934,17 @@ static int amd_gpio_suspend_hibernate_common(struct device *dev, bool is_suspend
 				  pin, is_suspend ? "suspend" : "hibernate");
 		}
 
+		/*
+		 * debounce enabled over suspend has shown issues with a GPIO
+		 * being unable to wake the system, as we're only interested in
+		 * the actual wakeup event, clear it.
+		 */
+		if (gpio_dev->saved_regs[i] & (DB_CNTRl_MASK << DB_CNTRL_OFF)) {
+			amd_gpio_set_debounce(gpio_dev, pin, 0);
+			pm_pr_dbg("Clearing debounce for GPIO #%d during %s.\n",
+				  pin, is_suspend ? "suspend" : "hibernate");
+		}
+
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
-- 
2.39.5



