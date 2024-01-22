Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C625D4E1AD;
	Tue, 23 Jan 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971613; cv=none; b=P0QTUGcTRXF2Zr2JiYwdQOJjUt/ZBOXB4Zr73q8TQpKc2VoeJ8X4nuw78/Uc1DA/Y8QmPBovp1qB5jRUqQ0ClfjFHDcWnVyLs9+x85mg5Qjk9NiRM48baJCcoMiBMMIWWVlXKOPYaz5lnwwKlQdI1gddqrUbiuVmVEX4xFepHG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971613; c=relaxed/simple;
	bh=mlIe1XKf52MEQKShZdLi+ND6VwOzUXJrJw68y9xP7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lReIZ9X3vPcttEsSyfoMcbvvoQ8e1qsCd3Jqnv2dSyMbk11F2GklOzBHIeIfz06zVcqVI1ZVLMJ5FQfGTr/LwRryY/xTFlNxUjKbcWDo24S77o1lLxUJyxBaHAfEWYWcTqfxh3qo7uvT+Jra4uqrxNxey4Bbtp4I1Z0xjjblXiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcvPtoLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcvPtoLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5C5C433F1;
	Tue, 23 Jan 2024 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971613;
	bh=mlIe1XKf52MEQKShZdLi+ND6VwOzUXJrJw68y9xP7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcvPtoLgT99AYFppk4bIKGfZviSHEktv8pKrgpVzhi1O+iN77gHBOIPaj1VZFJuAM
	 nbXFFf46ViPeH3XPbTgf6by26ERzcTL11uFDpmOwEyhPe+3d2US6UlRKb7Xk3WP3Ei
	 gTKkVPenozJ28skOZhtA7plM6u9ohkjQcbJaFtec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Su Hui <suhui@nfschina.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/286] clk: si5341: fix an error code problem in si5341_output_clk_set_rate
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235739.297311533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 5607068ae5ab02c3ac9cabc6859d36e98004c341 ]

regmap_bulk_write() return zero or negative error code, return the value
of regmap_bulk_write() rather than '0'.

Fixes: 3044a860fd09 ("clk: Add Si5341/Si5340 driver")
Acked-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231101031633.996124-1-suhui@nfschina.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 4dea29fa901d..d6515661580c 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -888,10 +888,8 @@ static int si5341_output_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	r[0] = r_div ? (r_div & 0xff) : 1;
 	r[1] = (r_div >> 8) & 0xff;
 	r[2] = (r_div >> 16) & 0xff;
-	err = regmap_bulk_write(output->data->regmap,
+	return regmap_bulk_write(output->data->regmap,
 			SI5341_OUT_R_REG(output), r, 3);
-
-	return 0;
 }
 
 static int si5341_output_reparent(struct clk_si5341_output *output, u8 index)
-- 
2.43.0



