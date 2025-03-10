Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676B41DE89C;
	Mon, 10 Mar 2025 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627335; cv=none; b=s4Za4SitX88yTB9qblAuLOPl7w3zpG/2osWacXashxMQnrQF9bgZZzTNv/zH4lLcbDwDp1NDsf6sN1ziTZdta49Jj2eG30AnZwgqkbXpQwvO7fXx4C+65GY9+6x/NNAvnZOrYqrJ3cAH7RAV9Ktu+thjxvojmU702wAMEie4G7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627335; c=relaxed/simple;
	bh=ClV549Nszec9h69sFuBD50MwU8aHiF3quEEm42DMIIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbWLHYB/bV1cmjFk1rAkcCr1Ojo+s054sAzIywdvGMspPXc9cijaOQ9lMqPrfL4TquV/nAz2mVoJuTX11WSL2B/Lh386QEbVLKlWU5ua25hNepFgGibqftmDPsja3CeJ6i1c+Fx70SbjE8Ykzpz9CM+vyo6+v153jNAROxhn6XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0VipMfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0VipMfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6BC4CEE5;
	Mon, 10 Mar 2025 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627335;
	bh=ClV549Nszec9h69sFuBD50MwU8aHiF3quEEm42DMIIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0VipMflu8YqN7OIILYFwMfPNKy/Ii+Kq9/fRScxoDfMYdZOXv3jIA7VIUxABlYDD
	 wcZzdO2flFcNTHe8elFo1A2UUcY1Gffs1IFGnb6eKSi2gy28H6b6nWuu6thAyP+ndU
	 yex0SaQr/th2Vyu2VOdaqXrl/D0v/MYhjLP1mCk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 095/269] drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params
Date: Mon, 10 Mar 2025 18:04:08 +0100
Message-ID: <20250310170501.495872700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 374c9faac5a763a05bc3f68ad9f73dab3c6aec90 upstream.

Null pointer dereference issue could occur when pipe_ctx->plane_state
is null. The fix adds a check to ensure 'pipe_ctx->plane_state' is not
null before accessing. This prevents a null pointer dereference.

Found by code review.

Fixes: 3be5262e353b ("drm/amd/display: Rename more dc_surface stuff to plane_state")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63e6a77ccf239337baa9b1e7787cde9fa0462092)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1455,7 +1455,8 @@ bool resource_build_scaling_params(struc
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
 
 	/* Invalid input */
-	if (!plane_state->dst_rect.width ||
+	if (!plane_state ||
+			!plane_state->dst_rect.width ||
 			!plane_state->dst_rect.height ||
 			!plane_state->src_rect.width ||
 			!plane_state->src_rect.height) {


