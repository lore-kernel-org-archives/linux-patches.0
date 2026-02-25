Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1B6256C6C;
	Wed, 25 Feb 2026 01:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983427; cv=none; b=JFeyECe/WcUlkqbtXZyic4eOsuuRrVumutl8rjPFzkZUVHlmqiuHhB9sji+RER/eLTnJB5VX/PYbVwtfIwIlG8f9aignPnqPtSROH/l6YZpHD/TlcrBQUxVjZrqHVMRkKWrRvT6GvLeXmD1qtgt890+KpsACl5W3Wim7ssJ6n+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983427; c=relaxed/simple;
	bh=JN0wJGxmL8OM6868lSc62Svn2eFrkuHxv48hvnKs49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niRtcf/bSA+OtFneQuIuBlzsxmQn/IrNrBqdv18j06zLjIaQf7rVr7go90UMRdQn3CFASZX7NrNW0OS3yPfVRRpgEBaG4yPYUBmtoWjT2b0gvTfI5YYWFzyjt6DqVwJvO6rNuZSNsu470JstZPAaYZgFYae5bzJlnpgjDeM2fNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PsVyrZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PsVyrZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AD7C116D0;
	Wed, 25 Feb 2026 01:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983427;
	bh=JN0wJGxmL8OM6868lSc62Svn2eFrkuHxv48hvnKs49Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PsVyrZ8nElq5D9Iu9IvwX36oh06HiadkuEnFexeOyFrOxHo/mKwePD7Vw24LvLS3
	 SxNOMI4namnp2Y/0lLejb1+A3WU6LP7BoWP99y0QveGCBeANa81Ral+1lI9pMyiJJT
	 J6oW1TG7i95tpuZNTGqSjD/9faFY26df2PB0VoDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 529/781] clk: qcom: alpha-pll: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:38 -0800
Message-ID: <20260225012412.774453706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



