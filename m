Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001DA5475F;
	Sat, 12 Sep 2026 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224194; cv=none; b=nMg9ZSodqqJ1OFe2RWMVgMRuT0GtQCnuL8CCTQD7Viv4BpQ75xi2cQSSZwLzT/X0sNt1cRvn+z5tX3JGd2Gf934P9wniTQg2FaUpJccs336QphZPHTnKZXpElY0DDxgliOfYcmHQo/UDWOI3A9DO4epNOylWWK9P5CiTTtH6dsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224194; c=relaxed/simple;
	bh=1o+Y0l6MbbnSvLz79H6KDaSZiHP6TU+xFhXCFpVDYrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovtkKzFcwMH914E9MTNSMYEIz8pWOtFew/2Nlza53lBNmyOFNQYQiQNuuzFi+rdX1I14s36Nf//ym4aHAuPHOr45+XOzdLONNZEi8zzkwUzNxx4B1mvxuYVOllKnDIrqDxZAVIxqbCyO9xSOSY0Q2X7zjpyR6EVuvpzSXyC1PH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YukWTyQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YukWTyQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CC11F000FF;
	Sat, 12 Sep 2026 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224192;
	bh=H2Ohs/2dRtJfkx7MHkVSjuFAkVWAfGPyA46JhY6L1nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YukWTyQNXp+xWjU4bNnv5/6nFmzlEAseUV/A0Ras6wpugXUPhljj3CS9UPEg9VB6l
	 ukOul34soulJ4L7anEai6ohQnOH0pJiMpESiKOxToudxvuuaYL/fAGYLqIlOn3iXzN
	 SdhnAePcoQL08VkBLh50fx3RoIITZM2HtcOsLCZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0942/1424] clk: qcom: gcc-qcm2290: dont park QUP RCGs upon registration
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065628.415973293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48995e50c6bd7..7b9c978f92332 100644
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



