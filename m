Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252582222AF;
	Mon,  2 Jun 2025 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873755; cv=none; b=k5IL+HC3aNPVzWAEBd7rROzMOIXXCNIQJyjc5bKpJ3CkP42r11+0O50AMEMJCslzXcYXKvGJ9uPrqk6lrPEIASb9EZOwbuRkPuDI/omEjgcB2XD0OSkhYMKSZ/S1tRpZAjq4uyWm7byBMvtT6NgkpZrIzug5Om764LYVH211r4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873755; c=relaxed/simple;
	bh=6L+777jYcEcXxJ24JEk4HnBaSL1GC4JfM+aKmid5JrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBQmok0Vy5dm8IXU/RvaD3k8d3I+U98Pmui2azjm6QwL7ol6Ty77MDlsSbdbLsLa4Dd5Nw+qVc+npFV426vDNLTkqiiVaTAZUATopQpfaZDxy3cbqfvO92prRLvu/Zzaxd45rVpnBoKLjMsRuL3SCtBiAGEScolroj0fR9mhVFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx7lE4FJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx7lE4FJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9DEC4CEEB;
	Mon,  2 Jun 2025 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873755;
	bh=6L+777jYcEcXxJ24JEk4HnBaSL1GC4JfM+aKmid5JrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx7lE4FJ1Ssmn8AYeqFdBn3CbnAsFOxLNtY1oV815a7tRdwvtl9+cLedkK8WUpcDV
	 bG778IKxDNLszJLBzJhq7JSNkxoV3bA3madCFLPyozx/lmODGPJvpT1+lwoCbMDFrc
	 16DMvYLsip51ixZwluSVtvoY+mf5wG2Qkr5sJ+bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Harry VanZyllDeJong <hvanzyll@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/444] drm/amd/display: Add support for disconnected eDP streams
Date: Mon,  2 Jun 2025 15:44:34 +0200
Message-ID: <20250602134349.431723436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry VanZyllDeJong <hvanzyll@amd.com>

[ Upstream commit 6571bef25fe48c642f7a69ccf7c3198b317c136a ]

[Why]
eDP may not be connected to the GPU on driver start causing
fail enumeration.

[How]
Move the virtual signal type check before the eDP connector
signal check.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Harry VanZyllDeJong <hvanzyll@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 1e621eae9b7da..adf0ef8b70e4b 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -920,6 +920,9 @@ bool link_decide_link_settings(struct dc_stream_state *stream,
 		 * TODO: add MST specific link training routine
 		 */
 		decide_mst_link_settings(link, link_setting);
+	} else if (stream->signal == SIGNAL_TYPE_VIRTUAL) {
+		link_setting->lane_count = LANE_COUNT_FOUR;
+		link_setting->link_rate = LINK_RATE_HIGH3;
 	} else if (link->connector_signal == SIGNAL_TYPE_EDP) {
 		/* enable edp link optimization for DSC eDP case */
 		if (stream->timing.flags.DSC) {
-- 
2.39.5



