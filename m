Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3676FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B737EC433EF;
	Mon, 16 Jan 2023 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888695;
	bh=gKLD9ZWWuo/UinEmfFH5+PYIvivA1C8VvjWP41wq1Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzawRthccC9zqrGtAVc+RMK3E/DYhsDmiEusK9PGzxqzY7u0SbkjwYdSyEIDQeuvK
	 oWDOv79l5eBGjMb37fZ77sLKLFaRXZXVoOk5fFGN+tFYgNqytBMOdLAmU+nKcuwq30
	 9hyrjun5XysIDXaMiE14hbSTn3V0TkqE7AgwD/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 103/338] mmc: moxart: fix return value check of mmc_add_host()
Date: Mon, 16 Jan 2023 16:49:36 +0100
Message-Id: <20230116154825.374757417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0ca18d09c744fb030ae9bc5836c3e357e0237dea ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host().

Fixes: 1b66e94e6b99 ("mmc: moxart: Add MOXA ART SD/MMC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-3-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/moxart-mmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 1552d1f09c5c..52307dce08ba 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -660,7 +660,9 @@ static int moxart_probe(struct platform_device *pdev)
 		goto out;
 
 	dev_set_drvdata(dev, mmc);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out;
 
 	dev_dbg(dev, "IRQ=%d, FIFO is %d bytes\n", irq, host->fifo_width);
 
-- 
2.35.1



