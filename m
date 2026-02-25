Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32F030E0F8;
	Wed, 25 Feb 2026 06:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002659; cv=none; b=swD6n2/UFke6TVbjTODZdP9zrLbUvRU8M+WD422yHP+ELakSYSSt95XHIL+GfLvTOeLRoMR6kYavKKcVl16oA/y/uOwbkTpjOIGvoLFYlnRj4Y+noWF0Bnf8rgDee6JHAiKoWVyifDiSOKBm+OT76ovPnJfcXg7qA8HGQ9Gy16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002659; c=relaxed/simple;
	bh=UwbPHa9JACmZoFMaI8B+TBkMKxUyu7ASI1QZpiDsb4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brP35d0tcE/YuEu4w7ekAO6EvTd0H9BWeg+tRo0fPPi2eNWxqe2F54cdtUgMt0MruldgG8o0UzyFWwY/+VcdUinrt52Cb98OE4GhYv9iTOfdU+gR+9GwtI4hn2eQymX+dQXtUZAeSnkkkV2J+dyVVRU9vFJ495XKIc/VmGgnA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqkyaHWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqkyaHWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32FEC116D0;
	Wed, 25 Feb 2026 06:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002659;
	bh=UwbPHa9JACmZoFMaI8B+TBkMKxUyu7ASI1QZpiDsb4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqkyaHWqFAb63q9YTiaQE6wss6yY6AAzkVeRRObNkMyi9pL4najeSwAzQOwqyhjF2
	 nGDFJBRMU43zp7GIy/11nQ0/Zhas3eoMlsyCt0VzTfzSkPw4y0Ak1r78QEPf/7UYE6
	 u0tEm6fJSy86Z+GiZvjHnYgo1qvI34m7GStMtky4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 420/641] clk: qcom: alpha-pll: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:26 -0800
Message-ID: <20260225012358.730594260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit e1f08613e113f02a3ec18c9a7964de97f940acbf ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 0e56e3369b60 ("clk: qcom: alpha-pll: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260108-clk-divider-round-rate-v1-14-535a3ed73bf3@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 6aeba40358c11..a84e8bee65346 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1257,11 +1257,8 @@ static int clk_alpha_pll_postdiv_determine_rate(struct clk_hw *hw,
 	else
 		table = clk_alpha_div_table;
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       table, pll->width,
-				       CLK_DIVIDER_POWER_OF_TWO);
-
-	return 0;
+	return divider_determine_rate(hw, req, table, pll->width,
+				      CLK_DIVIDER_POWER_OF_TWO);
 }
 
 static int clk_alpha_pll_postdiv_ro_determine_rate(struct clk_hw *hw,
@@ -1617,11 +1614,8 @@ static int clk_trion_pll_postdiv_determine_rate(struct clk_hw *hw,
 {
 	struct clk_alpha_pll_postdiv *pll = to_clk_alpha_pll_postdiv(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       pll->post_div_table,
-				       pll->width, CLK_DIVIDER_ROUND_CLOSEST);
-
-	return 0;
+	return divider_determine_rate(hw, req, pll->post_div_table, pll->width,
+				      CLK_DIVIDER_ROUND_CLOSEST);
 };
 
 static int
@@ -1657,11 +1651,8 @@ static int clk_alpha_pll_postdiv_fabia_determine_rate(struct clk_hw *hw,
 {
 	struct clk_alpha_pll_postdiv *pll = to_clk_alpha_pll_postdiv(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       pll->post_div_table,
-				       pll->width, CLK_DIVIDER_ROUND_CLOSEST);
-
-	return 0;
+	return divider_determine_rate(hw, req, pll->post_div_table, pll->width,
+				      CLK_DIVIDER_ROUND_CLOSEST);
 }
 
 static int clk_alpha_pll_postdiv_fabia_set_rate(struct clk_hw *hw,
-- 
2.51.0



