Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6248BE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F2BC433EF;
	Thu,  1 Jun 2023 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625865;
	bh=g0TJ93JGyT0DxiuSJeQbm5dUZgAWHbobsy2benX0x6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBBizG6eu0HIrud/HdnY4n0uO9vrEuGxwLTsLIPDKMkiV+vqlmYsOSUArOcY1Uv9r
	 zflmS/OSuFHckRkGzm4RjcKwQp1p8wnyQeuWPRIWGjw/8jmokukEAdpA26HBC3bcWV
	 Ek/pcTkSFBgk6rA5rijObWYMJ/3tgCKrxu8EUeyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/42] power: supply: bq24190: Call power_supply_changed() after updating input current
Date: Thu,  1 Jun 2023 14:20:53 +0100
Message-Id: <20230601131936.981711386@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
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

[ Upstream commit 77c2a3097d7029441e8a91aa0de1b4e5464593da ]

The bq24192 model relies on external charger-type detection and once
that is done the bq24190_charger code will update the input current.

In this case, when the initial power_supply_changed() call is made
from the interrupt handler, the input settings are 5V/0.5A which
on many devices is not enough power to charge (while the device is on).

On many devices the fuel-gauge relies in its external_power_changed
callback to timely signal userspace about charging <-> discharging
status changes. Add a power_supply_changed() call after updating
the input current. This allows the fuel-gauge driver to timely recheck
if the battery is charging after the new input current has been applied
and then it can immediately notify userspace about this.

Fixes: 18f8e6f695ac ("power: supply: bq24190_charger: Get input_current_limit from our supplier")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 19537bd75013d..90ac5e59a5d6f 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1213,6 +1213,7 @@ static void bq24190_input_current_limit_work(struct work_struct *work)
 	bq24190_charger_set_property(bdi->charger,
 				     POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
 				     &val);
+	power_supply_changed(bdi->charger);
 }
 
 /* Sync the input-current-limit with our parent supply (if we have one) */
-- 
2.39.2



