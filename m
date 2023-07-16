Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836B8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE4AC433C8;
	Sun, 16 Jul 2023 20:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539828;
	bh=gq4/+l8k/WUMkKmOcnpc+My5IeRJU1SJXIgHezpCJKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2+gUPfa9Qy1qq+GkaonDHJBNRSKmHTm71KUQX3Lz+g+lz9vininYO4QvtE8wbzgs
	 1yYrE+8SjcQm20XIlWj8yGTT+TA9pK8+Q2Asknb+3WmRm9SRITUYz/SUXpsfbXkyK5
	 F+6iUPK08FpOUhfmDpMB2y1HIA9QGD2rt1HGItwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/591] drm/bridge: tc358768: always enable HS video mode
Date: Sun, 16 Jul 2023 21:44:46 +0200
Message-ID: <20230716194927.674346537@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 75a8aeac2573ab258c53676eba9b3796ea691988 ]

Always enable HS video mode setting the TXMD bit, without this change no
video output is present with DSI sinks that are setting
MIPI_DSI_MODE_LPM flag (tested with LT8912B DSI-HDMI bridge).

Previously the driver was enabling HS mode only when the DSI sink was
not explicitly setting the MIPI_DSI_MODE_LPM, however this is not
correct.

The MIPI_DSI_MODE_LPM is supposed to indicate that the sink is willing
to receive data in low power mode, however clearing the
TC358768_DSI_CONTROL_TXMD bit will make the TC358768 send video in
LP mode that is not the intended behavior.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-2-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 4c4b77ce8aba3..23a7a1206e900 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -867,8 +867,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	val = TC358768_DSI_CONFW_MODE_SET | TC358768_DSI_CONFW_ADDR_DSI_CONTROL;
 	val |= (dsi_dev->lanes - 1) << 1;
 
-	if (!(dsi_dev->mode_flags & MIPI_DSI_MODE_LPM))
-		val |= TC358768_DSI_CONTROL_TXMD;
+	val |= TC358768_DSI_CONTROL_TXMD;
 
 	if (!(mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS))
 		val |= TC358768_DSI_CONTROL_HSCKMD;
-- 
2.39.2



