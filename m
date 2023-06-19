Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8685381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BFC433C9;
	Mon, 19 Jun 2023 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171437;
	bh=FMWsSiYerd3VpLtJ0RL80ScgmPJ4SpAcn+LdzIeVyV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VS7cSVJPS7dmyx6s99k706JH90UCT5kPmdT4mIYmP9qX8um9quxJBwsBkRcWWIWlx
	 LxjncfhRc3gxad2HGuzoebT0nzRw91Cd34KIs9nIV89ZfuiZbt7PyhXC0Tms3VlS17
	 b20IcL8oxw2xkPh2wLpWapNuK6P2Ck+FIMiuVC24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <Evan.Quan@amd.com>,
	Lijo Lazar <Lijo.Lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/166] power: supply: Fix logic checking if system is running from battery
Date: Mon, 19 Jun 2023 12:28:20 +0200
Message-ID: <20230619102155.861195571@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 95339f40a8b652b5b1773def31e63fc53c26378a ]

The logic used for power_supply_is_system_supplied() counts all power
supplies and assumes that the system is running from AC if there is
either a non-battery power-supply reporting to be online or if no
power-supplies exist at all.

The second rule is for desktop systems, that don't have any
battery/charger devices. These systems will incorrectly report to be
powered from battery once a device scope power-supply is registered
(e.g. a HID device), since these power-supplies increase the counter.

Apart from HID devices, recent dGPUs provide UCSI power supplies on a
desktop systems. The dGPU by default doesn't have anything plugged in so
it's 'offline'. This makes power_supply_is_system_supplied() return 0
with a count of 1 meaning all drivers that use this get a wrong judgement.

To fix this case adjust the logic to also examine the scope of the power
supply. If the power supply is deemed a device power supply, then don't
count it.

Cc: Evan Quan <Evan.Quan@amd.com>
Suggested-by: Lijo Lazar <Lijo.Lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 8382be867d274..7871ab5e979c0 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -348,6 +348,10 @@ static int __power_supply_is_system_supplied(struct device *dev, void *data)
 	struct power_supply *psy = dev_get_drvdata(dev);
 	unsigned int *count = data;
 
+	if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_SCOPE, &ret))
+		if (ret.intval == POWER_SUPPLY_SCOPE_DEVICE)
+			return 0;
+
 	(*count)++;
 	if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY)
 		if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE,
@@ -366,8 +370,8 @@ int power_supply_is_system_supplied(void)
 				      __power_supply_is_system_supplied);
 
 	/*
-	 * If no power class device was found at all, most probably we are
-	 * running on a desktop system, so assume we are on mains power.
+	 * If no system scope power class device was found at all, most probably we
+	 * are running on a desktop system, so assume we are on mains power.
 	 */
 	if (count == 0)
 		return 1;
-- 
2.39.2



