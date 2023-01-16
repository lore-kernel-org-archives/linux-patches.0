Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E187EC433EF;
	Mon, 16 Jan 2023 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885795;
	bh=2N/zyrmvZxVXf9UnfBaY5VptyHvddOnsQozxmqhL+Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFSKRS36Tbdkaf+orxweBmSVFJLvrNVnMgwUCATeI9kXL/n/67ATNSPzvn3g+pd1h
	 /tP5xjRoRL0cONGBgyFYw4cexlJVXb75E9+QvofiJAZ0wbu+X4O9OPiK2swcfXgnMx
	 Ex5rjAcAy1mLxADHl2k9V24iYuQuRJ2PyXBSFd/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/658] drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()
Date: Mon, 16 Jan 2023 16:44:05 +0100
Message-Id: <20230116154916.636639693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 7ad4384d53c67672a8720cdc2ef638d7d1710ab8 ]

Add the missing clk_disable_unprepare() before return from
tegra_dc_probe() in the error handling path.

Fixes: f68ba6912bd2 ("drm/tegra: dc: Link DC1 to DC0 on Tegra20")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index c410221824c1..923899b95c88 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2458,8 +2458,10 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	usleep_range(2000, 4000);
 
 	err = reset_control_assert(dc->rst);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(dc->clk);
 		return err;
+	}
 
 	usleep_range(2000, 4000);
 
-- 
2.35.1



