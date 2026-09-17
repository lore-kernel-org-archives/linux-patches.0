Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480E74C10F0;
	Thu, 17 Sep 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660323; cv=none; b=KwP5RGZVDtvo0A5VKqO1WxbV8gl5uiFHWS4217wutM+3iJ9NXwEiMJqKE6MZsoT02wiyTEJvlU7UATQhqjkcn5CdVUMzfDdrttkQ/OVHgP0lAO8LaHsRrByZaS9+q7mYASAYGKpFi87u88j1XkbDcHy3IkaiWldl/qVNyGHOm3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660323; c=relaxed/simple;
	bh=WnLBSKu0NFOu+Msq5f+fg+daRxDAJxHQiydOjRxfHBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S92E0FiN6dKQ423qb8yyH8/8exhBv58Ax9hBV2gsoktfmegk0oIN+X3FOE5xvY0R5pcyT9G/oi7XmtqLMSCUG+Mg1X6WXOateaT5hrhN4q7wK79u9KOtkStLA2D+IL8FZtcwUVNg2D8jDbVosd2W+Kgva7EviGcRfgkmFwJCUbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elAOSgis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elAOSgis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1051F000FF;
	Thu, 17 Sep 2026 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660321;
	bh=PJIGoRPAk7kWvafmTihulapd8hp4erNYy7rIM34lWzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elAOSgiss3d5xjPKhAXEhugUxivY167x0TW0TBDxYbns1wv9ChXKWtj+SbZNwDOJG
	 uMOrYAWyCUnfSEsM4b4xenIINik4v5sqyOOubKXB0U3SNZjC8N4QQTwphg0XE6Xwup
	 9/EVEgzSRGveHepMWsE5MU/tV65Eb6tRQoNY3Ayo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 536/733] drm/amd/display: Rebuild InfoFrames on output color space changes
Date: Thu, 17 Sep 2026 16:14:04 +0100
Message-ID: <20260917151405.571642081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyajit Roy <sroy14@alum.utk.edu>

commit 8cfd9e22eb5c04b15b82985ff913944f84673d4f upstream.

resource_build_info_frame() derives colorimetry and RGB quantization from
stream->output_color_space. A Broadcast RGB-only atomic commit updates
that field and reprograms the output CSC, but none of the InfoFrame update
predicates include output_color_space. The sink can therefore retain the
previous AVI InfoFrame range while the source starts transmitting a
different pixel range.

Treat an output color space change as an InfoFrame change in update
classification and in both stream programming paths.

Hardware testing on an HDMI 2.1 television confirmed that its automatic
black-level selection follows Full to Limited and Limited to Full
transitions in SDR, HDR, and HDR with VRR active, without a modeset or
visible link blank.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d6faca79f5720893843e649e70aeb19147ee0578)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3122,6 +3122,7 @@ static struct surface_update_descriptor
 		}
 
 		if ((stream_update->hdr_static_metadata && !stream_update->stream->use_dynamic_meta) ||
+				stream_update->output_color_space ||
 				stream_update->vrr_infopacket ||
 				stream_update->vsc_infopacket ||
 				stream_update->vsp_infopacket ||
@@ -4090,6 +4091,7 @@ static void commit_planes_do_stream_upda
 				hwss_add_setup_periodic_interrupt(&seq_state, dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
+					stream_update->output_color_space ||
 					stream_update->vrr_infopacket ||
 					stream_update->vsc_infopacket ||
 					stream_update->vsp_infopacket ||
@@ -4272,6 +4274,7 @@ static void commit_planes_do_stream_upda
 				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
+					stream_update->output_color_space ||
 					stream_update->vrr_infopacket ||
 					stream_update->vsc_infopacket ||
 					stream_update->vsp_infopacket ||


