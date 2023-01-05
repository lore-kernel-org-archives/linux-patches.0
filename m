Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854498494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07184C433EF;
	Thu,  5 Jan 2023 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923636;
	bh=//f2zPsvMgopbD5CMjIBsxA9BC423trwka1ZcB487yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD4m0YiWCGIzWnL+6aQA1aeRbxzPjoMji4fZeyEvnyXRaJDq6RwrFM9iKZLarPhsV
	 xjrXsrHvZNHURo/visaGiQ8a0J8onn8QAEl1jFw3Uym3rxTtGJeF3c6OYUf2ps4tXS
	 EHxgLJJNeFQGQT6OSOKN4WUP3qC1U3U+2lyywe9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/251] mmc: mxcmmc: fix return value check of mmc_add_host()
Date: Thu,  5 Jan 2023 13:53:40 +0100
Message-Id: <20230105125338.596967804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit cde600af7b413c9fe03e85c58c4279df90e91d13 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host().

Fixes: d96be879ff46 ("mmc: Add a MX2/MX3 specific SDHC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-4-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxcmmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index fb3ca8296273..2c57cccb0fa1 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1159,7 +1159,9 @@ static int mxcmci_probe(struct platform_device *pdev)
 	host->watchdog.function = &mxcmci_watchdog;
 	host->watchdog.data = (unsigned long)mmc;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out_free_dma;
 
 	return 0;
 
-- 
2.35.1



