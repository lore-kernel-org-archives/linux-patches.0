Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CF713341F;
	Tue, 23 Jan 2024 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971842; cv=none; b=nab+vYmTT765BxLgqKbIqPd6tfQ6lb3IIYpuPlMi2CLU9Mr18F3qbkaZa7YVJGWL1g31gktPLyP9o54wHSpebeicJNNnFYYqp6ARaBhAZfybGo/D5w42okaB+Jd5NHIVnzi/LOuEl8HTzUbKBCXg+n33bVr2l4qfJ4kGhHvLTTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971842; c=relaxed/simple;
	bh=ej2ZxhO0qwZo5E2EDZ913QAuEfjpms5qDY6LSgCsgTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXhpgY/Eyi1JsP0o0x0WbsBmh7JiVk3RuAob3YkF7dzAUFSMl8QsC0cMys2V2ecH/raHO/NactHBna90980okhssKGq9GZi1p5tPJ7Ggilt6pEohs16qQORifO3SWNsPhMiphxr+zKsi+nLER4btUa7E5eLymrNSeFotEj/CRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiDO2sCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiDO2sCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD22C433F1;
	Tue, 23 Jan 2024 01:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971842;
	bh=ej2ZxhO0qwZo5E2EDZ913QAuEfjpms5qDY6LSgCsgTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiDO2sCzC5GhhhnSvJRopMHgKV9gy2lTJ+KPu3fo4o+Qju0Bxtpx6K5iB74JqMfTl
	 XamvwJfqak5q/Yi63Li0njyvZFmDoPPj5V22SttI+6gJpYQeyHe7tN8DvI3dp9dThm
	 7qpzSZPhgKxB/bNob2ub5dJ5dXgrUHzmLZ/Mui7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/286] power: supply: cw2015: correct time_to_empty units in sysfs
Date: Mon, 22 Jan 2024 15:59:08 -0800
Message-ID: <20240122235741.388163187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index de1fa71be1e8..d1071dbb904e 100644
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



