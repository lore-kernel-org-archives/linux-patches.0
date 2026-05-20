Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BCF34EF05;
	Wed, 20 May 2026 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296224; cv=none; b=QE1COZkJlxoK6AR46cQvE78/hng6zstKk9I+HeIbvOkIVgM/LyKzAAUUtav48za3fvIVAErhxNSrdq8WW2DczMtQVUurRwte8CB/ePVHyyvNkIP6k5aOW23Mjji+ON7+vRiznJxh5waqmrwB84mSjBathvU+2V8sO50Zmprc24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296224; c=relaxed/simple;
	bh=ioyEfAE9zNffwbQqTsczKiLLcSJQWHLtRedIBj4NPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tArOV+jMHEBp56aSrp8AvbnzqDaAW/qZDmwj6XdX7AfFaCMw8EvIYUFuhqVCOUk229lmBH0Yqmt74iNW98jQ+hTcv5XGzazi723Zk6eRJ/j56I8WoJIcioW/BNSzqqoqZDN8L1sFcdD0SZBfQdJXyb1W6XlWRFZKAP8gpRi5RBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e08ovGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e08ovGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353E11F000E9;
	Wed, 20 May 2026 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296223;
	bh=Y7m2rnsOI7hESHUgtfLh+XXfbqI6jxYQ75VWVBXFS1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2e08ovGvQYD1SVOF2Y2zUBQqV3iOLwvEd9clN3b68h17KsFzlmewZieAuqnOwIV3r
	 ybzRI7HcXeW4i+N+J7cR02rtDR3rqtz6Rw3xJ/ZNJ5PNFm1kYE5g7PFdgkkErVS0Pf
	 stN3XITfvhLQpY2NdBFM7PrsX2Ya9R7HA+u9UbEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0718/1146] clk: qcom: dispcc-sm8250: Use shared ops on the mdss vsync clk
Date: Wed, 20 May 2026 18:16:08 +0200
Message-ID: <20260520162204.454799774@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 8c522da70f0c2e5148c4c13ccb1c64cca57a6fdb ]

mdss_gdsc can get stuck on boot due to RCGs being left on from last boot.
As a fix, commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
registration") introduced a callback to ensure the RCG is off upon init.
However, the fix depends on all shared RCGs being marked as such in code.

For SM8150/SC8180X/SM8250 the MDSS vsync clock was using regular ops,
unlike the same clock in the SC7180 code. This was causing display to
frequently fail to initialize after rebooting on the Surface Pro X.
Fix by using shared ops for this clock.

Fixes: 80a18f4a8567 ("clk: qcom: Add display clock controller driver for SM8150 and SM8250")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260312112321.370983-8-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8250.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index 8f433e1e70283..cdfdb2cfb02b2 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -632,7 +632,7 @@ static struct clk_rcg2 disp_cc_mdss_vsync_clk_src = {
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.53.0



