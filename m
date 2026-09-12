Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DE03F788A;
	Sat, 12 Sep 2026 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230615; cv=none; b=clcJ5+fDd+QVkgi/appVU4yXQIwSLD+6hNo0xkjGIS7/KkFiF/YXJuGwsrqbM/F5eT3bPsaMKkDGHmGoBcPxGHKKwwYcBbpuV4Ytqkff4xePOFLTXagsH76o6Oo3Janmq1dlOlWVjg+798+ljLSyQGQ7zWxloHzLRbmGHMImtOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230615; c=relaxed/simple;
	bh=iS3AgJe2VEDzJ4+sbJGuopPGIJ7dTZ1qWI3u4BlkQsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1a8CfKv4MqQUp0fq6wt/OZS/q0D4YGfe1SqEuVm04gj9umiTgUy1SC4KnclmAxMqhu24hJgh8c9A0bZFY5ZOzEBtCB+ioyWmaVg+6UStpfQbKMFNuvYdDUJjEu/D8DHbCovt3fEILPaIZpO8C+okZkMWiO+OtXOFszxoTqZ93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvGa65jP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvGa65jP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2507D1F000FF;
	Sat, 12 Sep 2026 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230614;
	bh=4NeKiUvWoebznrDMJGpiH6bgcnhJvgKKoue5KtbSlCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvGa65jPouBykFtxJF9U6j2lZqZQbsy/eL7KAj51nKGEfzFVDtllpeUPs5XZ8GDX/
	 OuwnLq/7eb0kCauVz4m6wcaL2zxrWk9eP162iCUOtHaRvWs40crPQT3vfe6LXanB0H
	 zmo25fe7ZGXN+NijGFI9NkKO+UYP2f7hxpJ1F6OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0788/1191] clk: qcom: Return expected ENOMEM error on dynamic allocation failure
Date: Sat, 12 Sep 2026 08:58:36 +0200
Message-ID: <20260912065605.975126133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86a5283381ae7..946a6c7fdb3a8 100644
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



