Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773968;
	b=UjVfCeGXRGpF3b8WyVZ57FcY5g6UKXlE6+swm6QB1SLHnTEWPC2WlgYz7r7qqWVwFQ00
	 oY8INt7vhmD6AuSsvTjDhXyznbAzKJsRZ5GK+Yi3yONrUOyA2OE1nmodAizwaripV7Efx
	 Ig0iR1ZFtp/Fo/JTfKmjr/IyTD3ZSMxcW6gns8GROphvyVy9Rdb4ABemJ9CDkteoUYMTK
	 qYu4Z45vJTLlJyFHBxxqbhO7ZFoyJ9t8IRUt1b6X71ZUvApFVK4Y5yftLBKldUcmeLIBP
	 8vsLZzrEN+pVG9hKRszo7xLVxHGUWAUxN236TCakO404dopPR2ChFFnV+43nTyhnXMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sFX0BvlxZAybs/wDoYtZImiytGdMvGabqvd21YcJYOc=;
	b=OcM3Utzz3IezdyjPRcUv0VwqioUVtiiqIXLwcfavfI9JY0lO3NfW/DAn86cFtbYj2hye
	 +OZ0930gGwOJYNrVF03kqItNOth5zJ+2VpJl4dLsIpISXbLkZJ7K8YG+rN3s9lj+GWdbj
	 foS1rbp8qlQ9ktRhyqF7w+L03JqVq0EtCYKuGL0UdjVaVhGUgaUji/KGp+etse39SF5CO
	 ELIkVHS9tZDJFcNUJCYDB0xBuh8ENzxK1Jv9nU3rP2nB7Q9xuE6qaYj2c+0KT+7i01D7k
	 Hg0ujXNJ9ilVSpz4lqOQ0HX0ohiNTkirijrVptQbqrCkrVujg1FNA6GoNInFPvhwRxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWM6mfrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1CA606A31A;
	Fri, 23 Oct 2026 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWM6mfrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD8D1F01825;
	Fri, 23 Oct 2026 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773967;
	bh=sFX0BvlxZAybs/wDoYtZImiytGdMvGabqvd21YcJYOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWM6mfrzbdr49CV/Ow57w2WLdJnDce3KUgtyaInr/TYdcVMaGBHMFhcdrHzfmEBiG
	 FKNt+gEAqd1430ouxNHtL6+eewO7F4CZ2f1NTD7/uCWpa7e4+lJ5u/jcDwDG2ubKTM
	 jXhI5Dh7b0EzwncXvaX/4DoFWSUtU08cszhmNjlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 076/193] watch_queue: Fix note pool publication race in watch_queue_set_size()
Date: Fri, 23 Oct 2026 18:35:53 +0200
Message-ID: <20261023163716.000454660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

commit 5e531d62f1f8834faf7a4eed0d41105cf6570a8f upstream.

There is a race between watch_queue_set_size() and post_one_notification().
watch_queue_set_size() publishes wqueue->notes, notes_bitmap, nr_pages and
nr_notes with plain stores, and post_one_notification() reads them with
plain loads under a different lock, so nothing orders the four stores
against the poster's loads: depending on the build, notes can be stored
last (gcc 14 on x86-64 does this).  Since keyctl_watch_key() lets a watch
attach to a queue before it is sized, post_one_notification() can already
be running on another CPU at that moment: it reads nr_notes > 0, passes
its bounds check, and then reads notes while it is still NULL,
dereferencing notes[0].

An unprivileged user triggers this reliably by watching one of its own
keys through a notification pipe and racing ioctl(IOC_WATCH_QUEUE_SET_SIZE)
on that pipe against keyctl(KEYCTL_SETPERM) on the key from another CPU,
triggering:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:post_one_notification.isra.0+0xa2/0x1e0
  Call Trace:
   __post_watch_notification+0x148/0x180
   keyctl_setperm_key+0x119/0x130
   do_syscall_64+0x108/0x4c0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Kernel panic - not syncing: Fatal exception in interrupt

Fix this by publishing nr_notes last with smp_store_release(), and by
reading it once with smp_load_acquire() in post_one_notification() before
the bitmap and the page array are touched.  A poster that observes a
non-zero nr_notes then also observes the pool behind it; one that observes
zero drops the notification as before.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Dae R. Jeong <threeearcat@gmail.com>
Closes: https://lore.kernel.org/all/ZT-S8Q7tyutcvu_q@dragonet/
Reported-by: AutonomousCodeSecurity@microsoft.com
Suggested-by: Dae R. Jeong <threeearcat@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Link: https://patch.msgid.link/20261009224715.46121-1-cenzhang@linux.microsoft.com
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -101,7 +101,7 @@ static bool post_one_notification(struct
 	struct pipe_inode_info *pipe = wqueue->pipe;
 	struct pipe_buffer *buf;
 	struct page *page;
-	unsigned int head, tail, note, offset, len;
+	unsigned int head, tail, note, offset, len, nr_notes;
 	bool done = false;
 
 	spin_lock_irq(&pipe->rd_wait.lock);
@@ -111,8 +111,10 @@ static bool post_one_notification(struct
 	if (pipe_full(head, tail, pipe->ring_size))
 		goto lost;
 
-	note = find_first_bit(wqueue->notes_bitmap, wqueue->nr_notes);
-	if (note >= wqueue->nr_notes)
+	/* Pairs with the smp_store_release() in watch_queue_set_size(). */
+	nr_notes = smp_load_acquire(&wqueue->nr_notes);
+	note = find_first_bit(wqueue->notes_bitmap, nr_notes);
+	if (note >= nr_notes)
 		goto lost;
 
 	page = wqueue->notes[note / WATCH_QUEUE_NOTES_PER_PAGE];
@@ -297,7 +299,8 @@ long watch_queue_set_size(struct pipe_in
 	wqueue->notes = pages;
 	wqueue->notes_bitmap = bitmap;
 	wqueue->nr_pages = nr_pages;
-	wqueue->nr_notes = nr_notes;
+	/* Pairs with the smp_load_acquire() in post_one_notification(). */
+	smp_store_release(&wqueue->nr_notes, nr_notes);
 	return 0;
 
 error_p:


