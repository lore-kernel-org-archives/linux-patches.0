Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439171C6FE9;
	Mon,  2 Jun 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877463; cv=none; b=QLE7N5bvbdYXHsW1hG7ZoFWYWqvqHlD4LGqzfh1YRZbAP6tKyeApRNCiD5+Ij84rOKyZsGU5UQPeSiflthoi/3N52PYmhxxCj+LmOB027hFAZjW7aHuPmUUEpwidDX2t+bqT0OVhgtZiBlHqiQAaSkrL7ceJ7JDxlwhIs9Y6+JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877463; c=relaxed/simple;
	bh=+SS1IiEH/BcPv6UxkuE8qr29jbcCYIC4IW0wV08P+Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXlmUtp0aTESTjZczMk3WO2Q7AgVh18Dsg5U15PAXxnVN4D7dNzFonI5AfeOGvrsT3Z5vPSNZgDuZihJHQB8Hj1O7/WJm8sWsxrCP8jaebUEIJtGCmcPHvpTw/ZxnCBoQujaHyZoV6d5gbjgOYr38dAjP8h4SGr224xBah9p8zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tH3jIYhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tH3jIYhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ADEC4CEEB;
	Mon,  2 Jun 2025 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877463;
	bh=+SS1IiEH/BcPv6UxkuE8qr29jbcCYIC4IW0wV08P+Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH3jIYhinDo1ba8j2q5htNctgwSSq1O79SIHgvbKWE+zwGG855dPJs0Clr91FR8Kr
	 2U0DRd4jCqKIbdT8sMOi2aP83shko460lhdhfyrY5qswnOToTIKS8/fVU9058ILPvO
	 iqzbqRgdQwZG+ymIE6h/q2rC31WD8G3W5pR9WCto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 286/325] af_unix: Remove io_uring code for GC.
Date: Mon,  2 Jun 2025 15:49:22 +0200
Message-ID: <20250602134331.519036633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 11498715f266a3fb4caabba9dd575636cbcaa8f1 upstream.

Since commit 705318a99a13 ("io_uring/af_unix: disable sending
io_uring over sockets"), io_uring's unix socket cannot be passed
via SCM_RIGHTS, so it does not contribute to cyclic reference and
no longer be candidate for garbage collection.

Also, commit 6e5e6d274956 ("io_uring: drop any code related to
SCM_RIGHTS") cleaned up SCM_RIGHTS code in io_uring.

Let's do it in AF_UNIX as well by reverting commit 0091bfc81741
("io_uring/af_unix: defer registered files gc to io_uring release")
and commit 10369080454d ("net: reclaim skb->scm_io_uring bit").

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20240129190435.57228-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -184,12 +184,10 @@ static bool gc_in_progress;
 
 static void __unix_gc(struct work_struct *work)
 {
-	struct sk_buff *next_skb, *skb;
-	struct unix_sock *u;
-	struct unix_sock *next;
 	struct sk_buff_head hitlist;
-	struct list_head cursor;
+	struct unix_sock *u, *next;
 	LIST_HEAD(not_cycle_list);
+	struct list_head cursor;
 
 	spin_lock(&unix_gc_lock);
 
@@ -293,30 +291,11 @@ static void __unix_gc(struct work_struct
 
 	spin_unlock(&unix_gc_lock);
 
-	/* We need io_uring to clean its registered files, ignore all io_uring
-	 * originated skbs. It's fine as io_uring doesn't keep references to
-	 * other io_uring instances and so killing all other files in the cycle
-	 * will put all io_uring references forcing it to go through normal
-	 * release.path eventually putting registered files.
-	 */
-	skb_queue_walk_safe(&hitlist, skb, next_skb) {
-		if (skb->scm_io_uring) {
-			__skb_unlink(skb, &hitlist);
-			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
-		}
-	}
-
 	/* Here we are. Hitlist is filled. Die. */
 	__skb_queue_purge(&hitlist);
 
 	spin_lock(&unix_gc_lock);
 
-	/* There could be io_uring registered files, just push them back to
-	 * the inflight list
-	 */
-	list_for_each_entry_safe(u, next, &gc_candidates, link)
-		list_move_tail(&u->link, &gc_inflight_list);
-
 	/* All candidates should have been detached by now. */
 	WARN_ON_ONCE(!list_empty(&gc_candidates));
 


