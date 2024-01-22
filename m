Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA9176908;
	Tue, 23 Jan 2024 02:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975504; cv=none; b=LYqLtqtCUTOr7fvzrq4CHjIuzS9kUvZiQc+b6Ak4mN8XLbK6Q8Qm3xxL4hx7DJvJ7e0cCZWRYXGI9sFUftyv2wBiSucEtRbf0eVcdnpnhjyxDz1CeDyheb6nDA/oGEfvWFAyLpEP2DNiXCBBhm9hHO1B+H7V3uHyiHI9uD5lZ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975504; c=relaxed/simple;
	bh=k1R0GQnjAv1wb6QW7Nf1s6xUVv4YELWEE4fXqyWDDWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psGV+zJ7Hgn+Bz9yzlb8cWtEXvGmK5Kc3lq86s9FnuqugjDVrb/GDGKFvhQapOVBk4MHbW00oIdIALROZSbc+z7sZvDoIGgJg7bdjlCCrcavjGJpg1/WX+44JHPYNbtj7UG/fwnhmZSwZKbGSp2jTnWh77Q0URSJHCElRQ4K3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qe3GUHat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qe3GUHat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD356C43399;
	Tue, 23 Jan 2024 02:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975503;
	bh=k1R0GQnjAv1wb6QW7Nf1s6xUVv4YELWEE4fXqyWDDWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qe3GUHath5+hMsdaT1+fUlMa7BwH/o1JOEYggqy+xY/O22LSZ7tTPaRAalb4m0gLd
	 br6sBuOn0lRzWdLYUiaSF5EjuEiss6izp1+cVeV/61Waq3M7MedIfPDGVEx/U1Cds/
	 DocGcoskEDA0n8mLgs8nTV4NI+XsEFhDAyC98o/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 456/583] power: supply: cw2015: correct time_to_empty units in sysfs
Date: Mon, 22 Jan 2024 15:58:27 -0800
Message-ID: <20240122235825.923122886@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb29e9ebd24a..99f3ccdc30a6 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -491,7 +491,7 @@ static int cw_battery_get_property(struct power_supply *psy,
 
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		if (cw_battery_valid_time_to_empty(cw_bat))
-			val->intval = cw_bat->time_to_empty;
+			val->intval = cw_bat->time_to_empty * 60;
 		else
 			val->intval = 0;
 		break;
-- 
2.43.0



