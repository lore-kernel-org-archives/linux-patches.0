Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5E6220F50;
	Mon, 23 Jun 2025 21:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713165; cv=none; b=iaDxylXtfQJzl5Aw+NJBYzK8oV4N+PCsD5Y3HxO5ioaAlpV7Q6Ksw2inZooZFsat0XHKyeAJ49X8+gOG9/KyH+clhAAmt3rO9PyB/b50NMUN+SkoHqmncUYBvzGDIA/MxhZeSw/XPoeUSJ0y0t/j/HVSYy+coRAjEinffZFBSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713165; c=relaxed/simple;
	bh=KL3u4gYgjDgApU6hM4NZEmL0QYwD8FIktsdCglww3ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfLyW0g6bQf/F0ZJrWY3tbH6FQZ2cr3RD01kdlj2BF6LU9NjxigMUShssjY7zdRYyH0+3sPgCWx5sQKwMWLJVRGyDSWRlq/89d4KR/NrEeURFv9L7JVxbyL/80dnDXCOFyVOOqCCUA1Z5Woo9kNGcF2p6opm/5LcnuD+urfM1uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oapgn7EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oapgn7EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8114C4CEEA;
	Mon, 23 Jun 2025 21:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713165;
	bh=KL3u4gYgjDgApU6hM4NZEmL0QYwD8FIktsdCglww3ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oapgn7EJN0pfE/ukQh7dkveyFngivdsF2Z5a2/4ZXx6N5M+XBmiy6l+DSv1PmWDP5
	 x+Y68cUabde24MYR7uco82JPOkfaj+l1xnEqVF0tq0/rCZVHvCsmEeFYHZ2SLPfl4A
	 CgPpT+LiMhyKS/cll7bfWpsO1UhpWyki7chzd8Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 049/414] media: ccs-pll: Correct the upper limit of maximum op_pre_pll_clk_div
Date: Mon, 23 Jun 2025 15:03:06 +0200
Message-ID: <20250623130643.270053736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


