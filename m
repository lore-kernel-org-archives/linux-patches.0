Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47444AB7F;
	Thu, 30 Jul 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425368; cv=none; b=dQpCGwrdXEHFleDOZsN3torJEFaEY1/lIsdK0YO/BM+1baD0AnucVpwmoH3Ybuoq++V1PmrPhmEcODpaVgI9ZyvZ7Z6/p+xH4Pojm9xV5L37NPXKqu7bpNVPAHWdv5AHKp4OjB4wm8m2zTYMz0se6c0zIaS5UcCOA/Vhgv6mcyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425368; c=relaxed/simple;
	bh=0MWcznPiUOTHiO+Nc/FfmuhSrGRNchii1QQw7LXYDUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP/p13llaCwSHEWmqQM8BYLm3q90ENFik4tt7tCDQ/eQZDreyZPxNRqPKTGAw12ZpSuECoGNUmQB/BveLivvU3/rgm2anSfn4KJ7/rvsJKruoGGA8k8eiz2S+MmlEu6zqGIe/9Dm1n/WMByt0G/nzevl0Swt715qtCn9Yvr6l4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02VcTA+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02VcTA+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4953B1F000E9;
	Thu, 30 Jul 2026 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425366;
	bh=crwZHCWUGnd5GR0Er9kFskMup6OtkAm0JIUOrMGtWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02VcTA+d1+ct3VAY+kZh20UKGg6OgZTouJizhCmomK2t7beTzHNATnrIF7I1tnG+x
	 WvakFElywSrfKgd2dK033amh+g29Z7WUMHVbksqdeJnjtlaBT7jFeHu71yK5aTDKxL
	 mSrctuTC0pSVjdnTrWj47FGr4cQjtYlQeV5lrCtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.12 011/602] seqlock: Cure some more scoped_seqlock() optimization fails
Date: Thu, 30 Jul 2026 16:06:43 +0200
Message-ID: <20260730141436.233789438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1201,7 +1201,7 @@ struct ss_tmp {
 	spinlock_t	*lock_irqsave;
 };
 
-static inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
 {
 	if (sst->lock)
 		spin_unlock(sst->lock);
@@ -1226,7 +1226,7 @@ static inline void __scoped_seqlock_bug(
 extern void __scoped_seqlock_bug(void);
 #endif
 
-static inline void
+static __always_inline void
 __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 {
 	switch (sst->state) {


