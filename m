Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFB82D249B;
	Mon, 17 Aug 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978854; cv=none; b=jvZqmMuQ26AUoj272xHBRFZxwPEFiPgmMzDPDkKiyQpxMU0tUBJCjZn231ukppX/XndPaQFRFNEoo9OWfrtCLwL9qNeEkgiG2GofJynb3bXYHaKaEsZfZeGYy4qAuqcq2VKOJvBWLmAU98B9/hxIVBkONu5HUHK0Kd0kKQX/ykQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978854; c=relaxed/simple;
	bh=FnZnObrqCBvPti+Nx20qPiF2db6FW15SL/+eMVihbg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBQ6+iFCvIqZErm0NOOOdrLIKVSQ2iH8ctMMOKACuh1LqlkzsF+zkBn9xUO1p+wRogPxjFL0UefFjv2h+UNLXQ5/pgQOMXo1nnYUw38axPu6Q8AGJAmxAFFQW/mIi+0PZ3cZuXGTUQ7FB7HWFrMqQMSvPUHsd9I8RD8McX2fN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq6uvWJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq6uvWJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A731F000E9;
	Mon, 17 Aug 2026 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978852;
	bh=+k0sY1wprCNA6V1C7F//5IbDK6PIcjn2aAPHoJnuzK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq6uvWJcdNImGgHFYlQy02ISD8/AqmgoJkNwPs11PCHLDC13JuBYQIRaW0JjLY5A4
	 7o7ZsAY6nCYAY4C7iyG2sx1XxEEkiERcKwwCzs/XO710huaszU7FEuk5WzafSCi90R
	 JSiu6SLrQxq22ehv/VLqHbzpaLSwmDSSEHFavHjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.1 004/609] seqlock: Cure some more scoped_seqlock() optimization fails
Date: Mon, 17 Aug 2026 15:25:00 +0200
Message-ID: <20260817132543.267232011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


