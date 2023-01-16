Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA83F46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50060C433EF;
	Mon, 16 Jan 2023 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886303;
	bh=AAn9ZkdBxOPqpVV2IYV/HJWyyR5U5eVwWNDBxy42Tsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdUc+YqzuCeY8WVFXcao6zQs1aNXZaXcrJA/cFdw6w2MwXAYNc8ERgUhnDHUhU+s4
	 cO8GbaJi+b/Eju9ZKnBr10jTr0OwbAarnwVHyi+ks6oXCDDjBoUov7LbQBuqvIdwpR
	 U+MoXmiJCWzsDkp5Y6GeCVZ8rSCEGbHs8AMSu3Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GUO Zihua <guozihua@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 378/658] rtc: mxc_v2: Add missing clk_disable_unprepare()
Date: Mon, 16 Jan 2023 16:47:46 +0100
Message-Id: <20230116154926.848871051@linuxfoundation.org>
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
index d349cef09cb7..48595b00ebb3 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -337,8 +337,10 @@ static int mxc_rtc_probe(struct platform_device *pdev)
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



