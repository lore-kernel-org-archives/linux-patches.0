Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4BC6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E29C433C7;
	Sun, 17 Sep 2023 19:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978461;
	bh=sR81dnaaaLWGrBIcKKj+EJ3wUQmsdG3TQj5KHUzTMmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCBHGMJWM+tuy7NLZLEqMOIyOcep75ci09C0HbFdAaVoCa54LHo9mVMeMOpK2zTQE
	 rfquGYjuoT5VR9AzcUHkTj0X7Hm56WcCsPSPZm6bpdWeK6aUfQ6tifVFih5Aa/PJ7R
	 Bhu0XvSwUpAv1CcBwzdRzPbkO5mClYQ3mM92AHZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/406] eventfd: Export eventfd_ctx_do_read()
Date: Sun, 17 Sep 2023 21:08:40 +0200
Message-ID: <20230917191102.881791034@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 28f1326710555bbe666f64452d08f2d7dd657cae ]

Where events are consumed in the kernel, for example by KVM's
irqfd_wakeup() and VFIO's virqfd_wakeup(), they currently lack a
mechanism to drain the eventfd's counter.

Since the wait queue is already locked while the wakeup functions are
invoked, all they really need to do is call eventfd_ctx_do_read().

Add a check for the lock, and export it for them.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <20201027135523.646811-2-dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 758b49204781 ("eventfd: prevent underflow for eventfd semaphores")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventfd.c            | 5 ++++-
 include/linux/eventfd.h | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 4a14295cffe0d..b8d38b970ce7f 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -187,11 +187,14 @@ static __poll_t eventfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
-static void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
+void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
 {
+	lockdep_assert_held(&ctx->wqh.lock);
+
 	*cnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
 	ctx->count -= *cnt;
 }
+EXPORT_SYMBOL_GPL(eventfd_ctx_do_read);
 
 /**
  * eventfd_ctx_remove_wait_queue - Read the current counter and removes wait queue.
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 6cd2a92daf205..c1bd4883e2faf 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -42,6 +42,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
 __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
+void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
 
 DECLARE_PER_CPU(int, eventfd_wake_count);
 
@@ -89,6 +90,11 @@ static inline bool eventfd_signal_count(void)
 	return false;
 }
 
+static inline void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
+{
+
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */
-- 
2.40.1



