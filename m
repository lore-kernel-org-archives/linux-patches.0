Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEA159565;
	Mon,  6 Jan 2025 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177873; cv=none; b=Y/Hv/holPVocy3v7LJvV8ZosMV62RMjzCES3vQHtFp+zUthD9YCGgkeapWf4bINGDiqb26lONwHsgj9u/TbJ57yhmwMHN1bqllE7e/yBeadh6pSXEUOLdv6T+FD0KAFH1zPknbGQ/X17elxYeaRnl0LJvkAwZNi2I8RpKPjgsmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177873; c=relaxed/simple;
	bh=YuCFp/nDjjqq6jZxFJV23gDaOIFPIfce1SJs7aDQeB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6nWxDLr3gzJ527BrWQ4s6Z99b7nLHAdduE0xHs7c9vLBVFZP/POTdWxxEQH9Vci09xpLh3Ps5at2Hyqma/vJrNb6KZbEeiARvgs46Aj8G5IV9xsRHb4pObCCC2mk39rmSG5p5iyaZ7Bqt6XBX2AkUX8a/6kZ3DyXcCFtGgCjHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVaZyfST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVaZyfST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32441C4CED2;
	Mon,  6 Jan 2025 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177873;
	bh=YuCFp/nDjjqq6jZxFJV23gDaOIFPIfce1SJs7aDQeB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVaZyfSTyFsgtK7+js143X9a1R1Z0NfgMFO3nCxF4QwWvyme1qzLgfkrjvualeMY6
	 2dyOUBdSs9HJnvL8K6UfqJmASTzoGukWW7g8zKI2p14eO1vtmKUSyCNg4UHtKKGRwJ
	 P207g4SGfGqz0qRV/qYAgvCzufoCg+V31Tvjvzd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/156] drm/i915/cx0_phy: Fix C10 pll programming sequence
Date: Mon,  6 Jan 2025 16:15:40 +0100
Message-ID: <20250106151143.770157126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 385a95cc72941c7f88630a7bc4176048cc03b395 ]

According to spec VDR_CUSTOM_WIDTH register gets programmed after pll
specific VDR registers and TX Lane programming registers are done.
Moreover we only program into C10_VDR_CONTROL1 to update config and
setup master lane once all VDR registers are written into.

Bspec: 67636
Fixes: 51390cc0e00a ("drm/i915/mtl: Add Support for C10 PHY message bus and pll programming")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241216181554.2861381-1-suraj.kandpal@intel.com
(cherry picked from commit f9d418552ba1e3a0e92487ff82eb515dab7516c0)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cx0_phy.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cx0_phy.c b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
index 4a6c3040ca15..f11309efff33 100644
--- a/drivers/gpu/drm/i915/display/intel_cx0_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
@@ -2084,14 +2084,6 @@ static void intel_c10_pll_program(struct drm_i915_private *i915,
 		      0, C10_VDR_CTRL_MSGBUS_ACCESS,
 		      MB_WRITE_COMMITTED);
 
-	/* Custom width needs to be programmed to 0 for both the phy lanes */
-	intel_cx0_rmw(encoder, INTEL_CX0_BOTH_LANES, PHY_C10_VDR_CUSTOM_WIDTH,
-		      C10_VDR_CUSTOM_WIDTH_MASK, C10_VDR_CUSTOM_WIDTH_8_10,
-		      MB_WRITE_COMMITTED);
-	intel_cx0_rmw(encoder, INTEL_CX0_BOTH_LANES, PHY_C10_VDR_CONTROL(1),
-		      0, C10_VDR_CTRL_UPDATE_CFG,
-		      MB_WRITE_COMMITTED);
-
 	/* Program the pll values only for the master lane */
 	for (i = 0; i < ARRAY_SIZE(pll_state->pll); i++)
 		intel_cx0_write(encoder, INTEL_CX0_LANE0, PHY_C10_VDR_PLL(i),
@@ -2101,6 +2093,10 @@ static void intel_c10_pll_program(struct drm_i915_private *i915,
 	intel_cx0_write(encoder, INTEL_CX0_LANE0, PHY_C10_VDR_CMN(0), pll_state->cmn, MB_WRITE_COMMITTED);
 	intel_cx0_write(encoder, INTEL_CX0_LANE0, PHY_C10_VDR_TX(0), pll_state->tx, MB_WRITE_COMMITTED);
 
+	/* Custom width needs to be programmed to 0 for both the phy lanes */
+	intel_cx0_rmw(encoder, INTEL_CX0_BOTH_LANES, PHY_C10_VDR_CUSTOM_WIDTH,
+		      C10_VDR_CUSTOM_WIDTH_MASK, C10_VDR_CUSTOM_WIDTH_8_10,
+		      MB_WRITE_COMMITTED);
 	intel_cx0_rmw(encoder, INTEL_CX0_LANE0, PHY_C10_VDR_CONTROL(1),
 		      0, C10_VDR_CTRL_MASTER_LANE | C10_VDR_CTRL_UPDATE_CFG,
 		      MB_WRITE_COMMITTED);
-- 
2.39.5



