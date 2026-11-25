Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624627;
	b=NW81df9l/3tQ7inFkIbzkhK6Ke5crhaouhd/GOhGG/6A318027OAenyYkTzRULkJ6eLv
	 3UUueskHMdO53F9WyTTvkNEee8nXLovgQsPFqSf1swXg9VXbkvlPxsXf3UT7VdPUfR52X
	 rrzEiW60cOJfy00Peg1SKZCzBxbIjXQFB0cWBq9NuPLyhS22ww1/QgUo2eZeE40s++2dL
	 w4Em8ASgiPNizZeCi8vGjg6NfLaWL0Ecl94di80lzk5xbO9K6qfZcTchHQxJNUzjKmA25
	 r26VjBqLgI4vK6eBj15Am1m0mLQ7Y01VlffEkOmI51V5Y86jI3bJ0nEGFfxA3pT3pTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh/8MT0tOS8Mpkeb4VDgGaAx9TwLGxUrNq8s5AJCRyQ=;
	b=OyJDT2CEEW2HRGxOAemQ1Ainse5awp0CvtxBinL/NXsKU+bIdYksWqyNk0GYQ1MhLao6
	 tJty+QZRc1SfWmST47gfqj7MRjH42sck6jO9OEhfpmxmWRcxokzsXSRMqyXCR9JFcoR+p
	 KSXBOnGwwrWINXnjosxsN6E2Q77Z+Nao0dSj86vU9G2d32Jd5d8RNcHV8w2EFwfEGzVC3
	 /eJr4ZHA5Of/bb7+LvM13lWOzbBUxzqpqibKY6ocYXVC6flyVH0TvULOPODiTz15AZlEQ
	 gft71fExVvNmXJIjvj+1REDa0w3tuEpRRPo7MeknXiQcDi6TkBecLppmk9e+KHek5CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFBNddKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BBE606A33D;
	Wed, 25 Nov 2026 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFBNddKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E87E1F000C6;
	Wed, 25 Nov 2026 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624627;
	bh=Mh/8MT0tOS8Mpkeb4VDgGaAx9TwLGxUrNq8s5AJCRyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFBNddKmA+V2PU6sEscQn48g/oqIutWBG+xTS9iAqsm8prMpwHV3W+MlRCLn+ww+7
	 iVdS7WPWysn7MO7kerPMPYQsILS2up5g0Yd1F0w0iL0y+rq3CMq5HIQ0TucPv0ueLN
	 TDgD/37Xiqt4gk16+Br9VyDrVJrUk94AQQH0MuIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/816] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
Date: Wed, 25 Nov 2026 15:30:02 +0100
Message-ID: <20261125143855.088936801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1b9e01fcc47aff00d2fd64693c5dcd620eff5865 ]

The atomic_cmpxchg() in osq_wait_next() removes the current CPU's node
from the tail of the queue and puts @old_cpu back.

This is very much like an 'unlock', which is RELEASE, rather than
ACQUIRE.

Additionally, on success (the only case where the ordering is
effective), this returns NULL which means both callsites will do nothing
more, there are no subsequent operations to order against.

Furthermore, the osq_lock() caller will then return false, indicating
failure to acquire -- the mutex must go block. Again, not making a case
for ACQUIRE.  Neither atomics nor locks provide ordering on failure.

Since ACQUIRE makes no sense, while RELEASE makes it more symmetric with
osq_unlock(), switch the ordering. This then makes osq_unlock()
consistently RELEASE.

Fixes: c55a6ffa6285 ("locking/osq: Relax atomic semantics")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 75a6f6133866d..2f2718a278a54 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -59,7 +59,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 
 	for (;;) {
 		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg_acquire(&lock->tail, curr, old_cpu) == curr) {
+		    atomic_cmpxchg_release(&lock->tail, curr, old_cpu) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
-- 
2.53.0



