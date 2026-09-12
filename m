Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564037B030;
	Sat, 12 Sep 2026 08:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200667; cv=none; b=Q/ccFbxB2HSrgk3ulFjEoNTlyS0PQMBltXTssKLkb95PL3Wa7x1S/CZWz00+kLSmDzikpxeO6kLAMjBDERyj80JCItLae46LrnYaVf2V8JsMaWy6pRZ6JLtRC0qVD60B2OYNtZBz0qmTU2lKxAnSkhcxAF4VgtSfZ8pkegOc8QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200667; c=relaxed/simple;
	bh=d8DA3G9JsOcKDcHawpfeWnSm+Ax+/qaksyqLgnTyK9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htw63eAUwvl9WQInbqeDeE7OmlBIjcvzeBMZILADtmhzA6Hzi7U9gFqJpoB5NRGaTY8rzl3uyo7dN0YvVIPdu5mseqa8u861jgk7uLjIeor+S/ltmFHr9mDaRoFKs+eiUm/RkCDN7YOmAQtd8GACrMSSiphhfuQvl4/qMlrFDZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrfSdYLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrfSdYLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4811F000FF;
	Sat, 12 Sep 2026 08:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200666;
	bh=Ljif5MUxtRmm0e+X9BAiMRrSTGAhiiUCuR8vGzFqMoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrfSdYLYamcHtpGr0nBnsXvAvH5ToN4pG3T48RtM42HDl4+VzyBPX+pHF1C5959Dr
	 SqoWJ9diEkw9/CuFC08gQ0p+A7/tRdWqu4rshrXQOtOd19rZbKKeTT4AJLoCsXctad
	 JV2v24neBfU7ZnX6Q6rSS5MDaeKNtl/yNfpRI/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0838/1815] clk: qcom: Return expected ENOMEM error on dynamic allocation failure
Date: Sat, 12 Sep 2026 08:43:08 +0200
Message-ID: <20260912065708.587287136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 22d9257f08913b6eec3e8ece4d13d9c41f14428b ]

If a dynamic memory allocation fails, the returned error code in clock
controller driver probe functions on a few legacy platforms should be
set to -ENOMEM instead of -EINVAL.

Fixes: ee15faffef11 ("clk: qcom: common: Add API to register board clocks backwards compatibly")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260629162127.3910603-1-vz@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index eec369d2173b5..0e8f380873af0 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -169,7 +169,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (!node) {
 		fixed = devm_kzalloc(dev, sizeof(*fixed), GFP_KERNEL);
 		if (!fixed)
-			return -EINVAL;
+			return -ENOMEM;
 
 		fixed->fixed_rate = rate;
 		fixed->hw.init = &init_data;
@@ -186,7 +186,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (add_factor) {
 		factor = devm_kzalloc(dev, sizeof(*factor), GFP_KERNEL);
 		if (!factor)
-			return -EINVAL;
+			return -ENOMEM;
 
 		factor->mult = factor->div = 1;
 		factor->hw.init = &init_data;
-- 
2.53.0



