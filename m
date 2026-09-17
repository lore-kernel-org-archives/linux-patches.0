Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F514B44A4;
	Thu, 17 Sep 2026 15:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659420; cv=none; b=q0mLagOotOXQkkWf3nqPsXLZ7z21xQ0vQIB3SPPwlX7eSzR4rqsKL0C2hQy5Oh6ms0frwzaygZe92De4wT2u9gxrtTVOUGD5BlgL0zETCjpdlIrAhp95djJ4XWqo/oKo/tf67LahFXiX6/3rX5TJ2mX+qEUky4Alf+LyveNimF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659420; c=relaxed/simple;
	bh=lQwT/MKPTPCZCnAZeqn8j3g0T92hYsdYVIYvHGrD+JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRvC2SMROob6jbLFb38wUO/eCr+J8L7rM4kudac+lqt6BMpQI2jVfBUDLfoD8zASnRO3XfcmD6ZSdiXqrvdE4LDUCWcgPDyWGCE2BEzSeBpl6RKgVbJhkecdFcFN2U0AYW5BZk8Xm5cuvYAB/60r5Lg9usgUONGPW90ge8l/BcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quM1sZ8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quM1sZ8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5D51F00898;
	Thu, 17 Sep 2026 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659412;
	bh=F6grQjz7oQBPg3O/m0YlcvYD0svd+tPtgpCqEYTg3xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quM1sZ8UvV+YIVIxVejYDQm6vdG6b+F53I6iZGwGp9tYynZknfeXcPV2shgMFV7RL
	 WiV4Jw2Ujud8jLP3PWyr/OWN2qE/z1B/jY0QZ6XAZWpajDfXiMD/VkiJs4J2wj4je2
	 wjqNqbmB2qrqlH3wG78hcAxGWRPKGNazB6nNXXk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 209/733] net/rds: use clear_bit_unlock() in release_refill()
Date: Thu, 17 Sep 2026 16:08:37 +0100
Message-ID: <20260917151356.391598659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 17c4476dbb9c3bfd34193a6c22f2c3da8747134a ]

release_refill() drops the RDS_RECV_REFILL bit with a plain
clear_bit().  clear_bit() has no ordering semantics, and the
smp_mb__after_atomic() that follows it sits on the wrong side for a
lock release: it orders the clear against the waitqueue_active() load
below it, but does nothing to order the refill critical section's ring
and descriptor stores before the clear itself.

That matters once connection teardown owns RDS_RECV_REFILL as a lock
across the transport shutdown and path reset, rather than sampling it
clear, which "net/rds: acquire the fastpath locks in
rds_conn_shutdown()" later in this series arranges: on a weakly
ordered architecture the teardown can win the bit and start the
shutdown and reset while some of the refill's stores are not yet
visible to it.  The same gap existed under the sample-based scheme - a
waiter that saw the bit clear had no guarantee it also observed the
refill's stores - but taking the bit as a lock makes the missing
release pairing load-bearing.

Switch to clear_bit_unlock(), which orders the critical section before
the release, and replace the open-coded barrier-plus-waitqueue_active()
with wq_has_sleeper(), whose internal full barrier keeps the
store-buffering guarantee between clearing the bit and checking for
sleepers.  This mirrors what "net/rds: use wq_has_sleeper() in
release_in_xmit()" does for RDS_IN_XMIT.

The fast-path acquire side, acquire_refill(), uses test_and_set_bit(),
a full-barrier RMW that pairs with this release.  The teardown at this
point in the series still samples the bit, so on its own this change
is release-side hardening; the shutdown-conversion patch named above
makes the teardown acquire the bit with the same RMW, completing the
pairing at the end of the series.

Fixes: 73ce4317bf98 ("RDS: make sure we post recv buffers")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_recv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 357128d34a546..a6983861eec70 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -363,15 +363,14 @@ static int acquire_refill(struct rds_connection *conn)
 
 static void release_refill(struct rds_connection *conn)
 {
-	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
-	smp_mb__after_atomic();
+	clear_bit_unlock(RDS_RECV_REFILL, &conn->c_flags);
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk
 	 * the system-wide hashed waitqueue buckets in the fast path only to
 	 * almost never find waiters.
 	 */
-	if (waitqueue_active(&conn->c_waitq))
+	if (wq_has_sleeper(&conn->c_waitq))
 		wake_up_all(&conn->c_waitq);
 }
 
-- 
2.53.0



