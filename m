Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C11C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3F8C433D2;
	Wed, 28 Dec 2022 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243469;
	bh=pIvTbqYetTh7+SYJiQ8FiLsngdD7fn0kVTwx86Wz7hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtTOanJdaxsDsQkxEDV2y5BdKRpy6/Ux+5gOQddu3FLIBcxBj/MK/IhtJR55H+B5B
	 qwMma0k6sfoAzcUtDDyFmUkuXZqhggykouE84W1MMUz+ixLXP5ipWmSGY02gGcWHoV
	 t/uEdE5uU9J5JX1sRjdjIPOG1L3wSRLANIlGZQcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0496/1146] mmc: moxart: fix return value check of mmc_add_host()
Date: Wed, 28 Dec 2022 15:33:55 +0100
Message-Id: <20221228144343.653664297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index dfc3ffd5b1f8..52ed30f2d9f4 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -665,7 +665,9 @@ static int moxart_probe(struct platform_device *pdev)
 		goto out;
 
 	dev_set_drvdata(dev, mmc);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out;
 
 	dev_dbg(dev, "IRQ=%d, FIFO is %d bytes\n", irq, host->fifo_width);
 
-- 
2.35.1



