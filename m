Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E8C17DFFA;
	Sat, 12 Sep 2026 09:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206848; cv=none; b=g9nhmHHknEXuppoUBSDmSftl/Cgz1ZyfiUAatEtKa7bRzRSindE/bv6Xboun1NcU8qGOxk2dX4sicD69TwjoIixyCzaBeK8OBqT93duOsEag2XgW0CruUZJrqvHCwSaDJrEPfHzlNZmQLhKYFxhfa9R3/teHPjqqG8qCMxqC3tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206848; c=relaxed/simple;
	bh=3hi77XyZC8tU18ofFQRLFfbs7c0juDkb+TapI2Tbieo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ms9Qhc42ma1fQ/DQRMPjfiASx6hTVR03s135J7DdWC2LZAX4AaG810RJUukf7+DSF3GRlyqWCTt8d0RI9YHaZ2rA4Wvz8czC3jitiZlPTyEOZOr42tHMd8kxy6dwfqg+QU9pMqF/r0Lc+fgFgD6lg7LyQwTgnpn2IeWX3ouGndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFuur928; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFuur928"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA721F000FF;
	Sat, 12 Sep 2026 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206847;
	bh=dNZmuIwiDtG0kc0vK+IWqgetHe/cTWC7KCv3KfV8c6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFuur928/mbGk38atZl4UBO7zqGWajv0kV1/iOGQCLzRRiO280gJjwdd6vP6KzB3k
	 ShvFcvPFI4Dn2zxzXahqGe0t6jcbyNgtxF+HQz9g+RmQuBiNMG3hcpjzQB3cY5VbFc
	 CEMrPFlOVs1F1eCUZw705wgpaCnvD1K8qk8ewbrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0292/1518] leds: st1202: Validate LED reg property against channel count
Date: Sat, 12 Sep 2026 08:41:01 +0200
Message-ID: <20260912065630.087651021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit cf197514bdfd3877f42b5dce1efd40b7b686547e ]

The reg property from the device tree is used directly as an array index
into chip->leds[] without bounds checking. A value >= ST1202_MAX_LEDS
would cause an out-of-bounds write during probe.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB849718B43321DB7E5A05D17BC5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 61b7fe715b880..f5b53a9ed59c6 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -278,13 +278,19 @@ static int st1202_dt_init(struct st1202_chip *chip)
 {
 	struct device *dev = &chip->client->dev;
 	struct st1202_led *led;
-	int err, reg;
+	int err;
+	u32 reg;
 
 	for_each_available_child_of_node_scoped(dev_of_node(dev), child) {
 		err = of_property_read_u32(child, "reg", &reg);
 		if (err)
 			return dev_err_probe(dev, err, "Invalid register\n");
 
+		if (reg >= ST1202_MAX_LEDS)
+			return dev_err_probe(dev, -EINVAL,
+					"LED reg %u out of range [0, %d]\n",
+					reg, ST1202_MAX_LEDS - 1);
+
 		led = &chip->leds[reg];
 		led->is_active = true;
 		led->fwnode = of_fwnode_handle(child);
-- 
2.53.0



