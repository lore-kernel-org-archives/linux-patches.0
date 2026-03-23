Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19402BEC3F;
	Mon, 23 Mar 2026 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282694; cv=none; b=iLyeiJocz03pQe0gp/+kHx/DhzbOj5Na1j/WaVLSZ5vtJQou7rv36ImjwKP8mgcHhU3Jww8yzutWocZ5HP2QG+/87vyp8HIsPsvmGDnAFmxZRH4fZWWLghRxvjuLNTJlf+a5PRLsV3tkYCykRQ8tWY7XtK1t5IQ4vtEZwhCckNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282694; c=relaxed/simple;
	bh=BFxBkIlix6S1Ny3tGtNYsr12v2zWIW7liLTs2/X2xuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJSwA43cl0QHlvoy9DpHvLirVuPrE+pWJwYo9T0BvroqLM1UsR0PjbQWWzTSzrnfGvDJvK/npc37H9OROmB5Wm7gL87SN3gTcNgs7iSM6EMoLTe9cXRmlhMF7V5ue+ESaxiXM7inP+2yM9pMABrXV936D7IxAt/TuTUF3s8nhZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF4D1gHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF4D1gHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EB9C4CEF7;
	Mon, 23 Mar 2026 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282693;
	bh=BFxBkIlix6S1Ny3tGtNYsr12v2zWIW7liLTs2/X2xuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF4D1gHt0OKn3j1KV7xg0JEfNIk3KlMcAa5Wc/mMf96SEsOA9ZEY0nYgO53ZIqBVi
	 0N/SBn+Hbiuvp0EhrUEqHQY8QMbsPpOlM6dAeLKbwdN/nqb7sjqvjYiwVbWXfrLvjC
	 umabTCOJMywwMJkWi9D3Fz6FA3w8j14hWrx4dBv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.1 251/481] drm/bridge: ti-sn65dsi83: fix CHA_DSI_CLK_RANGE rounding
Date: Mon, 23 Mar 2026 14:43:53 +0100
Message-ID: <20260323134531.272071526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 2f22702dc0fee06a240404e0f7ead5b789b253d8 upstream.

The DSI frequency must be in the range:

  (CHA_DSI_CLK_RANGE * 5 MHz) <= DSI freq < ((CHA_DSI_CLK_RANGE + 1) * 5 MHz)

So the register value should point to the lower range value, but
DIV_ROUND_UP() rounds the division to the higher range value, resulting in
an excess of 1 (unless the frequency is an exact multiple of 5 MHz).

For example for a 437100000 MHz clock CHA_DSI_CLK_RANGE should be 87 (0x57):

  (87 * 5 = 435) <= 437.1 < (88 * 5 = 440)

but current code returns 88 (0x58).

Fix the computation by removing the DIV_ROUND_UP().

Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Cc: stable@vger.kernel.org
Reviewed-by: Marek Vasut <marek.vasut@mailbox.org>
Link: https://patch.msgid.link/20260226-ti-sn65dsi83-dual-lvds-fixes-and-test-pattern-v1-1-2e15f5a9a6a0@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -303,9 +303,9 @@ static u8 sn65dsi83_get_dsi_range(struct
 	 *  DSI_CLK = mode clock * bpp / dsi_data_lanes / 2
 	 * the 2 is there because the bus is DDR.
 	 */
-	return DIV_ROUND_UP(clamp((unsigned int)mode->clock *
-			    mipi_dsi_pixel_format_to_bpp(ctx->dsi->format) /
-			    ctx->dsi->lanes / 2, 40000U, 500000U), 5000U);
+	return clamp((unsigned int)mode->clock *
+		     mipi_dsi_pixel_format_to_bpp(ctx->dsi->format) /
+		     ctx->dsi->lanes / 2, 40000U, 500000U) / 5000U;
 }
 
 static u8 sn65dsi83_get_dsi_div(struct sn65dsi83 *ctx)


