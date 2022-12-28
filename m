Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F33B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F2AC433D2;
	Wed, 28 Dec 2022 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244822;
	bh=2T2LJ59ayqgeEhm+nqeNL0q+bbd5bJDVPllt0w3at18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLslj6yKnhwQGM/CYnHsVuhKG2ToRV2G3K3uROnxRPDmNfyt03ZesWP3sT4NT3ETv
	 TG2j6fE5NKo0ke9OS16/EW3rIVYoc4ZqUMxgIzP4+6lQzdST4C4zaqbIMAiPD46gdN
	 8aue98htuofRvz2CMXy0HioJwjqBFM3ICwn++ezI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0753/1073] power: supply: bq25890: Ensure pump_express_work is cancelled on remove
Date: Wed, 28 Dec 2022 15:39:01 +0100
Message-Id: <20221228144348.472698098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit a7aaa80098d5b7608b2dc1e883e3c3f929415243 ]

The pump_express_work which gets queued from an external_power_changed
callback might be pending / running on remove() (or on probe failure).

Add a devm action cancelling the work, to ensure that it is cancelled.

Note the devm action is added before devm_power_supply_register(), making
it run after devm unregisters the power_supply, so that the work cannot
be queued anymore (this is also why a devm action is used for this).

Fixes: 48f45b094dbb ("power: supply: bq25890: Support higher charging voltages through Pump Express+ protocol")
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index b4c8481ea17b..92fab662a51d 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1189,6 +1189,13 @@ static int bq25890_fw_probe(struct bq25890_device *bq)
 	return 0;
 }
 
+static void bq25890_non_devm_cleanup(void *data)
+{
+	struct bq25890_device *bq = data;
+
+	cancel_delayed_work_sync(&bq->pump_express_work);
+}
+
 static int bq25890_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -1244,6 +1251,14 @@ static int bq25890_probe(struct i2c_client *client)
 	/* OTG reporting */
 	bq->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 
+	/*
+	 * This must be before bq25890_power_supply_init(), so that it runs
+	 * after devm unregisters the power_supply.
+	 */
+	ret = devm_add_action_or_reset(dev, bq25890_non_devm_cleanup, bq);
+	if (ret)
+		return ret;
+
 	ret = bq25890_register_regulator(bq);
 	if (ret)
 		return ret;
-- 
2.35.1



