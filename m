Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A471FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5016C433D2;
	Fri,  3 Feb 2023 10:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419521;
	bh=D4M29BTteyS3xWJOfQL/c5/hQpFbOp7cxr30QXQYRbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6WtSqht9ptjyuhmCx7a7lscLw/T+IZ+nftrHBVb8Oi+7l4fowdtfZP5+bhAwhHBt
	 SM5I5KWKcNn86nNkA9ZG3KgnVX1Ssr/3DpfrwfK3AzZAmd5G7HC1TtE29dlY/1PZA0
	 X63grBg939siGAYEjPudQRcsJbTXCR5HQixipexY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/80] w1: fix deadloop in __w1_remove_master_device()
Date: Fri,  3 Feb 2023 11:12:24 +0100
Message-Id: <20230203101016.464087441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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
index 890c038c25f8..c1d0e723fabc 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1140,6 +1140,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 1c776178f598..eb851eb44300 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -60,10 +60,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
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



