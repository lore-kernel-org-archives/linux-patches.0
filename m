Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300261A76B6;
	Tue, 30 Jul 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359734; cv=none; b=gXOOnDsxODQh6XdoASehtbZRRFB6GVL7gElsu3/StBP48FBVWHwtr7K6E29fnh6yiZnC9YHEE9Lce6iAoPhcKG4iKr4n9JUMoxpj5JMJBm6xHKsaNzTn3QTK1WWkIULUwVrGHuF6C7dfMR/LBEN2QHTH63Rtyz5RKEGZ9VPxpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359734; c=relaxed/simple;
	bh=DkXrfa9Zh0gdQoZNSc6KhjjEK09XOVlZFSOqSNDAPcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmbOKEv3YfOcevtQNyjXv8tDab7HS0JH/OCUPjnpnatns5vuOJ1+o5cdWaDvct+XC6AHGYw8z04GtsXQgQ77ADrKEDw6RTkjfb1qU8Kc5PRAjfjCAhLNTkZK2hf4dUnJ2Dmar3yleQkseoSe4Evkc6G76xb8iGkjLzCMnB4QW04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEgYu/6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEgYu/6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4863CC32782;
	Tue, 30 Jul 2024 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359733;
	bh=DkXrfa9Zh0gdQoZNSc6KhjjEK09XOVlZFSOqSNDAPcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEgYu/6RUytAuKFRgyD33982oQVId8zYsn4aYE9YiUjEo/F1Q6mhfhJQD75tea6yG
	 SiXbtA0WUkb2gpPaiiyEnAGusjV6c9wCb4rL2C7sFaOvz+nd0WCYYuKCZnzkPNDRc5
	 7vq23McKcXpQdyJVLv1s5GBXtBZMODvZjE+BlejI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 525/809] power: supply: ab8500: Fix error handling when calling iio_read_channel_processed()
Date: Tue, 30 Jul 2024 17:46:41 +0200
Message-ID: <20240730151745.473998963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3288757087cbb93b91019ba6b7de53a1908c9d48 ]

The ab8500_charger_get_[ac|vbus]_[current|voltage]() functions should
return an error code on error.

Up to now, an un-initialized value is returned.
This makes the error handling of the callers un-reliable.

Return the error code instead, to fix the issue.

Fixes: 97ab78bac5d0 ("power: supply: ab8500_charger: Convert to IIO ADC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/f9f65642331c9e40aaebb888589db043db80b7eb.1719037737.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 9b34d1a60f662..4b0ad1b4b4c9b 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -488,8 +488,10 @@ static int ab8500_charger_get_ac_voltage(struct ab8500_charger *di)
 	/* Only measure voltage if the charger is connected */
 	if (di->ac.charger_connected) {
 		ret = iio_read_channel_processed(di->adc_main_charger_v, &vch);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(di->dev, "%s ADC conv failed,\n", __func__);
+			return ret;
+		}
 	} else {
 		vch = 0;
 	}
@@ -540,8 +542,10 @@ static int ab8500_charger_get_vbus_voltage(struct ab8500_charger *di)
 	/* Only measure voltage if the charger is connected */
 	if (di->usb.charger_connected) {
 		ret = iio_read_channel_processed(di->adc_vbus_v, &vch);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(di->dev, "%s ADC conv failed,\n", __func__);
+			return ret;
+		}
 	} else {
 		vch = 0;
 	}
@@ -563,8 +567,10 @@ static int ab8500_charger_get_usb_current(struct ab8500_charger *di)
 	/* Only measure current if the charger is online */
 	if (di->usb.charger_online) {
 		ret = iio_read_channel_processed(di->adc_usb_charger_c, &ich);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(di->dev, "%s ADC conv failed,\n", __func__);
+			return ret;
+		}
 	} else {
 		ich = 0;
 	}
@@ -586,8 +592,10 @@ static int ab8500_charger_get_ac_current(struct ab8500_charger *di)
 	/* Only measure current if the charger is online */
 	if (di->ac.charger_online) {
 		ret = iio_read_channel_processed(di->adc_main_charger_c, &ich);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(di->dev, "%s ADC conv failed,\n", __func__);
+			return ret;
+		}
 	} else {
 		ich = 0;
 	}
-- 
2.43.0



