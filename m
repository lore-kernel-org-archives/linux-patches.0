Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF90415E8B;
	Mon, 30 Dec 2024 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574123; cv=none; b=U/thOA3bFLzlDLG/aRJuokCkHmfmU3PjfNdZYczpUqa06ZpCOn/UrsTApPLVtkgBAZvIecprEZH8xoxVq896H1tq5q+aBWPSZgD5mhWgCer0wTZffEysemJoisK1mKrHdp+Ucq63MXocbapBhXFISWf4PugRdFkSXh2TdVr5i1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574123; c=relaxed/simple;
	bh=fkcBS2NI/7tReThK/Bep3y2xSkENaIg5xvqZUSURmxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbbxXsBH9Dt8qAsorz5Rt8ZKdkWBimFGT+d94UkSRHGotTD0ZtKQrkvXjBC8tzluxOB1IB7H5hC+9iUL+wbDAnk01fZ82lqd3Qn0N9t9BOxlSjCehu61Dkv7Rk1gmFtwhkHun1+gHxOIGucJ3xKv6snOm8ix/X2RucUVrEadVp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8gEbSV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8gEbSV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228D2C4CED0;
	Mon, 30 Dec 2024 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574123;
	bh=fkcBS2NI/7tReThK/Bep3y2xSkENaIg5xvqZUSURmxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8gEbSV4yUlKnweFz9ZHq1eWSfKk8zpdCab180F6edacGNrbhlR8ZzoS5p7DYkYHl
	 WgBk+xCLL5EcnKQo21o11bbaSpYK78/ubiiYNljbYkVMaTiJZt/2/8tCHkqqhbDR5S
	 teVd7X46G5NQ7FCHzlUUK2aC13KFHKpXQ/byBcC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/114] power: supply: bq24190: Fix BQ24296 Vbus regulator support
Date: Mon, 30 Dec 2024 16:42:40 +0100
Message-ID: <20241230154219.716328045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b3ded6072c5600704cfa3ce3a8dc8718d34bda66 ]

There are 2 issues with bq24296_set_otg_vbus():

1. When writing the OTG_CONFIG bit it uses POC_CHG_CONFIG_SHIFT which
   should be POC_OTG_CONFIG_SHIFT.

2. When turning the regulator off it never turns charging back on. Note
   this must be done through bq24190_charger_set_charge_type(), to ensure
   that the charge_type property value of none/trickle/fast is honored.

Resolve both issues to fix BQ24296 Vbus regulator support not working.

Fixes: b150a703b56f ("power: supply: bq24190_charger: Add support for BQ24296")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241116203648.169100-2-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 2b393eb5c282..c47f32f152e6 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -567,6 +567,7 @@ static int bq24190_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
 
 static int bq24296_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
 {
+	union power_supply_propval val = { .intval = bdi->charge_type };
 	int ret;
 
 	ret = pm_runtime_resume_and_get(bdi->dev);
@@ -587,13 +588,18 @@ static int bq24296_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
 
 		ret = bq24190_write_mask(bdi, BQ24190_REG_POC,
 					 BQ24296_REG_POC_OTG_CONFIG_MASK,
-					 BQ24296_REG_POC_CHG_CONFIG_SHIFT,
+					 BQ24296_REG_POC_OTG_CONFIG_SHIFT,
 					 BQ24296_REG_POC_OTG_CONFIG_OTG);
-	} else
+	} else {
 		ret = bq24190_write_mask(bdi, BQ24190_REG_POC,
 					 BQ24296_REG_POC_OTG_CONFIG_MASK,
-					 BQ24296_REG_POC_CHG_CONFIG_SHIFT,
+					 BQ24296_REG_POC_OTG_CONFIG_SHIFT,
 					 BQ24296_REG_POC_OTG_CONFIG_DISABLE);
+		if (ret < 0)
+			goto out;
+
+		ret = bq24190_charger_set_charge_type(bdi, &val);
+	}
 
 out:
 	pm_runtime_mark_last_busy(bdi->dev);
-- 
2.39.5



