Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ACF78685;
	Mon, 15 Apr 2024 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191519; cv=none; b=uZAVq5mKbgO/UOGtTtIZLJaapWOto8k+lpPxZPtPouuA0v3vSMampw4znsMnVf5SYRk1hhxGvl5GPWpgafEVHK+oxHGoSwB7PB1sK0Ki6xPvyqgHQgJaYOpFaVjrsl7lWOFyJUxWBck/xPZ9g9Oeb0ZF6TjExXVckoxYj7itie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191519; c=relaxed/simple;
	bh=Ch1xreVw8RoPkgHjgRd6v46CEj/eVwgpitVyXJxfPus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmfp6XJ9auXEoIPdMQ/pO8rD96iMYyUZIWqTgVYllm0lmH7gFMEnpJlePQ95GhBChp2MmRgHyMO+HagtXRNjyilikc4XZENvJi3K+81GaIypgU/JF9YsmgcYp7Gaj94NYyiFiqr3UpfANk01djtdW0JRAMVlZNYNH19sRIGxLbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxJHnF6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxJHnF6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C811C113CC;
	Mon, 15 Apr 2024 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191518;
	bh=Ch1xreVw8RoPkgHjgRd6v46CEj/eVwgpitVyXJxfPus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxJHnF6NDoHqPHIPQ/69iuiJlmThKriqlhNEaDx7zQUxDc/iuTnhUxDG63/oQwKSa
	 WIh1bLou3jzweS7eGXckJOZqRTpJXSZOkj3dOpKge/h5ZZMqbpnz8m75+Vu8HYBIyW
	 ptSMQ01OWGo9yyIoxDZu79rPnQ+7a+u7caurX3Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 168/172] drm/amd/display: Set VSC SDP Colorimetry same way for MST and SST
Date: Mon, 15 Apr 2024 16:21:07 +0200
Message-ID: <20240415142005.450293536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit c3e2a5f2da904a18661335e8be2b961738574998 upstream.

The previous check for the is_vsc_sdp_colorimetry_supported flag
for MST sink signals did nothing. Simplify the code and use the
same check for MST and SST.

Cc: stable@vger.kernel.org
Reviewed-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6264,15 +6264,9 @@ create_stream_for_sink(struct drm_connec
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
 		//
-		stream->use_vsc_sdp_for_colorimetry = false;
-		if (aconnector->dc_sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT_MST) {
-			stream->use_vsc_sdp_for_colorimetry =
-				aconnector->dc_sink->is_vsc_sdp_colorimetry_supported;
-		} else {
-			if (stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
-			    stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED)
-				stream->use_vsc_sdp_for_colorimetry = true;
-		}
+		stream->use_vsc_sdp_for_colorimetry = stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
+						      stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED;
+
 		if (stream->out_transfer_func->tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
 		mod_build_vsc_infopacket(stream, &stream->vsc_infopacket, stream->output_color_space, tf);


