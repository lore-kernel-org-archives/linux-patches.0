Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25947E10B;
	Mon,  8 Apr 2024 13:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583428; cv=none; b=prxgtydCWZDuzCdKS9y4OUlpgghRMIFGOQMZGY5SqKDcHBUTCvHpoThLNOMYQP8zuK8LqNryB0yNfA+NSfTv9v9b3kgWeKQzbOX/h0JIIBj+CoWbEqZWEKod7AjLzozXnkH6f1AyxBs57swdmlHFNYN9TZeuLeiFG+dke6wxKaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583428; c=relaxed/simple;
	bh=RusXzZRj1W97bW8iBS4LVSovMvplDAy4q/AMvOB5F8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4jTeOHGJwcKro3PjKHKgD/7P6GHaoTv72Z9rR9vT9ZHjUct8PE4eGeyiah4LnVtz9gsOr17dUwZ0Rr6NICTx4OBhg9dImLQ1jwzaLl2pUCyE+ickH/hLyO9wfQYJNk9AV+POjQidUS9ylW6z0cVKFejZ1NXY5rOPJnBm84xOHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLFX+Yro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLFX+Yro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76428C433C7;
	Mon,  8 Apr 2024 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583427;
	bh=RusXzZRj1W97bW8iBS4LVSovMvplDAy4q/AMvOB5F8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLFX+Yro7ZfPDIC9BpFAuFzYYUqK0lEG1nBLrkc2RsT2guTOZQRTBQ8jeQOTC0wks
	 pwVFArkIEPqvqbnSNhhW8u9TB0fzpDfjczT5aNjl4NC+pgmwjuczOqQuROQO5nI+4w
	 iRF3Q09gIJ5F4Noul3BgXj9kP/tutjHYk5C0rVgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 178/273] drm/i915/dp: Fix DSC state HW readout for SST connectors
Date: Mon,  8 Apr 2024 14:57:33 +0200
Message-ID: <20240408125314.800748712@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit d725ce9d7c78fb4e22c6c7676106e135ade14fa8 ]

Commit 0848814aa296 ("drm/i915/dp: Fix connector DSC HW state readout")
moved the DSC HW state readout to a connector specific hook, however
only added the hook for DP MST connectors, not for DP SST ones. Fix
adding the hook for SST connectors as well.

This fixes the following warn on platforms where BIOS enables DSC:

[   66.208601] i915 0000:00:02.0: drm_WARN_ON(!connector->dp.dsc_decompression_aux || !connector->dp.dsc_decompression_enabled)
...
[   66.209024] RIP: 0010:intel_dp_sink_disable_decompression+0x76/0x110 [i915]
...
[   66.209333]  ? intel_dp_sink_disable_decompression+0x76/0x110 [i915]
...
[   66.210068]  intel_disable_ddi+0x135/0x1d0 [i915]
[   66.210302]  intel_encoders_disable+0x9b/0xc0 [i915]
[   66.210565]  hsw_crtc_disable+0x153/0x170 [i915]
[   66.210823]  intel_old_crtc_state_disables+0x52/0xb0 [i915]
[   66.211107]  intel_atomic_commit_tail+0x5cf/0x1330 [i915]
[   66.211366]  intel_atomic_commit+0x39d/0x3f0 [i915]
[   66.211612]  ? intel_atomic_commit+0x39d/0x3f0 [i915]
[   66.211872]  drm_atomic_commit+0x9d/0xd0 [drm]
[   66.211921]  ? __pfx___drm_printfn_info+0x10/0x10 [drm]
[   66.211975]  intel_initial_commit+0x1a8/0x260 [i915]
[   66.212234]  intel_display_driver_probe+0x2a/0x80 [i915]
[   66.212479]  i915_driver_probe+0x7c6/0xc60 [i915]
[   66.212664]  ? drm_privacy_screen_get+0x168/0x190 [drm]
[   66.212711]  i915_pci_probe+0xe2/0x1c0 [i915]

Fixes: 0848814aa296 ("drm/i915/dp: Fix connector DSC HW state readout")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10410
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240311145626.2454923-1-imre.deak@intel.com
(cherry picked from commit 7a51a2aa2384ea8bee76698ae586a2bea5b8ddb5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 94d2a15d8444a..820cc9d3cc0b3 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -6523,6 +6523,7 @@ intel_dp_init_connector(struct intel_digital_port *dig_port,
 		intel_connector->get_hw_state = intel_ddi_connector_get_hw_state;
 	else
 		intel_connector->get_hw_state = intel_connector_get_hw_state;
+	intel_connector->sync_state = intel_dp_connector_sync_state;
 
 	if (!intel_edp_init_connector(intel_dp, intel_connector)) {
 		intel_dp_aux_fini(intel_dp);
-- 
2.43.0



