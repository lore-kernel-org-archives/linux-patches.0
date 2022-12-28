Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F35C433EF;
	Wed, 28 Dec 2022 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240197;
	bh=e3OsxW13efZx5c2lO7pbpoPbHRXeTSQvQ1JS+fLpk50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcniUxQVW6zUisN0d8j5VjHCj78vjpPXMpchsxOGQhoT5znqmyvoARUJU8Qr+s7Mp
	 McdXQ7lhSVt18CQr+JYr60jKkuMjpMV8YFAU/lluudFWr/f2yga+HjpSplBzJS3jI8
	 F26sV+AY4NDiyzBxeQE1O5pg86OcoJi+9raiJh2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/731] mmc: pxamci: fix return value check of mmc_add_host()
Date: Wed, 28 Dec 2022 15:36:41 +0100
Message-Id: <20221228144305.096091950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 80e1ef3afb8bfbe768380b70ffe1b6cab87d1a3b ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, ->exit() need be called to uninit the pdata.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-5-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/pxamci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 55868b6b8658..e25e9bb34eb3 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -763,7 +763,12 @@ static int pxamci_probe(struct platform_device *pdev)
 			dev_warn(dev, "gpio_ro and get_ro() both defined\n");
 	}
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		if (host->pdata && host->pdata->exit)
+			host->pdata->exit(dev, mmc);
+		goto out;
+	}
 
 	return 0;
 
-- 
2.35.1



