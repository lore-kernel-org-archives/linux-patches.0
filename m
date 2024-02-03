Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96BC1CAA5;
	Sat,  3 Feb 2024 04:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933863; cv=none; b=NgnoVkfnf95K3jSlEMiEnGd+SoQiEePeKE0rhA87TRCbhdNs9weH4G05RCV1c9ZG4SpZgaEwAqMFtRRSq3zCQuKCsjWQeK7FOu12nrxeYmgqEWVHmwRtl+1X3h460CBnQk2pTyjRQgJxmgQ6ZN3dR2HiS5HA3AIIn4DbKESG7S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933863; c=relaxed/simple;
	bh=tkwHYwTZWUrLt/WOAQ+MUOaTP3BXaU6pkeigFoURRus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz0XUI59tijO9NZjf0Qblp/wynWh+86Ey+rBqiRUuaH+LJxIdiWPrxCT7aDW3ehJSd57sqXG+sFDBwsU1SCpDNzwi4/c/f1jyNYk8llNQMB0OqkT0p3XMEki/RDRnB6g3nHzS0W887bF2S2kdmmiLAuW/Qm9YAgRrJYv252zbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnKEuzIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnKEuzIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B940C433F1;
	Sat,  3 Feb 2024 04:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933863;
	bh=tkwHYwTZWUrLt/WOAQ+MUOaTP3BXaU6pkeigFoURRus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnKEuzIpqwPq8523NLhRHtNziiNhe5gMk3IjAC/vZvTtfjamWhVNyIMPu/hYFzGHn
	 IOJt/0L/6tT5J+ncqR0SFSkYwGBrbHz0iZARke7r3xmAh7mA1d6ZBDYS3NuDsldYbe
	 tCzUhxR/H6zGu9yw8fNQaSLtF5y3Cop1usc5DsAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 175/353] drm/amd/display: Fix MST PBN/X.Y value calculations
Date: Fri,  2 Feb 2024 20:04:53 -0800
Message-ID: <20240203035409.181389830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit 94bbf802efd0a8f13147d6664af6e653637340a8 ]

Changing PBN calculation to be more in line with spec. We don't need to
inflate PBN_NATIVE value by the 1.006 margin, since that is already
taken care of in the get_pbn_per_slot function.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 04d1ecd6e593..d28564b1b28a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -1061,18 +1061,21 @@ static struct fixed31_32 get_pbn_from_bw_in_kbps(uint64_t kbps)
 	uint32_t denominator = 1;
 
 	/*
-	 * margin 5300ppm + 300ppm ~ 0.6% as per spec, factor is 1.006
+	 * The 1.006 factor (margin 5300ppm + 300ppm ~ 0.6% as per spec) is not
+	 * required when determining PBN/time slot utilization on the link between
+	 * us and the branch, since that overhead is already accounted for in
+	 * the get_pbn_per_slot function.
+	 *
 	 * The unit of 54/64Mbytes/sec is an arbitrary unit chosen based on
 	 * common multiplier to render an integer PBN for all link rate/lane
 	 * counts combinations
 	 * calculate
-	 * peak_kbps *= (1006/1000)
 	 * peak_kbps *= (64/54)
-	 * peak_kbps *= 8    convert to bytes
+	 * peak_kbps /= (8 * 1000) convert to bytes
 	 */
 
-	numerator = 64 * PEAK_FACTOR_X1000;
-	denominator = 54 * 8 * 1000 * 1000;
+	numerator = 64;
+	denominator = 54 * 8 * 1000;
 	kbps *= numerator;
 	peak_kbps = dc_fixpt_from_fraction(kbps, denominator);
 
-- 
2.43.0



