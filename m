Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA5A13C660;
	Thu, 13 Jun 2024 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281657; cv=none; b=alRr63Z6oK0nDpWqtachcuAWgbFs7QN5ADfL5GKhkYW3TBE6PUsF/IYN0HPlz+d3L48kuiGURQRLuaguBeJbtxcErBdE0AL/kddaoIH3sv8eRxAC+yC4MSsjxf3tJABudJ4SHfUGNxhS0XSHACmfgCw/wiZOpwZsne+VIhWXWl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281657; c=relaxed/simple;
	bh=H+Zsr3Iu9s3X3aP38Hs4lgEb0IsTQXC31dVAB11dAks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOCLoycZsdKgFywdcnZ6gIGPC0v9vTaSUHP6S4LK3icWSxiAePzZgZwkVoh/g5WNZQIgE+hP2M4dELXFcvcuhpN6OB6SeMuGqsTce2GRehL/eyPu5YqvSoeJf7W44A7uWbDsxqyG14GdAiJBgyEvvD2F9tZHm8lARGQ0KTb+1HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM3dPNgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM3dPNgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C09BC2BBFC;
	Thu, 13 Jun 2024 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281656;
	bh=H+Zsr3Iu9s3X3aP38Hs4lgEb0IsTQXC31dVAB11dAks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM3dPNgW9ZaBc7F8I1nUX1OD1xkJCgcY+RTJHQCOjd++dqs7q1BqloZADPZ8QEodZ
	 LNCEdx2ObqbneN58uq09RS5x+JDVmZjZunghKhODMxlxyqJrTwVH1hulmvOXsjsZHS
	 f0MfW1RU5/zGTee+HjhHh76BuM6pcZ18Nju/84i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 012/402] nilfs2: fix potential hang in nilfs_detach_log_writer()
Date: Thu, 13 Jun 2024 13:29:29 +0200
Message-ID: <20240613113302.616201449@linuxfoundation.org>
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
@@ -2229,6 +2229,14 @@ static int nilfs_segctor_sync(struct nil
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
@@ -2244,7 +2252,7 @@ static int nilfs_segctor_sync(struct nil
 	return err;
 }
 
-static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
+static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
 {
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
@@ -2252,7 +2260,7 @@ static void nilfs_segctor_wakeup(struct
 	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.head, wq.entry) {
 		if (!atomic_read(&wrq->done) &&
-		    nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq)) {
+		    (force || nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq))) {
 			wrq->err = err;
 			atomic_set(&wrq->done, 1);
 		}
@@ -2392,7 +2400,7 @@ static void nilfs_segctor_notify(struct
 	if (mode == SC_LSEG_SR) {
 		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
 		sci->sc_seq_done = sci->sc_seq_accepted;
-		nilfs_segctor_wakeup(sci, err);
+		nilfs_segctor_wakeup(sci, err, false);
 		sci->sc_flush_request = 0;
 	} else {
 		if (mode == SC_FLUSH_FILE)
@@ -2774,6 +2782,13 @@ static void nilfs_segctor_destroy(struct
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
 


