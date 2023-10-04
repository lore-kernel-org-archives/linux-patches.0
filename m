Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E960B1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfVu7p8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59963C433CA;
	Wed,  4 Oct 2023 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443740;
	bh=lsN6gvsy2grec2LFeu1p+iSfVchja3KdeszUfRrb9h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfVu7p8Lw+V3miJkjbDga3cJ9gU1aEkZEb+e2LwiSRok7wuT9LD60QLl91umIPsPu
	 innmmEQ6Ojw3+t/8nzYztATEP1c1zut2rstjAoAtTbk0P/bqKKtzR+vDCvLmlhUhxR
	 nBQKoxQ1XWv326dnhPTT+FVc+1dtbHoIuJzo2eAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hansson <newbyte@disroot.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 253/259] power: supply: ab8500: Set typing and props
Date: Wed,  4 Oct 2023 19:57:06 +0200
Message-ID: <20231004175229.020650555@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit dc77721ea4aa1e8937e2436f230b5a69065cc508 upstream.

I had the following weird phenomena on a mobile phone: while
the capacity in /sys/class/power_supply/ab8500_fg/capacity
would reflect the actual charge and capacity of the battery,
only 1/3 of the value was shown on the battery status
indicator and warnings for low battery appeared.

It turns out that UPower, the Freedesktop power daemon,
will average all the power supplies of type "battery" in
/sys/class/power_supply/* if there is more than one battery.

For the AB8500, there was "battery" ab8500_fg, ab8500_btemp
and ab8500_chargalg. The latter two don't know anything
about the battery, and should not be considered. They were
however averaged and with the capacity of 0.

Flag ab8500_btemp and ab8500_chargalg with type "unknown"
so they are not averaged as batteries.

Remove the technology prop from ab8500_btemp as well, all
it does is snoop in on knowledge from another supply.

After this the battery indicator shows the right value.

Cc: Stefan Hansson <newbyte@disroot.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ab8500_btemp.c    |    9 +--------
 drivers/power/supply/ab8500_chargalg.c |    2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -115,7 +115,6 @@ struct ab8500_btemp {
 static enum power_supply_property ab8500_btemp_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_ONLINE,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
 	POWER_SUPPLY_PROP_TEMP,
 };
 
@@ -532,12 +531,6 @@ static int ab8500_btemp_get_property(str
 		else
 			val->intval = 1;
 		break;
-	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		if (di->bm->bi)
-			val->intval = di->bm->bi->technology;
-		else
-			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = ab8500_btemp_get_temp(di);
 		break;
@@ -662,7 +655,7 @@ static char *supply_interface[] = {
 
 static const struct power_supply_desc ab8500_btemp_desc = {
 	.name			= "ab8500_btemp",
-	.type			= POWER_SUPPLY_TYPE_BATTERY,
+	.type			= POWER_SUPPLY_TYPE_UNKNOWN,
 	.properties		= ab8500_btemp_props,
 	.num_properties		= ARRAY_SIZE(ab8500_btemp_props),
 	.get_property		= ab8500_btemp_get_property,
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -1720,7 +1720,7 @@ static char *supply_interface[] = {
 
 static const struct power_supply_desc ab8500_chargalg_desc = {
 	.name			= "ab8500_chargalg",
-	.type			= POWER_SUPPLY_TYPE_BATTERY,
+	.type			= POWER_SUPPLY_TYPE_UNKNOWN,
 	.properties		= ab8500_chargalg_props,
 	.num_properties		= ARRAY_SIZE(ab8500_chargalg_props),
 	.get_property		= ab8500_chargalg_get_property,


