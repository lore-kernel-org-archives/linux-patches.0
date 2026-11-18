Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054594;
	b=oQlBdF5skUU1mlpmIq66upVPAQ5H995HJU1LwjzHvZvGrXlql6rog4fZ+7vrS+evmFrr
	 AvBXttFPf0Pki15a0uJmBPLQMNNnPo+aQ782naJ09iPUK0UuDsgY3h9UHcYWZodFABFau
	 fJssNEdJPjX7ePkGsZpevWUC0koMjzVpSsadfefPGKJle97H+5yCxRBvab9/brYXM9jeC
	 71J/eX8yPvbe3rBz8sZNYMDBdNiAT7azkXAvjmKuJJ2z8dQpo6uQYGjeivcuuJ21BYe8d
	 PqqXBd/N7yrQCp2EtZZXaVOmL0NUv8h7g0U/8l5sthLld3i72KzzhQqVRFd5pfAfIhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=obkKhrx06+v5sFAYK+IGLoiZEZvcZqSWBMHZoOBM1Ig=;
	b=trujdE3jguaMJTIq70L2nCNlSaM6w/OXNKq6zLnOdWD832LRQG5V8gyqu0f3N9KIo/bx
	 GdDHggLwcjPrsqbj3zkegpRTK9bF3hFLHA1uBwGTMKVAVI/Q8zqWWyrVL16/r5T6DCShX
	 SHqBZmF12yI+hwnTjqwVwc60oNOa13r8pcasXO77IdLXO4w72b82K0K03HyNPPyBQonV2
	 NAKeDGc93jUKypKLWPYptsg1Zlbez04Aw1L/I2FWMWtlKjYBuuM0oyTPkZleylDmllWtJ
	 Bh+Arl0lO5S53XPg42PJYua5+Ljz5ZA1AAk8tyRByx8rPZ500tg5CeOPhAVILnXFPtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nke2y98B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201FA606A320;
	Thu, 19 Nov 2026 02:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nke2y98B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759551F000C4;
	Thu, 19 Nov 2026 02:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054594;
	bh=obkKhrx06+v5sFAYK+IGLoiZEZvcZqSWBMHZoOBM1Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nke2y98BqwrfYEXzPgIxuRPDblg5yIe7rKI2YDSkuCBQTTdLzOaOhqvFNtvjmLkiE
	 ByXf9WBJ8QAJ2UtM4hRpclke0dtmnsXp4Pt5byli8wWj+3qGmEc1gr5IycmC31kbVp
	 IFTtYKF9NYv2GzHcrEprWxV2tjg3BImxxAXEPywU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1328/2214] drm/omap: dsi: avoid sending bta sync all the time in writes
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150104.548262212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 20207f78382ff339f3a7f7c5db2c0219b157d32a ]

Some chips need configuration commands to be sent first, before they can
send data. TC358762 for example needs PPI_LPTXTIMECNT configured
and PPI_STARTPPI set to 1 to be able to transmit anything. To be able to
configure such chips, do not send bta sync during writes if no acks are
requested. Instead just wait for the packet to be sent to avoid FIFO
overflows. There might be more to do about acks, but there seem to be
virtually no users of that flag.

This came to light when fiddling with the Epson Moverio BT-200 display
which consists of 2 TC358762 bridges with SPI funneled through
to the unknown display chip. With that patch the bridge can be accessed,
Reading back registers works, when the above-mentioned registers are set.

In Command-Mode update, there was a nop sent, apparently the most
relevant part was the bta sync to actually force low power mode.

Video mode panel at OMAP4 (BT-200) and video mode at OMAP5 was tested.

Fixes: e70965386353e ("drm/omap: dsi: simplify write function")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260629-vm-upstr-v4-1-9f0c62d8808e@kemnade.info
Link: https://patch.msgid.link/20260628-vm-upstr-v3-1-9e9add93378b@kemnade.info
Link: https://patch.msgid.link/20260529-vm-upstr-v2-1-24c30671719f@kernel.org
Link: https://lore.gitlab.freedesktop.org/drm-ai-reviews/review-patch1-20260529-vm-upstr-v2-1-24c30671719f@kernel.org/
Link: https://patch.msgid.link/20260528-vm-upstr-v1-1-fb93ef8cbe47@kernel.org
Link: https://patch.msgid.link/20260804-vm-upstr-v6-1-1bf3748b2fa3@kemnade.info
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dsi.c | 63 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index ef632c71cb412..60d03e8e1cb18 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -58,9 +58,6 @@ static void dsi_uninit_dispc(struct dsi_data *dsi);
 
 static int dsi_vc_send_null(struct dsi_data *dsi, int vc, int channel);
 
