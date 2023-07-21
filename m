Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80CE1DDDB
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C29C433C8;
	Fri, 21 Jul 2023 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955732;
	bh=Jyauy269MUlVY1CjK+q/cwEIeNNSWq1E4iftvfEmbkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdHrH5ZoKQGDVzUWEZ7jpTAjfFOno784TNkjcLOSOWxTw1X6OWIHgNGi7MsxEjMz4
	 86REaOTfW+B6ADDo6l6GoXw3ikczdbCyn69ps8nVMgHaY6fMM+hdLlcthtqEtCNNg8
	 dABjtT4cbj0/jICox/4trQfy/q+Ye9LqNOaPAcaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	"Lukas F. Hartmann" <lukas@mntre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 011/292] drm: bridge: dw_hdmi: fix connector access for scdc
Date: Fri, 21 Jul 2023 18:02:00 +0200
Message-ID: <20230721160529.298967445@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 98703e4e061fb8715c7613cd227e32cdfd136b23 ]

Commit 5d844091f237 ("drm/scdc-helper: Pimp SCDC debugs") changed the scdc
interface to pick up an i2c adapter from a connector instead. However, in
the case of dw-hdmi, the wrong connector was being used to pass i2c adapter
information, since dw-hdmi's embedded connector structure is only populated
when the bridge attachment callback explicitly asks for it.

drm-meson is handling connector creation, so this won't happen, leading to
a NULL pointer dereference.

Fix it by having scdc functions access dw-hdmi's current connector pointer
instead, which is assigned during the bridge enablement stage.

Fixes: 5d844091f237 ("drm/scdc-helper: Pimp SCDC debugs")
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reported-by: Lukas F. Hartmann <lukas@mntre.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
[narmstrong: moved Fixes tag before first S-o-b and added Reported-by tag]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230601123153.196867-1-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 603bb3c51027b..3b40e0fdca5cb 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1426,9 +1426,9 @@ void dw_hdmi_set_high_tmds_clock_ratio(struct dw_hdmi *hdmi,
 	/* Control for TMDS Bit Period/TMDS Clock-Period Ratio */
 	if (dw_hdmi_support_scdc(hdmi, display)) {
 		if (mtmdsclock > HDMI14_MAX_TMDSCLK)
-			drm_scdc_set_high_tmds_clock_ratio(&hdmi->connector, 1);
+			drm_scdc_set_high_tmds_clock_ratio(hdmi->curr_conn, 1);
 		else
-			drm_scdc_set_high_tmds_clock_ratio(&hdmi->connector, 0);
+			drm_scdc_set_high_tmds_clock_ratio(hdmi->curr_conn, 0);
 	}
 }
 EXPORT_SYMBOL_GPL(dw_hdmi_set_high_tmds_clock_ratio);
@@ -2116,7 +2116,7 @@ static void hdmi_av_composer(struct dw_hdmi *hdmi,
 				min_t(u8, bytes, SCDC_MIN_SOURCE_VERSION));
 
 			/* Enabled Scrambling in the Sink */
-			drm_scdc_set_scrambling(&hdmi->connector, 1);
+			drm_scdc_set_scrambling(hdmi->curr_conn, 1);
 
 			/*
 			 * To activate the scrambler feature, you must ensure
@@ -2132,7 +2132,7 @@ static void hdmi_av_composer(struct dw_hdmi *hdmi,
 			hdmi_writeb(hdmi, 0, HDMI_FC_SCRAMBLER_CTRL);
 			hdmi_writeb(hdmi, (u8)~HDMI_MC_SWRSTZ_TMDSSWRST_REQ,
 				    HDMI_MC_SWRSTZ);
-			drm_scdc_set_scrambling(&hdmi->connector, 0);
+			drm_scdc_set_scrambling(hdmi->curr_conn, 0);
 		}
 	}
 
@@ -3553,6 +3553,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 	hdmi->bridge.ops = DRM_BRIDGE_OP_DETECT | DRM_BRIDGE_OP_EDID
 			 | DRM_BRIDGE_OP_HPD;
 	hdmi->bridge.interlace_allowed = true;
+	hdmi->bridge.ddc = hdmi->ddc;
 #ifdef CONFIG_OF
 	hdmi->bridge.of_node = pdev->dev.of_node;
 #endif
-- 
2.39.2



