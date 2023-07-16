Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043B78F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0A1C433C8;
	Sun, 16 Jul 2023 20:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539237;
	bh=sAvxDAvpZIGEhfezrcwVQoH/pX2QTjTEtDwlUABkclQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+0Y5Z/JaeVG1UaGhM4UsRL9ElvKrbUV1BoH2ld0ZbiNpS6Uy1AgrGsP70vC+eENQ
	 KHLRg68EpyKME9vYjblyCyMsoucbzL2NMD9+2+p2ZOgKAUQKcj/p1PwmHn8C5ZXCd9
	 T9AB3Vgu/nbR04ro9hEVRHb90Zq16n6k+IDWp1nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <code@siddh.me>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.4 737/800] watch_queue: prevent dangling pipe pointer
Date: Sun, 16 Jul 2023 21:49:50 +0200
Message-ID: <20230716195006.235853293@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddh Raman Pant <code@siddh.me>

commit 943211c87427f25bd22e0e63849fb486bb5f87fa upstream.

NULL the dangling pipe reference while clearing watch_queue.

If not done, a reference to a freed pipe remains in the watch_queue,
as this function is called before freeing a pipe in free_pipe_info()
(see line 834 of fs/pipe.c).

The sole use of wqueue->defunct is for checking if the watch queue has
been cleared, but wqueue->pipe is also NULLed while clearing.

Thus, wqueue->defunct is superfluous, as wqueue->pipe can be checked
for NULL. Hence, the former can be removed.

Tested with keyutils testsuite.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Acked-by: David Howells <dhowells@redhat.com>
Message-Id: <20230605143616.640517-1-code@siddh.me>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/watch_queue.h |    3 +--
 kernel/watch_queue.c        |   12 ++++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -38,7 +38,7 @@ struct watch_filter {
 struct watch_queue {
 	struct rcu_head		rcu;
 	struct watch_filter __rcu *filter;
-	struct pipe_inode_info	*pipe;		/* The pipe we're using as a buffer */
+	struct pipe_inode_info	*pipe;		/* Pipe we use as a buffer, NULL if queue closed */
 	struct hlist_head	watches;	/* Contributory watches */
 	struct page		**notes;	/* Preallocated notifications */
 	unsigned long		*notes_bitmap;	/* Allocation bitmap for notes */
@@ -46,7 +46,6 @@ struct watch_queue {
 	spinlock_t		lock;
 	unsigned int		nr_notes;	/* Number of notes */
 	unsigned int		nr_pages;	/* Number of pages in notes[] */
-	bool			defunct;	/* T when queues closed */
 };
 
 /*
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -42,7 +42,7 @@ MODULE_AUTHOR("Red Hat, Inc.");
 static inline bool lock_wqueue(struct watch_queue *wqueue)
 {
 	spin_lock_bh(&wqueue->lock);
-	if (unlikely(wqueue->defunct)) {
+	if (unlikely(!wqueue->pipe)) {
 		spin_unlock_bh(&wqueue->lock);
 		return false;
 	}
@@ -104,9 +104,6 @@ static bool post_one_notification(struct
 	unsigned int head, tail, mask, note, offset, len;
 	bool done = false;
 
-	if (!pipe)
-		return false;
-
 	spin_lock_irq(&pipe->rd_wait.lock);
 
 	mask = pipe->ring_size - 1;
@@ -603,8 +600,11 @@ void watch_queue_clear(struct watch_queu
 	rcu_read_lock();
 	spin_lock_bh(&wqueue->lock);
 
-	/* Prevent new notifications from being stored. */
-	wqueue->defunct = true;
+	/*
+	 * This pipe can be freed by callers like free_pipe_info().
+	 * Removing this reference also prevents new notifications.
+	 */
+	wqueue->pipe = NULL;
 
 	while (!hlist_empty(&wqueue->watches)) {
 		watch = hlist_entry(wqueue->watches.first, struct watch, queue_node);


