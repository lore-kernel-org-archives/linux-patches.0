Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4592D0C94;
	Sat, 12 Sep 2026 11:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212779; cv=none; b=c7lldDEDZv/SFB7E47b5i6RL7nR2bhiZWklMOwQedHmmkFNo6Wl611hCsl9DmrzT46eVvebwEDvXaDQPqciNyx51dSM53e0h/LFoHV/fXv7HeaSgWlyiYCJBDJSP666KcRcmU5xXKxp0b81XkaIHWUkVsV2lKeqt/ZmYZ2LSDzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212779; c=relaxed/simple;
	bh=7A6JgKsTpsAXCQNBeQ0IkIwbdThhDSu0mcx+I4Jv72o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfGrsUo+uS3tFfwZZM/DbGY1IM8NreJjXvGZqJ9GXlR9SclvwXlNR2c9XBJpcfUHa/KJ9Jq06L+OzRbXpcB1aYfbLXnteZCV6nvspI/EateqWfaYYx6WVpL+DBwl5/IxPfxRtJVykfUxpQ3Ouu6z3fdU3HPcOUuzsRP8mSzd1gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGoaXuRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGoaXuRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C1E1F000FF;
	Sat, 12 Sep 2026 11:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212778;
	bh=yyCV5d8JPdgWSA2P3wm02b6fJTaQYwFheMsaMFcDAVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGoaXuRTTg/9dyoekPJDT/VW7YfGfMc98hD3wP8q77qqDxk//lN8+q/FnvDL8YGv8
	 45WuM7jQ0hTCODixFdOXDW4+pc0efyylPAHGDNB/flqJ1r40jv9H0X7lODC8BLt0T5
	 jgZcGjtQPLVrmOmcpMKeeTxfaqnlLXduIYQL8Dh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eb441775f4f948a0902f@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1505/1518] io_uring/waitid: fix KCSAN warning on io_waitid->head
Date: Sat, 12 Sep 2026 09:01:14 +0200
Message-ID: <20260912065657.610807104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b994ace83a2bc7699420f6a4c6b860c8da133159 ]

Storing of the iw->head entry inside the wait_queue callback, or when
removing a waitid item, really should use proper load/store
acquire/release semantics, and KCSAN correctly warns of that. Ensure
that they do so.

Reported-by: syzbot+eb441775f4f948a0902f@syzkaller.appspotmail.com
Fixes: a48c0cbf28c0 ("io_uring/waitid: have io_waitid_complete() remove wait queue entry")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 1137e3a166d12..2b756017423f0 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -114,11 +114,11 @@ static void io_waitid_remove_wq(struct io_kiocb *req)
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
@@ -265,7 +265,7 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 0;
 
 	list_del_init(&wait->entry);
-	iw->head = NULL;
+	smp_store_release(&iw->head, NULL);
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
-- 
2.53.0



