Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AE743E094;
	Thu, 30 Jul 2026 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427057; cv=none; b=dQLQkTCxrE1U1xxB4kCov0qBSksaIFkTpzaeBcBHrBZQd55SGmR6GZt5+HtEUy5AUrWweeJ6nMLz7tmk3ydtIA0UccHlJmrPxouLYrRwVlnEp/lzdWtvnPkpFncqYQzn4GEoBaCKOzU2EWaNzv7cooCnt1bou4wCONVzB8JFHK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427057; c=relaxed/simple;
	bh=Woi8dFMcmYUws65BB6Cm4LiEkYD68u+MT0IykQteZ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he+cs57JojZ3Pj3KgKL/v09AVhQ1WjZvs231HvXn5kWkeFMPIqn3FAZpBAp1EpP6nl8scsKPOh4T0Uaf1gF32KdOQQy3zNhpGdQu9XsnXPN/mjSi9rr3cBkTpr4HyoTMLYp+I+qnRgQJAulM6woqRRht+YBzO5DF1FeKiIkqlgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipo0NxJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipo0NxJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DA61F000E9;
	Thu, 30 Jul 2026 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427055;
	bh=Jbv/7yvyt1vYTEEm+ag7WaqMce7TBFdV0eX+gPekjso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipo0NxJSQ+UDM+h3OFR9WUDW842zRmZpLRu9JrOR8KKFlH8OCREtI6r6b73ljW5Vv
	 i256bGYNsGC92xVnT5q/oR84oELK+5VqH2D/IP5dzOq/FOkHHPZINQmYAFJlP+qGx+
	 h4cIiNq7RkzrQ69qpqNiDUlMLSnWjjFdwZhpVon8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.6 007/484] seqlock: Cure some more scoped_seqlock() optimization fails
Date: Thu, 30 Jul 2026 16:08:24 +0200
Message-ID: <20260730141423.563735040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 90dfeef1cd38dff19f8b3a752d13bfd79f0f7694 upstream.

Arnd reported an x86 randconfig using gcc-15 tripped over
__scoped_seqlock_bug(). Turns out GCC chose not to inline the
scoped_seqlock helper functions and as such was not able to optimize
properly.

[ mingo: Clang fails the build too in some circumstances. ]

Reported-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20251204104332.GG2528459@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1281,7 +1281,7 @@ struct ss_tmp {
 	spinlock_t	*lock_irqsave;
 };
 
-static inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
 {
 	if (sst->lock)
 		spin_unlock(sst->lock);
@@ -1306,7 +1306,7 @@ static inline void __scoped_seqlock_bug(
 extern void __scoped_seqlock_bug(void);
 #endif
 
-static inline void
+static __always_inline void
 __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 {
 	switch (sst->state) {


