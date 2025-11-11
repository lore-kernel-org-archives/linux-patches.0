Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED9E2DE707;
	Tue, 11 Nov 2025 01:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824700; cv=none; b=OGVSOg7qf1Urge402NzOnIr/AiI/yR+c9YxD+MvNq/FFbDoq+3YGbnzjY3LSGGaLzRnhoy4qNS/BwL9Satg7ji/3gvsMZVGvfvd6FDBVDGMduItmDcvhktIJRdpKsi5AX5ON6zblz9KsixGqiQVFRthyfGQZCJ8xSahph/ooP1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824700; c=relaxed/simple;
	bh=1veMqOIlF2DhuEpuLQsDYAoqufV84kmi2FBw4ExIPgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPwlppK3v94Y3wA3YWvcAWkM3TPYBeT9NLmhXAsMrkTK96mQIoBTrgNIJrtMWhOR206aqYOj/1yS6mVvP8GGkZLGarVr2iUKMDzgPP97mM1tNJEAvD//brOXCvJq8ONNvgv4LyG3qp5JJYwtZGtROkq6OZXSMN9JmlPTJeBvXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Od55mhKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Od55mhKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7D3C4AF0C;
	Tue, 11 Nov 2025 01:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824700;
	bh=1veMqOIlF2DhuEpuLQsDYAoqufV84kmi2FBw4ExIPgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Od55mhKtkO31F+xDNk/azvsV+g4oeg5KbBliLlIO3Vs84y3ERPutAwzLhoD86kux8
	 OZ+A23bOopCdODjGe9IB20M10ANq9uZftyZRoEzCEAXGtmjvjP5FOKCoUk4pR1fPy1
	 ZunAhaYHE4coBJ5luNUypY3UwOvA/Uruue6nXap4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Chen <leo.chen@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 553/849] drm/amd/display: fix dml ms order of operations
Date: Tue, 11 Nov 2025 09:42:03 +0900
Message-ID: <20251111004549.777561885@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 02a6c2e4b28ff31f7a904c196a99fb2efe81e2cf ]

[why&how]
small error in order of operations in immediateflipbytes
calculation on dml ms side that can result in dml ms
and mp mismatch immediateflip support for a given pipe
and thus an invalid hw state, correct the order to align
with mp.

Reviewed-by: Leo Chen <leo.chen@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 715f9019a33e2..4b9b2e84d3811 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6529,7 +6529,7 @@ static noinline_for_stack void dml_prefetch_check(struct display_mode_lib_st *mo
 				mode_lib->ms.TotImmediateFlipBytes = 0;
 				for (k = 0; k <= mode_lib->ms.num_active_planes - 1; k++) {
 					if (!(mode_lib->ms.policy.ImmediateFlipRequirement[k] == dml_immediate_flip_not_required)) {
-						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k];
+						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k]);
 						if (mode_lib->ms.use_one_row_for_frame_flip[j][k]) {
 							mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (2 * mode_lib->ms.DPTEBytesPerRow[j][k]);
 						} else {
-- 
2.51.0



