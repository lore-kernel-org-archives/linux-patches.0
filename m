Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013BD199B7
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeyPaqIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B766C433C7;
	Mon,  9 Oct 2023 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858642;
	bh=UIEaVgMhHs5QHFmjWg3+w0uuDW93SlL4MR0IVr1o7xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeyPaqIskpjoxn0bLRTnrcHIy6heB6zE+9rHjcNv9qabNMS5j0FkUP5iayp4MhyBa
	 YP0lZ8jLqRtiGlYmFJ8o5LWcziHccalgbrXpgckBxDQ93vy4sJDUl9kmj8nYwKHonF
	 DDeqcI/aXh9nbQhOnRud/yyT/xpq6bIdVcZHNVW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/226] seqlock: avoid -Wshadow warnings
Date: Mon,  9 Oct 2023 15:00:15 +0200
Message-ID: <20231009130128.203362509@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a07c45312f06e288417049208c344ad76074627d ]

When building with W=2, there is a flood of warnings about the seqlock
macros shadowing local variables:

  19806 linux/seqlock.h:331:11: warning: declaration of 'seq' shadows a previous local [-Wshadow]
     48 linux/seqlock.h:348:11: warning: declaration of 'seq' shadows a previous local [-Wshadow]
      8 linux/seqlock.h:379:11: warning: declaration of 'seq' shadows a previous local [-Wshadow]

Prefix the local variables to make the warning useful elsewhere again.

Fixes: 52ac39e5db51 ("seqlock: seqcount_t: Implement all read APIs as statement expressions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201026165044.3722931-1-arnd@kernel.org
Stable-dep-of: 41b43b6c6e30 ("locking/seqlock: Do the lockdep annotation before locking in do_write_seqcount_begin_nested()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1ac20d75b0618..fb89b05066f43 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -328,13 +328,13 @@ SEQCOUNT_LOCKNAME(ww_mutex,     struct ww_mutex, true,     &s->lock->base, ww_mu
  */
 #define __read_seqcount_begin(s)					\
 ({									\
-	unsigned seq;							\
+	unsigned __seq;							\
 									\
-	while ((seq = __seqcount_sequence(s)) & 1)			\
+	while ((__seq = __seqcount_sequence(s)) & 1)			\
 		cpu_relax();						\
 									\
 	kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX);			\
-	seq;								\
+	__seq;								\
 })
 
 /**
@@ -345,10 +345,10 @@ SEQCOUNT_LOCKNAME(ww_mutex,     struct ww_mutex, true,     &s->lock->base, ww_mu
  */
 #define raw_read_seqcount_begin(s)					\
 ({									\
-	unsigned seq = __read_seqcount_begin(s);			\
+	unsigned _seq = __read_seqcount_begin(s);			\
 									\
 	smp_rmb();							\
-	seq;								\
+	_seq;								\
 })
 
 /**
@@ -376,11 +376,11 @@ SEQCOUNT_LOCKNAME(ww_mutex,     struct ww_mutex, true,     &s->lock->base, ww_mu
  */
 #define raw_read_seqcount(s)						\
 ({									\
-	unsigned seq = __seqcount_sequence(s);				\
+	unsigned __seq = __seqcount_sequence(s);			\
 									\
 	smp_rmb();							\
 	kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX);			\
-	seq;								\
+	__seq;								\
 })
 
 /**
-- 
2.40.1



