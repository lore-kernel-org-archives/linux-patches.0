Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8B23E330;
	Mon, 23 Jun 2025 13:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684425; cv=none; b=B2OU8qbcRGywDsfC8WGuD7ThUfbjPHgD3eCegXfIyZpIqBaZNEaptpsk4W/zUGvGiSLUHuOTe7B46YQgOtoGDSzS1J7cGxzcC8I5xK8ZuHiBarzgClblRksDiDjx+Xl9e3OrAoIQWpVnKwQPYK39JYaNEtNEtv4uhpLw/XcnYHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684425; c=relaxed/simple;
	bh=77oS9/4U1Va9jt5D0C6N+UBgYYfKAiS+UPIy4RWtGTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0Tik3eKfPVDaHtRVyjGWRuM0KV5ZvwgM7tdoYVIHHUH6+aT3uQ6TjroM+FGVhBgGIzdwEAWZWEgozgkuRduTghZz2saR8KUW41uqO2seVzH1eEi5IbhjE/Jq5VK+wpsUwyxqlrt4oGIU39Y477VmQDnNkiGMrtiBFyvTxDZYRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+IfhxTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+IfhxTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA0FC4CEEA;
	Mon, 23 Jun 2025 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684425;
	bh=77oS9/4U1Va9jt5D0C6N+UBgYYfKAiS+UPIy4RWtGTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+IfhxTiVITTRd6L5ACCGamSmFucqenlTQgbAYFHq8HVa+X5ZTGcHfksFu+NLXFMW
	 g3oc51a2oB5LRZM0Rkzt6fXOmqGiemrB/FmdQus2tpoxCIqjvWgrViSyzoVC9sJSof
	 lunq9VA/3MTlWG5pjdkaROy3AY5kw3lXOFBvirms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 063/592] media: ccs-pll: Start OP pre-PLL multiplier search from correct value
Date: Mon, 23 Jun 2025 15:00:21 +0200
Message-ID: <20250623130701.758122460@linuxfoundation.org>
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

commit 660e613d05e449766784c549faf5927ffaf281f1 upstream.

The ccs_pll_calculate() function does a search over possible PLL
configurations to find the "best" one. If the sensor does not support odd
pre-PLL divisors and the minimum value (with constraints) isn't 1, other
odd values could be errorneously searched (and selected) for the pre-PLL
divisor. Fix this.

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
@@ -817,6 +817,8 @@ int ccs_pll_calculate(struct device *dev
 			      one_or_more(
 				      DIV_ROUND_UP(op_lim_fr->max_pll_op_clk_freq_hz,
 						   pll->ext_clk_freq_hz))));
+	if (!(pll->flags & CCS_PLL_FLAG_EXT_IP_PLL_DIVIDER))
+		min_op_pre_pll_clk_div = clk_div_even(min_op_pre_pll_clk_div);
 	dev_dbg(dev, "pll_op check: min / max op_pre_pll_clk_div: %u / %u\n",
 		min_op_pre_pll_clk_div, max_op_pre_pll_clk_div);
 


