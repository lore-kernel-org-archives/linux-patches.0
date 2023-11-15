Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DD73BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVr5YqWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5873BC433CC;
	Wed, 15 Nov 2023 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076229;
	bh=m0t2pxsYyzaTWXboVfD6xJZLmOxTVYStpJh+Wr5Ba/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVr5YqWj/MqwoQeVYxL/OpFw2L5rU8Bob42KiyJkajbQeBkn/NQDSgYvYXmN+JtDN
	 wSVGRyP7jxEUE2+8/P2u+g/06azivkweEeytw63ewptsSEmn6RG1zhciXj9ia3WiSu
	 TrxrA0Zo8WmrdVECQAcWUKnttJJcTGCbgwCA5WKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 157/550] clk: qcom: mmcc-msm8998: Fix the SMMU GDSC
Date: Wed, 15 Nov 2023 14:12:21 -0500
Message-ID: <20231115191611.577156825@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 1fc62c8347397faf4e18249e88ecd4470c0a5357 ]

The SMMU GDSC doesn't have to be ALWAYS-ON and shouldn't feature the
HW_CTRL flag (it's separate from hw_ctrl_addr).  In addition to that,
it should feature a cxc entry for bimc_smmu_axi_clk and be marked as
votable.

Fix all of these issues.

Fixes: d14b15b5931c ("clk: qcom: Add MSM8998 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20230531-topic-8998_mmssclk-v3-5-ba1b1fd9ee75@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8998.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-msm8998.c b/drivers/clk/qcom/mmcc-msm8998.c
index 9b98e0fb8b914..7b1d105afbd8c 100644
--- a/drivers/clk/qcom/mmcc-msm8998.c
+++ b/drivers/clk/qcom/mmcc-msm8998.c
@@ -2628,11 +2628,13 @@ static struct gdsc camss_cpp_gdsc = {
 static struct gdsc bimc_smmu_gdsc = {
 	.gdscr = 0xe020,
 	.gds_hw_ctrl = 0xe024,
+	.cxcs = (unsigned int []){ 0xe008 },
+	.cxc_count = 1,
 	.pd = {
 		.name = "bimc_smmu",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL | ALWAYS_ON,
+	.flags = VOTABLE,
 };
 
 static struct clk_regmap *mmcc_msm8998_clocks[] = {
-- 
2.42.0



