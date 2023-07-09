Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B70522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A30AC433C7;
	Sun,  9 Jul 2023 11:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901856;
	bh=yHyq7tBFcrv7UPp3Aawh0GQa6mXCEyfNLVrsGavfYKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaVRHqhwRMmbkGpOZNa6AUX2niRAIJYnkIIqF2eBa0a+dOWEsbXlANqsI70T22O5j
	 FXXAl3wJimgKeXjlVWC3F7zyvoStfErn35Z2gDpvbnuPVDIlDMIMp6wQFzZ0Valxp5
	 TrspiVAf62zkzLlDeYKv5+y4u7HMqhvsp7SIwkco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 169/431] drm/bridge: tc358768: fix PLL parameters computation
Date: Sun,  9 Jul 2023 13:11:57 +0200
Message-ID: <20230709111455.134355368@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 6a4020b4c63911977aaf8047f904a300d15de739 ]

According to Toshiba documentation the PLL input clock after the divider
should be not less than 4MHz, fix the PLL parameters computation
accordingly.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-3-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 8f349bf4fc32f..e9e3f9e02bba0 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -334,13 +334,17 @@ static int tc358768_calc_pll(struct tc358768_priv *priv,
 		u32 fbd;
 
 		for (fbd = 0; fbd < 512; ++fbd) {
-			u32 pll, diff;
+			u32 pll, diff, pll_in;
 
 			pll = (u32)div_u64((u64)refclk * (fbd + 1), divisor);
 
 			if (pll >= max_pll || pll < min_pll)
 				continue;
 
+			pll_in = (u32)div_u64((u64)refclk, prd + 1);
+			if (pll_in < 4000000)
+				continue;
+
 			diff = max(pll, target_pll) - min(pll, target_pll);
 
 			if (diff < best_diff) {
-- 
2.39.2



