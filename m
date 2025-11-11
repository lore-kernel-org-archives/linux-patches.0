Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C82E6CA4;
	Tue, 11 Nov 2025 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824716; cv=none; b=PiCUKfb4Tr8m3KhCbeZrQDiH/6bUsNCN6RcLk9OpzExOXHznkHN3d5swA3Pq6n1YaeiSUcvWK8QFs7LC1ZAgdNG/V3d2WfCBHIpOJIPNRH9s+Fic+5ql7WKy7g/3G8NTxqut0qbAJs+nn8F12w7iYdP/shQv+9k0snpNXLCaeac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824716; c=relaxed/simple;
	bh=lFYj7BCdNcpTF6vdhxJ15qFR94lzEyBkP4lFmGVhCZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIcWSyC26yWgPgT/p2RyuPSFtcbzfNhlr63ZD+l8r22nB3AqgokSZy9o/70nywNjsK8HNkt0hV8uTQxEUTCNIibWOGGqZhm2DubeTchBb84sHPQgbIawchkvJ6I5CkZIZd/IT9I0YaUgLYULLKiMxMXZXoNKT82BAcjdRajbu2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnxTKh3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnxTKh3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A58C19421;
	Tue, 11 Nov 2025 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824716;
	bh=lFYj7BCdNcpTF6vdhxJ15qFR94lzEyBkP4lFmGVhCZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnxTKh3ZRhe5hjxLhH7rVQxA+l0hD5nE2+RRLp3U2JQ7WN7QtT7n0F1QIuek2q9Y9
	 UeeptUqT7FecyyexvnIqHw5+32DJ95TVtWsPZ2R47ZbrV4QjBn0Xilhz5VkQa5qI3c
	 4evbOeNfY1ppsL2XJ1gZzHe+vCIbqU6Eh6s7hKyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 556/849] drm/amd/display: Keep PLL0 running on DCE 6.0 and 6.4
Date: Tue, 11 Nov 2025 09:42:06 +0900
Message-ID: <20251111004549.849736948@linuxfoundation.org>
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

[ Upstream commit 0449726b58ea64ec96b95f95944f0a3650204059 ]

DC can turn off the display clock when no displays are connected
or when all displays are off, for reference see:
- dce*_validate_bandwidth

DC also assumes that the DP clock is always on and never powers
it down, for reference see:
- dce110_clock_source_power_down

In case of DCE 6.0 and 6.4, PLL0 is the clock source for both
the engine clock and DP clock, for reference see:
- radeon_atom_pick_pll
- atombios_crtc_set_disp_eng_pll

Therefore, PLL0 should be always kept running on DCE 6.0 and 6.4.
This commit achieves that by ensuring that by setting the display
clock to the corresponding value in low power state instead of
zero.

This fixes a page flip timeout on SI with DC which happens when
all connected displays are blanked.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/resource/dce60/dce60_resource.c    | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index f887d59da7c6f..33c1b9b24bb9c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -881,7 +881,16 @@ static enum dc_status dce60_validate_bandwidth(
 		context->bw_ctx.bw.dce.dispclk_khz = 681000;
 		context->bw_ctx.bw.dce.yclk_khz = 250000 * MEMORY_TYPE_MULTIPLIER_CZ;
 	} else {
-		context->bw_ctx.bw.dce.dispclk_khz = 0;
+		/* On DCE 6.0 and 6.4 the PLL0 is both the display engine clock and
+		 * the DP clock, and shouldn't be turned off. Just select the display
+		 * clock value from its low power mode.
+		 */
+		if (dc->ctx->dce_version == DCE_VERSION_6_0 ||
+			dc->ctx->dce_version == DCE_VERSION_6_4)
+			context->bw_ctx.bw.dce.dispclk_khz = 352000;
+		else
+			context->bw_ctx.bw.dce.dispclk_khz = 0;
+
 		context->bw_ctx.bw.dce.yclk_khz = 0;
 	}
 
-- 
2.51.0