-static ssize_t _omap_dsi_host_transfer(struct dsi_data *dsi, int vc,
-				       const struct mipi_dsi_msg *msg);
-
 #ifdef DSI_PERF_MEASURE
 static bool dsi_perf;
 module_param(dsi_perf, bool, 0644);
@@ -2189,28 +2186,45 @@ static int dsi_vc_send_null(struct dsi_data *dsi, int vc, int channel)
 static int dsi_vc_write_common(struct omap_dss_device *dssdev, int vc,
 			       const struct mipi_dsi_msg *msg)
 {
+	DECLARE_COMPLETION_ONSTACK(completion);
 	struct dsi_data *dsi = to_dsi_data(dssdev);
+	u32 err;
 	int r;
 
+	/* wait for IRQ for packet transmission confirmation */
+	r = dsi_register_isr_vc(dsi, vc, dsi_completion_handler,
+				&completion, DSI_VC_IRQ_PACKET_SENT);
+	if (r)
+		return r;
+
 	if (mipi_dsi_packet_format_is_short(msg->type))
 		r = dsi_vc_send_short(dsi, vc, msg);
 	else
 		r = dsi_vc_send_long(dsi, vc, msg);
 
-	if (r < 0)
+	if ((!r) && wait_for_completion_timeout(&completion,
+				msecs_to_jiffies(500)) == 0)
+		r = -EIO;
+
+	dsi_unregister_isr_vc(dsi, vc, dsi_completion_handler,
+			      &completion, DSI_VC_IRQ_PACKET_SENT);
+	if (r)
 		return r;
 
-	/*
-	 * TODO: we do not always have to do the BTA sync, for example
-	 * we can improve performance by setting the update window
-	 * information without sending BTA sync between the commands.
-	 * In that case we can return early.
-	 */
+	/* TODO: find out if more needs to be done for MIPI_DSI_MSG_REQ_ACK */
 
-	r = dsi_vc_send_bta_sync(dssdev, vc);
-	if (r) {
-		DSSERR("bta sync failed\n");
-		return r;
+	if (msg->flags & MIPI_DSI_MSG_REQ_ACK) {
+		r = dsi_vc_send_bta_sync(dssdev, vc);
+		if (r) {
+			DSSERR("bta sync failed\n");
+			return r;
+		}
+	} else {
+		err = dsi_get_errors(dsi);
+		if (err) {
+			DSSERR("Error while sending: %x\n", err);
+			return -EIO;
+		}
 	}
 
 	/* RX_FIFO_NOT_EMPTY */
@@ -3228,21 +3242,6 @@ static int _dsi_update(struct dsi_data *dsi)
 	return 0;
 }
 
-static int _dsi_send_nop(struct dsi_data *dsi, int vc, int channel)
-{
-	const u8 payload[] = { MIPI_DCS_NOP };
-	const struct mipi_dsi_msg msg = {
-		.channel = channel,
-		.type = MIPI_DSI_DCS_SHORT_WRITE,
-		.tx_len = 1,
-		.tx_buf = payload,
-	};
-
-	WARN_ON(!dsi_bus_is_locked(dsi));
-
-	return _omap_dsi_host_transfer(dsi, vc, &msg);
-}
-
 static int dsi_update_channel(struct omap_dss_device *dssdev, int vc)
 {
 	struct dsi_data *dsi = to_dsi_data(dssdev);
@@ -3263,13 +3262,13 @@ static int dsi_update_channel(struct omap_dss_device *dssdev, int vc)
 	DSSDBG("dsi_update_channel: %d", vc);
 
 	/*
-	 * Send NOP between the frames. If we don't send something here, the
+	 * Transition to LP here. If we don't send something here, the
 	 * updates stop working. This is probably related to DSI spec stating
 	 * that the DSI host should transition to LP at least once per frame.
 	 */
-	r = _dsi_send_nop(dsi, VC_CMD, dsi->dsidev->channel);
+	r = dsi_vc_send_bta_sync(dssdev, VC_CMD);
 	if (r < 0) {
-		DSSWARN("failed to send nop between frames: %d\n", r);
+		DSSWARN("failed to send bta sync between frames: %d\n", r);
 		goto err;
 	}
 
-- 
2.53.0



