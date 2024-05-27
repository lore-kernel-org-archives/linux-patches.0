Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E97915FCE6;
	Mon, 27 May 2024 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836373; cv=none; b=hWh7jr6mrgxvOVPQ16kGwydP+ONiqSlg4+m4ta0xXATk1nltZhEw8lrYyYZYEZJdOgPoojvBOv5BHT3vCqw9b5PZosQpZIL7cNO1FQiKkZOIuiLeqXm5rEZ9pp1DhtZuSAyufc9tc6T2QI9oDKBL00ebCNK/wUNkM5dpK+6Y6sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836373; c=relaxed/simple;
	bh=PH2laBc3FBGvAyEhbW5U38kL76GG+EEzxxWR2choQjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZQ9PpGJ8jjqY8R2ZztNcWAqfqEw04Dk+K2ZkWb3sRbGx+LM15UmSjXINF9gpMrC731+CysxuDxeyznIYRU4JMTaEJeUe1+aUwkeSXSjKiQav/MsRtFuG5SkOavrZo9YeTCnjTBfHJYsEUCHIb+UBdQgHUvvV8KEZt47cXxt5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pxzbyLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pxzbyLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B509C2BBFC;
	Mon, 27 May 2024 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836372;
	bh=PH2laBc3FBGvAyEhbW5U38kL76GG+EEzxxWR2choQjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pxzbyLzHxvij8EQOwTTX/n2tb7FiyHrSTb7mzBfD8kEyM1coyfr9xbZQ2t64YlWn
	 Pmn44oAh0I7REUaUBxmy6G4qTqaY0Z524P4qUjzVXqCFfPYlzPgGIKpiJanFBS07JB
	 ZLCM9lmAf0ZM7IfvAiJ45pMtae31B0eicoyGOe1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 028/427] nilfs2: fix use-after-free of timer for log writer thread
Date: Mon, 27 May 2024 20:51:15 +0200
Message-ID: <20240527185604.290069336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2124,8 +2124,10 @@ static void nilfs_segctor_start_timer(st
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
@@ -2326,10 +2328,21 @@ int nilfs_construct_dsync_segment(struct
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
@@ -2355,7 +2368,7 @@ static void nilfs_segctor_notify(struct
 			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
 
 		/* re-enable timer if checkpoint creation was not done */
-		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) && sci->sc_task &&
 		    time_before(jiffies, sci->sc_timer.expires))
 			add_timer(&sci->sc_timer);
 	}
@@ -2545,6 +2558,7 @@ static int nilfs_segctor_thread(void *ar
 	int timeout = 0;
 
 	sci->sc_timer_task = current;
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
 	sci->sc_task = current;
@@ -2612,6 +2626,7 @@ static int nilfs_segctor_thread(void *ar
  end_thread:
 	/* end sync. */
 	sci->sc_task = NULL;
+	timer_shutdown_sync(&sci->sc_timer);
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
 	spin_unlock(&sci->sc_state_lock);
 	return 0;
@@ -2675,7 +2690,6 @@ static struct nilfs_sc_info *nilfs_segct
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_iput_queue);
 	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
-	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
@@ -2754,7 +2768,6 @@ static void nilfs_segctor_destroy(struct
 
 	down_write(&nilfs->ns_segctor_sem);
 
-	timer_shutdown_sync(&sci->sc_timer);
 	kfree(sci);
 }
 


