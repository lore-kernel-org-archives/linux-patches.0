Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067C434EEE4;
	Tue, 16 Dec 2025 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885613; cv=none; b=juHKOM+D3Wp2hICi+tQaBQo+E12onAd0X84NqNRlj0Zve3lANriytwvk3YGn/5fnLNYeXmU0OHIgWyl3Kcng6wy6bspCyHZO91XWkWa7yHVNfenipVxoLa8rM98/7CErWm5KMNwr89zvSlPNSteSCzmZN7osnzvZI16oaCwCZPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885613; c=relaxed/simple;
	bh=yHk4urGp57CrnGj1viNWXTazc4tlcjVvW8IguAJNcDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzWGKSyBuZ/f75sr/zFop9KQXjsdVKSdE+mBlt6ocN0V1TxbrgDtn8G47X2mlCeZXHHNJ8WWs7C9U4EUuGhqe0HjNi+LUytMtzH52IlhxKjrkXDVAwFRMHVlssCgchQ+U3pBzTVyD//5q11+eJj2+AOLo3gHgBYx/47IbNtEftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6FeNJVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6FeNJVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5004CC4CEF1;
	Tue, 16 Dec 2025 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885612;
	bh=yHk4urGp57CrnGj1viNWXTazc4tlcjVvW8IguAJNcDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6FeNJVwJC63XvqvSXulKfl0bkEZhgl+RdiGSnCF+FJP+vrsCSGk9hmd7FteHmZ2G
	 QAtAssO54i528lgE7VQdFxl2U/tGwojZhRjxEN7ay6u6h12SaxmKN5cVCnRChJEgAh
	 eBd6uTSQKVB2mvRVJ8V36GHaLD0oxiwrg3FsVS/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 191/507] md: fix rcu protection in md_wakeup_thread
Date: Tue, 16 Dec 2025 12:10:32 +0100
Message-ID: <20251216111352.431484952@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 0dc76205549b4c25705e54345f211b9f66e018a0 ]

We attempted to use RCU to protect the pointer 'thread', but directly
passed the value when calling md_wakeup_thread(). This means that the
RCU pointer has been acquired before rcu_read_lock(), which renders
rcu_read_lock() ineffective and could lead to a use-after-free.

Link: https://lore.kernel.org/linux-raid/20251015083227.1079009-1-yun.zhou@windriver.com
Fixes: 446931543982 ("md: protect md_thread with rcu")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 ++++++--------
 drivers/md/md.h |  8 +++++++-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 07e48faa87e0b..436aab6c5d3de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -100,7 +100,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
-static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
+static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
 /*
  * Default number of read corrections we'll attempt on an rdev
@@ -4984,7 +4984,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 	 * Thread might be blocked waiting for metadata update which will now
 	 * never happen
 	 */
-	md_wakeup_thread_directly(mddev->sync_thread);
+	md_wakeup_thread_directly(&mddev->sync_thread);
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
@@ -8196,22 +8196,21 @@ static int md_thread(void *arg)
 	return 0;
 }
 
-static void md_wakeup_thread_directly(struct md_thread __rcu *thread)
+static void md_wakeup_thread_directly(struct md_thread __rcu **thread)
 {
 	struct md_thread *t;
 
 	rcu_read_lock();
-	t = rcu_dereference(thread);
+	t = rcu_dereference(*thread);
 	if (t)
 		wake_up_process(t->tsk);
 	rcu_read_unlock();
 }
 
-void md_wakeup_thread(struct md_thread __rcu *thread)
+void __md_wakeup_thread(struct md_thread __rcu *thread)
 {
 	struct md_thread *t;
 
-	rcu_read_lock();
 	t = rcu_dereference(thread);
 	if (t) {
 		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
@@ -8219,9 +8218,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
 		if (wq_has_sleeper(&t->wqueue))
 			wake_up(&t->wqueue);
 	}
-	rcu_read_unlock();
 }
-EXPORT_SYMBOL(md_wakeup_thread);
+EXPORT_SYMBOL(__md_wakeup_thread);
 
 struct md_thread *md_register_thread(void (*run) (struct md_thread *),
 		struct mddev *mddev, const char *name)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a030793..c989cc9f6216b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -878,6 +878,12 @@ struct md_io_clone {
 
 #define THREAD_WAKEUP  0
 
+#define md_wakeup_thread(thread) do {   \
+	rcu_read_lock();                    \
+	__md_wakeup_thread(thread);         \
+	rcu_read_unlock();                  \
+} while (0)
+
 static inline void safe_put_page(struct page *p)
 {
 	if (p) put_page(p);
@@ -891,7 +897,7 @@ extern struct md_thread *md_register_thread(
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp);
-extern void md_wakeup_thread(struct md_thread __rcu *thread);
+extern void __md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern enum sync_action md_sync_action(struct mddev *mddev);
-- 
2.51.0



