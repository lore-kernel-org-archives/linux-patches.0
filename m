Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8809D8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C04DC433C7;
	Sun, 16 Jul 2023 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540932;
	bh=D/J2/m1xCjd7q/92n1eW/+BvxSEjW1/ljxk7o34EdS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDE/9bbnsyqbH4ZVU59NDRA6XdB5mL92aD6293zON2LPZi08JSeDCC0J1ghRX799w
	 rhCdnLs5Ltk5OarGuh0gW+PUrc3GyXDToFeql2dlLEY1+Fyjxx6OIzkjRFuF++grPM
	 JhQWm+Bwzr08qdKdLvsXf1ygQweuKlmZFVpwbU5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <code@siddh.me>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 539/591] watch_queue: prevent dangling pipe pointer
Date: Sun, 16 Jul 2023 21:51:18 +0200
Message-ID: <20230716194937.808912408@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 static inline bool lock_wqueue(struct watch_queue *wqueue)
 {
 	spin_lock_bh(&wqueue->lock);
-	if (unlikely(wqueue->defunct)) {
+	if (unlikely(!wqueue->pipe)) {
 		spin_unlock_bh(&wqueue->lock);
 		return false;
 	}
@@ -105,9 +105,6 @@ static bool post_one_notification(struct
 	unsigned int head, tail, mask, note, offset, len;
 	bool done = false;
 
-	if (!pipe)
-		return false;
-
 	spin_lock_irq(&pipe->rd_wait.lock);
 
 	mask = pipe->ring_size - 1;
@@ -604,8 +601,11 @@ void watch_queue_clear(struct watch_queu
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


