Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397BF221FC7;
	Mon, 23 Jun 2025 21:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714770; cv=none; b=rqnzjCPp+5B1hhxQPScCBCboK4xYApPg85IP4ZLHrqgfB0ICP/zHFEjxs6J7D5MHvnBSLNBOyc/Yzd90X3VQoHBcD7FnLmtV2Iv9BgGENpeAI6AS77u8ms3M16d2lVJh/YDX348HRw7wnT1Ved/+ZXvswkC9AO8EFj3EPKJvrq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714770; c=relaxed/simple;
	bh=a2S7gdUVq9ygX+CFqKAl+1wByy7vif5uLJpFMKX7baE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqIz8mJVGcQ+uuz/D4fmSaevHNIUeXXxZCQrAg2q5Bc7OidQtVooV/j9VfnqYkJphSmPXErkIs1cKU7PYYD8n6WOncyA/b5TZAS1CKM8cREUu4YSImBInA/2S+ZZ4s8ie7VVM7Bi6vCGSBoqPciHhJS5DFs5VXzbq7bgLSuJRag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIaytkEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIaytkEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBEFC4CEEA;
	Mon, 23 Jun 2025 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714769;
	bh=a2S7gdUVq9ygX+CFqKAl+1wByy7vif5uLJpFMKX7baE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIaytkEGm50PJ3Q7rqlPgZj7T92BBzmCnGWDbZFaHcaeMcUHqYH5bfLUln7bvAAq2
	 P7YZKXObqQSRtEq2ndhLADxGGOS9Wl+RbGDnHPPrNL6fmQ2Za3yzIAPK70pB8AYkVQ
	 /2ZDMHmYd/eySR5VD0T9goMQflY9pocqws+gqVf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 208/411] media: ccs-pll: Correct the upper limit of maximum op_pre_pll_clk_div
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130638.907249699@linuxfoundation.org>
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


