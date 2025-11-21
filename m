Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021A22FF173;
	Fri, 21 Nov 2025 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732768; cv=none; b=IDWKREjPpAyvqotWxMy1KUolYrx8O/qeXIKQs0TiTgsdMDiIuN+a4Zm7+d+tOOCwTnYsTC+va23W6l5V8Ty4Y48Pi1EWkmmulyzl2JAtmUtPVgE5TdqqCbcYax7kj2b67oTxbMkDU7bql6xPuUU/yOqeSHJ55DLyBHeDX6pA09s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732768; c=relaxed/simple;
	bh=/7couot9xJevDkx5M3hmrmNGgT3w8zkEPOf9uj4vn5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqeL+EWjRdEg/IfvHZ4tGfQLwoX1PsunCsN/nWKd1zdRYz8kj+PWWUiLyZcdNtCC+8wszzokS+AeMca1g0E9nrw45641HKgqvYeQiLnHJpDxrgl3Pq0sciksUgXZdHh0+RJTwIQEj9AmadmTmm/nOEFSPGmBg682teMiWGBPFWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjnmfHx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjnmfHx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F060C4CEF1;
	Fri, 21 Nov 2025 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732767;
	bh=/7couot9xJevDkx5M3hmrmNGgT3w8zkEPOf9uj4vn5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjnmfHx1wGRXYpSeT4jwmp6Ct8G/5DjuvYs9CfLEB4B+tPOwlt0/VXq+i+OrM/7BH
	 1Y1CbS7FjkowhuWGuqbMm4/hEmFyhIvIuvzTpVkDKz+D+taKVkO+FDBicS9QVE5Cdd
	 /LaRHuIR9ElDAX2vvNLK10mvxUndZ9IOOZPatUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/529] drm/amd/display: Fix DVI-D/HDMI adapters
Date: Fri, 21 Nov 2025 14:08:54 +0100
Message-ID: <20251121130239.380339712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 489f0f600ce2c0dae640df9035e1d82677d2580f ]

When the EDID has the HDMI bit, we should simply select
the HDMI signal type even on DVI ports.

For reference see, the legacy amdgpu display code:
amdgpu_atombios_encoder_get_encoder_mode
which selects ATOM_ENCODER_MODE_HDMI for the same case.

This commit fixes DVI connectors to work with DVI-D/HDMI
adapters so that they can now produce output over these
connectors for HDMI monitors with higher bandwidth modes.
With this change, even HDMI audio works through DVI.

For testing, I used a CAA-DMDHFD3 DVI-D/HDMI adapter
with the following GPUs:

Tahiti (DCE 6) - DC can now output 4K 30 Hz over DVI
Polaris 10 (DCE 11.2) - DC can now output 4K 60 Hz over DVI

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_detection.c b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
index c7a9e286a5d4d..978e09284da0e 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1113,6 +1113,10 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 		if (sink->sink_signal == SIGNAL_TYPE_HDMI_TYPE_A &&
 		    !sink->edid_caps.edid_hdmi)
 			sink->sink_signal = SIGNAL_TYPE_DVI_SINGLE_LINK;
+		else if (dc_is_dvi_signal(sink->sink_signal) &&
+			 aud_support->hdmi_audio_native &&
+			 sink->edid_caps.edid_hdmi)
+			sink->sink_signal = SIGNAL_TYPE_HDMI_TYPE_A;
 
 		if (link->local_sink && dc_is_dp_signal(sink_caps.signal))
 			dp_trace_init(link);
-- 
2.51.0



