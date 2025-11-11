Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C652DEA9D;
	Tue, 11 Nov 2025 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824721; cv=none; b=TYuwrSFmeR+40SLT8kknNaTnScjOyVz//mNt3bJtZD5RCkLvWPHzVATOhFLTwYs5/7gp6xF2GhCQxR5Vyze3bGtyBHuabAp3EtS4V+cpFyl35BueV7h0W6SHbdmXbh8zv9sMwQleWw+gZQf3n0vXWMLEQPzKoVsLDjeTZ1P4/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824721; c=relaxed/simple;
	bh=SqV1mzG+8kHAUDm+SIcBF3aJJZnINQiMuypegPXdg+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WlflysRY6fu+VtJ+YRXuXe+cjGHv7d8jNz0VfQlKOQ/pTA7ZhJHhleTJiEeVKlWjezB8v5/dUNxb5ZrjF7zgfSQfZ0k8jXy2VzqPwdLmEiDLd8qTDkSBYZFpWZpZWoq47atjUUvS+yZ1N/l0+IyJIKmW8HfzzN7UJTCxaQDzx34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFtNpRH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFtNpRH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BED0C113D0;
	Tue, 11 Nov 2025 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824721;
	bh=SqV1mzG+8kHAUDm+SIcBF3aJJZnINQiMuypegPXdg+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFtNpRH9SY5xaeejok0WZNJzl4abTS9gpTE3wF6oVbEG/8ysRoVknwYhzSDCuRkqd
	 QCVx1S4JEF0prsooOCg5dEHNshXXEPSRJcNqHMjduKTbK3UlDloy0M2/nJrNbee05m
	 NvIFKcOvDqKyPriIC5UNPB6f5OMl6zT9QZYhls18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 557/849] drm/amd/display: Fix DVI-D/HDMI adapters
Date: Tue, 11 Nov 2025 09:42:07 +0900
Message-ID: <20251111004549.873830236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 827b630daf49a..18d0ef40f23fb 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1140,6 +1140,10 @@ static bool detect_link_and_local_sink(struct dc_link *link,
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



