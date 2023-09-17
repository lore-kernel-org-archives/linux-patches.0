Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3886FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9186DC433C7;
	Sun, 17 Sep 2023 19:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980378;
	bh=VhaUDfkEwSMloKhp8Rp2ZIuk8+GkIjfPp2aWUzAEGmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwwl4g9593QzSQUZCIvcKPQqPRTWJ7RCAfpvRugbJdSsF+igYNwU8pLhMj7r3ViqO
	 kIrxJAyW8E4QWvkfOj6SVum0wCyFTwA3bnbFttMRoXtOd1+TCopsLl8V3Dm0JOwJbd
	 n/TvA3LTc2gnZPSs+hyvsqfGrEeMIwU321HHznyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 175/285] sh: push-switch: Reorder cleanup operations to avoid use-after-free bug
Date: Sun, 17 Sep 2023 21:12:55 +0200
Message-ID: <20230917191057.691406198@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 246f80a0b17f8f582b2c0996db02998239057c65 ]

The original code puts flush_work() before timer_shutdown_sync()
in switch_drv_remove(). Although we use flush_work() to stop
the worker, it could be rescheduled in switch_timer(). As a result,
a use-after-free bug can occur. The details are shown below:

      (cpu 0)                    |      (cpu 1)
switch_drv_remove()              |
 flush_work()                    |
  ...                            |  switch_timer // timer
                                 |   schedule_work(&psw->work)
 timer_shutdown_sync()           |
 ...                             |  switch_work_handler // worker
 kfree(psw) // free              |
                                 |   psw->state = 0 // use

This patch puts timer_shutdown_sync() before flush_work() to
mitigate the bugs. As a result, the worker and timer will be
stopped safely before the deallocate operations.

Fixes: 9f5e8eee5cfe ("sh: generic push-switch framework.")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230802033737.9738-1-duoming@zju.edu.cn
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/drivers/push-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index c95f48ff3f6fb..6ecba5f521eb6 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -101,8 +101,8 @@ static int switch_drv_remove(struct platform_device *pdev)
 		device_remove_file(&pdev->dev, &dev_attr_switch);
 
 	platform_set_drvdata(pdev, NULL);
-	flush_work(&psw->work);
 	timer_shutdown_sync(&psw->debounce);
+	flush_work(&psw->work);
 	free_irq(irq, pdev);
 
 	kfree(psw);
-- 
2.40.1



