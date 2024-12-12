Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9E21766D;
	Thu, 12 Dec 2024 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016534; cv=none; b=V8uqCSwpPUbg5OmuyGaPSQhHHvUGvCMqU2WxiYo9AZUlE6MnsKURf3nn/l0Knyz0ba1w1/4fnUL4qugbA+T4aTmJbPwT80+9r/rhLmZWCamOeotTy6iJkerJ/gG3zQONcSusif+GRxVjUJZ5B7muHhZFVFwOAAtUfnN+aKYTXzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016534; c=relaxed/simple;
	bh=P2rl59M/j8HMCXEQ+Cnfm5XVd1+KDPmLHz45Zb+1638=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rixbUYSOu8DQPb5vfboSGJFiCmMrpDs+UB5yKIuHyY9vhUeWXOn6yf0/mki3lglvmxVPCQAUkTcByZ85RNJHdBiwrxlBXuZ09MQlGWqs16NP6bf7O82M+pADqRWYlaUeuQPX+c0yHf3A2DvrmmC9DIOutLJt1h455DT6SQF3vzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Fmq5ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Fmq5ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17705C4CED0;
	Thu, 12 Dec 2024 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016534;
	bh=P2rl59M/j8HMCXEQ+Cnfm5XVd1+KDPmLHz45Zb+1638=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0Fmq5ZW8F5FssRHm77OMWAp6GWgWAdg7gqFbdN7JA2TJd2PbV1RZ/UgsDEqEAPfZ
	 5O+IISAFkYgXHPjafOhYh6RB+ubG0SIx/a758x0mbMCoIkBds/tEqIl0UXNQNzLWzf
	 i4vqzSR3NtuVBA7B9SRzgIN4SzGidUvbCfzCaza4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 195/466] stackdepot: fix stack_depot_save_flags() in NMI context
Date: Thu, 12 Dec 2024 15:56:04 +0100
Message-ID: <20241212144314.497251978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Elver <elver@google.com>

commit 031e04bdc834cda3b054ef6b698503b2b97e8186 upstream.

Per documentation, stack_depot_save_flags() was meant to be usable from
NMI context if STACK_DEPOT_FLAG_CAN_ALLOC is unset.  However, it still
would try to take the pool_lock in an attempt to save a stack trace in the
current pool (if space is available).

This could result in deadlock if an NMI is handled while pool_lock is
already held.  To avoid deadlock, only try to take the lock in NMI context
and give up if unsuccessful.

The documentation is fixed to clearly convey this.

Link: https://lkml.kernel.org/r/Z0CcyfbPqmxJ9uJH@elver.google.com
Link: https://lkml.kernel.org/r/20241122154051.3914732-1-elver@google.com
Fixes: 4434a56ec209 ("stackdepot: make fast paths lock-less again")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/stackdepot.h |    6 +++---
 lib/stackdepot.c           |   10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -147,7 +147,7 @@ static inline int stack_depot_early_init
  * If the provided stack trace comes from the interrupt context, only the part
  * up to the interrupt entry is saved.
  *
- * Context: Any context, but setting STACK_DEPOT_FLAG_CAN_ALLOC is required if
+ * Context: Any context, but unsetting STACK_DEPOT_FLAG_CAN_ALLOC is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case for contexts where neither %GFP_ATOMIC nor
  *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
@@ -156,7 +156,7 @@ static inline int stack_depot_early_init
  */
 depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 					    unsigned int nr_entries,
-					    gfp_t gfp_flags,
+					    gfp_t alloc_flags,
 					    depot_flags_t depot_flags);
 
 /**
@@ -175,7 +175,7 @@ depot_stack_handle_t stack_depot_save_fl
  * Return: Handle of the stack trace stored in depot, 0 on failure
  */
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
-				      unsigned int nr_entries, gfp_t gfp_flags);
+				      unsigned int nr_entries, gfp_t alloc_flags);
 
 /**
  * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -630,7 +630,15 @@ depot_stack_handle_t stack_depot_save_fl
 			prealloc = page_address(page);
 	}
 
-	raw_spin_lock_irqsave(&pool_lock, flags);
+	if (in_nmi()) {
+		/* We can never allocate in NMI context. */
+		WARN_ON_ONCE(can_alloc);
+		/* Best effort; bail if we fail to take the lock. */
+		if (!raw_spin_trylock_irqsave(&pool_lock, flags))
+			goto exit;
+	} else {
+		raw_spin_lock_irqsave(&pool_lock, flags);
+	}
 	printk_deferred_enter();
 
 	/* Try to find again, to avoid concurrently inserting duplicates. */


