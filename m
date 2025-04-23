Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637DC28C5A4;
	Wed, 23 Apr 2025 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421348; cv=none; b=F/03Zr/3CvwMbsr3t/Bt8NGPN7lXVFFCkPT8mhrzrtivods0AJ/DmzECmzwq7N+N1hbTb9ZWwIj4/r5FO28d2M7W0FWllnag96P7czv3COT35IfDxnGhd+m4kZWGAF+NMhEctClmOT0hbhtGki/n/SyJ31mvapNWmPXsxIf7bhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421348; c=relaxed/simple;
	bh=EA38VdJovGL3ILlTgZ2ukOUzrMxgNLi3hJCeoGVGxzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBwbjsyeSM1qNNLFiSXc6Yy0zFjwvKYKvp+6qQ/c3HbkQE/3lZk2PBFbDNW1dhD0N/aLn16DHnB5jSc7p+GfKgbjG1PrkeQ+LZ6kMMgv7ueh9uljKxEnuy4j6SvB3fx+XqnFrek5mJpw69758ErcGwOCj7Ffn31J5kR+Tfix4k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUydXMqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUydXMqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA916C4CEE2;
	Wed, 23 Apr 2025 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421348;
	bh=EA38VdJovGL3ILlTgZ2ukOUzrMxgNLi3hJCeoGVGxzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUydXMqJzrsS4CXxkzln3ReNYM79qICD4MfVjDs6PfjpRm0zExZDBkXFk6vtiHhTi
	 7lK+0rhP5rpP5jU+iHjcYr0MrIR/LErbVnZPg0X3EKBRUue9ytCCCDZuRcY6Vbsepq
	 0OCIIbqeZ+oo5kwS1F/1qNZlKm6UdsW7RsZ7jMNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Brendan Tam <Brendan.Tam@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 177/241] drm/amd/display: prevent hang on link training fail
Date: Wed, 23 Apr 2025 16:44:01 +0200
Message-ID: <20250423142627.757707726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Tam <Brendan.Tam@amd.com>

commit 8058061ed9d6bc259d1e678607b07d259342c08f upstream.

[Why]
When link training fails, the phy clock will be disabled. However, in
enable_streams, it is assumed that link training succeeded and the
mux selects the phy clock, causing a hang when a register write is made.

[How]
When enable_stream is hit, check if link training failed. If it did, fall
back to the ref clock to avoid a hang and keep the system in a recoverable
state.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Brendan Tam <Brendan.Tam@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |    6 +++++-
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |    7 +++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3027,7 +3027,11 @@ void dcn20_enable_stream(struct pipe_ctx
 		dccg->funcs->set_dpstreamclk(dccg, DTBCLK0, tg->inst, dp_hpo_inst);
 
 		phyd32clk = get_phyd32clk_src(link);
-		dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		if (link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN) {
+			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
+		} else {
+			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		}
 	} else {
 		if (dccg->funcs->enable_symclk_se)
 			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -936,8 +936,11 @@ void dcn401_enable_stream(struct pipe_ct
 	if (dc_is_dp_signal(pipe_ctx->stream->signal) || dc_is_virtual_signal(pipe_ctx->stream->signal)) {
 		if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
 			dccg->funcs->set_dpstreamclk(dccg, DPREFCLK, tg->inst, dp_hpo_inst);
-
-			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+			if (link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN) {
+				dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
+			} else {
+				dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+			}
 		} else {
 			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
 					link_enc->transmitter - TRANSMITTER_UNIPHY_A);


