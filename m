Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5B9183CD4;
	Mon, 12 Aug 2024 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480178; cv=none; b=p5qh33JfOIRWfc6LCAn05t/UBYO3l7b5SH8iaarotJ1CvHTKalt0M4F5yzj4gRGhkmRV05QtlsET+ofDcavvv0S901V9Rqn9tbOremWDkmxbwCtnP9hQLzc2ughhtIg/WtRDALq5xKY1d4mIXOerUPy6BAIuNd8y7UiKQcFmvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480178; c=relaxed/simple;
	bh=iaaWBB4grooMxrMw4XvMEi8QlpD+6Zy5ihy3bGyDbNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuFt4PZ2K8SKwRkN2HB+7Mh/ml+clB6Bi8gRoN3uGNygycSB0GwYcLyYX1gVI6W2q1q7jGxmS8DhcJ6HRhLoEsZchJ2FUR7bSrfCtvWBk7Dy+N3GTv8JYaFZWSwge4/ypd0vatKcgp9boX1b1kZO1m1fimZ62tjlGAACNh6sEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZApFCUCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZApFCUCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80395C32782;
	Mon, 12 Aug 2024 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480178;
	bh=iaaWBB4grooMxrMw4XvMEi8QlpD+6Zy5ihy3bGyDbNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZApFCUCkOd0Y+ati9X4Dg3Cf9rb1befL+lweOvv5wlqYVpn8Z5lfhlrHMvELL4Ig7
	 9bF6h7elQUYr2d+bx7W1SDj00YTH5IZ6T+ZyQNwNAvXrdoQ7KIW9AL15kzH5KBpst5
	 GofwP5ueGqyXXTqDkp9sxLTJsYObrY8s4PoQ7b+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Chen <robin.chen@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sung-huai Wang <danny.wang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/263] drm/amd/display: Handle HPD_IRQ for internal link
Date: Mon, 12 Aug 2024 18:01:28 +0200
Message-ID: <20240812160149.876107459@linuxfoundation.org>
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

[ Upstream commit 239b31bd5c3fef3698440bf6436b2068c6bb08a3 ]

[Why]
TCON data is corrupted after electro static discharge test.
Once the TCON data get corrupted, they will get themselves
reset and send HPD_IRQ to source side.

[How]
Support HPD_IRQ for internal link, and restore the PSR/Replay setup.

Reviewed-by: Robin Chen <robin.chen@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sung-huai Wang <danny.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/link/protocols/link_dp_irq_handler.c   | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
index 0fcf0b8530acf..659b8064d3618 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
@@ -373,6 +373,7 @@ bool dp_handle_hpd_rx_irq(struct dc_link *link,
 	union device_service_irq device_service_clear = {0};
 	enum dc_status result;
 	bool status = false;
+	bool allow_active = false;
 
 	if (out_link_loss)
 		*out_link_loss = false;
@@ -427,12 +428,6 @@ bool dp_handle_hpd_rx_irq(struct dc_link *link,
 		return false;
 	}
 
-	if (handle_hpd_irq_psr_sink(link))
-		/* PSR-related error was detected and handled */
-		return true;
-
-	handle_hpd_irq_replay_sink(link);
-
 	/* If PSR-related error handled, Main link may be off,
 	 * so do not handle as a normal sink status change interrupt.
 	 */
@@ -454,9 +449,8 @@ bool dp_handle_hpd_rx_irq(struct dc_link *link,
 	 * If we got sink count changed it means
 	 * Downstream port status changed,
 	 * then DM should call DC to do the detection.
-	 * NOTE: Do not handle link loss on eDP since it is internal link*/
-	if ((link->connector_signal != SIGNAL_TYPE_EDP) &&
-			dp_parse_link_loss_status(
+	 */
+	if (dp_parse_link_loss_status(
 					link,
 					&hpd_irq_dpcd_data)) {
 		/* Connectivity log: link loss */
@@ -465,6 +459,11 @@ bool dp_handle_hpd_rx_irq(struct dc_link *link,
 					sizeof(hpd_irq_dpcd_data),
 					"Status: ");
 
+		if (link->psr_settings.psr_feature_enabled)
+			edp_set_psr_allow_active(link, &allow_active, true, false, NULL);
+		else if (link->replay_settings.replay_allow_active)
+			edp_set_replay_allow_active(link, &allow_active, true, false, NULL);
+
 		if (defer_handling && has_left_work)
 			*has_left_work = true;
 		else
@@ -477,6 +476,14 @@ bool dp_handle_hpd_rx_irq(struct dc_link *link,
 		dp_trace_link_loss_increment(link);
 	}
 
+	if (*out_link_loss == false) {
+		if (handle_hpd_irq_psr_sink(link))
+			/* PSR-related error was detected and handled */
+			return true;
+
+		handle_hpd_irq_replay_sink(link);
+	}
+
 	if (link->type == dc_connection_sst_branch &&
 		hpd_irq_dpcd_data.bytes.sink_cnt.bits.SINK_COUNT
 			!= link->dpcd_sink_count)
-- 
2.43.0



