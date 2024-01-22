Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F98629F1;
	Tue, 23 Jan 2024 01:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974970; cv=none; b=RioxrfzCyWnh9VkgrGmyPAsnXrNsDUvp9mCGlNiUeYRe7U6sXHfafmWVLIaVtKtG3cTaaaV/XTuVzsbDqfRUIJ3Fbdczh4lznCgWjNOB4zhb6B8RiE5m//Dcy9hd3uLyxMkDNkeiXmcPyMf/yl3GdSUwAEKhLI5Tt5MjYEaiwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974970; c=relaxed/simple;
	bh=CX6mkZ7HTySJKvkIMSUSqhzc48CAW6nMeP8OcZgNPac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUt0m21O2LfYJw0wAAgR2eK0v9gF8TtbAPqidebNPZvJ4FORWWq5tAF7iIiRBHIi/INYyh/OGGtOG8ha5L/ghyPTArUK+iOIcWe4+qEfAlg1fO32Pvw7QiZIVcGuVl7yGRntHJpwp80vTLWHw+HCdqMgJroOzGrnD58MTSYDsZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRe6yMN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRe6yMN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F9C433B1;
	Tue, 23 Jan 2024 01:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974969;
	bh=CX6mkZ7HTySJKvkIMSUSqhzc48CAW6nMeP8OcZgNPac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRe6yMN5gyxz83+sCA3bx0+xGOM2sdwyr5Li4g0gYZVrsUogxG8hIpgyDzKKa/68Y
	 fU2PqxxVyT1yYupGMjtjd0EnUw8bnyaGQC99Dm9yA9qb3XP1B46ylcPEyHOQTQtmGq
	 ThVQ4uVS+uk2DGEoLpNoXKinsShKanm2K0WzfAVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/374] power: supply: cw2015: correct time_to_empty units in sysfs
Date: Mon, 22 Jan 2024 15:59:17 -0800
Message-ID: <20240122235755.261988858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Palus <jpalus@fastmail.com>

[ Upstream commit f37669119423ca852ca855b24732f25c0737aa57 ]

RRT_ALRT register holds remaining battery time in minutes therefore it
needs to be scaled accordingly when exposing TIME_TO_EMPTY via sysfs
expressed in seconds

Fixes: b4c7715c10c1 ("power: supply: add CellWise cw2015 fuel gauge driver")
Signed-off-by: Jan Palus <jpalus@fastmail.com>
Link: https://lore.kernel.org/r/20231111221704.5579-1-jpalus@fastmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 091868e9e9e8..587db9fd8624 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -490,7 +490,7 @@ static int cw_battery_get_property(struct power_supply *psy,
 
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		if (cw_battery_valid_time_to_empty(cw_bat))
-			val->intval = cw_bat->time_to_empty;
+			val->intval = cw_bat->time_to_empty * 60;
 		else
 			val->intval = 0;
 		break;
-- 
2.43.0



