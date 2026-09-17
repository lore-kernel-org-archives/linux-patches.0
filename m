Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9803854707D;
	Thu, 17 Sep 2026 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671397; cv=none; b=IkEUdgmlFIa2IV1LX2rW3FzUurpygtXNO9SMXkUeOYc1Oh5pB/bX5PJtAmGtLvADJ3B/53E5x2FVr87PXGq9Y3Rg9MXqOhJEmzP0d5pAzK+eMP/DiYEPVpi6600crhqsaI+D29ayFA1GaMKc+lRtlF3I4FHy7F0pBqXiyFlDb7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671397; c=relaxed/simple;
	bh=lXbTCIcMl4YAmxjKCNdbzIWAP7BkfkazJHVt+2AaaZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sumgEyurZKt1CEcE7D7EHMBNHobXCxH0napqEx+xsEed4uL/vPOX6vd1lnQmCcNhiFW3+RWu8YV3qo5IWLjOeMFONbcZv1YWN2r+YkED2pjmJdJMEYoNmyqV35Kxlrn3+Cq7s8flHsX34M1EnyRXxdYhF6Td+TCSlm0RWjoWKOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BL+sRtYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BL+sRtYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62891F000FF;
	Thu, 17 Sep 2026 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671396;
	bh=ZaRwYieMICTsAD2soPiZ8FK7u/CYUfEBTNrB/RFQ8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BL+sRtYS2wTLqTYBcItRwxjXgPjA5iZBaOyGwXLMffzpozaSG7FxzLd0VsEBKVVUy
	 Grg1CfkUIvJP9kr3kK/RyapHi2ffCnXySVINOoOZQx9oA3UABH6Lw2bbs+hbkaB9Mw
	 XS2KbRJz+WHFNCFlNA3e+POfvHacfG2j8vQf9u80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0960/1102] fuse: fix race between interrupt and resend
Date: Thu, 17 Sep 2026 16:15:03 +0100
Message-ID: <20260917151604.765211478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit ed9c881f3b498383f73c42712b359419da42a7b0 ]

After commit f8fce75fedf7 ("fuse: clear intr_entry in fuse_resend and
fuse_remove_pending_req") the WARN_ON(!list_empty(&req->intr_entry)) in
fuse_request_free() still triggers due to the following race:

In request_wait_answer()
  if (test_bit(FR_SENT, &req->flags)) -> returns true

In fuse_chan_resend()
  clear_bit(FR_SENT, &req->flags)

In request_wait_answer()
  queue_interrupt(req)

Fix by:

 - move clearing FR_SENT inside fpq->lock

 - move setting FR_PENDING inside fiq->lock

 - recheck FR_SENT after acquiring fiq->lock in fuse_dev_queue_interrupt()

Reported-by: zdi-disclosures@trendmicro.com
Fixes: f8fce75fedf7 ("fuse: clear intr_entry in fuse_resend and fuse_remove_pending_req")
Cc: stable@vger.kernel.org # 6.9
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ renamed upstream's fuse_chan_resend()/fuse_dev_end_requests() identifiers back to this tree's pre-refactor fuse_resend()/end_requests() names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -267,7 +267,8 @@ static void fuse_dev_queue_forget(struct
 static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
-	if (list_empty(&req->intr_entry)) {
+	/* Repeat FR_SENT test after obtaining the lock to prevent race with fuse_resend() */
+	if (list_empty(&req->intr_entry) && test_bit(FR_SENT, &req->flags)) {
 		list_add_tail(&req->intr_entry, &fiq->interrupts);
 		/*
 		 * Pairs with smp_mb() implied by test_and_set_bit()
@@ -1870,7 +1871,7 @@ copy_finish:
 static void fuse_resend(struct fuse_conn *fc)
 {
 	struct fuse_dev *fud;
-	struct fuse_req *req, *next;
+	struct fuse_req *req;
 	struct fuse_iqueue *fiq = &fc->iq;
 	LIST_HEAD(to_queue);
 	unsigned int i;
@@ -1885,24 +1886,20 @@ static void fuse_resend(struct fuse_conn
 		struct fuse_pqueue *fpq = &fud->pq;
 
 		spin_lock(&fpq->lock);
-		for (i = 0; i < FUSE_PQ_HASH_SIZE; i++)
-			list_splice_tail_init(&fpq->processing[i], &to_queue);
+		for (i = 0; i < FUSE_PQ_HASH_SIZE; i++) {
+			struct list_head *this_queue = &fpq->processing[i];
+
+			list_for_each_entry(req, this_queue, list)
+				clear_bit(FR_SENT, &req->flags);
+			list_splice_tail_init(this_queue, &to_queue);
+		}
 		spin_unlock(&fpq->lock);
 	}
 	spin_unlock(&fc->lock);
 
-	list_for_each_entry_safe(req, next, &to_queue, list) {
-		set_bit(FR_PENDING, &req->flags);
-		clear_bit(FR_SENT, &req->flags);
-		/* mark the request as resend request */
-		req->in.h.unique |= FUSE_UNIQUE_RESEND;
-	}
-
 	spin_lock(&fiq->lock);
 	if (!fiq->connected) {
 		spin_unlock(&fiq->lock);
-		list_for_each_entry(req, &to_queue, list)
-			clear_bit(FR_PENDING, &req->flags);
 		end_requests(&to_queue);
 		return;
 	}
@@ -1911,6 +1908,10 @@ static void fuse_resend(struct fuse_conn
 	 * intr_entry on fiq->interrupts after the request is re-queued.
 	 */
 	list_for_each_entry(req, &to_queue, list) {
+		set_bit(FR_PENDING, &req->flags);
+		/* mark the request as resend request */
+		req->in.h.unique |= FUSE_UNIQUE_RESEND;
+
 		if (test_bit(FR_INTERRUPTED, &req->flags))
 			list_del_init(&req->intr_entry);
 	}


