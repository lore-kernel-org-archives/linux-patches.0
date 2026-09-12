Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE46242D65;
	Sat, 12 Sep 2026 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216535; cv=none; b=sKUsVju3le64lpQybucWCwyUCu/5rTPoyOmBGsj3EVcYhSYdmEIlPR0Mhpyimjs22HKFEjgjJ7/D/NBN62LpM7GqxKTVXcS7EoDGg8fwiLjOjfivUJE0ZKKlPGs2d0z1Xsmg2kF2jalHnj/pFBlyYMGH63hUNpGaHd4Kap7RlmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216535; c=relaxed/simple;
	bh=4Fd1RrSKOBx3lbQODWZQPzbT38rah42XYVLPmaxjF8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvhvHsrKo93oHTe9H3qegOPO27WtW8ZVvcFjaX6kw2OZQWNUMwjs7u7wwFG6jRMf3AY/fuj3Lua+Doi3jdlf8teUJU5F9ahYqu2CL/LNlcjCNELR7o5DUVtNgyno6YTCREiEtbcZ2yjsAxEzj4v1O1NdXSxhkjjIb9kpCuJpk2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQpmj5j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQpmj5j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755591F000FF;
	Sat, 12 Sep 2026 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216534;
	bh=YTXjtwcFnSzRFGiAF9ZbzjkyiMh4H5BnGUvgdQjSazQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQpmj5j/AjiIpWVnrty/6L87WytvYyC4t1qnKlhd70eoQyQ3NA6dEKrIlfqFs0ySU
	 ViFXrZnIJ4TExLkcOhQDkxnv6z8SeELCUOL4hV0iURBCVeOmGQVRA6CP8rK3Cd4wRC
	 bC9bPdxAmRqZcdJU7tTFDbxUaNYo62j2oRz8Cuxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0757/1376] clk: qcom: gcc-qcm2290: dont park QUP RCGs upon registration
Date: Sat, 12 Sep 2026 08:53:03 +0200
Message-ID: <20260912065624.412558009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 9c4cee964e0ccc155e4ab8fa6cec88fffc262c63 ]

The gcc_qupv3_wrap0_s[0-5]_clk_src RCGs feed the QUP serial engines
(UART/I2C/SPI). Since shared RCGs are parked to XO at registration time,
binding the gcc-qcm2290 driver reprograms these clocks away from the
rate configured by the bootloader. For the UART used as the boot console
this drops early console output until the serial driver later
reconfigures the clock.

Switch the QUP wrap0 clock sources over to
clk_rcg2_shared_no_init_park_ops so their frequency is left unchanged at
registration time, keeping the bootloader-configured console working
across the gcc driver probe.

Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260722-agatti-no-park-v1-1-31ae3a4774e5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcm2290.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcm2290.c b/drivers/clk/qcom/gcc-qcm2290.c
index 9a6703365e619..bbcbe847fd95a 100644
--- a/drivers/clk/qcom/gcc-qcm2290.c
+++ b/drivers/clk/qcom/gcc-qcm2290.c
@@ -1082,7 +1082,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s0_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s0_clk_src = {
@@ -1098,7 +1098,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s1_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s1_clk_src = {
@@ -1114,7 +1114,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s2_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s2_clk_src = {
@@ -1130,7 +1130,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s3_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s3_clk_src = {
@@ -1146,7 +1146,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s4_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s4_clk_src = {
@@ -1162,7 +1162,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s5_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_shared_ops,
+	.ops = &clk_rcg2_shared_no_init_park_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s5_clk_src = {
-- 
2.53.0



