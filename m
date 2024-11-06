Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D781EE002;
	Wed,  6 Nov 2024 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898594; cv=none; b=caHqNj+LBBoy3vaTh3fMndJMO+d9RFmAAdsGPvvw2jlyf40bRTfRlrOXIosl+518O+VB0YPt2mTXz64Iy/S2zJ1r22BvTPUItSU6mx7kSf9qTJZgvmatSKTUSLRSQkatHS8PVOjzPIOIZJyTAMod7y7Sa8v+eoczUUF+UiOtFcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898594; c=relaxed/simple;
	bh=h548rlFP8ZoMpaD7c2jmgbFxhEznxp96nU2zIHlty8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvPbUVkLMvknffdZQAb+pQdKhAFtgW7FLW2zSGMdnCod8kQae2UCLhO9rMsmGzpbFfeDMbygrQgIlhYGr2m0dG/yFR9uYh/KDWDSQiGss6/icldeQEIF7MEoFRLV5RRBBEEJyfxF6Y8PXUySPtT6ytbhEzDN1Du+aTMaw2zYCuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeWt2NNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeWt2NNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C75C4CED3;
	Wed,  6 Nov 2024 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898594;
	bh=h548rlFP8ZoMpaD7c2jmgbFxhEznxp96nU2zIHlty8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeWt2NNR13MuDezHA6aUI90AUvgS1hJR98BzWDhIjZBB9jOs0NlDS2oZmk7FYLylU
	 gUeI1Hp5GZaw64C9pWtYTwbk6Z1T5t8dwLDxvlF6zFmsyFlIuWV06CNYbl/kzhln9L
	 RpsCLe95h1reJSARfO/P5PEakVpbXVxOH09Ykqio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 290/462] clk: qcom: clk-rpmh: Fix overflow in BCM vote
Date: Wed,  6 Nov 2024 13:03:03 +0100
Message-ID: <20241106120338.688996284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit a4e5af27e6f6a8b0d14bc0d7eb04f4a6c7291586 ]

Valid frequencies may result in BCM votes that exceed the max HW value.
Set vote ceiling to BCM_TCS_CMD_VOTE_MASK to ensure the votes aren't
truncated, which can result in lower frequencies than desired.

Fixes: 04053f4d23a4 ("clk: qcom: clk-rpmh: Add IPA clock support")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Link: https://lore.kernel.org/r/20240809-clk-rpmh-bcm-vote-fix-v2-1-240c584b7ef9@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 21f4248ba7ddb..a1cd64d71cec9 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -270,6 +270,8 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
 		cmd_state = 0;
 	}
 
+	cmd_state = min(cmd_state, BCM_TCS_CMD_VOTE_MASK);
+
 	if (c->last_sent_aggr_state != cmd_state) {
 		cmd.addr = c->res_addr;
 		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
-- 
2.43.0



