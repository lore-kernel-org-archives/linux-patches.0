Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946AF24DCFD;
	Mon, 23 Jun 2025 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685867; cv=none; b=ksQSFlS8uEonXXTjMEVKDhbt9Hxmpk+/6QVsJKHiKM3RH97GJlsytJBcZ0cflm6RnM2MXYKUQPkp/WK9l6aEbDQRJf1fJppFkV9bFKrAB9BxjZCt+T5QBabGTGC+Fjk9blpQ79BcbHKZ1d8K8660jzeQO2RuD4GICZE+JQWviGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685867; c=relaxed/simple;
	bh=CCg3U/dA14kinUEkcKxQ6svZq3aFFckl718DtQ1RG0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNb6CYPIzmdzC8o4S91iU4AatJQ9EaB+PyAkGB6X3lH3l7OnnKsl+/EMAiEdwdpio+uCpb+T6incbheuvn7KPWKvDrWVRxxilIo8r/aLy6235DNYaOtzUtozCe3JfjjbCbNuZ50FHruE23b7MpZ65h6u2ik4zlhMdmAOSXTFzA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCnIi5Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCnIi5Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2936FC4CEEA;
	Mon, 23 Jun 2025 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685867;
	bh=CCg3U/dA14kinUEkcKxQ6svZq3aFFckl718DtQ1RG0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCnIi5Ml4PAK9sCgFNjMfrnZVf3WElH9AMH1YXSjR2qkFILjlwePJEh6a9Yxa+fUr
	 kd6yArE86uOmZuBPVWSXIU0zEiBOqFiMqbBBsCY1De5UBOoAfLWCwniTME9+H9vWm8
	 5HUGFyQV551LpwrUEqn5OQnx8b9K7ODtcLS5f/JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 030/290] media: ccs-pll: Correct the upper limit of maximum op_pre_pll_clk_div
Date: Mon, 23 Jun 2025 15:04:51 +0200
Message-ID: <20250623130627.898425237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


