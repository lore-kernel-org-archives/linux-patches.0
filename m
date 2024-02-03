Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712DC182B5;
	Sat,  3 Feb 2024 04:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933625; cv=none; b=FB6B/818nKZJR7Lr8k+YsZvv/hnww78fT/F4gWZtxCVpUqljBzVE+msK7aeMSVbzfscYYYUKWhC1bLQtUPT9kxFUNLULkyUkbdc8NkejR02W0N+vWpdEKwYekRNKrikHNgmH3oip7VI/2hThWDwgVVtMoc7DfJQTZNScNYGFWZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933625; c=relaxed/simple;
	bh=mIa75TZ0nyK3rclLCQFjcn2ssygx1MNdN6DNNbaPThI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKlqh3TcDyXBQpDKRLB8MuDkcEzWkPQmDzo4dHzu3skN7uZm/CSMOIB/OVMjwSkfTp/CQdZplO6HranHxvmOQ7OTNcde40H8S78ecf6k5yQZgNzDEQB4GVOn050obVRTx1vJZlppoG+K11mqJbsI2nZZoP17o1Srl/wAFbfUayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDIZvZai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDIZvZai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A003C433C7;
	Sat,  3 Feb 2024 04:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933625;
	bh=mIa75TZ0nyK3rclLCQFjcn2ssygx1MNdN6DNNbaPThI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDIZvZaisiYa3jiQ07kq7isIeWz7lDZNBCuY0/KJTygFUyhd5vOhBJ3vj9IhvtITg
	 VRFKB6UaSQJlCXc0225dWlNPvEY13G7dlXOGPUu262Y1ok+eJWxERrZltl45ud9pSy
	 /vlnu9NV1rP2FJrJC3t0zpJIhztzVGJ/RKxkpSK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/322] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Fri,  2 Feb 2024 20:04:58 -0800
Message-ID: <20240203035405.730862741@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



