Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD315611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6847BC4339B;
	Sun, 28 May 2023 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302494;
	bh=MwTGrKYNPdamWbkxpMIn3/Lp1x50/ZzFv/NxFcV55yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvwS+Du69iKvyAt/w85iDT47ceQhUgUyagk+CpYsEIi0AZplY+p8krxQSugiEkJWw
	 hA8WtK3iEACqPcd2J9v2mHVHMZy7Ll2oVhy9PHzQ4xeAYRMnlBpKgDlpsB8v2BrxCN
	 QIgwfWwzu3fk6GGZI9t2mXnMx2vwrDZNPTCZjwos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 026/119] power: supply: bq25890: Fix external_power_changed race
Date: Sun, 28 May 2023 20:10:26 +0100
Message-Id: <20230528190836.211187629@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 029a443b9b6424170f00f6dd5b7682e682cce92e upstream.

bq25890_charger_external_power_changed() dereferences bq->charger,
which gets sets in bq25890_power_supply_init() like this:

  bq->charger = devm_power_supply_register(bq->dev, &bq->desc, &psy_cfg);

As soon as devm_power_supply_register() has called device_add()
the external_power_changed callback can get called. So there is a window
where bq25890_charger_external_power_changed() may get called while
bq->charger has not been set yet leading to a NULL pointer dereference.

This race hits during boot sometimes on a Lenovo Yoga Book 1 yb1-x90f
when the cht_wcove_pwrsrc (extcon) power_supply is done with detecting
the connected charger-type which happens to exactly hit the small window:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  <snip>
  RIP: 0010:__power_supply_is_supplied_by+0xb/0xb0
  <snip>
  Call Trace:
   <TASK>
   __power_supply_get_supplier_property+0x19/0x50
   class_for_each_device+0xb1/0xe0
   power_supply_get_property_from_supplier+0x2e/0x50
   bq25890_charger_external_power_changed+0x38/0x1b0 [bq25890_charger]
   __power_supply_changed_work+0x30/0x40
   class_for_each_device+0xb1/0xe0
   power_supply_changed_work+0x5f/0xe0
  <snip>

Fixing this is easy. The external_power_changed callback gets passed
the power_supply which will eventually get stored in bq->charger,
so bq25890_charger_external_power_changed() can simply directly use
the passed in psy argument which is always valid.

Fixes: eab25b4f93aa ("power: supply: bq25890: On the bq25892 set the IINLIM based on external charger detection")
Cc: stable@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -650,7 +650,7 @@ static void bq25890_charger_external_pow
 	if (bq->chip_version != BQ25892)
 		return;
 
-	ret = power_supply_get_property_from_supplier(bq->charger,
+	ret = power_supply_get_property_from_supplier(psy,
 						      POWER_SUPPLY_PROP_USB_TYPE,
 						      &val);
 	if (ret)


