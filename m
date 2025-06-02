Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A2C2248BF;
	Mon,  2 Jun 2025 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873633; cv=none; b=J4MOUuWo6+Ojdq+mswEk19lNiVNf3JehVydud+XBu0SVYg4Nxh3Tl1hq9S1zNNQn6oLqDeO7PoTiGGPqeINdLwlwMdqf30xNocGFNhjRk+unFN/pQK/nJGXhNKK8FA5PK6lXW1a03gGJxd61EbnnXfO6E0E4cIWu2Lutbmkw5lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873633; c=relaxed/simple;
	bh=mfdxeDEyNOJxmW2amUZXj5fafkZTPcQhnwExjB17e8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/FGlksckDkKwwva4VzPFBu7NSqC4sY5nrH0IYRvlR6hl7jnmN9PyIxGs5ejKGE+RPMPUOrsi3yQuMKjNsInwarw2PR64mgdqEdRJ2ZzP5Gxyg/OEP9wBb9saY4A567v2ITqY8qrbkPm1gjWyDDZYvQOcsnZFAOvtLS7h47Vz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE5uS7tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE5uS7tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D9C4CEEB;
	Mon,  2 Jun 2025 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873632;
	bh=mfdxeDEyNOJxmW2amUZXj5fafkZTPcQhnwExjB17e8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE5uS7tcBeXhclZNRUZsfSCMdGYB15k+vGxvTmshriHtHHoAC/ZnH0/7Cw2KJDI0C
	 WGFjHrNRKEnAhtEkkFvvSpIUSWowIBhfx1HHVrAn1JEID+olc2Q1xJfYGYsyP5ieE1
	 CTIwX22aQU5XKqAF0KDW2lEacjkMR7SnPxaBJ0WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/444] leds: pwm-multicolor: Add check for fwnode_property_read_u32
Date: Mon,  2 Jun 2025 15:43:59 +0200
Message-ID: <20250602134347.996680010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 6d91124e7edc109f114b1afe6d00d85d0d0ac174 ]

Add a check to the return value of fwnode_property_read_u32()
in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20250223121459.2889484-1-ruc_gongyuanjun@163.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-pwm-multicolor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/rgb/leds-pwm-multicolor.c b/drivers/leds/rgb/leds-pwm-multicolor.c
index e1a81e0109e8a..c0aa34b1d0e2d 100644
--- a/drivers/leds/rgb/leds-pwm-multicolor.c
+++ b/drivers/leds/rgb/leds-pwm-multicolor.c
@@ -135,8 +135,11 @@ static int led_pwm_mc_probe(struct platform_device *pdev)
 
 	/* init the multicolor's LED class device */
 	cdev = &priv->mc_cdev.led_cdev;
-	fwnode_property_read_u32(mcnode, "max-brightness",
+	ret = fwnode_property_read_u32(mcnode, "max-brightness",
 				 &cdev->max_brightness);
+	if (ret)
+		goto release_mcnode;
+
 	cdev->flags = LED_CORE_SUSPENDRESUME;
 	cdev->brightness_set_blocking = led_pwm_mc_set;
 
-- 
2.39.5



