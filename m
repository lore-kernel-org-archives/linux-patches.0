Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E902566DB;
	Thu, 17 Apr 2025 18:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914186; cv=none; b=QDKSXLcfBTUGUcsH6N0T4Yl6zYDp5gJBw/hvfiMLqzFuLSJeyn34767+QsKfmTl1fn5BC7afW+1w6mveTk2VAhs7MynE3Efl54QwGMrcp/W2bO3HO31fQm+5KUs1s4H5kIiaM0BhpDg3tDnGepcVT8XvPSBxMi8nDWN8jIPPE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914186; c=relaxed/simple;
	bh=qVtXPFk62+4OusNe6rPc1lZhvuk2Y5nmOIw2nTgEKAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmqa/I0hy0vGGwnD3PycNcDJ5sFNNnH0cJLQBO2P2+AVKYZ+Io2PR/3kESgnpNQ1Zwmg4lEafGybKksy7mPgyLivJQbaamSl7I9bHY+zRgxLftzqfmYW9sRdmdfxdYlGhoYybrFwh4waSTGmiCTdH5frIus12DEnNOugs4+sY0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv1K/Dbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv1K/Dbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89E1C4CEE4;
	Thu, 17 Apr 2025 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914186;
	bh=qVtXPFk62+4OusNe6rPc1lZhvuk2Y5nmOIw2nTgEKAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wv1K/DbdApBhcJetaaVz3l2A5Dg51PqCXhTrqTx5v2HcrsrYM0YL2niPIH2cmAycL
	 pB1aPwHk/l+eaIsvro6nzv3KF5cAw2jkiSI7WoYwuInQQMwQBkyZ/oQiXd4cjn2R2Q
	 Rf0apmEY+y+/IrS6FO+//I/el3y3dDdDG2Ze+toQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Brendan Tam <Brendan.Tam@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 134/414] drm/amd/display: add workaround flag to link to force FFE preset
Date: Thu, 17 Apr 2025 19:48:12 +0200
Message-ID: <20250417175116.821176180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Tam <Brendan.Tam@amd.com>

[ Upstream commit 51d1b338541dea83fec8e6f95d3e46fa469a73a8 ]

[Why]
There have been instances of some monitors being unable to link train on
their reported link speed using their selected FFE preset. If a different
FFE preset is found that has a higher rate of success during link training
this workaround can be used to force its FFE preset.

[How]
A new link workaround flag is made called force_dp_ffe_preset. The flag is
checked in override_training_settings and will set lt_settings->ffe_preset
which is null if the flag is not set. The flag is then set in
override_lane_settings.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Brendan Tam <Brendan.Tam@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                             | 2 ++
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 08c5a315b3a67..1e1633b7771c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1780,7 +1780,9 @@ struct dc_link {
 		bool dongle_mode_timing_override;
 		bool blank_stream_on_ocs_change;
 		bool read_dpcd204h_on_irq_hpd;
+		bool force_dp_ffe_preset;
 	} wa_flags;
+	union dc_dp_ffe_preset forced_dp_ffe_preset;
 	struct link_mst_stream_allocation_table mst_stream_alloc_table;
 
 	struct dc_link_status link_status;
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 754c895e1bfbd..09024a8bac128 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -736,6 +736,8 @@ void override_training_settings(
 		lt_settings->pre_emphasis = overrides->pre_emphasis;
 	if (overrides->post_cursor2 != NULL)
 		lt_settings->post_cursor2 = overrides->post_cursor2;
+	if (link->wa_flags.force_dp_ffe_preset && !dp_is_lttpr_present(link))
+		lt_settings->ffe_preset = &link->forced_dp_ffe_preset;
 	if (overrides->ffe_preset != NULL)
 		lt_settings->ffe_preset = overrides->ffe_preset;
 	/* Override HW lane settings with BIOS forced values if present */
-- 
2.39.5



