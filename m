Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C8168D0;
	Sat,  3 Feb 2024 04:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933875; cv=none; b=BC/NUZZN8WL/qGVrVAPtSn4aO3tXMf74yQ/WDHf3offys5TYCRnbHxIcHXyUHB25GMWmjpcSPgtExW7oVOfPHTpOSgmFvBR5i4sVHhII1LG4NF1Dyt1C6GPg193Eib6GG9ex8hDfX9CHoo0U9O3yVGwIKfnpMPTtCgfNqNc6L3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933875; c=relaxed/simple;
	bh=Oq1dj9Dr2vHpx3vHUAK2maMurBvwJVsSHHS+hZSvPpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOwcvwyCQtyH6RyGmBX8sLWBMkQdJrC+rwPKUWVu4gcKdPhTZjcNVqmxwL9x5jdrAdb2fcgS4ZlQFs/S6+v5kIzoNEsilEBBz2pam5/NAVLiyo6fciUsBZxfru32RV02uajSAfrfNlhA2vaCL49jn85CN3ccEkF+JJNF/gh0OU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzWQSgzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzWQSgzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD38CC433C7;
	Sat,  3 Feb 2024 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933874;
	bh=Oq1dj9Dr2vHpx3vHUAK2maMurBvwJVsSHHS+hZSvPpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzWQSgzQb4NBiScpr/n4wTf/DS2u/oylfqFekL440KjzBGWVDnFOuiY4VLlyelXnN
	 PWBhwhuULYQYs0P4XzQZ1LU1c5KgTMAHuLqU0nbIiSuqJ0de/KcNxa+OOvn1J3Ffze
	 YH99ZF6qZVjhX0heKtBKi5F8CIU+1B3l4x5xcryc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 213/353] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Fri,  2 Feb 2024 20:05:31 -0800
Message-ID: <20240203035410.433009101@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit bfbea9e5667cfa9552c3d88f023386f017f6c308 ]

In cases where kcalloc() fails for the 'clk_data->clks' allocation, the
code path does not handle the failure gracefully, potentially leading
to a memory leak. This fix ensures proper cleanup by freeing the
allocated memory for 'clk_data' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210165040.3407545-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clk-hi3620.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 2d7186905abd..5d0226530fdb 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -466,8 +466,10 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
 		return;
 
 	clk_data->clks = kcalloc(num, sizeof(*clk_data->clks), GFP_KERNEL);
-	if (!clk_data->clks)
+	if (!clk_data->clks) {
+		kfree(clk_data);
 		return;
+	}
 
 	for (i = 0; i < num; i++) {
 		struct hisi_mmc_clock *mmc_clk = &hi3620_mmc_clks[i];
-- 
2.43.0



