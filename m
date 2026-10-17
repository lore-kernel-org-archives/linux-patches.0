Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE81392829;
	Sat, 17 Oct 2026 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258276; cv=none; b=HxRN+MeL5HieH/izgz1BmaN8M3Lym1V9bLhLpFKXhLbb1JIpWDPPS5Hp1mvdR1q/Gygz565rnt55Yd38eBECY3uA39G9hODMuWcOwgS/yZU4NvBOU2M5vqwcHUuR/wjI7u0XhQXORxF9DzQ9AC5sRhS1iNWibGrfzs5apZuOfRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258276; c=relaxed/simple;
	bh=fuZW0JjYQYUPt8aPvQULTULdYVRtabSHyvknMRchnEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR9UKU1DHxh0GW5vFMulRVrlgto0i9a0qChvDEM+j53/D1f5lIv9k55oH5qBvUQ/l3gJLKuuftpgoBMzSd9GCvh2znwGeKuozD+ICho9C3WLvp+J3F5Pi7UTym807uP4TqGxysO9+4aT06lpw44ETvT6CcL3TxxMeRd6p2BQohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DZ1P/CU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DZ1P/CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2375F1F000C4;
	Sat, 17 Oct 2026 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258274;
	bh=AVuRhcoRPd+vYpgF8N9/e7sI88VkblJBI0eYcFruecU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DZ1P/CU6wcLyySICJaIn63rZw3ofuVFpghvaXEsolyWl6B9PRHoHLyT5CcaprJ/j
	 7SaOl3alQDafdW8q+9WH+Bp2bp3Pda4jYaRe7o+4Gs1vhAmX6+O/W71KnDoKDumxZc
	 I4REpLgP4RA7C76H8jO4ms9Yr6liRkTx6BVYbMqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0829/1674] md: fix rcu protection in md_wakeup_thread
Date: Sat, 17 Oct 2026 17:51:41 +0200
Message-ID: <20261017160452.403927955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b2acf648d767..5e13891d85139 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -89,7 +89,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
-static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
+static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
 /*
  * Default number of read corrections we'll attempt on an rdev
@@ -4861,7 +4861,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 	 * Thread might be blocked waiting for metadata update which will now
 	 * never happen
 	 */
-	md_wakeup_thread_directly(mddev->sync_thread);
+	md_wakeup_thread_directly(&mddev->sync_thread);
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
@@ -8004,31 +8004,29 @@ static int md_thread(void *arg)
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
 		set_bit(THREAD_WAKEUP, &t->flags);
 		wake_up(&t->wqueue);
 	}
-	rcu_read_unlock();
 }
-EXPORT_SYMBOL(md_wakeup_thread);
+EXPORT_SYMBOL(__md_wakeup_thread);
 
 struct md_thread *md_register_thread(void (*run) (struct md_thread *),
 		struct mddev *mddev, const char *name)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 46995558d3bd9..59f92aa48b37e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -756,6 +756,12 @@ struct md_io_clone {
 
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
@@ -773,7 +779,7 @@ extern struct md_thread *md_register_thread(
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp);
-extern void md_wakeup_thread(struct md_thread __rcu *thread);
+extern void __md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern int mddev_init_writes_pending(struct mddev *mddev);
-- 
2.53.0



