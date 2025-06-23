Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E682459FF;
	Mon, 23 Jun 2025 13:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684420; cv=none; b=MuHkKOtcOV6dsQX7ofdRxyX8xgNQiNetjDVlsutyywzowBoM0xRiZy49YQCvMZdC2eQJgOE6L37UAuOf/XdGE8FsutPdOeMzI7TsJwXGFFyY66rI+4L8qO85Xs1bvES+h9qGIlX4MIO0lZyxZ1vdfpxtQ6vxiBrdvUuXUCKeHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684420; c=relaxed/simple;
	bh=1Crsd2P+Dsz1gb2RPJkbXgmM+7Owv0Byezgx2+8ZTyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3X0DI5d/p1faXmBNZG8tGIZrSvIxVOMx5p4XGVdMW9fiA3X5hCIy5Flsldry3kwRb9334Mv496ezjPZu3e1nJ7vIfwT957tDbJGZLfhsadaowyzYTM4ZEKcMlk+FQjN5yZIgy+XwFLw9mmnra6lkLyeQh6r30SfqP9GE8igiuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VznEsNiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VznEsNiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81BAC4CEEA;
	Mon, 23 Jun 2025 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684420;
	bh=1Crsd2P+Dsz1gb2RPJkbXgmM+7Owv0Byezgx2+8ZTyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VznEsNiEZIiERiXfubfrb4/ANqmLvYdn+EQXkbvcLMMU7+q0uEJ6eOm9aU6mjy2Nl
	 W/xRjQdcxZDcR+pusVffSMo91jowyFNscfWgEs7B4bJtVcmQYn/9GZBOFSduF8EsZY
	 Uk+Ycn0ZarFAypPhe3hTaVbVtEWFIrVJFzkzQz1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 061/592] media: ccs-pll: Start VT pre-PLL multiplier search from correct value
Date: Mon, 23 Jun 2025 15:00:19 +0200
Message-ID: <20250623130701.708139592@linuxfoundation.org>
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


