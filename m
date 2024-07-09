Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD4C155389;
	Tue,  9 Jul 2024 11:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523614; cv=none; b=jUAgau8TQ4pDroP9QcMt0PVAJUWYvJ7TRYJ+PSbKwaW4sMqXXvEVsaDvSUVLebFvc+8loMLDIDALC6Ca1RsBfdYFLZGksEiIVqMLxJ7pZi7uvSeH10G7WqT92mL0doJ/cOBjJSeOBa7URB0LvoifddkuVkZbNkbyhsHEaliBeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523614; c=relaxed/simple;
	bh=++IHXKe4ROUe0qVMEgHI4ef78U9HcphMF055PYomkjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/fhKBCozKWG4rPzZqEzpjHrxwZnNs6o1mXNuoQTYyqQZNlzcYcqIly82XTB2w+rBVRnrpipjFp24giNNjeB+8iPP8BzEs/mR0w8Wu/beTSgh+Ssb6lxNebSDFowrJa2Vm9g4XQJP2Wy6RZ3bVtnLHxHMAVyCUezXKTjb3jkfVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raholALk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raholALk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854C2C3277B;
	Tue,  9 Jul 2024 11:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523613;
	bh=++IHXKe4ROUe0qVMEgHI4ef78U9HcphMF055PYomkjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raholALkBKCq7jhszwAPdconLRWhFM+B5ODgt2/ToxPORiTJvaMy1xovGZ/lzG/Wh
	 zc9RhZmso6xkKsx/pmiXHXmsvV3dCLUkDbwJPZkLW23ei2LJiHyuu4Y38vo6Ncp4Ez
	 qwT+Hq4gdViLrzCinRiwjBtW2orXeHJazBcRVyWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/139] drm/amd/display: Check pipe offset before setting vblank
Date: Tue,  9 Jul 2024 13:08:41 +0200
Message-ID: <20240709110658.983353719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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
index 44649db5f3e32..5646b7788f02e 100644
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



