Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FAF4432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC36C433C8
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:48:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=axis.com header.i=@axis.com header.b="Pg2NjzVM"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Mon, 11 Sep 2023 13:48:10 +0100
Resent-Message-ID: <ZP8MigUE/xn+xLQn@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 11 Sep 2023 13:42:58 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=ThSf=E3=axis.com=Vincent.Whitchurch@kernel.org>)
	id 1qfgFj-00AWd2-QU
	for broonie@sirena.co.uk; Mon, 11 Sep 2023 13:42:58 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id CEBD6B812A3
	for <broonie@sirena.co.uk>; Mon, 11 Sep 2023 12:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 5472FC4339A; Mon, 11 Sep 2023 12:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58456C433C7
	for <broonie@kernel.org>; Mon, 11 Sep 2023 12:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 58456C433C7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=axis.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1694436171;
  x=1725972171;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=iRWKgzYyApFXq9hIJlEr7x3MLl9rxdsbG3Nqgvq7fM4=;
  b=Pg2NjzVMf5xIU9kjje5DOQIAYpmuT0HXyONHVokdYME0Zah87IWOOiBi
   35RVqE7OJHvFUJU/YK0QNg4iZUfxma4MTV9rba3F6ZlynaFh6+KAHmmYy
   pEiDKXKzLBiC17+7lOuwtwM9QzoQV2vIaraJ12kTzE2EofwlMvfa+3H6A
   MdkMFbumAB9jB2IEH+F6JBHd7ljo9Olr5zmx1AVqa5wP7OhrSUyVZIv4j
   bU9gyU7tqY8p1Eij1lvDxNYsHREW307huoXkl6859UJBl7KB8sMf+J1L7
   8S5PiydxyYU2oGMIZE4f7etYWmXrR4dX+KvXtqrU8mO1klamVOufL/EHh
   w==;
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Mon, 11 Sep 2023 14:42:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230911-regulator-voltage-sel-v1-1-886eb1ade8d8@axis.com>
X-B4-Tracking: v=1; b=H4sIAEYL/2QC/x2MQQqAMAzAviI9O2gnIvoV8TC2qoXhpFMRxL87P
 AaSPJBZhTMM1QPKl2RJWwGqK/Cr2xY2EgqDRdtgT2SUlzO6I6m5UjxcETJH03rCQD6g7RBKuyv
 Pcv/fcXrfDz1qBzVnAAAA
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
	Chen-Yu Tsai <wenst@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <kernel@axis.com>, Vincent Whitchurch
	<vincent.whitchurch@axis.com>
X-Mailer: b4 0.12.3
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=ThSf=E3=axis.com=Vincent.Whitchurch@kernel.org
Subject: [PATCH] regulator: Fix voltage range selection
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 45UsfbYTTcAh

Use the correct field to fix wrong voltage range selection on regulators
such as tps6287x since the blamed commit.

Fixes: 269cb04b601d ("regulator: Use bitfield values for range selectors")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/regulator/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
index 5ad5f3b3a6b5..d49268336553 100644
--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -197,7 +197,7 @@ int regulator_set_voltage_sel_pickable_regmap(struct regulator_dev *rdev,
 	sel += rdev->desc->linear_ranges[i].min_sel;
 
 	range = rdev->desc->linear_range_selectors_bitfield[i];
-	range <<= ffs(rdev->desc->vsel_mask) - 1;
+	range <<= ffs(rdev->desc->vsel_range_mask) - 1;
 
 	if (rdev->desc->vsel_reg == rdev->desc->vsel_range_reg) {
 		ret = regmap_update_bits(rdev->regmap,

---
base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
change-id: 20230911-regulator-voltage-sel-5c10d1cd0270

Best regards,
-- 
Vincent Whitchurch <vincent.whitchurch@axis.com>

