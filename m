Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CEB43F4C7;
	Thu, 30 Jul 2026 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422064; cv=none; b=SWN27DROFbOLaMsmKPUysXwPtgHC+myFpIW7Q0fnZIHjDvuRRWw4dJWrUA59yyI1CcQ2iNu3++1ZM5BJolFbeylct+jnQoAipHoxo6SjRsYmdZKIputOiGeF8Ucq5oxO2EcT0DjHJz6dYP8FRKBxGsq7KdBkcUKdjgaecBF3LEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422064; c=relaxed/simple;
	bh=bFS2TBWwkmbJ+g5KG5AmkZ1F8uZIAe/vCCwozqgtzbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVfA62AhdaYdeaQ3vlflF+AEcBmTCv9WdBXS6Q/i8wRYn8qYU+slRWPs4A+9Hp9Izd/S1A18le5hfEoK4jOpO/ns6Ai81WjcgE3Wf9mLg41UxMLLyuyVEAkPuSKPY7bQQWNs+84LhD3A7z+adjOvaC3FcKqm3E1uSlinjO7xmDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGdAghV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGdAghV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7181F000E9;
	Thu, 30 Jul 2026 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422062;
	bh=bOwmpNUWqSUlZSpC/Q+C9rX8cKDCmzPGaNAZpC52TLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGdAghV8Cp4Z1y+c+jXJMbpBzC1wNtvVC79BRj7mtRpPfDjEb0ZN2PNzipU6d2MxK
	 gYOnrclNLlqb3TesQ2ghm8wQFVk7M5c5ZUAPzzFwpsbXdkO0BrI9ca1zxQWl5ErK+5
	 /ql6hSg0kOJUmzwc8MCozdxBU1qH4LyJdpFTCrjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 310/744] smp: Make CSD lock acquisition atomic for debug mode
Date: Thu, 30 Jul 2026 16:09:43 +0200
Message-ID: <20260730141450.876627191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit 35551efb155e3b83445a6c3f66cb498d5efc182c ]

Commit b0473dcd4b1d ("smp: Improve smp_call_function_single()
CSD-lock diagnostics") changed smp_call_function_single() so that,
when CSD lock debugging is enabled, async !wait calls use the
destination CPU csd_data. That improves diagnostics, but it also removes
the single-writer property that made the old csd_lock() safe: multiple
CPUs can now prepare the same destination CPU CSD concurrently.

csd_lock() currently waits for CSD_FLAG_LOCK to clear and then sets the
bit with a non-atomic read-modify-write. Two senders can both see an
unlocked CSD, set the bit, overwrite the callback fields, and enqueue
the same llist node. Re-adding a node that is already the queue head can
make node->next point to itself, leaving the target CPU stuck walking
call_single_queue. Later synchronous work, such as a TLB shootdown, can
then remain queued and trigger soft-lockup warnings or panics.

Keep the single csd_lock() implementation, but when CSD lock debugging is
enabled, acquire CSD_FLAG_LOCK with try_cmpxchg_acquire(). This makes the
destination CPU CSD a real atomic lock in the only configuration where it
can be shared by multiple remote senders, while preserving the existing
non-debug fast path.

Fixes: b0473dcd4b1d ("smp: Improve smp_call_function_single() CSD-lock diagnostics")
Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260716004539.13983-2-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index dc6582bb35d084..52dffc86555cd2 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -137,10 +137,10 @@ csd_do_func(smp_call_func_t func, void *info, call_single_data_t *csd)
 	trace_csd_function_exit(func, csd);
 }
 
-#ifdef CONFIG_CSD_LOCK_WAIT_DEBUG
-
 static DEFINE_STATIC_KEY_MAYBE(CONFIG_CSD_LOCK_WAIT_DEBUG_DEFAULT, csdlock_debug_enabled);
 
+#ifdef CONFIG_CSD_LOCK_WAIT_DEBUG
+
 /*
  * Parse the csdlock_debug= kernel boot parameter.
  *
@@ -342,6 +342,10 @@ static __always_inline void csd_lock_wait(call_single_data_t *csd)
 	smp_cond_load_acquire(&csd->node.u_flags, !(VAL & CSD_FLAG_LOCK));
 }
 #else
+static __always_inline void __csd_lock_wait(call_single_data_t *csd)
+{
+}
+
 static void csd_lock_record(call_single_data_t *csd)
 {
 }
@@ -354,8 +358,23 @@ static __always_inline void csd_lock_wait(call_single_data_t *csd)
 
 static __always_inline void csd_lock(call_single_data_t *csd)
 {
-	csd_lock_wait(csd);
-	csd->node.u_flags |= CSD_FLAG_LOCK;
+	if (IS_ENABLED(CONFIG_CSD_LOCK_WAIT_DEBUG) &&
+	    static_branch_unlikely(&csdlock_debug_enabled)) {
+
+		for (;;) {
+			unsigned int flags;
+
+			__csd_lock_wait(csd);
+			flags = READ_ONCE(csd->node.u_flags);
+
+			if (!(flags & CSD_FLAG_LOCK) &&
+			    try_cmpxchg_acquire(&csd->node.u_flags, &flags, flags | CSD_FLAG_LOCK))
+				break;
+		}
+	} else {
+		csd_lock_wait(csd);
+		csd->node.u_flags |= CSD_FLAG_LOCK;
+	}
 
 	/*
 	 * prevent CPU from reordering the above assignment
-- 
2.53.0



