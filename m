Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22E1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C70C433EF;
	Wed, 28 Dec 2022 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244678;
	bh=EburepUz3/VPm54H9JLafbIA0MJZRjiFiR4eFeT2XS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2W+SyEy2lViSW9OISsQP7yjazQbXzjrDe7gfISCD99xzc09GFJBtzyP9jU9VJ1S4
	 ooeukGAIcGqbVnPDU4b/uiCbsROT6Erp2BUw6BZlvmYBIaD97J58whjqTLVt1Lmgvi
	 UHM/bUwCBPZiadFxvKAue6rymYEtz+Nn7p4xLW6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Vincent Knecht <vincent.knecht@mailoo.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0755/1073] leds: is31fl319x: Fix setting current limit for is31fl319{0,1,3}
Date: Wed, 28 Dec 2022 15:39:03 +0100
Message-Id: <20221228144348.525609012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 135780f1048b3f956f5b10bb23dec9c2d2c4ef6d ]

The current setting lives in bits 4:2 (as also defined by the mask) but
the current limit defines in the driver use bits 2:0 which should be
shifted over so they don't get masked out completely (except for 17.5mA
which became 10mA).

Now checking /sys/kernel/debug/regmap/1-0068/registers shows that the
current limit is applied correctly and doesn't take the default b000 =
42mA.

Fixes: fa877cf1abb9 ("leds: is31fl319x: Add support for is31fl319{0,1,3} chips")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Vincent Knecht <vincent.knecht@mailoo.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-is31fl319x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-is31fl319x.c b/drivers/leds/leds-is31fl319x.c
index 52b59b62f437..b2f4c4ec7c56 100644
--- a/drivers/leds/leds-is31fl319x.c
+++ b/drivers/leds/leds-is31fl319x.c
@@ -38,6 +38,7 @@
 #define IS31FL3190_CURRENT_uA_MIN	5000
 #define IS31FL3190_CURRENT_uA_DEFAULT	42000
 #define IS31FL3190_CURRENT_uA_MAX	42000
+#define IS31FL3190_CURRENT_SHIFT	2
 #define IS31FL3190_CURRENT_MASK		GENMASK(4, 2)
 #define IS31FL3190_CURRENT_5_mA		0x02
 #define IS31FL3190_CURRENT_10_mA	0x01
@@ -553,7 +554,7 @@ static int is31fl319x_probe(struct i2c_client *client)
 			     is31fl3196_db_to_gain(is31->audio_gain_db));
 	else
 		regmap_update_bits(is31->regmap, IS31FL3190_CURRENT, IS31FL3190_CURRENT_MASK,
-				   is31fl3190_microamp_to_cs(dev, aggregated_led_microamp));
+				   is31fl3190_microamp_to_cs(dev, aggregated_led_microamp) << IS31FL3190_CURRENT_SHIFT);
 
 	for (i = 0; i < is31->cdef->num_leds; i++) {
 		struct is31fl319x_led *led = &is31->leds[i];
-- 
2.35.1



