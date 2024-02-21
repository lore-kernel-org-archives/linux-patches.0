Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FF57F47A;
	Wed, 21 Feb 2024 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524367; cv=none; b=p/mhDJvGUAyPn/im3Evnvv4RGPubSadzuVUxlSD+4Lwy8z4xIq05/LlD+TxhFAXvfHlz5+M4jCVsdTQb+DEDwIkv0BKOkThz40X6q81JuY2hkXVmqzHS2nXVP+PVsJE1ollRKcVz6UZ65UOxaJPk3RGWQCkW8qSwmIjwQ28Idxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524367; c=relaxed/simple;
	bh=Kcj1GjJnEEIbUnfWabWkqYv0bYJtthbv4KrxSAytib4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGyQdryHhwwxLwf546jGb48XVELFFcgWRMXTj3yPeWr/Adt/4yZLI89xYm5qGxhk76FS/xktMvQxjr7L5a6T31nA2IsDNT/ZRNLEYvTkgHuIJTzA23IWMHn+iopJ8XzwPHk+1Ax/cqULPDuJjFkDTbQPzPQk1wEXXzMir4xHCbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzRo5XwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzRo5XwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD52C433C7;
	Wed, 21 Feb 2024 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524367;
	bh=Kcj1GjJnEEIbUnfWabWkqYv0bYJtthbv4KrxSAytib4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzRo5XwJQIRudXSezqcXR91gIQqDeoOvGh+4sjaqIBY96XjR+Nomz80sP6yGsg/lh
	 WAsAD6PwXWX2bua6c0Ucxtxbt3eSexfKe6InfqWiYkatlhE7wJfg96elwWeciAVjq3
	 TGTkag/floAH8r7tjTb+vo/BJhpSnSwSh7DZj430=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/379] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Wed, 21 Feb 2024 14:06:13 +0100
Message-ID: <20240221130000.644712542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



