Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209111;
	b=bwlUb6k1WUe2jMOmkXQLiDIHZm5rDjIIJRaoMOYytbYO6eS2zbcQ5ExCv0xJ1w7uSamX
	 ZNWtNSpJEjNCVkMZV+SgdQLVyRzA2/wGboQvAjsnrsFuTMzrF4+Yv3YbVcB1rp7sR98ef
	 bRNncE0gXbBUCrIxa7+8mpSatsFHT4XQRhsu7uEqWNtLOs8iDEpolQv/yTtWeOzdQPCIt
	 w/cBZMuKXlgIbizlMqEC6rntSkpCeyCXPWcDinZBWM35GwVFZL5gjclfdFTOfXDj8ZBql
	 XSEimHhUbStR+Thwfhh5cJ0m9/B+HTOvCpDio0lqYktyvJLP3D+oabwGTObs4nCWtuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j28edNERyGku7Sxo7txDaJz+RmMlshTAEq6uWLX1pis=;
	b=3V1tTnEWEEENtIdfSqWK8b4FbNxpTDxxvPJIM1gvhRQaQ+v4gvr/TFkt8bypqaTu05xp
	 hMmYoRigSvXTv0G3BT/vVZ9v3r1w0S3uLJFfJnN+4UUar8RBWAWdAFhf0acmeE4XbxIIT
	 6Z/Y4wm02dMly1nhRyja2TjEfqoJjbtNo4URSel1sRXcPWHR87C+uROvGiuMAYxf7zdm2
	 bs5I/+Hlk2yLPzAdG/b+lBwXbg/7EV7UHPY8UrnScZGCqFOBgR8S0BVxG1oyMgXivAEaZ
	 qGnfJuSBh3SUikUNrSofOaAPUs3nbO+eFuUf93day8LemRAFCkjLG7e3ojfY7+yXk+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaIAWAxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0884606A32F;
	Wed, 28 Oct 2026 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaIAWAxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A6A1F01825;
	Wed, 28 Oct 2026 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209110;
	bh=j28edNERyGku7Sxo7txDaJz+RmMlshTAEq6uWLX1pis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaIAWAxN88tnc1+CrYKPDPHdE2PBoIfF/PjGHuqifi1hwGtdLOGbDhz9njnypiEvx
	 jt83m7ppQAg+Cqv0/HAEvSlYbTl8mSWO9XFllN8AFMySdDYtlP4lZVDp/S03GrY2gz
	 HjiZ8/m+7psGEiv+NNJmL4eaoqvu7zOl3Nw7QW7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ccffdf05833ebdaeae70@syzkaller.appspotmail.com,
	Raj Ojha <rajojha047@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 329/516] memstick: core: wait for request completion before freeing card
Date: Wed, 28 Oct 2026 17:58:01 +0100
Message-ID: <20261028170011.282443443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raj Ojha <rajojha047@gmail.com>

commit aa0a37b5024d921e96ac4f8f487c8bfbf1f1a582 upstream.

In memstick_alloc_card() and memstick_set_rw_addr(),
wait_for_completion_timeout() is used to wait for device identification
and address configuration requests to complete.

The memstick subsystem does not provide an abort or cancellation
callback in struct memstick_host for in-flight requests. If
wait_for_completion_timeout() expires (for instance, when a USB transfer
or command retry is delayed), memstick_alloc_card() returns an error and
frees the memstick_dev structure via kfree(card).

However, the host controller driver (such as rtsx_usb_ms) is still
running the request asynchronously in worker context. When the transfer
eventually finishes, the driver writes into host->req->data, which
points to memory inside the already freed card structure. This leads to
a KASAN slab-use-after-free write:

  BUG: KASAN: slab-use-after-free in ms_read_bytes+0x8fe/0x990
  Write of size 1 at addr ffff88813c188079 by task kworker/1:5/5239
  Workqueue: events rtsx_usb_ms_handle_req
  Call Trace:
   ms_read_bytes+0x8fe/0x990 drivers/memstick/host/rtsx_usb_ms.c:450
   rtsx_usb_ms_issue_cmd drivers/memstick/host/rtsx_usb_ms.c:477 [inline]
   rtsx_usb_ms_handle_req+0x557/0x1a00 drivers/memstick/host/rtsx_usb_ms.c:531
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
   worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
   kthread+0x373/0x450 kernel/kthread.c:436

  Allocated by task 1662:
   memstick_alloc_card drivers/memstick/core/memstick.c:383 [inline]
   memstick_check+0x2c1/0x10d0 drivers/memstick/core/memstick.c:452
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396

  Freed by task 1662:
   kfree+0x20c/0x650 mm/slub.c:6792
   memstick_alloc_card drivers/memstick/core/memstick.c:420 [inline]
   memstick_check+0x72b/0x10d0 drivers/memstick/core/memstick.c:452
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396

Host controller drivers (rtsx_usb_ms, jmb38x_ms, tifm_ms, r592) already
implement their own hardware and bus timeouts, and callers in
mspro_block and ms_block already rely on wait_for_completion()
unconditionally.

Replace wait_for_completion_timeout() with wait_for_completion() in
memstick_set_rw_addr() and memstick_alloc_card() so that the card
structure is never freed while an asynchronous request is in flight.

Fixes: baf8532a147d ("memstick: initial commit for Sony MemoryStick support")
Reported-by: syzbot+ccffdf05833ebdaeae70@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccffdf05833ebdaeae70
Cc: stable@vger.kernel.org
Signed-off-by: Raj Ojha <rajojha047@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -369,9 +369,7 @@ int memstick_set_rw_addr(struct memstick
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	if (!wait_for_completion_timeout(&card->mrq_complete,
-			msecs_to_jiffies(500)))
-		card->current_mrq.error = -ETIMEDOUT;
+	wait_for_completion(&card->mrq_complete);
 
 	return card->current_mrq.error;
 }
@@ -405,9 +403,7 @@ static struct memstick_dev *memstick_all
 
 		card->next_request = h_memstick_read_dev_id;
 		memstick_new_req(host);
-		if (!wait_for_completion_timeout(&card->mrq_complete,
-				msecs_to_jiffies(500)))
-			card->current_mrq.error = -ETIMEDOUT;
+		wait_for_completion(&card->mrq_complete);
 
 		if (card->current_mrq.error)
 			goto err_out;


