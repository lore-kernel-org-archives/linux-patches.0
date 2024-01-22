Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110452F7C;
	Tue, 23 Jan 2024 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969909; cv=none; b=ahURUKWZc3LaPY8eKSDXF3aId2Auyr8SaE61Hr4/MZd9d0CtXhS9HkHgo1zTpUiRPaam7S1wfMXLfgCAbwywQ2qOVuNu+8XXc3g7JKDVn9yd5BSdI7LmtnbZjHCiWdsZdyntl3Z3GwAdTPzH+pyWYvjwUSjIoVtQ+xEgCYmiNac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969909; c=relaxed/simple;
	bh=PbJV10MgpnbdkLkV5pMZ0tyFCPAtEIXy5PJ+kvJ1Jjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u135m8JyBj2VYTal4tlIWGVz+VUsq16RpfDwP1yzsH8ZxwYNMDNnKtkm6VbR5OWQTRjbO365NER9+nqy5FeonBTya2Z52/2R3Loy3P3YD/P0xc12A8WWGHBBdTs3f4Z0QGpx85YUKb3IOUnxxgyEc1wXxNdnkbk0UWYNtLciE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sariL3B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sariL3B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08478C433F1;
	Tue, 23 Jan 2024 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969909;
	bh=PbJV10MgpnbdkLkV5pMZ0tyFCPAtEIXy5PJ+kvJ1Jjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sariL3B5clvkXuQf6O9iNe4AA8tOAEowi9oPKSl83kxJC7a4Pbq+mcyV4SxJ1UO+v
	 7exgjKUvv1lq1TAEuMTSyldm7NTjrKwTWI+uLL7NE4gug5AN+Y3L2bstCy5As/jpwp
	 RoQv90cd3ujjjvI/jQMZxJTZ6cdQPBiRxtTBId9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 502/641] power: supply: cw2015: correct time_to_empty units in sysfs
Date: Mon, 22 Jan 2024 15:56:46 -0800
Message-ID: <20240122235833.776473614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



