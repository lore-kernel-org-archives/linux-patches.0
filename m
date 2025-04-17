Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E715152532;
	Thu, 17 Apr 2025 18:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913561; cv=none; b=NLBNeVhsYxpvWwahpB0dRuLD22JB2jwFnom3quUZNDkdMWZVeLDDh6PIBuS23cNsL+3jhVmY1RF1a4qQu3pkw8tHL8NvOmE3hOGTRGL/xGdVXpxSg9vZ6b78Ougnu+qspzlcrf50vXvxsBDSvWYcgEXooDovkcPcWNne6g+PP3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913561; c=relaxed/simple;
	bh=wCyjreo4ELL43dILoL7FnQdMwcn8xQ4H8iGHhG4sASk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzA9y3KWpXyHB16ZOfRJ0Nz7nirF7dDt+HgTnQnMITQW5ejHQ9o9Sx1+YUDdxytLzJIjRkNcviNjOIFe0GFcAH6njqfoqpARWGVyrTpxoyZowrwj91rduvy2mOtMDLuetS+Gxox7Si41uPZMAOZvtS6UogxbdJhsmrQgdnFo3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NKgazY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NKgazY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3E8C4CEE4;
	Thu, 17 Apr 2025 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913560;
	bh=wCyjreo4ELL43dILoL7FnQdMwcn8xQ4H8iGHhG4sASk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NKgazY9/jVwrHWr16O4TpQyRoy+BaCAqwNaAA7g3iUYxlvIyUd6cKGuUuVdGIgfA
	 mbnmRm7lkrgWjP6Klu959/K/xKm2Vl0ea6KgfR9AIu5syxhK1NJhqXu26gWSKZuSVL
	 Q76QnHKM1pebFTGe/3My1r8VLS0FnFzq3TZ5DqOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Pandey <quic_ajipan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 379/449] clk: qcom: clk-branch: Fix invert halt status bit check for votable clocks
Date: Thu, 17 Apr 2025 19:51:07 +0200
Message-ID: <20250417175133.511707477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajit Pandey <quic_ajipan@quicinc.com>

commit 5eac348182d2b5ed1066459abedb7bc6b5466f81 upstream.

BRANCH_HALT_ENABLE and BRANCH_HALT_ENABLE_VOTED flags are used to check
halt status of branch clocks, which have an inverted logic for the halt
bit in CBCR register. However, the current logic in the _check_halt()
method only compares the BRANCH_HALT_ENABLE flags, ignoring the votable
branch clocks.

Update the logic to correctly handle the invert logic for votable clocks
using the BRANCH_HALT_ENABLE_VOTED flags.

Fixes: 9092d1083a62 ("clk: qcom: branch: Extend the invert logic for branch2 clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Ajit Pandey <quic_ajipan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250128-push_fix-v1-1-fafec6747881@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-branch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/clk-branch.c
+++ b/drivers/clk/qcom/clk-branch.c
@@ -28,7 +28,7 @@ static bool clk_branch_in_hwcg_mode(cons
 
 static bool clk_branch_check_halt(const struct clk_branch *br, bool enabling)
 {
-	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	bool invert = (br->halt_check & BRANCH_HALT_ENABLE);
 	u32 val;
 
 	regmap_read(br->clkr.regmap, br->halt_reg, &val);
@@ -44,7 +44,7 @@ static bool clk_branch2_check_halt(const
 {
 	u32 val;
 	u32 mask;
-	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	bool invert = (br->halt_check & BRANCH_HALT_ENABLE);
 
 	mask = CBCR_NOC_FSM_STATUS;
 	mask |= CBCR_CLK_OFF;


