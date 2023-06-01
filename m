Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9116E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470D9C433EF;
	Thu,  1 Jun 2023 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625775;
	bh=Zt26YdEXW3xdOjwxCyEekt37/R+kVK2LUMAdvvojyx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5Zct0LGBHfE6vXrbULUvCKxxU3DmHPfAoy9l1exWl7SyVqAM7+PzYI867FWPf9Z2
	 6bXiZlPUIKMKlT6ATE+yRFxSA5W8TnrfG6lRQd7heDgc250Mb1Rs9cHC57J0agxpnr
	 kyFjImtXXOVXw/ajzn0zjWywAO7qP4qgVPui4CD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/22] power: supply: bq27xxx: fix polarity of current_now
Date: Thu,  1 Jun 2023 14:21:01 +0100
Message-Id: <20230601131933.881797295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit cd060b4d0868c806c2738a5e64e8ab9bd0fbec07 ]

current_now has to be negative during discharging and positive during
charging, the behavior seen is the other way round.

Tested on GTA04 with Openmoko battery.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 35092c5819f8 ("power: supply: bq27xxx: Add cache parameter to bq27xxx_battery_current_and_status()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index c08dd4e6d35ad..79eee63a2041e 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1773,7 +1773,7 @@ static int bq27xxx_battery_current(struct bq27xxx_device_info *di,
 
 	if (di->opts & BQ27XXX_O_ZERO) {
 		flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, true);
-		if (flags & BQ27000_FLAG_CHGS) {
+		if (!(flags & BQ27000_FLAG_CHGS)) {
 			dev_dbg(di->dev, "negative current!\n");
 			curr = -curr;
 		}
@@ -1781,7 +1781,7 @@ static int bq27xxx_battery_current(struct bq27xxx_device_info *di,
 		val->intval = curr * BQ27XXX_CURRENT_CONSTANT / BQ27XXX_RS;
 	} else {
 		/* Other gauges return signed value */
-		val->intval = (int)((s16)curr) * 1000;
+		val->intval = -(int)((s16)curr) * 1000;
 	}
 
 	return 0;
-- 
2.39.2



