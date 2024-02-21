Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8C13CF42;
	Wed, 21 Feb 2024 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525468; cv=none; b=pEgtv8bOiyyrUcC5cvM3OJMv7IzJQcuOoXsZA38MfXX3Y1vZN+HWz5YAKZSfs1mSum8sMMe53tqQgj5SZnhcRuoGryFTkM9gMFdqjIQ1GK7eb+Ni4gkzZQbrjD8o2IGQoQotuDHFPSXdX0lGO/xi6pbgRJmLDRv6VG3B946Rn5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525468; c=relaxed/simple;
	bh=exafPFEsj56r1FJkHiJPwWj0FNub1fTj9xIXeAi6Vng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT3QPgY6gLaMh2RTSQ4GW4Gk6qxwAjZCr8lyQObQd1yVMqZjMJcWPIvyCNebpSk/LhLxMBMbFFUN9+Fkip3Jf0eA+xjyLqyOdEvbpFic4LOpBJC0UlbYT25FwSm6TPL7HayZJaVag8FGShsTQbcg3SRPHgqNE7/Fm8zt73ph0zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCcfL++x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCcfL++x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26C9C433F1;
	Wed, 21 Feb 2024 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525467;
	bh=exafPFEsj56r1FJkHiJPwWj0FNub1fTj9xIXeAi6Vng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCcfL++xio/m4WQG/aapecpPbFy4ZvGpT7nQZcSU1+jlUZZXeLn4eZEPJnh47OdIS
	 syFKh9tavl1lMWtb0gxNk5E6d3cCDDncNAPR2pzGOeFgWFGzUSJDVL4VlGVCYicaqc
	 rXr+nZUDXVKn/PBFVqs1ThMrHkWukyrvTJ/bz0uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/267] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Wed, 21 Feb 2024 14:07:56 +0100
Message-ID: <20240221125944.291692958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a3d04c7c3da8..eb9c139babc3 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -467,8 +467,10 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
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



