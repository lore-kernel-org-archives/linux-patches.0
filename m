Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53454149C57;
	Mon, 16 Sep 2024 12:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488681; cv=none; b=RcHGVpwjoBU1+7BNN/sf4jdtsXvxlIon7RKb4FSE9+zmQYBl0l9LK/6J73ocE5dnAoVN3x+xSz9GndShHPBGsrmBwEpRWCwcK6IRguDSiDauQr4E4+FaBl1axdFX4F46NzuWiLQwh3OBJTEoJ+ZNwXQm5b1kqATUsgFAkOOp/FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488681; c=relaxed/simple;
	bh=EzSNESjls5qXI9P2543yR3ID+r0Ak2Rlz1qRUBY2U30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgqM67IBuRipbnpaVkSlMKtQUS/LuTZPgoAmIc2Q221i46vQGUxc15BaRAnUd5ZbK1s+jAO0WNVp1+HF1mrJJn7dTxG1vDdFW9aFGRGfJ45JkXt0BH3ymsauKpqQr516+rHTKzNuWRNAZ85RzCaVBzMZUHdJbA/Hv0wtufFS0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMQYqPzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMQYqPzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A8C4CEC4;
	Mon, 16 Sep 2024 12:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488681;
	bh=EzSNESjls5qXI9P2543yR3ID+r0Ak2Rlz1qRUBY2U30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMQYqPzRWyEWQ2Vst8aQFwILnRb37ymYkur0f9DY9NADKbQt7byIIDDnnZ0S3Krqm
	 OEg5k4s3q5KlqtiqQn03acy1owk/EvMGjw5rPSjzSCrkN0DOJ/hmyyH8SL4+g51ihe
	 WE8MAT6LVed+bAQwzbVaWwlmMSnmRE/uBIdcP1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Cruise <cruise.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/91] drm/amd/display: Disable error correction if its not supported
Date: Mon, 16 Sep 2024 13:44:25 +0200
Message-ID: <20240916114226.122420820@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cruise <cruise.hung@amd.com>

[ Upstream commit a8ac994cf0693a1ce59410995594e56124a1c79f ]

[Why]
Error correction was enabled in a monitor which doesn't support.

[How]
Disable error correction if it's not supported

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Cruise <cruise.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a8baec4623ae ("drm/amd/display: Fix FEC_READY write on DP LT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/link/protocols/link_dp_phy.c   | 47 +++++++++----------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
index 0050e0a06cbc..f06f708ba5c8 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
@@ -143,32 +143,27 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, const struct link_resource
 
 	link_enc = link_enc_cfg_get_link_enc(link);
 	ASSERT(link_enc);
+	if (link_enc->funcs->fec_set_ready == NULL)
+		return DC_NOT_SUPPORTED;
 
-	if (!dp_should_enable_fec(link))
-		return status;
-
-	if (link_enc->funcs->fec_set_ready &&
-			link->dpcd_caps.fec_cap.bits.FEC_CAPABLE) {
-		if (ready) {
+	if (ready && dp_should_enable_fec(link)) {
+		if (link->fec_state == dc_link_fec_not_ready) {
 			fec_config = 1;
-			status = core_link_write_dpcd(link,
-					DP_FEC_CONFIGURATION,
-					&fec_config,
-					sizeof(fec_config));
+
+			status = core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
+					&fec_config, sizeof(fec_config));
+
 			if (status == DC_OK) {
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
-			} else {
-				link_enc->funcs->fec_set_ready(link_enc, false);
-				link->fec_state = dc_link_fec_not_ready;
-				dm_error("dpcd write failed to set fec_ready");
 			}
-		} else if (link->fec_state == dc_link_fec_ready) {
+		}
+	} else {
+		if (link->fec_state == dc_link_fec_ready) {
 			fec_config = 0;
-			status = core_link_write_dpcd(link,
-					DP_FEC_CONFIGURATION,
-					&fec_config,
-					sizeof(fec_config));
+			core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
+				&fec_config, sizeof(fec_config));
+
 			link_enc->funcs->fec_set_ready(link_enc, false);
 			link->fec_state = dc_link_fec_not_ready;
 		}
@@ -183,14 +178,12 @@ void dp_set_fec_enable(struct dc_link *link, bool enable)
 
 	link_enc = link_enc_cfg_get_link_enc(link);
 	ASSERT(link_enc);
-
-	if (!dp_should_enable_fec(link))
+	if (link_enc->funcs->fec_set_enable == NULL)
 		return;
 
-	if (link_enc->funcs->fec_set_enable &&
-			link->dpcd_caps.fec_cap.bits.FEC_CAPABLE) {
-		if (link->fec_state == dc_link_fec_ready && enable) {
-			/* Accord to DP spec, FEC enable sequence can first
+	if (enable && dp_should_enable_fec(link)) {
+		if (link->fec_state == dc_link_fec_ready) {
+			/* According to DP spec, FEC enable sequence can first
 			 * be transmitted anytime after 1000 LL codes have
 			 * been transmitted on the link after link training
 			 * completion. Using 1 lane RBR should have the maximum
@@ -200,7 +193,9 @@ void dp_set_fec_enable(struct dc_link *link, bool enable)
 			udelay(7);
 			link_enc->funcs->fec_set_enable(link_enc, true);
 			link->fec_state = dc_link_fec_enabled;
-		} else if (link->fec_state == dc_link_fec_enabled && !enable) {
+		}
+	} else {
+		if (link->fec_state == dc_link_fec_enabled) {
 			link_enc->funcs->fec_set_enable(link_enc, false);
 			link->fec_state = dc_link_fec_ready;
 		}
-- 
2.43.0



