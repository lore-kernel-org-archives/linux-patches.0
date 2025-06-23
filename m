Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B631E22E6;
	Mon, 23 Jun 2025 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715545; cv=none; b=dXuEzk/lewQhTKAHIijt/+Qt94iBWgJ/XswBJ0ygvbG7nb2IJL+Pu4M/KUj/wxOYPsxxTHk9vSWKN+ocMFX4KVqWttwhIccjBlwlhMCOImkrOp0iiyobZIFk1lL0iVgBfzhcTHydhHRU1MkNimiwvYzipGgPZfd3KooV8L3lEo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715545; c=relaxed/simple;
	bh=VgnEf0jS/7qBlvV+APVjxFBt4oO2b6yHEeDktjVMLM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfNur35QEyGsdt+shzaIzyS3Id2Ho8CDkFNy3+MzHcZb/w8Xn7QgAy36xd8JH2CeRFC23yYNyMYlqlP77MCdERgg28g0eesBnIpUvhlEHyGVzp/TOQn1PJ7bq+N5X83csttb64/F5GQF3AOu3p9HhiQuELG/ekLPxMbCeiGYIBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAhiT09n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAhiT09n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51568C4CEEA;
	Mon, 23 Jun 2025 21:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715545;
	bh=VgnEf0jS/7qBlvV+APVjxFBt4oO2b6yHEeDktjVMLM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAhiT09nEhB7YH2yr/niE4V0Dz9az6R9ZjAnCaFpzVKRYZBZbt3e64JNouCSezAU1
	 BpV5IHdJ6FLMib0e8+RkdP9/h+mcmfhMXRJGfZVyy2Rq334NSM6U97HtwcioLrLXtZ
	 5HEUUNrd3CFHqiQln5bjhpmZpDq8A0cPAyD6Qb3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/411] media: ccs-pll: Better validate VT PLL branch
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130640.798682871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit cd9cb0313a42ae029cd5af9293b0add984ed252e ]

Check that the VT PLL dividers are actually found, don't trust they always
are even though they should be.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs-pll.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ccs-pll.c b/drivers/media/i2c/ccs-pll.c
index c876ea851ed7c..fe9e3a90749de 100644
--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -442,7 +442,7 @@ static int ccs_pll_calculate_vt_tree(struct device *dev,
 	return -EINVAL;
 }
 
-static void
+static int
 ccs_pll_calculate_vt(struct device *dev, const struct ccs_pll_limits *lim,
 		     const struct ccs_pll_branch_limits_bk *op_lim_bk,
 		     struct ccs_pll *pll, struct ccs_pll_branch_fr *pll_fr,
@@ -565,6 +565,8 @@ ccs_pll_calculate_vt(struct device *dev, const struct ccs_pll_limits *lim,
 		if (best_pix_div < SHRT_MAX >> 1)
 			break;
 	}
+	if (best_pix_div == SHRT_MAX >> 1)
+		return -EINVAL;
 
 	pll->vt_bk.sys_clk_div = DIV_ROUND_UP(vt_div, best_pix_div);
 	pll->vt_bk.pix_clk_div = best_pix_div;
@@ -577,6 +579,8 @@ ccs_pll_calculate_vt(struct device *dev, const struct ccs_pll_limits *lim,
 out_calc_pixel_rate:
 	pll->pixel_rate_pixel_array =
 		pll->vt_bk.pix_clk_freq_hz * pll->vt_lanes;
+
+	return 0;
 }
 
 /*
@@ -852,8 +856,10 @@ int ccs_pll_calculate(struct device *dev, const struct ccs_pll_limits *lim,
 		if (pll->flags & CCS_PLL_FLAG_DUAL_PLL)
 			break;
 
-		ccs_pll_calculate_vt(dev, lim, op_lim_bk, pll, op_pll_fr,
-				     op_pll_bk, cphy, phy_const);
+		rval = ccs_pll_calculate_vt(dev, lim, op_lim_bk, pll, op_pll_fr,
+					    op_pll_bk, cphy, phy_const);
+		if (rval)
+			continue;
 
 		rval = check_bk_bounds(dev, lim, pll, PLL_VT);
 		if (rval)
-- 
2.39.5



