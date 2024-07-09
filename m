Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBC515F308;
	Tue,  9 Jul 2024 11:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524058; cv=none; b=dFwlVSledsqfSjf+pmEmkLKGpisPY4ca9OyELetvz+x8maXzvuhGV29mM+ScbsZBEtrbpyf6RVv0Zh9XBE1py3Uaf/G5zxHGNybGkszeFAGWodQpl95hIehXxcTnMnsFcvu3iO3iA8hzWAGrD2bsQXem/doJs8JB5wwMSeU48O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524058; c=relaxed/simple;
	bh=Uep2HgvJpboR+/2n+FoWW1zXrHojJ/mHcjCLTCDIriw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfYb5aY0o/fpy3HQwcwAFx8ih1ODRsLUys4bIb67s7DvQOexnME0V0s3f6XEKxsTx4Ssi7T+0YRzaREL8oX2ouCfSsPmRD8HEMe7UxkTsUMKtbYJ2yIluEMUbebFrnEHHYsKBZ0QPbpbiLx3L68sZll7MO8KvanJKb8K8LaL7XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxZtIxTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxZtIxTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9176C32786;
	Tue,  9 Jul 2024 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524058;
	bh=Uep2HgvJpboR+/2n+FoWW1zXrHojJ/mHcjCLTCDIriw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxZtIxTmEJ8NqFR+TwLFak+spa4IEKyW21hMX8z59sIpzF0RXSOmc1jO++A1LCexr
	 ifFQW2Y/ZO99I43hxXOy4u82PexcRRuzKcsQNOfKv39lLRwBhHmtnKNDwu47+rV9OQ
	 kVBF7nyq4rMrsCksbkGBCAA6C8YQ7gCQGrhJH2zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 030/197] drm/amd/display: Check pipe offset before setting vblank
Date: Tue,  9 Jul 2024 13:08:04 +0200
Message-ID: <20240709110710.084038917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 5396a70e8cf462ec5ccf2dc8de103c79de9489e6 ]

pipe_ctx has a size of MAX_PIPES so checking its index before accessing
the array.

This fixes an OVERRUN issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/irq/dce110/irq_service_dce110.c    | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c b/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
index 1c0d89e675da5..bb576a9c5fdbd 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
@@ -211,8 +211,12 @@ bool dce110_vblank_set(struct irq_service *irq_service,
 						   info->ext_id);
 	uint8_t pipe_offset = dal_irq_src - IRQ_TYPE_VBLANK;
 
-	struct timing_generator *tg =
-			dc->current_state->res_ctx.pipe_ctx[pipe_offset].stream_res.tg;
+	struct timing_generator *tg;
+
+	if (pipe_offset >= MAX_PIPES)
+		return false;
+
+	tg = dc->current_state->res_ctx.pipe_ctx[pipe_offset].stream_res.tg;
 
 	if (enable) {
 		if (!tg || !tg->funcs->arm_vert_intr(tg, 2)) {
-- 
2.43.0



