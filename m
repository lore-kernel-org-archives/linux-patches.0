Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465E83ACA74;
	Mon, 17 Aug 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974726; cv=none; b=tGGTOA0w4fs5pTnxUjSdvED8hQynn9F8GT7BN/VyvnyXoX3GuFUfQPzy8jYdMd9mgivznW2OVaK06IwEikp5bgBCrjSQ7n8p+B2UE71DgF4PdXOgguJ1p+N/r3Jv60dwtaB51xkx0rpgPrbAI7TnJ2buftyiyMs1RQ0TkolE50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974726; c=relaxed/simple;
	bh=5ikyfm1wAbqsG7TbiFog9lhwss6WFORYccw274O5tio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEiSG72bJq2vm1p8NxdOIKd8iVCZ8ny0h8dZ3V1/BZ0aZM0gP68YyhkZUuKUBc4rjawLZdoQkBwECiig+iC9g4UwW0D4fog2sBPbYfuk4gnYVH036Nb9YV+oEgy1hSKVq1CKHOHo5D/RjKAJp89uJ4O5Jh+l0uj0QyjWuUyTnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ornbGwHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ornbGwHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AAD1F00A3E;
	Mon, 17 Aug 2026 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974718;
	bh=6eIX2Q58UbdCsY+9Bb28j2utdLY88SAPBTRpEWKYoBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ornbGwHRMUl54MTMNJMuNima5JgOZGYwdOYT8dNMy4GnaRugZPUvnHaiaGRZp6CgA
	 1ZX0JDGPNfkL0gCgxm+jCOSImXOXQLvQ8I5J8xqsZijJVqGcEIC7oS/lAkJWbgYrMo
	 /YRY6VF6JLaOezR0Tp/1p9p/SH0QPiWUT+8zwme0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Ray Wu <ray.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/250] drm/amd/display: Check for tg ops in dce110_set_avmute
Date: Mon, 17 Aug 2026 15:29:28 +0200
Message-ID: <20260817132536.761305488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Wu <ray.wu@amd.com>

[ Upstream commit 3141e3d61469bba2624a91c5e2407f110b33b29e ]

Some older DCE timing generators do not implement is_tg_enabled in
their ops table. Calling it unconditionally when waiting for AV mute
frames causes a NULL pointer dereference on Southern Islands dGPUs
when turning the display off over HDMI.

Check that tg and the required ops exist before waiting for frames.

Fixes: 414da24137ac ("drm/amd/display: Add AV mute wait frames to dce110_set_avmute")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5557
Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2686a0c0aaa07bec2e24131835cf27b5fd4935a5)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 13ae93b945a33..fe02dc4e97e4a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1277,7 +1277,10 @@ void dce110_set_avmute(struct pipe_ctx *pipe_ctx, bool enable)
 		 * process the mute state, especially after link re-establishment
 		 * with HDMI 2.0 scrambling enabled.
 		 */
-		if (enable && pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
+		if (enable && pipe_ctx->stream_res.tg &&
+		    pipe_ctx->stream_res.tg->funcs->is_tg_enabled &&
+		    pipe_ctx->stream_res.tg->funcs->wait_for_state &&
+		    pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
 			int i;
 
 			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
-- 
2.53.0



