Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3DE4C612;
	Mon,  8 Jan 2024 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLZUGhUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E624FC433C8;
	Mon,  8 Jan 2024 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726929;
	bh=WYs1w8QhSEti1a8S2RAc773ZT+rtIM4cjHoloc2kZLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLZUGhUf5KvYU5b2qqZsg9elDU8E8vB6v/mwzZ4a9+Lh69v4L1wdkGnedS7wgZ47O
	 z0k/qOJqj7C7NTwaqIWQy4wkGxUJCfWUcFhNou6V5lSKHF3vUnjK1/ky5lxNforrf1
	 n5jVpRlVy7nS3G7FN+Iv168A/BNKUbVnLVoKzARI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Melissa Wen <mwen@igalia.com>,
	Simon Berz <simon@berz.me>,
	Xaver Hugl <xaver.hugl@kde.org>,
	Joshua Ashton <joshua@froggi.es>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 116/124] drm/amd/display: Fix sending VSC (+ colorimetry) packets for DP/eDP displays without PSR
Date: Mon,  8 Jan 2024 16:09:02 +0100
Message-ID: <20240108150608.312433313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Joshua Ashton <joshua@froggi.es>

commit 202260f64519e591b5cd99626e441b6559f571a3 upstream.

The check for sending the vsc infopacket to the display was gated behind
PSR (Panel Self Refresh) being enabled.

The vsc infopacket also contains the colorimetry (specifically the
container color gamut) information for the stream on modern DP.

PSR is typically only supported on mobile phone eDP displays, thus this
was not getting sent for typical desktop monitors or TV screens.

This functionality is needed for proper HDR10 functionality on DP as it
wants BT2020 RGB/YCbCr for the container color space.

Cc: stable@vger.kernel.org
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Xaver Hugl <xaver.hugl@gmail.com>
Cc: Melissa Wen <mwen@igalia.com>
Fixes: 15f9dfd545a1 ("drm/amd/display: Register Colorspace property for DP and HDMI")
Tested-by: Simon Berz <simon@berz.me>
Tested-by: Xaver Hugl <xaver.hugl@kde.org>
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    8 +++---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c |   13 ++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6139,8 +6139,9 @@ create_stream_for_sink(struct amdgpu_dm_
 
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
 		mod_build_hf_vsif_infopacket(stream, &stream->vsp_infopacket);
-
-	if (stream->link->psr_settings.psr_feature_enabled || stream->link->replay_settings.replay_feature_enabled) {
+	else if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT ||
+			 stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST ||
+			 stream->signal == SIGNAL_TYPE_EDP) {
 		//
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
@@ -6156,8 +6157,9 @@ create_stream_for_sink(struct amdgpu_dm_
 		if (stream->out_transfer_func->tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
 		mod_build_vsc_infopacket(stream, &stream->vsc_infopacket, stream->output_color_space, tf);
-		aconnector->psr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
 
+		if (stream->link->psr_settings.psr_feature_enabled)
+			aconnector->psr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
 	}
 finish:
 	dc_sink_release(sink);
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -147,12 +147,15 @@ void mod_build_vsc_infopacket(const stru
 	}
 
 	/* VSC packet set to 4 for PSR-SU, or 2 for PSR1 */
-	if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
-		vsc_packet_revision = vsc_packet_rev4;
-	else if (stream->link->replay_settings.config.replay_supported)
+	if (stream->link->psr_settings.psr_feature_enabled) {
+		if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
+			vsc_packet_revision = vsc_packet_rev4;
+		else if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_1)
+			vsc_packet_revision = vsc_packet_rev2;
+	}
+
+	if (stream->link->replay_settings.config.replay_supported)
 		vsc_packet_revision = vsc_packet_rev4;
-	else if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_1)
-		vsc_packet_revision = vsc_packet_rev2;
 
 	/* Update to revision 5 for extended colorimetry support */
 	if (stream->use_vsc_sdp_for_colorimetry)


