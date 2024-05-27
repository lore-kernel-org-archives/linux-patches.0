Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861FC15FA85;
	Mon, 27 May 2024 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836375; cv=none; b=QgPkJombktcFr7ug5kzXFyxAwurA/Lh5xFJxnfoiiy3G8dJxCu8fBW0uUgj1/ByNBLPMMKtFU7/vXHfU9j1zdt3AIrxVqSofDmUhUmGWLfDbS3FthSqM2/gJexMVUJX+xTL/geFNavbpXmXTYoN3jaM9LIneGFX0K1m4qLdhhbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836375; c=relaxed/simple;
	bh=TV/aJtxmzhe5sndcwp9I7tp8vb02iD1p6qKaqNhLNnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvt6waEZntroBThA2KWmd/gQxQ/z/Ku+R4WY2wXPLih6zfKKvzINvR2sk0dt4waI2KlaIxObN/ty1PfHzZCZ32fW5+oUDVMwujt4R+gNPNwKAhEnll+d6SzxqblEVo5kv1ske6GPX+ZX9qOTWzHrxkuudrK5gXD6sD4xnT6e6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLhOOcJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLhOOcJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D13DC2BBFC;
	Mon, 27 May 2024 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836375;
	bh=TV/aJtxmzhe5sndcwp9I7tp8vb02iD1p6qKaqNhLNnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLhOOcJpq0eYQ3G+lQZp5KWpTiPNLdjJcpW3SQ0rfzlubS/sAbK4K1YL8s08vRxzI
	 J3I3OAPYxGR6FhSw+kwlTW0JRZRyp4j+lIW/xC8bNPFXUn9IoSqKT9XR+KQpZhsA4E
	 vuapzKnPRQv+Kdi4lvkPPEenZUpYcfSDwmOKhUSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 029/427] nilfs2: fix unexpected freezing of nilfs_segctor_sync()
Date: Mon, 27 May 2024 20:51:16 +0200
Message-ID: <20240527185604.427963021@linuxfoundation.org>
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
@@ -2174,19 +2174,28 @@ static int nilfs_segctor_sync(struct nil
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


