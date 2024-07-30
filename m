Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32DC188017;
	Tue, 30 Jul 2024 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359084; cv=none; b=C3XbZw6neWBMsr114dwY0A4//TZV/jxqKqe1+0s7ReBGPtL+OsyCX4nL7OGfv0p0IP5ptwYnrZUVkiGiJM99XfFVg8VC39TdYWgPyEGeshYuVj8nxFpDcvd6d5Jz7GjXCreLeYm7KLvQZ0yULmJxNdNqFh5ORUwvPCxyjNXIBec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359084; c=relaxed/simple;
	bh=TGDQsg6SRmFPzSk5FBo5oznZr6bu3J8mMcG7fHRekV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyyiLIVOV/S4Ue12PyrMFZabD/GpOYlJY5g0DwUUaQKEhxGdRz8oOnAadnMDaL1JhFB/EKwehxKGG8pZI5G1ogQKBigSPrVoD28CL9gwtNtvDhWm3qxk7B34d+bx5ZZ1g7vk0cXBnOyLdTaXtaLoPbrSDFoTYYSYPqPKtXsZBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEXECrUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEXECrUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE58C32782;
	Tue, 30 Jul 2024 17:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359084;
	bh=TGDQsg6SRmFPzSk5FBo5oznZr6bu3J8mMcG7fHRekV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEXECrUqE15ITn14KzG0aqGLuZd/NmD9s6boPsnj2t9m+QkmDz9kKl7ym9aQMbZXp
	 W5DQ2j+fHWLzGpnsS85RGnCdukqUaX0jJ+3vNn9zOg+mQhq5wWUs1mHZXTIzZkOq2A
	 X20op2hcHtt3jP2e99BZNmrY8vHweEE265ljvuBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 415/809] clk: qcom: gpucc-sa8775p: Park RCGs clk source at XO during disable
Date: Tue, 30 Jul 2024 17:44:51 +0200
Message-ID: <20240730151741.084923540@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit dff68b2f74547617dbb75d0d12f404877ec8f8ce ]

The RCG's clk src has to be parked at XO while disabling as per the
HW recommendation, hence use clk_rcg2_shared_ops to achieve the same.
Also gpu_cc_cb_clk is recommended to be kept always ON, hence use
clk_branch2_aon_ops to keep the clock always ON.

Fixes: 0afa16afc36d ("clk: qcom: add the GPUCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-5-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sa8775p.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sa8775p.c b/drivers/clk/qcom/gpucc-sa8775p.c
index f965babf4330d..1f7a02a7503d4 100644
--- a/drivers/clk/qcom/gpucc-sa8775p.c
+++ b/drivers/clk/qcom/gpucc-sa8775p.c
@@ -161,7 +161,7 @@ static struct clk_rcg2 gpu_cc_ff_clk_src = {
 		.name = "gpu_cc_ff_clk_src",
 		.parent_data = gpu_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -181,7 +181,7 @@ static struct clk_rcg2 gpu_cc_gmu_clk_src = {
 		.parent_data = gpu_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -200,7 +200,7 @@ static struct clk_rcg2 gpu_cc_hub_clk_src = {
 		.name = "gpu_cc_hub_clk_src",
 		.parent_data = gpu_cc_parent_data_2,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_2),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -294,7 +294,7 @@ static struct clk_branch gpu_cc_cb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_cb_clk",
-			.ops = &clk_branch2_ops,
+			.ops = &clk_branch2_aon_ops,
 		},
 	},
 };
-- 
2.43.0



