Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90181511208;
	Wed, 30 Sep 2026 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785111; cv=none; b=U0xTRF4RcFATP3ZSczhM0l7csqmz7vfN42H2B3s7knFxFujpYYNdWXmui72aG4ET5K0h6w5aN4FtttzzMsJ/8EOTzF427VdxzgJj+aWkRV+UbWpnTMfQkg4Qr6dQ4AxIO5AyubIDUeEqMGtJEyQEfozBHo6RpASGXuYkqsFCb8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785111; c=relaxed/simple;
	bh=54hK2f6jdmZtHGn1izkdOwd0yT9ECgj0BSegvRDUqNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEl0NTusrYzROzRyIcUVdNeH5jt1hX4XJWI+W3obLVOPk0/zrq4KY0sdmT8A8khTiJoMf5+jn5FMM9No/H1yb3ULsB6kSgiXSDC5RtDFkIlnGM6rDgEOV9G/z4sI79Ej6bkzfP56AFseleAyho49eDHplcR60PbKNQTVeMOne/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8id6dNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8id6dNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51411F000FF;
	Wed, 30 Sep 2026 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785107;
	bh=LEbMWAdA6/o1MS8ewomqpriCNgT9bM1Dq+oR14uSZys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8id6dNay6zZL8ErJ4QB0Aoxfsj9X14hhSiqYFwQt1EC3UYxMgZn12vGFja+udKHp
	 nBEBZs0g6zFQDkzDZ6cbFHnGUcw5jzqv3zK7SpovTo+kYjpGDqGuuaAaeBbB69+ydG
	 cJ2uXbEfwKq2XP5kzW5GQ6OEGIodglADAgbDVi4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/982] net/rds: use wq_has_sleeper() in release_in_xmit()
Date: Wed, 30 Sep 2026 17:18:46 +0200
Message-ID: <20260930152425.182931591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 2cedcb837b8f3..56090789eb3a2 100644
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



