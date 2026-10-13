Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE04F7CC9;
	Tue, 13 Oct 2026 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895780; cv=none; b=fC5o5SwTnMsptBZwfdNHHf3bCoWUucrg6glt+O7Mk8dFePrKCS2rdw8cAl27mZcwmo/ov+ZcjPLv3G1bt9nKRs7heCHTByxER5+/y+aIM6XRSsKLyabtfBn+wC9HR5W7qA36WHDwckJBWLgFk31wVJf+zGC+vRVqkz4/ai5ZZyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895780; c=relaxed/simple;
	bh=JAc5BJWp4Vtrn82xTZnPj4IKZhtJRT7kYH6jwoc8YqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8mw85H8QYdWNAGDwA2XZCEyefq2JC9yGuZFbOzQdvKdmRckrVjhRZ0O5u3454ts2x5DbGSK4QhH51ESo6TQss6WPLBCvPFX94to/xsrxxG0/Q+zeyo27dnpw6Va0oun7V83bwKgmODesKBQ+fP2b3VeMMB+rixbFVa2gMa48mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lafQiERu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lafQiERu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FE51F00893;
	Tue, 13 Oct 2026 12:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895779;
	bh=krQb+IhXS1iPwbkValttLXiWr6kaVG0Zp8F+mcTTSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lafQiERui/N9dzVL8wUGI2+9v+9jmF5w/H5Ft4KhC3GPHQovtZ+3znV7T0Q5paPhO
	 ZA+NcpwXotgI2ZA3nSVRyYkOen1mrjEzphsGNyswzKIrQjuwoxB8fsIwaboTt7o+X5
	 0rPutjiXDDuN5qkc2JFEaIbKSkuGSVvys1FbDksQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ccffdf05833ebdaeae70@syzkaller.appspotmail.com,
	Raj Ojha <rajojha047@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 390/497] memstick: core: wait for request completion before freeing card
Date: Tue, 13 Oct 2026 13:39:17 +0200
Message-ID: <20261013112917.151069843@linuxfoundation.org>
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
@@ -366,9 +366,7 @@ int memstick_set_rw_addr(struct memstick
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	if (!wait_for_completion_timeout(&card->mrq_complete,
-			msecs_to_jiffies(500)))
-		card->current_mrq.error = -ETIMEDOUT;
+	wait_for_completion(&card->mrq_complete);
 
 	return card->current_mrq.error;
 }
@@ -402,9 +400,7 @@ static struct memstick_dev *memstick_all
 
 		card->next_request = h_memstick_read_dev_id;
 		memstick_new_req(host);
-		if (!wait_for_completion_timeout(&card->mrq_complete,
-				msecs_to_jiffies(500)))
-			card->current_mrq.error = -ETIMEDOUT;
+		wait_for_completion(&card->mrq_complete);
 
 		if (card->current_mrq.error)
 			goto err_out;


