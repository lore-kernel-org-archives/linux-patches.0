Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF806FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B7DC433D2;
	Mon, 16 Jan 2023 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887842;
	bh=/QvuFOCiR0BO1zt5sRKCC/RGU3o4j+dOhjox9YrTnrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeC5LG8d3qPHeW8H16S1n3gZqrrcPKQntT5ne8Mja0Rzzz11ic/pJs6hWCupSyZ7R
	 7gRz+2f5Yw0JYSGXzT4RbaUT4xmDxBHCdnHC3/pt3ouFq8DYS/3/K3lNR2ZTbRkkpC
	 0pgowvgcOStQCYGt03uckB9chx2JaMn3d9VAD0I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GUO Zihua <guozihua@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 303/521] rtc: mxc_v2: Add missing clk_disable_unprepare()
Date: Mon, 16 Jan 2023 16:49:25 +0100
Message-Id: <20230116154900.670414817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 55d5a86618d3b1a768bce01882b74cbbd2651975 ]

The call to clk_disable_unprepare() is left out in the error handling of
devm_rtc_allocate_device. Add it back.

Fixes: 5490a1e018a4 ("rtc: mxc_v2: fix possible race condition")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20221122085046.21689-1-guozihua@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index 45c7366b7286..c16aa4a389e9 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -335,8 +335,10 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	}
 
 	pdata->rtc = devm_rtc_allocate_device(&pdev->dev);
-	if (IS_ERR(pdata->rtc))
+	if (IS_ERR(pdata->rtc)) {
+		clk_disable_unprepare(pdata->clk);
 		return PTR_ERR(pdata->rtc);
+	}
 
 	pdata->rtc->ops = &mxc_rtc_ops;
 	pdata->rtc->range_max = U32_MAX;
-- 
2.35.1



