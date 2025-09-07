Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AF4212B2F;
	Sun,  7 Sep 2025 20:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276375; cv=none; b=GB5eXL0lpFNUF/9rGTBnW+LKnlkYVJr0t2XCCCuuCcciQZcyFBDn1elEnR/RGqErUxna9Yv91BUzHbGRwfHH00SJmS/9Kw+mkpJWiyrp4AqdMIy4SxbVcZXNED7ZJRy0VP6hcA6+8p64ZvzA9QSsxub2z2ewOPnfIf4tytH9e9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276375; c=relaxed/simple;
	bh=1HJF3yP3xk90Va3/0UYPS+NXkkuQzJqSqBvG7OEsRkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6WtpUhNQ/z1w6Kw0e2Kwlq603o1vY9dZellOesg1WgA7oei54IfK1/U6ibqIZggzVa2wEpMF6zKgOQqZ30PLeGH+AEMEYXURIh6UgU4sS/4Xy2+hbJye4uSSvyDi0JN9h1L8w9TPZvjLH0Ss0GbKOWdeDO8i0a0Xwp5JWgXC34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJYoOgls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJYoOgls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F7CC4CEF0;
	Sun,  7 Sep 2025 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276375;
	bh=1HJF3yP3xk90Va3/0UYPS+NXkkuQzJqSqBvG7OEsRkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJYoOgls1XWRBBHFYXF7zgw3vpOh/b2O6SQOdVn93xKK55ssXvdSWIaQTgUb3GtRU
	 oPmxbItvFpbyIc3Sfnm3WvK72SqvAX+bH/Coe6P02KW5/NR6X9JtRU6JM4dXFBH8/v
	 ndQWt2jXBsGAc/ZymkClIba7kIX5JQVzcHAVpwbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/104] drm/bridge: ti-sn65dsi86: fix REFCLK setting
Date: Sun,  7 Sep 2025 21:58:42 +0200
Message-ID: <20250907195609.876448172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit bdd5a14e660062114bdebaef9ad52adf04970a89 ]

The bridge has three bootstrap pins which are sampled to determine the
frequency of the external reference clock. The driver will also
(over)write that setting. But it seems this is racy after the bridge is
enabled. It was observed that although the driver write the correct
value (by sniffing on the I2C bus), the register has the wrong value.
The datasheet states that the GPIO lines have to be stable for at least
5us after asserting the EN signal. Thus, there seems to be some logic
which samples the GPIO lines and this logic appears to overwrite the
register value which was set by the driver. Waiting 20us after
asserting the EN line resolves this issue.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250821122341.1257286-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 6595f954135ad..d31bb9153f4fb 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -375,6 +375,17 @@ static int __maybe_unused ti_sn65dsi86_resume(struct device *dev)
 
 	gpiod_set_value(pdata->enable_gpio, 1);
 
+	/*
+	 * After EN is deasserted and an external clock is detected, the bridge
+	 * will sample GPIO3:1 to determine its frequency. The driver will
+	 * overwrite this setting in ti_sn_bridge_set_refclk_freq(). But this is
+	 * racy. Thus we have to wait a couple of us. According to the datasheet
+	 * the GPIO lines has to be stable at least 5 us (td5) but it seems that
+	 * is not enough and the refclk frequency value is still lost or
+	 * overwritten by the bridge itself. Waiting for 20us seems to work.
+	 */
+	usleep_range(20, 30);
+
 	/*
 	 * If we have a reference clock we can enable communication w/ the
 	 * panel (including the aux channel) w/out any need for an input clock
-- 
2.51.0



