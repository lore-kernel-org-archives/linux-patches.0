Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65412D20E;
	Tue, 14 May 2024 10:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683954; cv=none; b=brTPXM4vczf8PZhP3XOUrveBZX9tzVGwSjUIMYC7m2eH0WXMU6TGsUmiLdpKL0j7emW8OUAnNwSj2zn36eUhP2x2ezrUxHi8jOUHFrPdUvInifRs7FdikOO+lov9g2LV5kN9jyplstrwTNLg55Y4ODAgd8g4nW1rMJGbMkPWLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683954; c=relaxed/simple;
	bh=ZcuYPJoLXSnuy/YSfTsNQms+qcpYatv/tO4GYXLfPpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBuBIfXGEWL06IGQc0dtyko5nDFQ9tOOx+NBx7xMvVnq61iNwiKb70nZWnfYAA/J1bsMc3fx34unnA7lfK4z/VeN4sI/BALF7pbMY0U3gu5P2pAw785/Ylj0bpprxkLOMsAXGrF2MgEjWxd60ZYBkWKHDgD4kEfMdwNnukcw8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3+JwbMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3+JwbMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744D4C2BD10;
	Tue, 14 May 2024 10:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683954;
	bh=ZcuYPJoLXSnuy/YSfTsNQms+qcpYatv/tO4GYXLfPpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3+JwbMkslyOizHFMpYxzTVksap6ZKdTo8SAsAhAhjpGqJcPnwzJLINHp3YvQfHJq
	 kMA7okzYjw3y/4tJH2styGyOps8XsFMO2qcFvunjq/a9A1z/ZGxP8X4NSTR7QNKlK1
	 /mb3+S9SSzNeQGX2xFsYKuSHM3aMacmHzi57TsC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.8 300/336] drm/amd/display: Fix idle optimization checks for multi-display and dual eDP
Date: Tue, 14 May 2024 12:18:24 +0200
Message-ID: <20240514101049.944481109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit b436f1cbed9c59d89ce63bd3b81b0e603c29d466 upstream.

[Why]
Idle optimizations are blocked if there's more than one eDP connector
on the board - blocking S0i3 and IPS2 for static screen.

[How]
Fix the checks to correctly detect number of active eDP.
Also restrict the eDP support to panels that have correct feature
support.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c |   33 +++++++++++++---
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -638,22 +638,43 @@ void dcn35_power_down_on_boot(struct dc
 
 bool dcn35_apply_idle_power_optimizations(struct dc *dc, bool enable)
 {
-	struct dc_link *edp_links[MAX_NUM_EDP];
-	int i, edp_num;
 	if (dc->debug.dmcub_emulation)
 		return true;
 
 	if (enable) {
-		dc_get_edp_links(dc, edp_links, &edp_num);
-		if (edp_num == 0 || edp_num > 1)
-			return false;
+		uint32_t num_active_edp = 0;
+		int i;
 
 		for (i = 0; i < dc->current_state->stream_count; ++i) {
 			struct dc_stream_state *stream = dc->current_state->streams[i];
+			struct dc_link *link = stream->link;
+			bool is_psr = link && !link->panel_config.psr.disable_psr &&
+				      (link->psr_settings.psr_version == DC_PSR_VERSION_1 ||
+				       link->psr_settings.psr_version == DC_PSR_VERSION_SU_1);
+			bool is_replay = link && link->replay_settings.replay_feature_enabled;
+
+			/* Ignore streams that disabled. */
+			if (stream->dpms_off)
+				continue;
 
-			if (!stream->dpms_off && !dc_is_embedded_signal(stream->signal))
+			/* Active external displays block idle optimizations. */
+			if (!dc_is_embedded_signal(stream->signal))
 				return false;
+
+			/* If not PWRSEQ0 can't enter idle optimizations */
+			if (link && link->link_index != 0)
+				return false;
+
+			/* Check for panel power features required for idle optimizations. */
+			if (!is_psr && !is_replay)
+				return false;
+
+			num_active_edp += 1;
 		}
+
+		/* If more than one active eDP then disallow. */
+		if (num_active_edp > 1)
+			return false;
 	}
 
 	// TODO: review other cases when idle optimization is allowed


