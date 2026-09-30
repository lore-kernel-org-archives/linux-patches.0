Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F841C2E4;
	Wed, 30 Sep 2026 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795192; cv=none; b=Ua8kxAv6YUgBlmQMI+/vTS9WytcrbepwF93bDJvm3pRbfgbHqAU0PpqcsGXaMz6Y5Jp50gjjoIBmQvNEAxfiYibbk6euVrp6fUmhb6WOn42ZbcDGPFcjVQmSCrIfmORtr8KwiyGyVezq8u8ADv6Xa2mYlfkejObudG4oUHln+vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795192; c=relaxed/simple;
	bh=GZkHfXQKb0dXv9REtFS0Tx4Fy5oTdbHa85XC1qVSuHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnEzaEASdxSwImqUW/2I6WC8bxOWK2DYQ7PeOqs/aLqVIBFHgvQNTpkSkZbuAVSgfqMhK0Tkm6zYFeA+MiGJ9IJtOAw6GP0YAOZLtAwJXAOwm8WiDMRxvvypuGpUDceD2OSu0ni+jZVUB+R6pdK6KBLMVkBO5cn5KSW1+2GsSq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzqZXM3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzqZXM3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38C11F000FF;
	Wed, 30 Sep 2026 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795191;
	bh=dgmgjXvMy+yQ0u5jXRgTx70Zmczx9ehf6EQUtQDg+vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzqZXM3Ywn7q4Ao2cC5hl8M5iC2oa1nUlDpvTdiymfBqqU/J1UFKaO15U2fDY99xU
	 i2ypPWONoLBr9TdCVQb1uGptuYuR+l74+HLljqr7mHKRZbSq6IOHWgxgtKSJA5/vTj
	 KVYmQav9ta4nPooZqD6mBB7wTrB4TzNm3+5SBmo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0468/1193] net/rds: use wq_has_sleeper() in release_in_xmit()
Date: Wed, 30 Sep 2026 17:19:12 +0200
Message-ID: <20260930152444.565909171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 6d0c8b7073913011459cf968cbbadd341e166bc3 ]

release_in_xmit() clears RDS_IN_XMIT with clear_bit_unlock() and then
checks waitqueue_active() to decide whether anyone needs waking.
clear_bit_unlock() is only a release operation: it orders the
critical section before the bit clear, but does not order the
subsequent plain load of the wait queue head after it.  The waiter
side does the mirror image - it adds itself to the wait queue and
then tests the bit.  That is the classic store-buffering pattern: the
releasing CPU can read the wait queue as empty while the waiting CPU
still reads the bit as set, so the sleeper is never woken.

The waiters are rds_conn_shutdown() and rds_tcp_reset_callbacks(),
both in uninterruptible wait_event() with no timeout.  A lost wake-up
strands the shutdown worker on its single-threaded workqueue until
some other sender releases the bit again - and on a connection that
is being torn down precisely because it failed, there may never be
another sender.

The barrier used to be there: release_in_xmit() did clear_bit()
followed by smp_mb__after_atomic() until commit 1422f28826d2 ("rds:
introduce acquire/release ordering in acquire/release_in_xmit()")
folded both into clear_bit_unlock(), which strengthened the lock
hand-off but silently dropped the full barrier the wake-up check
depends on.  The refill counterpart, release_refill() in
net/rds/ib_recv.c, still carries its smp_mb__after_atomic() for
exactly this reason.

Use wq_has_sleeper(), which is waitqueue_active() preceded by the
required full barrier.

Fixes: 1422f28826d2 ("rds: introduce acquire/release ordering in acquire/release_in_xmit()")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 1fc84bd899534..da3a6ad39b920 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -114,8 +114,13 @@ static void release_in_xmit(struct rds_conn_path *cp)
 	 * hot path and finding waiters is very rare.  We don't want to walk
 	 * the system-wide hashed waitqueue buckets in the fast path only to
 	 * almost never find waiters.
+	 *
+	 * wq_has_sleeper() supplies the full barrier that orders the wait
+	 * queue read after the bit clear; clear_bit_unlock() alone is only
+	 * a release and would let this check read a stale empty queue,
+	 * losing the wake-up.
 	 */
-	if (waitqueue_active(&cp->cp_waitq))
+	if (wq_has_sleeper(&cp->cp_waitq))
 		wake_up_all(&cp->cp_waitq);
 }
 
-- 
2.53.0



