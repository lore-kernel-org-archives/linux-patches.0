Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211402;
	b=5X74z/uSx5aPeDZXcwPonmSMqiYIujqi/0CQ2XA5wYysJwWjdPCuX+gF8sYA/cDD2s6M
	 E1gxJWyPLGjlASMH8XKKwIikxKyX626QKCs925iDO2jAVZXIGZ60buyriuDJ86hThlGtH
	 mUIFyiEDmoAsBgNpa8zlAmKcMawWa/8nB2hjdXkAXDUN+etBtkf1dqBoMG1ZhANsfCb3N
	 pP+r+avQkOlw4YsHLtdNWbC1JfhbWBOrb5FiD5so2iMGh77vyolElGRoWLV8gW7Go26fz
	 Ifmt5ld4VJ6q0ovdiFsq9MRg/hVyzvJdwynaMQrT8nC1Vf6BWEIWLRMvII5gwjxoFtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R1GZZaKonmrHl3IrmHLu+VOCCeFtvZCko6Gg8XwXyFM=;
	b=vGtfAUgkdqtlg9LeIAQ9/lHr3aTXZhokOthUtVFVcDZ04LiMYObKksApq/73Ol8WhPee
	 Ycb0oovs6CgHoZ/k7Bc2LRWhCI1t97TB37hXwHYY6RUX7sNzxb2T2yJz8/DRgvKkdQFYW
	 cGUsYgSSMV5VLxXdgWH2kgHJ6+3t67kJdNxG0nrZSORo7cD20QURFmUv0iUvKCNuIZId3
	 H9HQnOXgH0bqxBNy4khuOGubE7KCDFI44fgIiPyy2j/XDX+b7RPhIUl5dd2pPYzxWK3y2
	 N5Ho3jBXHIK5eA9HYA03b2gFSF3NPk+ahPWpBJX4TkMGdiUFYga0FulRLBLlKnqTqcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1W3NPww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED11A606A33D;
	Wed, 28 Oct 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1W3NPww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ECD1F01825;
	Wed, 28 Oct 2026 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211401;
	bh=R1GZZaKonmrHl3IrmHLu+VOCCeFtvZCko6Gg8XwXyFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1W3NPwwy0eRnwR85Sk2ovFuxhjimhA+1Jw/bxBnrT7w5Ssmv3Ny/mf2Vts95BzuF
	 c+cs1VbU64t4P64xx9dcSQmZAdm6dDrSPqiMY2FRgbhu7OlhkcjFbrVQnAHDSz5fVO
	 ELMdVN6nFZetj4uafZcB/P6gS34nMUQZy8LGtt+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ccffdf05833ebdaeae70@syzkaller.appspotmail.com,
	Raj Ojha <rajojha047@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 363/571] memstick: core: wait for request completion before freeing card
Date: Wed, 28 Oct 2026 17:58:30 +0100
Message-ID: <20261028170016.629615812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,9 +367,7 @@ int memstick_set_rw_addr(struct memstick
 {
 	card->next_request = h_memstick_set_rw_addr;
 	memstick_new_req(card->host);
-	if (!wait_for_completion_timeout(&card->mrq_complete,
-			msecs_to_jiffies(500)))
-		card->current_mrq.error = -ETIMEDOUT;
+	wait_for_completion(&card->mrq_complete);
 
 	return card->current_mrq.error;
 }
@@ -403,9 +401,7 @@ static struct memstick_dev *memstick_all
 
 		card->next_request = h_memstick_read_dev_id;
 		memstick_new_req(host);
-		if (!wait_for_completion_timeout(&card->mrq_complete,
-				msecs_to_jiffies(500)))
-			card->current_mrq.error = -ETIMEDOUT;
+		wait_for_completion(&card->mrq_complete);
 
 		if (card->current_mrq.error)
 			goto err_out;


