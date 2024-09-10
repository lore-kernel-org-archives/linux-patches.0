Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C355143880;
	Tue, 10 Sep 2024 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963509; cv=none; b=LSIQUtjmqZMbIMCAT4Vo4YHpjpgGnvSVzvv0CDjqPmMOnPndvdaJZCMp2eQWMOsy9UwIpyl3yHbRJwvJbP5YoQV0DHSuUxFbXdFtrmqblSXnLhvXF6V68XGZZdzVqTMAWTN6cTsvhcDbIN/KQPrLzmcSqDnkeZXWk/V086vO4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963509; c=relaxed/simple;
	bh=riwA/O1gjBKkfzkCLT8XYtDca2TSakpJVM7IosI1jrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCCvqrjMLPq6uLxAMbxhM25Q5UBXag1oDeUChS+NoNOOwvXfpgXIoOi0ewJ6xmvgCkc0RCd+O1+/cHC+h1LtINPnNYPq0YD7ei6R/NkUGQmQsOwHZxkBRnQGsBPBNJN4gQfHrVQvsdTwr75qu49UydvrA4EElrZ+mnhbXUmzFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV0KMVPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV0KMVPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD6CC4CECD;
	Tue, 10 Sep 2024 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963509;
	bh=riwA/O1gjBKkfzkCLT8XYtDca2TSakpJVM7IosI1jrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AV0KMVPfSfjBXAvDW5ibh4oRGBOyAgIyAYd8MS38wsALJt7NBbkJ0VssZrKv3LM4q
	 h3ImFTzzwzA+pfDsFFGeba0M5mZXKn5Oiv5NMhZQ7+99Bl9cFf8dSm7Hq5Og+trRuM
	 j4JXPjrx8Qm/ViIGZqeZvragUsIhp6bCyxpNserY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 081/214] clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API
Date: Tue, 10 Sep 2024 11:31:43 +0200
Message-ID: <20240910092602.042540300@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 4ad1ed6ef27cab94888bb3c740c14042d5c0dff2 upstream.

Correct the pll postdiv shift used in clk_trion_pll_postdiv_set_rate
API. The shift value is not same for different types of plls and
should be taken from the pll's .post_div_shift member.

Fixes: 548a909597d5 ("clk: qcom: clk-alpha-pll: Add support for Trion PLLs")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240731062916.2680823-3-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1362,8 +1362,8 @@ clk_trion_pll_postdiv_set_rate(struct cl
 	}
 
 	return regmap_update_bits(regmap, PLL_USER_CTL(pll),
-				  PLL_POST_DIV_MASK(pll) << PLL_POST_DIV_SHIFT,
-				  val << PLL_POST_DIV_SHIFT);
+				  PLL_POST_DIV_MASK(pll) << pll->post_div_shift,
+				  val << pll->post_div_shift);
 }
 
 const struct clk_ops clk_alpha_pll_postdiv_trion_ops = {


