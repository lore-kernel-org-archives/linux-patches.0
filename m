Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A185E30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A295C433CB;
	Wed, 20 Sep 2023 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212796;
	bh=CvqUcpb8giHA26I2NFB3MCp+RPntq8WwkYmfLzue86Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdUP8tViHs5cqCeaqVI/3BFC2V7nNiqe9mnJQtjqTa4GMMmXZLvfobKuI0Dpyn8Jp
	 ccipALhvcjBPH9B5z9Xf9gaqCdr0ZKhDvtcb0STVzWbYvs3yqo/cy0S47kFJSlMtxn
	 S956uwQ27/DOU40HtnqIAakPm7GI74a3wuoFSVyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/367] eventfd: Export eventfd_ctx_do_read()
Date: Wed, 20 Sep 2023 13:27:06 +0200
Message-ID: <20230920112859.758284842@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 78e41c7c3d05b..26b3d821e9168 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -181,11 +181,14 @@ static __poll_t eventfd_poll(struct file *file, poll_table *wait)
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
index 3482f9365a4db..de0ad39d4281f 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -41,6 +41,7 @@ struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
+void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
 
 DECLARE_PER_CPU(int, eventfd_wake_count);
 
@@ -82,6 +83,11 @@ static inline bool eventfd_signal_count(void)
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



