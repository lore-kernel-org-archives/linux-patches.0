Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F96CE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EA7C433EF;
	Thu,  1 Jun 2023 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625751;
	bh=d+zUvn4wqNLb0hFva8lzevle76nwN20nIFV96HKfP7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdOgVF+SwIVA9R9CDDUBjR6JVtLxlRPrk7KJFQfIWAZmOa5/FWUXj6aHFJsTFobEJ
	 g8UoaDv+2bENpYhRYp+fY9uAReRLD61Jnnt8hKCqIF3lGPfIee9NMMmY7XW6SwTrO8
	 j4xHyhdP79UCdgXhmhHzi8P8RlSXT35c9TcyVfYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/16] power: supply: bq27xxx: After charger plug in/out wait 0.5s for things to stabilize
Date: Thu,  1 Jun 2023 14:20:58 +0100
Message-Id: <20230601131932.106478456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
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

[ Upstream commit 59a99cd462fbdf71f4e845e09f37783035088b4f ]

bq27xxx_external_power_changed() gets called when the charger is plugged
in or out. Rather then immediately scheduling an update wait 0.5 seconds
for things to stabilize, so that e.g. the (dis)charge current is stable
when bq27xxx_battery_update() runs.

Fixes: 740b755a3b34 ("bq27x00: Poll battery state")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index b45cbd40294b9..ffdd646d7ebc0 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1862,8 +1862,8 @@ static void bq27xxx_external_power_changed(struct power_supply *psy)
 {
 	struct bq27xxx_device_info *di = power_supply_get_drvdata(psy);
 
-	cancel_delayed_work_sync(&di->work);
-	schedule_delayed_work(&di->work, 0);
+	/* After charger plug in/out wait 0.5s for things to stabilize */
+	mod_delayed_work(system_wq, &di->work, HZ / 2);
 }
 
 int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
-- 
2.39.2



