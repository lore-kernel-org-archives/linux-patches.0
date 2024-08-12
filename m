Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D4E1494B8;
	Mon, 12 Aug 2024 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480686; cv=none; b=b529K+ZfoUOXU8T3N6p99tKySAhI+sXP85SkXXFo6vdlxc08MKAMb38Jgz3BjhrlPwqNBn0EG0ZlP2aCYXbdP1sFZPj1miOo30buTtAyiXtTt7xNXcBOWurQFfMpK7ojOJEztpqBCC7p4zKuvXDp8ilW4ID2vW4vbEMVjcWxyyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480686; c=relaxed/simple;
	bh=eFPnaNBAw8DBfOWTcIWnLcXdYfZG2z5uAcQIYB19hn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxACzdkEpXvy1Oh9Gi8xiW+OwqGPjPASVJc6+Db9neLPcmFpl8wItgXQSIjChVCeNAz4pKe5j/IYHmiNgn+L78xphxFvSxKA9hw2dafAW/UpnE+d5qpot7rIfb46PfwB3QIYDSoPewoU/cnfqB6fVVT+24pJR4VKtqsk6BafKTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0/hxaeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0/hxaeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF17C32782;
	Mon, 12 Aug 2024 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480686;
	bh=eFPnaNBAw8DBfOWTcIWnLcXdYfZG2z5uAcQIYB19hn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0/hxaeHuGjGLEi3jYqLMDTtuTFidQ2t/gl+BoYJRl4fp5XkXQmUItMc43nTD8Jrz
	 M1yt4O9jkhDg/+u0W52csTFgvojfhJB9FMAOPY7WiDaiXUGl4AsSlGT9ub6xMqcigN
	 5VzEsBMuXFgAf8G6Efd3j95hic9/B6FCKXMdYIHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Sung-huai Wang <danny.wang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 251/263] Revert "drm/amd/display: Handle HPD_IRQ for internal link"
Date: Mon, 12 Aug 2024 18:04:12 +0200
Message-ID: <20240812160156.152361806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung-huai Wang <danny.wang@amd.com>

commit a2919b25778b7479e477cf49af8c680017eafc24 upstream.

[How&Why]
This reverts commit 239b31bd5c3fef3698440bf6436b2068c6bb08a3.

Due to the it effects Replay resync.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Sung-huai Wang <danny.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c |   24 +++-------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
@@ -373,7 +373,6 @@ bool dp_handle_hpd_rx_irq(struct dc_link
 	union device_service_irq device_service_clear = {0};
 	enum dc_status result;
 	bool status = false;
-	bool allow_active = false;
 
 	if (out_link_loss)
 		*out_link_loss = false;
@@ -428,6 +427,12 @@ bool dp_handle_hpd_rx_irq(struct dc_link
 		return false;
 	}
 
+	if (handle_hpd_irq_psr_sink(link))
+		/* PSR-related error was detected and handled */
+		return true;
+
+	handle_hpd_irq_replay_sink(link);
+
 	/* If PSR-related error handled, Main link may be off,
 	 * so do not handle as a normal sink status change interrupt.
 	 */
@@ -449,8 +454,10 @@ bool dp_handle_hpd_rx_irq(struct dc_link
 	 * If we got sink count changed it means
 	 * Downstream port status changed,
 	 * then DM should call DC to do the detection.
+	 * NOTE: Do not handle link loss on eDP since it is internal link
 	 */
-	if (dp_parse_link_loss_status(
+	if ((link->connector_signal != SIGNAL_TYPE_EDP) &&
+			dp_parse_link_loss_status(
 					link,
 					&hpd_irq_dpcd_data)) {
 		/* Connectivity log: link loss */
@@ -459,11 +466,6 @@ bool dp_handle_hpd_rx_irq(struct dc_link
 					sizeof(hpd_irq_dpcd_data),
 					"Status: ");
 
-		if (link->psr_settings.psr_feature_enabled)
-			edp_set_psr_allow_active(link, &allow_active, true, false, NULL);
-		else if (link->replay_settings.replay_allow_active)
-			edp_set_replay_allow_active(link, &allow_active, true, false, NULL);
-
 		if (defer_handling && has_left_work)
 			*has_left_work = true;
 		else
@@ -476,14 +478,6 @@ bool dp_handle_hpd_rx_irq(struct dc_link
 		dp_trace_link_loss_increment(link);
 	}
 
-	if (*out_link_loss == false) {
-		if (handle_hpd_irq_psr_sink(link))
-			/* PSR-related error was detected and handled */
-			return true;
-
-		handle_hpd_irq_replay_sink(link);
-	}
-
 	if (link->type == dc_connection_sst_branch &&
 		hpd_irq_dpcd_data.bytes.sink_cnt.bits.SINK_COUNT
 			!= link->dpcd_sink_count)


