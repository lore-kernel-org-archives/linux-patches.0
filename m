Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4533B194A67;
	Tue, 27 May 2025 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365189; cv=none; b=hON+9zTSEfPzjFbQWmLysygzgYFk8j4KyyrGfocd4rej/1xCj+iEXZOiFJ+BWCB77yGheh0gMIdN42IuKVRbXPVFksgLwHU+2RSVI164yKAM3GkF2cpdWw9wpPvDLwxETUByeJ/GlQQmwcpJi2ge3VxG636QI95KtVPIwheUywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365189; c=relaxed/simple;
	bh=gDbuONY8QV058CmvIFYjDNojQlZQDXeTaiRfyH+tAOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR98CCxib0FCJWMzVzMLQ0GbIi/DmFeeYuMMr0GlUcM6voGl4kMGcKK8gVgvKrM48UKyHiENJn3z9ddypEh3ntL9mpcP4/WPgkncPT4K91RJiFLaBEDu+7keH9HkPx4l2gGuFOfdA2G/50qmi9KI8G8YBoljUpZfx3scUBH+FkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6dF5y8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6dF5y8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B86C4CEE9;
	Tue, 27 May 2025 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365189;
	bh=gDbuONY8QV058CmvIFYjDNojQlZQDXeTaiRfyH+tAOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6dF5y8db9Cfzq7xAfk/XuA0tU4WEdOPJZWTdUeBLjQMnJN5cC3+3RWk/Nx+kPZY+
	 qfTWvab2ZqaYCvqcLjro0Q3W1QYXjFhNrLYDkOhz+jM+/f0VsCWy+TR1u1M/9KoyHH
	 JjoxH/XylSjD24NMUabWhaJ2m5Su8uAPFbds7A3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/626] leds: pwm-multicolor: Add check for fwnode_property_read_u32
Date: Tue, 27 May 2025 18:22:51 +0200
Message-ID: <20250527162456.319661212@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



