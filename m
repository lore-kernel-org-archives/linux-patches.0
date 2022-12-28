Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641831C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C643AC433D2;
	Wed, 28 Dec 2022 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244652;
	bh=LYR2MszpcfxALpm6QqqLQhYFaWt7DyQX8GcTxgD7xv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx5e9uizm12JqRK6XuDRRHZnrfDC9cFAPwaJjRrBQAqz6lUE0H19Fp+frSXe8hE0u
	 /MKz9P2sVm350JSZN9p5r/ZV38VxtxCKEF2T4XTybSHoPW1w5WaIggBTj2VQDEbUpL
	 jNxBYJ8SxyWebYLb2YFaFnLdi7JKZZbtPse9qeD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0748/1073] power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()
Date: Wed, 28 Dec 2022 15:38:56 +0100
Message-Id: <20221228144348.338920745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 97f2b4ddb0aa700d673691a7d5e44d226d22bab7 ]

cw_bat_probe() calls create_singlethread_workqueue() and not checked the
ret value, which may return NULL. And a null-ptr-deref may happen:

cw_bat_probe()
    create_singlethread_workqueue() # failed, cw_bat->wq is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: b4c7715c10c1 ("power: supply: add CellWise cw2015 fuel gauge driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 6d52641151d9..473522b4326a 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -699,6 +699,9 @@ static int cw_bat_probe(struct i2c_client *client)
 	}
 
 	cw_bat->battery_workqueue = create_singlethread_workqueue("rk_battery");
+	if (!cw_bat->battery_workqueue)
+		return -ENOMEM;
+
 	devm_delayed_work_autocancel(&client->dev,
 							  &cw_bat->battery_delay_work, cw_bat_work);
 	queue_delayed_work(cw_bat->battery_workqueue,
-- 
2.35.1



