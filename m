Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3BE16419;
	Mon, 23 Jun 2025 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685926; cv=none; b=LKAZmU83s2SKj6f6w4EPwlan1BNCGFvYGg2ivGS5fqRLU/VEwyoC5d3xQxKb0NYd2WcmHKoOAJjcR4+dXkgFX2PmLoaEifrV583IehWjnBa1Mp97DKV5I39gZvfj87CKRvfH7Ax8Nr2nwLsmq336xkeib1VB+DDBNcESzzhqwHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685926; c=relaxed/simple;
	bh=LE3OXNdHFc3vokQSq+ySe3+CZbtFpqXli0dVOj49Qtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW3O2fOMNOQZj9MK1yPoWMJToK7jOv3C+ZLLcLgJy+YYzbTrtjZtvltNGkCnY7oIbc5DX9M3sAH4dkJlYKCFaEvU4Npz3hX0+i7DxABPylLrnN7yRskU9sdsSH6dsfTaawKtGmQAdVH5joQZth8bWwp88LJhtbZvbolNogwv9Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ex3E4zOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ex3E4zOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E801C4CEEA;
	Mon, 23 Jun 2025 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685925;
	bh=LE3OXNdHFc3vokQSq+ySe3+CZbtFpqXli0dVOj49Qtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ex3E4zOOA1ac1fC+bVVEkeXDlNzWBOUElmDSLFrc0ly5OCwocz2QrhgPcLHrZ2dFW
	 LSOukCn9snHsZOkpy+x9xhSo5qJ05q9CF6raHd0OH4s+ZfJAlB5De37kbZKZxb5Ere
	 Gna5QRcfsW3PiL+fP8PKh8opBCJzZy7zC99lN74Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 271/592] media: ccs-pll: Better validate VT PLL branch
Date: Mon, 23 Jun 2025 15:03:49 +0200
Message-ID: <20250623130706.772537363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d985686b0a36b..2051f1f292294 100644
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



