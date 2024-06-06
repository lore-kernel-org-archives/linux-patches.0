Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117E19DF71;
	Thu,  6 Jun 2024 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683102; cv=none; b=swUPmaaApO/zlExcPDn4jXXBlSfzzG9PKCH5r7mrjMTLcKwnUiLKuxFXswHx19efcD2yINc0lgTEnC6uvCniKHp9Uyi4OtYDl9YdVeLbGVYogWZP5k4UFK1EPYKNnKU0pFe3CQK3VU0ke57+2IetHJ2cpgs2qthmKcD0NE4ZMDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683102; c=relaxed/simple;
	bh=qy1afM8dyFjOCJ/Z+0gwfqB7lDd8m20LE6JvXF7grK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltP2+olfbnXX1KwqP3b6lzfjCTScbqMw4mTqdloPvdWRc9xPYNgg75eVMxus0QXAQs/D4sNpsj3LQVudov78dY/e81ETR668invf7vssT5o2M6pMZapc4+3kUljXOcsk7+XksqfltIG59CgFF3+FhtQsdju3GGT9vq/fo8wWTWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJnIrWSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJnIrWSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112A0C2BD10;
	Thu,  6 Jun 2024 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683102;
	bh=qy1afM8dyFjOCJ/Z+0gwfqB7lDd8m20LE6JvXF7grK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJnIrWSEdEm4X2p78Q3y+HaIwmffZgHZbvag+KloDxTZHNsgelkLp/GgC1+uz2BzT
	 rN3EnY+85xg5hCcJOCbJDVlAuvyzLT7i8xvZ+X8imo9X797VqhsoYmnncMNDC+xvwy
	 pRb3TRMwh/MALoQowCvAb+ZdnbsLR2Ref1Ve9b1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 021/744] nilfs2: fix unexpected freezing of nilfs_segctor_sync()
Date: Thu,  6 Jun 2024 15:54:53 +0200
Message-ID: <20240606131733.118061330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 936184eadd82906992ff1f5ab3aada70cce44cee upstream.

A potential and reproducible race issue has been identified where
nilfs_segctor_sync() would block even after the log writer thread writes a
checkpoint, unless there is an interrupt or other trigger to resume log
writing.

This turned out to be because, depending on the execution timing of the
log writer thread running in parallel, the log writer thread may skip
responding to nilfs_segctor_sync(), which causes a call to schedule()
waiting for completion within nilfs_segctor_sync() to lose the opportunity
to wake up.

The reason why waking up the task waiting in nilfs_segctor_sync() may be
skipped is that updating the request generation issued using a shared
sequence counter and adding an wait queue entry to the request wait queue
to the log writer, are not done atomically.  There is a possibility that
log writing and request completion notification by nilfs_segctor_wakeup()
may occur between the two operations, and in that case, the wait queue
entry is not yet visible to nilfs_segctor_wakeup() and the wake-up of
nilfs_segctor_sync() will be carried over until the next request occurs.

Fix this issue by performing these two operations simultaneously within
the lock section of sc_state_lock.  Also, following the memory barrier
guidelines for event waiting loops, move the call to set_current_state()
in the same location into the event waiting loop to ensure that a memory
barrier is inserted just before the event condition determination.

Link: https://lkml.kernel.org/r/20240520132621.4054-3-konishi.ryusuke@gmail.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: "Bai, Shuangpeng" <sjb7183@psu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2211,19 +2211,28 @@ static int nilfs_segctor_sync(struct nil
 	struct nilfs_segctor_wait_request wait_req;
 	int err = 0;
 
-	spin_lock(&sci->sc_state_lock);
 	init_wait(&wait_req.wq);
 	wait_req.err = 0;
 	atomic_set(&wait_req.done, 0);
+	init_waitqueue_entry(&wait_req.wq, current);
+
+	/*
+	 * To prevent a race issue where completion notifications from the
+	 * log writer thread are missed, increment the request sequence count
+	 * "sc_seq_request" and insert a wait queue entry using the current
+	 * sequence number into the "sc_wait_request" queue at the same time
+	 * within the lock section of "sc_state_lock".
+	 */
+	spin_lock(&sci->sc_state_lock);
 	wait_req.seq = ++sci->sc_seq_request;
+	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
 	spin_unlock(&sci->sc_state_lock);
 
-	init_waitqueue_entry(&wait_req.wq, current);
-	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
-	set_current_state(TASK_INTERRUPTIBLE);
 	wake_up(&sci->sc_wait_daemon);
 
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;


