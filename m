Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE40248F63;
	Mon, 23 Jun 2025 13:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684430; cv=none; b=cnBrWjHBzZ0Yzq5ChW24ijljZxM4WruQK1pxHqhUpezaEE14uftf10D5kMLM39oF9EA4g2Fli/4WQIbL8exrIYDsVCXKeE2uPpR4Nq3seh6sV1BSSG92k2IipnjqkwpG2mCqqg5aTkXaQjBhef42p42XMHcUVY18ckasHpBmL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684430; c=relaxed/simple;
	bh=lscXhuoapaSuNL18EBTVWaXsjoIG1ocwoKxHJzIfPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfqDFIXPp4FPYN9WmrMxPs/xHpFqHOmYPROKtsH/qa/nF6hflJ1ZCHB1pboshj3wnGFhceou9GwOccYPB/t5+RG6gZOQylcpL0qPK0jMqJKiQsRUwIp/O8TXAyShJFmadzQSsFHMvowgJ2Ws5LJC67bCG9G11cBgQaMhYRf5bTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+jvUQJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+jvUQJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F349C4CEEA;
	Mon, 23 Jun 2025 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684430;
	bh=lscXhuoapaSuNL18EBTVWaXsjoIG1ocwoKxHJzIfPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+jvUQJZStlBhFB+YjIJXh5Zs+9/mWQBnNgah0R4qnmMBPoHZkYkcYu7d0t/zahyx
	 t4WDjQ/onDzRkckbh9pEWK1hqBUl6XBbwYIoJYcB4jrVuNbg5y36HobCUmSs+tevwI
	 A1Y0NPnVIldKTP8PPOjk9J/F+ySXDALxIMnsdVkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 064/592] media: ccs-pll: Correct the upper limit of maximum op_pre_pll_clk_div
Date: Mon, 23 Jun 2025 15:00:22 +0200
Message-ID: <20250623130701.782741163@linuxfoundation.org>
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

commit f639494db450770fa30d6845d9c84b9cb009758f upstream.

The PLL calculator does a search of the PLL configuration space for all
valid OP pre-PLL clock dividers. The maximum did not take into account the
CCS PLL flag CCS_PLL_FLAG_EXT_IP_PLL_DIVIDER in which case also odd PLL
dividers (other than 1) are valid. Do that now.

Fixes: 4e1e8d240dff ("media: ccs-pll: Add support for extended input PLL clock divider")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs-pll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -794,7 +794,7 @@ int ccs_pll_calculate(struct device *dev
 		op_lim_fr->min_pre_pll_clk_div, op_lim_fr->max_pre_pll_clk_div);
 	max_op_pre_pll_clk_div =
 		min_t(u16, op_lim_fr->max_pre_pll_clk_div,
-		      clk_div_even(pll->ext_clk_freq_hz /
+		      DIV_ROUND_UP(pll->ext_clk_freq_hz,
 				   op_lim_fr->min_pll_ip_clk_freq_hz));
 	min_op_pre_pll_clk_div =
 		max_t(u16, op_lim_fr->min_pre_pll_clk_div,


