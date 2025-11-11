Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E71A248883;
	Tue, 11 Nov 2025 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823103; cv=none; b=HvnnI9u4sr1KP8YkB3iOtlSXY3/QW891NeVdH66dr4x2cin1Q5uFJn5fNRLVQbnJ0XrUM7c5trAKWFL1cX7ZXxrIfwQ3lzWj6bDTFwM8mjIBgo44OXcgib+dqWZk3TTf+Dw0OY8InFUv1jbcgZK8Yi3D1dc5j13sTLXbrrkR/9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823103; c=relaxed/simple;
	bh=oRvSjvpmyn4T/thTbwVirwTyJdTRY2Mr+97DUTcwEZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/B66UNcCHBlP6vav+L+qHE+AQvGQCsqwQN3Bbu/HHqwewbGrXo3gBtHz5l8JJYTzr28LwU7M4kiOaI9Xccq2A89WOBcyVd6rU6Mt/vQ+UzixYosw7PQdCxShF+leKC4iowXoEu/Je11N2QiFmnH4EOpIp2q47kSb5VKwr8cKYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSLDka8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSLDka8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1856C16AAE;
	Tue, 11 Nov 2025 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823103;
	bh=oRvSjvpmyn4T/thTbwVirwTyJdTRY2Mr+97DUTcwEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSLDka8uojxuM+akNvPCEyJHwXof+euHk+XrTA4rJUrjZEvkgjBS+M0BlCHNh1iJh
	 ua1Fc3Y3sZguaFUk6RCo+tLohvuj8SacNakptTgP9uZPw/Cijvfp3pbokW2tLzXlUR
	 zqANs+9Kc49JoCa4tokfeoVBfXpHnwxKqVp2jEFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/565] drm/amd/display: fix condition for setting timing_adjust_pending
Date: Tue, 11 Nov 2025 09:40:28 +0900
Message-ID: <20251111004530.806337506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 1a6a3374ecb9899ccf0d209b5783a796bdba8cec ]

timing_adjust_pending is used to defer certain programming sequences
when OTG timing is about to be changed, like with VRR. Insufficient
checking for timing change in this case caused a regression which
reduces PSR Replay residency.

Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 84e377113e580..13d5f0451fecf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -453,7 +453,9 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 	 * avoid conflicting with firmware updates.
 	 */
 	if (dc->ctx->dce_version > DCE_VERSION_MAX) {
-		if (dc->optimized_required || dc->wm_optimized_required) {
+		if ((dc->optimized_required || dc->wm_optimized_required) &&
+			(stream->adjust.v_total_max != adjust->v_total_max ||
+			stream->adjust.v_total_min != adjust->v_total_min)) {
 			stream->adjust.timing_adjust_pending = true;
 			return false;
 		}
-- 
2.51.0



