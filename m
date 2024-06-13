Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFE4A0F;
	Thu, 13 Jun 2024 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282643; cv=none; b=av/M4B+hSEQtOKEU1vW7q1ymCgLzAUtPkpsq5nAElLC6vUCVFrewhQ2ryQrC5WxMKGWZlL1pZ87qMcf/hoamzMorlfZd1hLz5rYOEVT+skb9G+xW38Djoy3N+k1n/ERtHpeSzxY4/CuxjdkVEx77foHT+OrhZ3prrCGiJZAOG5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282643; c=relaxed/simple;
	bh=Oa54+QHnb4B6uKumMhlpCj1TeLHDNBrxnGb7Nqcv/AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbbITqLS+hZSbBDBIofsmgkC6ovS5pyoNYUOFRlqcHbqvNX96xQFxM4v0DIzM+3cby53w4XNZ0ORwJCIPL3OsMpdry03IiQsWEcA0jO5qQotWm+ppB6JlXWElMHkzxWQ9AdY3konQMoDt7a6SnETn27hJc8Afa8TdkoibqBO8Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T29I5Y9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T29I5Y9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04E7C2BBFC;
	Thu, 13 Jun 2024 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282643;
	bh=Oa54+QHnb4B6uKumMhlpCj1TeLHDNBrxnGb7Nqcv/AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T29I5Y9rIWA0rgfmEi4W/0jyQ6U9h3PPMS26zjWm/F/Tir+4AQYQZ8R6DaboBsM5c
	 OjI4A92QDT3vCMlM2piE7QW4fpU6rQiICCK6edqAk0FAbzvoyTMMKtYrQ2fwpGM++C
	 Wjb5yBDHFEccQlnIySLYgIMUztco2vtCSijrgGsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 345/402] nilfs2: fix use-after-free of timer for log writer thread
Date: Thu, 13 Jun 2024 13:35:02 +0200
Message-ID: <20240613113315.589031309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit f5d4e04634c9cf68bdf23de08ada0bb92e8befe7 upstream.

Patch series "nilfs2: fix log writer related issues".

This bug fix series covers three nilfs2 log writer-related issues,
including a timer use-after-free issue and potential deadlock issue on
unmount, and a potential freeze issue in event synchronization found
during their analysis.  Details are described in each commit log.


This patch (of 3):

A use-after-free issue has been reported regarding the timer sc_timer on
the nilfs_sc_info structure.

The problem is that even though it is used to wake up a sleeping log
writer thread, sc_timer is not shut down until the nilfs_sc_info structure
is about to be freed, and is used regardless of the thread's lifetime.

Fix this issue by limiting the use of sc_timer only while the log writer
thread is alive.

Link: https://lkml.kernel.org/r/20240520132621.4054-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240520132621.4054-2-konishi.ryusuke@gmail.com
Fixes: fdce895ea5dd ("nilfs2: change sc_timer from a pointer to an embedded one in struct nilfs_sc_info")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: "Bai, Shuangpeng" <sjb7183@psu.edu>
Closes: https://groups.google.com/g/syzkaller/c/MK_LYqtt8ko/m/8rgdWeseAwAJ
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2159,8 +2159,10 @@ static void nilfs_segctor_start_timer(st
 {
 	spin_lock(&sci->sc_state_lock);
 	if (!(sci->sc_state & NILFS_SEGCTOR_COMMIT)) {
-		sci->sc_timer.expires = jiffies + sci->sc_interval;
-		add_timer(&sci->sc_timer);
+		if (sci->sc_task) {
+			sci->sc_timer.expires = jiffies + sci->sc_interval;
+			add_timer(&sci->sc_timer);
+		}
 		sci->sc_state |= NILFS_SEGCTOR_COMMIT;
 	}
 	spin_unlock(&sci->sc_state_lock);
@@ -2380,10 +2382,21 @@ int nilfs_construct_dsync_segment(struct
  */
 static void nilfs_segctor_accept(struct nilfs_sc_info *sci)
 {
+	bool thread_is_alive;
+
 	spin_lock(&sci->sc_state_lock);
 	sci->sc_seq_accepted = sci->sc_seq_request;
+	thread_is_alive = (bool)sci->sc_task;
 	spin_unlock(&sci->sc_state_lock);
-	del_timer_sync(&sci->sc_timer);
+
+	/*
+	 * This function does not race with the log writer thread's
+	 * termination.  Therefore, deleting sc_timer, which should not be
+	 * done after the log writer thread exits, can be done safely outside
+	 * the area protected by sc_state_lock.
+	 */
+	if (thread_is_alive)
+		del_timer_sync(&sci->sc_timer);
 }
 
 /**
@@ -2409,7 +2422,7 @@ static void nilfs_segctor_notify(struct
 			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
 
 		/* re-enable timer if checkpoint creation was not done */
-		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) && sci->sc_task &&
 		    time_before(jiffies, sci->sc_timer.expires))
 			add_timer(&sci->sc_timer);
 	}
@@ -2599,6 +2612,7 @@ static int nilfs_segctor_thread(void *ar
 	int timeout = 0;
 
 	sci->sc_timer_task = current;
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
 	sci->sc_task = current;
@@ -2665,6 +2679,7 @@ static int nilfs_segctor_thread(void *ar
  end_thread:
 	/* end sync. */
 	sci->sc_task = NULL;
+	del_timer_sync(&sci->sc_timer);
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
 	spin_unlock(&sci->sc_state_lock);
 	return 0;
@@ -2728,7 +2743,6 @@ static struct nilfs_sc_info *nilfs_segct
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_iput_queue);
 	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
-	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
@@ -2814,7 +2828,6 @@ static void nilfs_segctor_destroy(struct
 
 	down_write(&nilfs->ns_segctor_sem);
 
-	del_timer_sync(&sci->sc_timer);
 	kfree(sci);
 }
 


