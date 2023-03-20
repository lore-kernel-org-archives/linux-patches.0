Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33C61C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EFAC4339B;
	Mon, 20 Mar 2023 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324328;
	bh=6am25mk83s35GrcKWPlhCwDLdpvRvjej6QDizOoyUJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZafIMz37CoRfwt2EC9WJv50O2W80WeqUvOKUDhWM6jB+4Yg/dgC1FzPgBbzZB7U70
	 I5IXbyd++dYpCFwtsz/qPkN00yEF6eQhvWnuHATl8EQ30EbfflACCN7geW1bxsCGmu
	 WDdDAo+0HdAHNhpGOj/TMcpEw/cM8VW8SIvUwIyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/36] hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition
Date: Mon, 20 Mar 2023 15:54:45 +0100
Message-Id: <20230320145424.959979677@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit cb090e64cf25602b9adaf32d5dfc9c8bec493cd1 ]

In xgene_hwmon_probe, &ctx->workq is bound with xgene_hwmon_evt_work.
Then it will be started.

If we remove the driver which will call xgene_hwmon_remove to clean up,
there may be unfinished work.

The possible sequence is as follows:

Fix it by finishing the work before cleanup in xgene_hwmon_remove.

CPU0                  CPU1

                    |xgene_hwmon_evt_work
xgene_hwmon_remove   |
kfifo_free(&ctx->async_msg_fifo);|
                    |
                    |kfifo_out_spinlocked
                    |//use &ctx->async_msg_fifo
Fixes: 2ca492e22cb7 ("hwmon: (xgene) Fix crash when alarm occurs before driver probe")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Link: https://lore.kernel.org/r/20230310084007.1403388-1-zyytlz.wz@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index a3cd91f232679..2dd19a4203052 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -780,6 +780,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
-- 
2.39.2



