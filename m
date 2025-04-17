Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F50264F9C;
	Thu, 17 Apr 2025 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914925; cv=none; b=ll3B9DmFlrMZn2dpfPM7hV92jrldf4Bky/PIFcH0PexzvCc6W6QHcYHZ4EAhGXSwqOgxr7xAmrfNK7skcLMWnWZoy7kfLSj82vDnk0aBW7nx+W9NiNFHE+5Oyj92GE1obu+LgqkgrGCA7qKuLGdvwuVHhEw6C0p9yM97l6eSs1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914925; c=relaxed/simple;
	bh=a0Mu6yKpxtjNgIOBYKIj/AbCd106hk4BgXf3z6G0t28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMdHZlXOQja26jsoWQ+Kp1hxnpoElrEXCicxeZeyHAjzMH9+SwbNVIOTcmRXz4u0pcrU37I+Wj7Xt+rgcY4XxLZQ3QakuBNE0uynnMbLcKJRRVS7j3YhZLVSx8fyw/cxaVbaHNuk2VaRehGg9Byz1bvP+TH3KcvlWtB6BshuEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvQdD03B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvQdD03B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FCBC4CEE4;
	Thu, 17 Apr 2025 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914925;
	bh=a0Mu6yKpxtjNgIOBYKIj/AbCd106hk4BgXf3z6G0t28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvQdD03BwchNECsvBcY4f2HW0Jr4E5KKAQSKOiLoDMuFQ36LIKilB+xmWoGmZ/Fun
	 c3FTZBoTkTF57ZODu/QyNBiYJX/OhXWTadbg9qi0fxtbZxDqerbQfVlX/ZzKlmhEfw
	 WdH5wykC1v+9b7rGOQO/s9rsTWIEmnPobjuEaU5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Pandey <quic_ajipan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 345/414] clk: qcom: clk-branch: Fix invert halt status bit check for votable clocks
Date: Thu, 17 Apr 2025 19:51:43 +0200
Message-ID: <20250417175125.304128544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


