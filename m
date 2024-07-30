Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D91A76BE;
	Tue, 30 Jul 2024 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359740; cv=none; b=utFJvlBc+/6iW97mg9n8OoMFK7sPEAJqAWzBlcvPvoXKGyd73nnRKBji+fdhd/tMQJb7eFI1JbPHw7vq6W7OtmiUSSDeu0QO54tJ36Z5wfLpgsjHHjgynKRB2Ox5Egfehz6+H7erIcX6IMjL7aGHtLHslj8i92giqyC522Gncq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359740; c=relaxed/simple;
	bh=Kt+2C1Gu9NmoJJ8ZoNlTEfRwV8uu7lZ9/B9kty9xUuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwxQFG3SKg650VExSBrJ+WE/73g+1/s7fy/dgbiuluKaLKfJHpikAznI7+ZmzHv/K2KB3CV1kodo8tmG2CXVe6L1zXcxXE20w5yK/vXacA0tLThSjorBYrAN77M15Op2k9ePa6+MFD+yvmpJml9u2hj4dluIVdaXcaWgc3MF4DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibfWZQ6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibfWZQ6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71FEC4AF0C;
	Tue, 30 Jul 2024 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359740;
	bh=Kt+2C1Gu9NmoJJ8ZoNlTEfRwV8uu7lZ9/B9kty9xUuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibfWZQ6Rwe6iFtoYxDpSHGggie1+caPDuO5eXmEdrjagDcGxES4Tz9lGtvWXXNOVY
	 9PyBoMdSyVd3OxG5U6WLXo/vZqfPZOF67Q72CPzGHVfQqveyJGch/E/Tp9LwOjq9KC
	 vQB84HPOYjtf3rX8REZYSLYdvf718UOMmh8yTb/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Artur Rojek <contact@artur-rojek.eu>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 526/809] power: supply: ingenic: Fix some error handling paths in ingenic_battery_get_property()
Date: Tue, 30 Jul 2024 17:46:42 +0200
Message-ID: <20240730151745.512615122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f8b6c1eb76f73ed721facd58d0cfb08513aad34c ]

If iio_read_channel_processed() fails, 'val->intval' is not updated, but it
is still *1000 just after. So, in case of error, the *1000 accumulate and
'val->intval' becomes erroneous.

So instead of rescaling the value after the fact, use the dedicated scaling
API. This way the result is updated only when needed. In case of error, the
previous value is kept, unmodified.

This should also reduce any inaccuracies resulting from the scaling.

Finally, this is also slightly more efficient as it saves a function call
and a multiplication.

Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery driver.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Artur Rojek <contact@artur-rojek.eu>
Link: https://lore.kernel.org/r/51e49c18574003db1e20c9299061a5ecd1661a3c.1719121781.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ingenic-battery.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/ingenic-battery.c b/drivers/power/supply/ingenic-battery.c
index 2e7fdfde47ece..0a40f425c2772 100644
--- a/drivers/power/supply/ingenic-battery.c
+++ b/drivers/power/supply/ingenic-battery.c
@@ -31,8 +31,9 @@ static int ingenic_battery_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_HEALTH:
-		ret = iio_read_channel_processed(bat->channel, &val->intval);
-		val->intval *= 1000;
+		ret = iio_read_channel_processed_scale(bat->channel,
+						       &val->intval,
+						       1000);
 		if (val->intval < info->voltage_min_design_uv)
 			val->intval = POWER_SUPPLY_HEALTH_DEAD;
 		else if (val->intval > info->voltage_max_design_uv)
@@ -41,8 +42,9 @@ static int ingenic_battery_get_property(struct power_supply *psy,
 			val->intval = POWER_SUPPLY_HEALTH_GOOD;
 		return ret;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = iio_read_channel_processed(bat->channel, &val->intval);
-		val->intval *= 1000;
+		ret = iio_read_channel_processed_scale(bat->channel,
+						       &val->intval,
+						       1000);
 		return ret;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
 		val->intval = info->voltage_min_design_uv;
-- 
2.43.0



