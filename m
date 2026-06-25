Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23641E633C;
	Thu, 25 Jun 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392781; cv=none; b=nCD0mRjgmLpE8xkrA5W+05366Bc0PvNnLqs40L7hcuYjRXixyv2PoS4BKrf6oAwCKYd/LuOZh3/9jnVGFUPjWqRPr/CFgbvbXHj8CUUFwxIqkBWJMl/hn0ogl2tcGQ7YUmjeRo4ETWxaO/HHar4noQkmCxbLzrsLrsXC3tJaD1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392781; c=relaxed/simple;
	bh=hgsrxSprFN4bqFe6PlxWkHE/prznJ6cFG5DAFOKIOsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdUdKoO09rpeiwq0t0iDMmIYRUOxP27E/GspUBLXG7PMQK9aPCeAqAEvj6Cp3Wb1UJXTsnsTWr4nS7VQTRrAnFko5oAnNcKKo0Fr72tQ7HWkp/qPLGQuYKb5Hj3SXnjM/ukYyLZ4kkHhw5qXdqOZLYnCm8tdyWZqdbpLJsTTWhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fERSYwyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fERSYwyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C341F000E9;
	Thu, 25 Jun 2026 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392779;
	bh=8a4R24ATu7dsvboeINkX3hJ3swyFNdgOdtHm5ooNaJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fERSYwyINXctptT2atY2Cc6DlO6YYq8PwabOvhHl0DuIv8lbyF48WE1vXpqQQfPcE
	 yYWBvC+hG3uYBKlWMMFD043h1+cSPmBwtfKdZTSpR0Wx7MsKSjWClCzk9Ve4o3a7Tk
	 jwaY3V+pvQCCBr/CtKNq2iwHnZuEvqaOUHf6vldU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8ca586b9fc235f0c0df@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 07/60] debugobjects: Do not fill_pool() if pi_blocked_on
Date: Thu, 25 Jun 2026 14:02:52 +0100
Message-ID: <20260625125646.600986183@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

commit 5f41161059fd0f1bbf18c90f3180e38cc45a14eb upstream.

On RT enabled kernels, fill_pool() ends up calling rtlock_lock(), which
asserts if current::pi_blocked_on is set, because a task can obviously only
block on one lock as otherwise the priority inheritenace chain gets
corrupted.

Prevent this by expanding the conditional to take current::pi_blocked_on
into account.

Fixes: 4bedcc28469a ("debugobjects: Make them PREEMPT_RT aware")
Reported-by: syzbot+b8ca586b9fc235f0c0df@syzkaller.appspotmail.com
Signed-off-by: Helen Koike <koike@igalia.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260511215359.3351259-1-koike@igalia.com
Closes: https://syzkaller.appspot.com/bug?extid=b8ca586b9fc235f0c0df
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 4343dc5e5c99da..cbd025dae5ce92 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -711,6 +711,15 @@ static struct debug_obj *lookup_object_or_alloc(void *addr, struct debug_bucket
 	return NULL;
 }
 
+static inline bool debug_objects_is_pi_blocked_on(void)
+{
+#ifdef CONFIG_RT_MUTEXES
+	return current->pi_blocked_on != NULL;
+#else
+	return false;
+#endif
+}
+
 static void debug_objects_fill_pool(void)
 {
 	if (!static_branch_likely(&obj_cache_enabled))
@@ -727,11 +736,12 @@ static void debug_objects_fill_pool(void)
 
 	/*
 	 * On RT enabled kernels the pool refill must happen in preemptible
-	 * context -- for !RT kernels we rely on the fact that spinlock_t and
-	 * raw_spinlock_t are basically the same type and this lock-type
-	 * inversion works just fine.
+	 * context and not enqueued on an rt_mutex -- for !RT kernels we rely
+	 * on the fact that spinlock_t and raw_spinlock_t are basically the
+	 * same type and this lock-type inversion works just fine.
 	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible() || system_state < SYSTEM_SCHEDULING) {
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || system_state < SYSTEM_SCHEDULING ||
+	    (preemptible() && !debug_objects_is_pi_blocked_on())) {
 		/*
 		 * Annotate away the spinlock_t inside raw_spinlock_t warning
 		 * by temporarily raising the wait-type to LD_WAIT_CONFIG, matching
-- 
2.53.0



