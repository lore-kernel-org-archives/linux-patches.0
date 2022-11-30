Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB0679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F298AC433D6;
	Wed, 30 Nov 2022 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833982;
	bh=+0mCiMLXDuHKOibpJFG05HDbiqBQy6oz5ba9lzIm1xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUv9befKvQwm33N+4o6I+as3P0xdmbXR5jxL0fEHGKytcGmfJUum/1MFQO+SDXHHp
	 CSdr4LGTRrLG1rNOjGeyT02bsybXCp3kMAuztWFqS24MLN3yWnABXfZKrCkf8FJDZM
	 BdWigPufP34SDI8eukZVvh5aSzvpGHojL5LUxOXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Samuel Holland <samuel@sholland.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/289] power: supply: ip5xxx: Fix integer overflow in current_now calculation
Date: Wed, 30 Nov 2022 19:20:33 +0100
Message-Id: <20221130180545.218325247@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ondrej Jirman <megi@xff.cz>

[ Upstream commit f9be5cb6c1f0191f8bcf4413b7e17e58e8dfaaa1 ]

When current is larger than ~2A, the multiplication in current_now
property overflows and the kernel reports invalid negative current
value. Change the numerator and denominator while preserving their
ratio to allow up to +-6A before the overflow.

Fixes: 75853406fa27 ("power: supply: Add a driver for Injoinic power bank ICs")
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Samuel Holland <samuel@sholland.org>
[use 149197/200 instead of 261095/350 as suggested by Samuel]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ip5xxx_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ip5xxx_power.c b/drivers/power/supply/ip5xxx_power.c
index 218e8e689a3f..00221e9c0bfc 100644
--- a/drivers/power/supply/ip5xxx_power.c
+++ b/drivers/power/supply/ip5xxx_power.c
@@ -352,7 +352,7 @@ static int ip5xxx_battery_get_property(struct power_supply *psy,
 		ret = ip5xxx_battery_read_adc(ip5xxx, IP5XXX_BATIADC_DAT0,
 					      IP5XXX_BATIADC_DAT1, &raw);
 
-		val->intval = DIV_ROUND_CLOSEST(raw * 745985, 1000);
+		val->intval = DIV_ROUND_CLOSEST(raw * 149197, 200);
 		return 0;
 
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
-- 
2.35.1



