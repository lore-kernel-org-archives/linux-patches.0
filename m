Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210159;
	b=w1m6pBddm4NnS7VSVYdx4k+UlkV1lzBLzFEUWWrf85QDapqSzRqUBM0XTy/KHB0BETB4
	 Wfd1knhs2+gvbUn0O+iORMuU2iiDdgJa31H3mBpulp4HlBsKG5vnOmf3XHEJ6GcaV/nFU
	 cJ6BdFQSb9DwPNkUYrmxZxV0X041KtAAu96fKzAtfwXkITZLugEBmDXq0LlFJA+ot4rQh
	 arkrc67JGHK8+s+w49lGDxrHxwI8fSDQKm9xgJQK9npvHGQVVekgaWiZbY53TOvfxnybS
	 Tw+5h3J7OhbgCWY41Ex2ypuQ65nedvrYoh0N34o64U5JQUxaXANXCg82Q6mSo/MISNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=prtqZVi86yAlHtD/fd1IQi1BD+Zl4MykMi0HCLYOVlo=;
	b=XxF3rS8sMa+cGAOxOF28VF/9c+Aj2Irh7fsR77Hs/9+8zDMzaj1qH9N2nwahVHrQrU0e
	 WQ3g7+w/FuwLfajmI1HjvgPsIUdh5KtSzCFxLIdTRbpW2I/Jf86j52h6RQJ7zFGb3MGVU
	 HAwKiGJvEFR44rXQUjAHuQ5tNjlA1rIr2G3rCv+8VzjqtTj0ZSwUjLA7CiC1au+LP6laL
	 xlzJ5mVyFAEVuIXQQo0mk4frkNQCsLbmgg2Pazf5B/nPVQux8WGJiddVp8W28bhW24mKt
	 Sh8xXPfeCdE+/oYg9KPv9Z9tAwwi8LZ5rXat51F+d4H/rY8jgAxZ1T7MYJcSO3xsdfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PluWu0Gy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437E860A2630;
	Wed, 28 Oct 2026 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PluWu0Gy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5605A1F01828;
	Wed, 28 Oct 2026 17:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210158;
	bh=prtqZVi86yAlHtD/fd1IQi1BD+Zl4MykMi0HCLYOVlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PluWu0GyhVJY93p2yzb4PUYhrrtq5Y0p74uOIEdsVimCRs2DnjY/xuwYreNKA5zD0
	 3tXhX8Vp5CKJq9XrBIzJ5vCgJQjg76Nzc9AiEIs6TrnYkPL2XpsK/cmmCHE+KiaR7w
	 GF2n2E31S2N7eAdzlUI1l/2CNOQBP+DeERj+wDcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/168] watch_queue: Fix note pool publication race in watch_queue_set_size()
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028165945.338576743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 5e531d62f1f8834faf7a4eed0d41105cf6570a8f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 0840603c91e37..d5a76a5efd204 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -101,7 +101,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	struct pipe_inode_info *pipe = wqueue->pipe;
 	struct pipe_buffer *buf;
 	struct page *page;
-	unsigned int head, tail, note, offset, len;
+	unsigned int head, tail, note, offset, len, nr_notes;
 	bool done = false;
 
 	spin_lock_irq(&pipe->rd_wait.lock);
@@ -111,8 +111,10 @@ static bool post_one_notification(struct watch_queue *wqueue,
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
@@ -297,7 +299,8 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	wqueue->notes = pages;
 	wqueue->notes_bitmap = bitmap;
 	wqueue->nr_pages = nr_pages;
-	wqueue->nr_notes = nr_notes;
+	/* Pairs with the smp_load_acquire() in post_one_notification(). */
+	smp_store_release(&wqueue->nr_notes, nr_notes);
 	return 0;
 
 error_p:
-- 
2.53.0



