Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879C14F4D1B;
	Tue, 13 Oct 2026 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896097; cv=none; b=He96Z9bIILswEu5vWXv0/aqhfLSA9nDmelqYEf6EU2W9W0k1xv5VubmoH32U6V685p4orNubXvP3t4+Roj7IfIryoYsGfYpXHW6dQjaOugh1/VMkZFe0cMhIszZWTXwTgLrSnXpuyPIN4Qc3+D3qgzRn1H4OO94D249sMsl8bKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896097; c=relaxed/simple;
	bh=PB7LUJi+okvFdivuD+5NdqY8hxfyE8oAltNcRNGxGwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUuNAXca1VDZ3QDwhBUPLgu2A1YmEsLGS/68ozUU1pW/yPfMM4je0qC1IYmQ5enX0V/7XOLzMdwGdxqzfEyZYxcjlmmzRB+/Z8/6U+Rfvh9IC4nL8RqKG574XWLLpIvQ8uWGttzC3eY7xzcB4dFiLemZfuUA1WNbMP/sBVK3HQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VQgxGxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VQgxGxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8037B1F00893;
	Tue, 13 Oct 2026 12:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896096;
	bh=AZ2QcNAawYz34itfBON3rNNNp/OEZ/l3JT/Ge6Hd+vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VQgxGxntPZZW/T8wH5B4Xc0KmYjvrwWMma4A3VGhGspbgEyOu4sqYsRxuAgsbsAf
	 B/yeZE0vfMfEnVd/vq/lwO03BiamCVlUhpfGBqY8+VBAsxyqqe9jaMa0ewX/+4gqgs
	 x5P1bPys6C9Mn6Q4ROKDrb9zHDDYgfIEB5X9uFTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eb441775f4f948a0902f@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 495/497] io_uring/waitid: fix KCSAN warning on io_waitid->head
Date: Tue, 13 Oct 2026 13:41:02 +0200
Message-ID: <20261013112919.625457741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit b994ace83a2bc7699420f6a4c6b860c8da133159 upstream.

Storing of the iw->head entry inside the wait_queue callback, or when
removing a waitid item, really should use proper load/store
acquire/release semantics, and KCSAN correctly warns of that. Ensure
that they do so.

Reported-by: syzbot+eb441775f4f948a0902f@syzkaller.appspotmail.com
Fixes: a48c0cbf28c0 ("io_uring/waitid: have io_waitid_complete() remove wait queue entry")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -120,11 +120,11 @@ static void io_waitid_remove_wq(struct i
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 	struct wait_queue_head *head;
 
-	head = READ_ONCE(iw->head);
+	head = smp_load_acquire(&iw->head);
 	if (head) {
 		struct io_waitid_async *iwa = req->async_data;
 
-		iw->head = NULL;
+		smp_store_release(&iw->head, NULL);
 		spin_lock_irq(&head->lock);
 		list_del_init(&iwa->wo.child_wait.entry);
 		spin_unlock_irq(&head->lock);
@@ -291,7 +291,7 @@ static int io_waitid_wait(struct wait_qu
 		return 0;
 
 	list_del_init(&wait->entry);
-	iw->head = NULL;
+	smp_store_release(&iw->head, NULL);
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)


