Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBC3FB1B;
	Mon, 23 Jun 2025 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713106; cv=none; b=I1Av3VfjBHSTbiDcW5gyeAIfCzDvmnMEMoOrQKl9gW+urdyXhAjkoP7zTeESkvnNMGuaFtwaTJPI5ghWSrqsSSZ3Vg2xSBO8WzQj5vDboRxILMvxhajhnbzFyEpdIQk/S21OGdVxoaLHLhIyin/Onvbih2JTzUfCFNX60TAbuBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713106; c=relaxed/simple;
	bh=3WlHP742llEs5h+kU+HBwg3Aft2WRKNsQCRiMqekei4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s97GvpRnKA7cJJpz7qmbvPrc7abXFeoTWYifxs6gIbOp/aZw/LdNjZ01sCbmCyBR3qlrFmfa4KykujxM8qP/QVpUn50Si6PUkGbC+Y2CF99mUbAJjHi0eFZN/u5PGIyRFfGn0n+Gh1v0I/R4BL6ubQbNahS9/66+TVI+z2hYIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw5RRedn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw5RRedn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E3CC4CEEA;
	Mon, 23 Jun 2025 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713106;
	bh=3WlHP742llEs5h+kU+HBwg3Aft2WRKNsQCRiMqekei4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw5RRedn1ZYm5eBFyIzeSry5QIWpGUgo7XqFiekDqdyEppseUHoSxRnI4TI98fjGd
	 7S8TeoEie1mPGTAr6qktSIMnvSNZ1QIKlv1duAOxs2YF14roo3YTHBNiFBZg7+yl+e
	 CfiG+H3sHLkbA/8KrqD2REhsd/TnCyZfUg6ad5ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 046/414] media: ccs-pll: Start VT pre-PLL multiplier search from correct value
Date: Mon, 23 Jun 2025 15:03:03 +0200
Message-ID: <20250623130643.191320412@linuxfoundation.org>
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

commit 06d2d478b09e6764fb6161d1621fc10d9f0f2860 upstream.

The ccs_pll_calculate_vt_tree() function does a search over possible VT
PLL configurations to find the "best" one. If the sensor does not support
odd pre-PLL divisors and the minimum value (with constraints) isn't 1,
other odd values could be errorneously searched (and selected) for the
pre-PLL divisor. Fix this.

Fixes: 415ddd993978 ("media: ccs-pll: Split limits and PLL configuration into front and back parts")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs-pll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -397,6 +397,8 @@ static int ccs_pll_calculate_vt_tree(str
 	min_pre_pll_clk_div = max_t(u16, min_pre_pll_clk_div,
 				    pll->ext_clk_freq_hz /
 				    lim_fr->max_pll_ip_clk_freq_hz);
+	if (!(pll->flags & CCS_PLL_FLAG_EXT_IP_PLL_DIVIDER))
+		min_pre_pll_clk_div = clk_div_even(min_pre_pll_clk_div);
 
 	dev_dbg(dev, "vt min/max_pre_pll_clk_div: %u,%u\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);


