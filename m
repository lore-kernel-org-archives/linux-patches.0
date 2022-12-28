Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4111863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE2FC433D2;
	Wed, 28 Dec 2022 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240938;
	bh=rLHu2CYfxahU9xq6+rUVZpyjwkXOw6GYE1rOuZsnWMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBCzgfQQmoawKzbd+y4FV/+Ggih6evpVbTBkV7T4xqeK2PToHJamExf2KvNviT3Gz
	 vVpN75KjAc4l8mGrLwq7nKx/nWWhPuXFVb55utH0NzAOVPEUygS0L89epge2SSgE2G
	 SIvrES2lDAl2TDrQG/spQScx8gZ/VOvFmxOl+xsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0221/1073] Input: iqs7222 - set all ULP entry masks by default
Date: Wed, 28 Dec 2022 15:30:09 +0100
Message-Id: <20221228144334.019659502@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit d56111ed58482de0045e1e1201122e6e71516945 ]

Some devices expose an ultra-low-power (ULP) mode entry mask for
each channel. If the mask is set, the device cannot enter ULP so
long as the corresponding channel remains in an active state.

The vendor has advised setting the mask for any disabled channel.
To accommodate this suggestion, initially set all masks and then
clear them only if specified in the device tree.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220908131548.48120-8-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 2f6fd2329789 ("Input: iqs7222 - protect against undefined slider size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index b2e8097a2e6d..8b3362169265 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1771,11 +1771,9 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222, int chan_index)
 	if (!chan_node)
 		return 0;
 
-	if (dev_desc->allow_offset) {
-		sys_setup[dev_desc->allow_offset] |= BIT(chan_index);
-		if (fwnode_property_present(chan_node, "azoteq,ulp-allow"))
-			sys_setup[dev_desc->allow_offset] &= ~BIT(chan_index);
-	}
+	if (dev_desc->allow_offset &&
+	    fwnode_property_present(chan_node, "azoteq,ulp-allow"))
+		sys_setup[dev_desc->allow_offset] &= ~BIT(chan_index);
 
 	chan_setup[0] |= IQS7222_CHAN_SETUP_0_CHAN_EN;
 
@@ -2206,6 +2204,9 @@ static int iqs7222_parse_all(struct iqs7222_private *iqs7222)
 	u16 *sys_setup = iqs7222->sys_setup;
 	int error, i;
 
+	if (dev_desc->allow_offset)
+		sys_setup[dev_desc->allow_offset] = U16_MAX;
+
 	if (dev_desc->event_offset)
 		sys_setup[dev_desc->event_offset] = IQS7222_EVENT_MASK_ATI;
 
-- 
2.35.1



