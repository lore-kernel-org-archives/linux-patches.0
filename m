Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9464B4C6803;
	Wed,  9 Sep 2026 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962002; cv=none; b=alLjfg6Pc7IoKWizLO79HLgOKryahBE0xrAFBBnhqmFgWmKDRP8M6ZAWhLeQoedKzwyBG/onw58VBEXeibfsDO0iuO8+T3sM+woAd8OtuFk9zGIDOOmZBgb8OI8OSvX+CA3ltUnRpT2UwUGkOQT58+JRZhOaqM3GlfPcxPrntHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962002; c=relaxed/simple;
	bh=KtUpWfOqysPR6qTvje9wRYhlIE0qiiP7Gma3IuMAw90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYIxC7afLn9Vxi4i+L3N74xb+i17kfTTH+qwrKxMoB9P5OHgfwJIIXazNx9HWRsgnZFEMUGdBeY11YMLac0DMyos0ruE1NBMmv2npfF7Cp0MOLY/T1rhCbt02RP3/iDHsCRnkY0kHPrJHw5k1NOS51rIms0UjmItxs+tXDkcuMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zULjUaWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zULjUaWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B295B1F00A3A;
	Wed,  9 Sep 2026 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962001;
	bh=dEK8tKxlQ1qEKovtXiRtcNYpkIkeO9Q5ScI1r51VbU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zULjUaWAjXhj7AsyDoxbCPxZ/FrmQaH4YmmEr2d9wOVXHhvMvHa0mKaXQ0sjtoGog
	 rIBdiJfLABFVasfk7eckMJdU+3GT6jwhcHryFbnClbOa4xyUo9eJ0tLPMHX3YMMTDs
	 5+RwXPMkH/vuC37cSVxkjh+aHUIwkcL60TNHS398=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Peter Zijlstra <peterz@infradead.org>,
	Weiming Shi <shiweiming@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>
Subject: [PATCH 7.2 140/556] perf: Fix use-after-free when perf mmap() revival races with the last munmap()
Date: Wed,  9 Sep 2026 15:37:00 +0200
Message-ID: <20260909134235.377569751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Zhang <yilinzhang@moonshot.ai>

commit 58a8108bc73de0740d5b88150465d6690ea5f85f upstream.

perf_mmap_close() drops rb->mmap_count *without* holding
event->mmap_mutex (the refcount_dec_and_test() right before the
refcount_dec_and_mutex_lock() of event->mmap_count). A concurrent
perf_mmap_rb() can slot its entire "revival" path into that window
(perf_mmap holds event->mmap_mutex for its whole duration, including
rb_alloc):

  munmap side (perf_mmap_close)          mmap side (perf_mmap_rb)
  -----------------------------------    --------------------------------
  rb->mmap_count 1 -> 0   (no lock)      (holds event->mmap_mutex)
                                         inc_not_zero(rb->mmap_count) fails
                                         ring_buffer_attach(event, NULL)
                                         rb_alloc() + attach new rb
                                         refcount_set(&event->mmap_count, 1)
  lock; event->mmap_count 1 -> 0
  ring_buffer_attach(event, NULL)
  ring_buffer_put() -> frees the *new* rb

The revival's refcount_set(&event->mmap_count, 1) is an invisible
1 -> 1 write: the close frees the just-revived buffer although the
other process still has it mapped -- a page-level use-after-free
allowing local privilege escalation to root by any unprivileged user
(default kernel.perf_event_paranoid=2).

Swap the order of the two counter updates: event->mmap_count is
dropped first via refcount_dec_and_mutex_lock(), so its 1 -> 0
transition and the ring_buffer_attach() stay serialized with
perf_mmap(). rb->mmap_count == 0 then implies every event using the
buffer is detached already, so the result of the rb->mmap_count drop
can gate the remaining teardown directly and detach_rest is no longer
needed.

An earlier fix for this race from Kyle Zeng and David Lee takes
event->mmap_mutex around both counter updates [0]; here the not-last
close stays lockless.

Fixes: 59741451b49c ("perf: Identify the 0->1 transition for event::mmap_count")
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Co-developed-by: Weiming Shi <shiweiming@moonshot.ai>
Signed-off-by: Weiming Shi <shiweiming@moonshot.ai>
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/linux-perf-users/20260804060931.711308-1-david.lee@trailofbits.com/ [0]
Cc: <stable@vger.kernel.org>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260831162155.1437652-1-yilinzhang@moonshot.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7029,7 +7029,6 @@ static void perf_mmap_close(struct vm_ar
 	mapped_f unmapped = get_mapped(event, event_unmapped);
 	struct perf_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
-	bool detach_rest = false;
 
 	/* FIXIES vs perf_pmu_unregister() */
 	if (unmapped)
@@ -7060,17 +7059,18 @@ static void perf_mmap_close(struct vm_ar
 		mutex_unlock(&rb->aux_mutex);
 	}
 
-	if (refcount_dec_and_test(&rb->mmap_count))
-		detach_rest = true;
-
-	if (!refcount_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
-		goto out_put;
-
-	ring_buffer_attach(event, NULL);
-	mutex_unlock(&event->mmap_mutex);
+	/*
+	 * Drop references in reverse order of perf_mmap() to prevent
+	 * rb revival after rb->mmap_count reaches zero.
+	 */
+	if (refcount_dec_and_mutex_lock(&event->mmap_count,
+					&event->mmap_mutex)) {
+		ring_buffer_attach(event, NULL);
+		mutex_unlock(&event->mmap_mutex);
+	}
 
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (!detach_rest)
+	if (!refcount_dec_and_test(&rb->mmap_count))
 		goto out_put;
 
 	/*


