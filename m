Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911771FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6E3C433EF;
	Fri,  3 Feb 2023 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420000;
	bh=BTTPIwi8bnXr+I8yxXvlcdUEYS1LQcH+Pwxq3JEea3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbh7MYnUTmJd128ThbHMEy6jUCPU0LwjZv6tXigZNsVIzDBGc2K/ZgJZkSVIMLVPe
	 /NrhRTx7KJtf00RBrOA/0Kt+3jwy6lBlf/8Utk1MlYdyapdqGIQHG37AKyqznXjQkK
	 S6f/3bQXLGu+x76Frle2zcZXcC45w6fpaeHOTY5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/134] w1: fix deadloop in __w1_remove_master_device()
Date: Fri,  3 Feb 2023 11:12:32 +0100
Message-Id: <20230203101026.005043183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

[ Upstream commit 25d5648802f12ae486076ceca5d7ddf1fef792b2 ]

I got a deadloop report while doing device(ds2482) add/remove test:

  [  162.241881] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  [  163.272251] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  [  164.296157] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  ...

__w1_remove_master_device() can't return, because the dev->refcnt is not zero.

w1_add_master_device()			|
  w1_alloc_dev()			|
    atomic_set(&dev->refcnt, 2)		|
  kthread_run()				|
					|__w1_remove_master_device()
					|  kthread_stop()
  // KTHREAD_SHOULD_STOP is set,	|
  // threadfn(w1_process) won't be	|
  // called.				|
  kthread()				|
					|  // refcnt will never be 0, it's deadloop.
					|  while (atomic_read(&dev->refcnt)) {...}

After calling w1_add_master_device(), w1_process() is not really
invoked, before w1_process() starting, if kthread_stop() is called
in __w1_remove_master_device(), w1_process() will never be called,
the refcnt can not be decreased, then it causes deadloop in remove
function because of non-zero refcnt.

We need to make sure w1_process() is really started, so move the
set refcnt into w1_process() to fix this problem.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221205080434.3149205-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1.c     | 2 ++
 drivers/w1/w1_int.c | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index e58c7592008d..9a9c6f54304e 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1131,6 +1131,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index b3e1792d9c49..3a71c5eb2f83 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -51,10 +51,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
 
-	/* 1 for w1_process to decrement
-	 * 1 for __w1_remove_master_device to decrement
+	/* For __w1_remove_master_device to decrement
 	 */
-	atomic_set(&dev->refcnt, 2);
+	atomic_set(&dev->refcnt, 1);
 
 	INIT_LIST_HEAD(&dev->slist);
 	INIT_LIST_HEAD(&dev->async_list);
-- 
2.39.0



