Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8130352000;
	Sat, 12 Sep 2026 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224280; cv=none; b=uWEo3TWiBucft0nsEZi45aSVZPaA1ozJsCXiHoLfQBKUMbh+ml8Tu7nGXPckC8ftSxTo7wyt/kqT0CVxpJUe9sN2lVtlKR/f+O/FX6VA2YYxiSf2kXcYfyeTT3hD60AzQ08oY83JLyMmgdb91kFWFvdtYGJbT+B7Fb6/bbrOY5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224280; c=relaxed/simple;
	bh=RhFjRK8I+jksXWnwyyDFgLaXSWRcmD/rxgmPkirGgnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMnG+EcDM/XgKzNXhvBSj3QjGnuDIPjZBrcY8p6DTuPHRl2AzjOJEJr11VxcolOmnoFFEyJ9o5eDrLsna27yIiurTbn48s6VGKGq+JQIHChSiHCCi6iqdAqs4wD8Q4w9UwGNE9BHl+rp0aG5gBgUNusAdIHRdNqvTXWW66fNpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmrhnxhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmrhnxhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6461F000FF;
	Sat, 12 Sep 2026 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224275;
	bh=05LXfdlJujhl3XHMRu1JvFje2w2zwjg+7tBjVH/GdhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmrhnxhn/ozUgcIrMTdO2u0kXkdf0ARFKN/msisDEo93ia4LTYg7rqMHdRaiZHqIq
	 7nn/zG2/GhRaoXQwBIJtAOFxfj8dBV+RD6sXCe+AV6L8OkWcKQ+IlyZ1hDYq+Nkyx7
	 dof2s8nFBJUBhdBbd9w6LNx5LHhBozQ6eu/zzhdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0961/1424] clk: qcom: Return expected ENOMEM error on dynamic allocation failure
Date: Sat, 12 Sep 2026 08:56:33 +0200
Message-ID: <20260912065628.834591849@linuxfoundation.org>
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
index 3d6e87872ddc3..aa5cca4f34cf2 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -146,7 +146,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (!node) {
 		fixed = devm_kzalloc(dev, sizeof(*fixed), GFP_KERNEL);
 		if (!fixed)
-			return -EINVAL;
+			return -ENOMEM;
 
 		fixed->fixed_rate = rate;
 		fixed->hw.init = &init_data;
@@ -163,7 +163,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (add_factor) {
 		factor = devm_kzalloc(dev, sizeof(*factor), GFP_KERNEL);
 		if (!factor)
-			return -EINVAL;
+			return -ENOMEM;
 
 		factor->mult = factor->div = 1;
 		factor->hw.init = &init_data;
-- 
2.53.0



