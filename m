Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC75C433C8;
	Sun, 16 Jul 2023 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537818;
	bh=oSXOFgtcyXlpIAsrvAp1cvh7AyyhdxLWT25YlAShx8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQLW5wfIBDgC6Dlc69EUGJgRpyu52eStVjN0O2WegcxmsjbfSYnJPknTq/4DGUwqn
	 OOlMTnhK+ndJzV1JYm13bEQS6y6OG1eOFyTJYtqvGqr2kXBrkHcuI7qpDg+bbKkNfi
	 Pnd3b1kuQf8FEBS8NJ3+P1sJIO521FwtaSHE0sfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 231/800] Input: cyttsp4_core - change del_timer_sync() to timer_shutdown_sync()
Date: Sun, 16 Jul 2023 21:41:24 +0200
Message-ID: <20230716194954.455306719@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit dbe836576f12743a7d2d170ad4ad4fd324c4d47a ]

The watchdog_timer can schedule tx_timeout_task and watchdog_work
can also arm watchdog_timer. The process is shown below:

----------- timer schedules work ------------
cyttsp4_watchdog_timer() //timer handler
  schedule_work(&cd->watchdog_work)

----------- work arms timer ------------
cyttsp4_watchdog_work() //workqueue callback function
  cyttsp4_start_wd_timer()
    mod_timer(&cd->watchdog_timer, ...)

Although del_timer_sync() and cancel_work_sync() are called in
cyttsp4_remove(), the timer and workqueue could still be rearmed.
As a result, the possible use after free bugs could happen. The
process is shown below:

  (cleanup routine)           |  (timer and workqueue routine)
cyttsp4_remove()              | cyttsp4_watchdog_timer() //timer
  cyttsp4_stop_wd_timer()     |   schedule_work()
    del_timer_sync()          |
                              | cyttsp4_watchdog_work() //worker
                              |   cyttsp4_start_wd_timer()
                              |     mod_timer()
    cancel_work_sync()        |
                              | cyttsp4_watchdog_timer() //timer
                              |   schedule_work()
    del_timer_sync()          |
  kfree(cd) //FREE            |
                              | cyttsp4_watchdog_work() // reschedule!
                              |   cd-> //USE

This patch changes del_timer_sync() to timer_shutdown_sync(),
which could prevent rearming of the timer from the workqueue.

Fixes: 17fb1563d69b ("Input: cyttsp4 - add core driver for Cypress TMA4XX touchscreen devices")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20230421082919.8471-1-duoming@zju.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/cyttsp4_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index 0cd6f626adec5..7cb26929dc732 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -1263,9 +1263,8 @@ static void cyttsp4_stop_wd_timer(struct cyttsp4 *cd)
 	 * Ensure we wait until the watchdog timer
 	 * running on a different CPU finishes
 	 */
-	del_timer_sync(&cd->watchdog_timer);
+	timer_shutdown_sync(&cd->watchdog_timer);
 	cancel_work_sync(&cd->watchdog_work);
-	del_timer_sync(&cd->watchdog_timer);
 }
 
 static void cyttsp4_watchdog_timer(struct timer_list *t)
-- 
2.39.2



