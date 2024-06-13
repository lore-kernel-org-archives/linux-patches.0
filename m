Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B06143884;
	Thu, 13 Jun 2024 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280792; cv=none; b=N1uOTXGqksdj2BHPnk1c0CVerVQjEc6bMDq5VqARlMC8v5dO81CEFnQ8wNe9a43IqXzZkDBO+MzrubRZN7mlkzmctwiW6onbUYC4haTZo6OUFVjQszNNw6r2bBRf96253pXDfb+VR+Tdj6fQkItYXh3tJ/9Koe/245+d/V6CDGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280792; c=relaxed/simple;
	bh=BP5Pto84SUOKo+l60YLGPSKQyEAMrEzFQd3KfRbLdbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6MYhDdiJddtrJ2xT0ExOoVymdVU/x/RyX7sW2bXLcON7OfhnQyao+ZOhKIzumXYBl4519oA0AtfoztmbZKxnXInywtBvTT0DlXbxyDly+UpXnmrV/wCImB4pCw/8sWRpDc1VT41mXpIP06vCqV+HNFQmwxrDysxvQNfj6PTkOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7FK7iCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7FK7iCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A64C2BBFC;
	Thu, 13 Jun 2024 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280791;
	bh=BP5Pto84SUOKo+l60YLGPSKQyEAMrEzFQd3KfRbLdbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7FK7iCBZYzHIG9RKBQmhv+bcNaQ89q2Is6f3FVDZOXSBVnewi2ZS4S2ELz+0Q66a
	 HiuhXTkerM0EQvowLcwjioFYGCWZJ1UYN8i60leLMbt7mQfQyYEGTtT2IPPr+Fo11F
	 06lJduKcEMC3NY5c9OF43OjkHm/4qx9FTmgir2qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 008/317] nilfs2: fix potential hang in nilfs_detach_log_writer()
Date: Thu, 13 Jun 2024 13:30:26 +0200
Message-ID: <20240613113247.859425020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit eb85dace897c5986bc2f36b3c783c6abb8a4292e upstream.

Syzbot has reported a potential hang in nilfs_detach_log_writer() called
during nilfs2 unmount.

Analysis revealed that this is because nilfs_segctor_sync(), which
synchronizes with the log writer thread, can be called after
nilfs_segctor_destroy() terminates that thread, as shown in the call trace
below:

nilfs_detach_log_writer
  nilfs_segctor_destroy
    nilfs_segctor_kill_thread  --> Shut down log writer thread
    flush_work
      nilfs_iput_work_func
        nilfs_dispose_list
          iput
            nilfs_evict_inode
              nilfs_transaction_commit
                nilfs_construct_segment (if inode needs sync)
                  nilfs_segctor_sync  --> Attempt to synchronize with
                                          log writer thread
                           *** DEADLOCK ***

Fix this issue by changing nilfs_segctor_sync() so that the log writer
thread returns normally without synchronizing after it terminates, and by
forcing tasks that are already waiting to complete once after the thread
terminates.

The skipped inode metadata flushout will then be processed together in the
subsequent cleanup work in nilfs_segctor_destroy().

Link: https://lkml.kernel.org/r/20240520132621.4054-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e3973c409251e136fdd0
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: "Bai, Shuangpeng" <sjb7183@psu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2234,6 +2234,14 @@ static int nilfs_segctor_sync(struct nil
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+		/*
+		 * Synchronize only while the log writer thread is alive.
+		 * Leave flushing out after the log writer thread exits to
+		 * the cleanup work in nilfs_segctor_destroy().
+		 */
+		if (!sci->sc_task)
+			break;
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;
@@ -2249,7 +2257,7 @@ static int nilfs_segctor_sync(struct nil
 	return err;
 }
 
-static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
+static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
 {
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
@@ -2257,7 +2265,7 @@ static void nilfs_segctor_wakeup(struct
 	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.head, wq.entry) {
 		if (!atomic_read(&wrq->done) &&
-		    nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq)) {
+		    (force || nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq))) {
 			wrq->err = err;
 			atomic_set(&wrq->done, 1);
 		}
@@ -2397,7 +2405,7 @@ static void nilfs_segctor_notify(struct
 	if (mode == SC_LSEG_SR) {
 		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
 		sci->sc_seq_done = sci->sc_seq_accepted;
-		nilfs_segctor_wakeup(sci, err);
+		nilfs_segctor_wakeup(sci, err, false);
 		sci->sc_flush_request = 0;
 	} else {
 		if (mode == SC_FLUSH_FILE)
@@ -2779,6 +2787,13 @@ static void nilfs_segctor_destroy(struct
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
+	/*
+	 * Forcibly wake up tasks waiting in nilfs_segctor_sync(), which can
+	 * be called from delayed iput() via nilfs_evict_inode() and can race
+	 * with the above log writer thread termination.
+	 */
+	nilfs_segctor_wakeup(sci, 0, true);
+
 	if (flush_work(&sci->sc_iput_work))
 		flag = true;
 


