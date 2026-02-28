Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D580F375223;
	Sat, 28 Feb 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301552; cv=none; b=cJcZ7WSjfg/Z6en9ZrWAfeOn5bTNcOZtVj/Lkp4XTwps31mjg4nFyRveP11K/4ex63RB0Qp4cgpGXEeDjyqdwv+mmrhGZuCbREkR5XKWcd8qFHvsY6nCtgWC1m/WAk5UAHOzYoaLL87pppx6qxUqJwmrDynLuF6NjMPYBCsts+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301552; c=relaxed/simple;
	bh=XX7glxt8fDEQyF7Gt80FGIRDHYiZyQxY1yZ3WlYF0YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrPr/gVwbHgCl1IQbx3kwzIffwUbS84+UbiF/kVwrvX/S0O/ifuxhIEx8tkHwv7LQVG8G4pxxD33LwZzlON+Ib+mI8e03xEJXN343lbGuczddqFzUV+ITDt9iF0Skbld8d4dopS8aA69Ut2xrgTuIAm4xdP56i8dub0iPAY0p4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sC0AVj7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sC0AVj7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10283C116D0;
	Sat, 28 Feb 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301552;
	bh=XX7glxt8fDEQyF7Gt80FGIRDHYiZyQxY1yZ3WlYF0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC0AVj7V96OhB8yDrJTzE8/Xz5VYoQRWk1PvFj1DDqvBjU1CA5dgvnae2CJ6g/iwN
	 +umUZbsr3tDW4I0watv/+TSBR5n5exkQI3mTrF0vRT4svqLIYryNplecCBWVO7u/t6
	 /NbxGZU76mWYSKMrRegjSYJQMSzu8UwrjJk98JdVZEy5jPPXy7uB7y+jlevfbBVrG0
	 lZG56JQHCxIOBvWu4AuFzT4xUmUCSt/Rt2yCN0WNFQE1navSg84OHXp3tzCTb+1D4K
	 1Ytau1O7tfZIebAyPfCg+kSgUSqJKtEEWS+oyKSJd+W8vNGHozag/Z1S9KUor7ftf1
	 Dw5Y5ad7leLpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kai Aizen <kai@snailsploit.com>,
	stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 736/752] io_uring/zcrx: fix user_ref race between scrub and refill paths
Date: Sat, 28 Feb 2026 12:47:27 -0500
Message-ID: <20260228174750.1542406-736-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kai Aizen <kai@snailsploit.com>

[ Upstream commit 003049b1c4fb8aabb93febb7d1e49004f6ad653b ]

The io_zcrx_put_niov_uref() function uses a non-atomic
check-then-decrement pattern (atomic_read followed by separate
atomic_dec) to manipulate user_refs. This is serialized against other
callers by rq_lock, but io_zcrx_scrub() modifies the same counter with
atomic_xchg() WITHOUT holding rq_lock.

On SMP systems, the following race exists:

  CPU0 (refill, holds rq_lock)          CPU1 (scrub, no rq_lock)
  put_niov_uref:
    atomic_read(uref) - 1
    // window opens
                                        atomic_xchg(uref, 0) - 1
                                        return_niov_freelist(niov) [PUSH #1]
    // window closes
    atomic_dec(uref) - wraps to -1
    returns true
    return_niov(niov)
    return_niov_freelist(niov)           [PUSH #2: DOUBLE-FREE]

The same niov is pushed to the freelist twice, causing free_count to
exceed nr_iovs. Subsequent freelist pushes then perform an out-of-bounds
write (a u32 value) past the kvmalloc'd freelist array into the adjacent
slab object.

Fix this by replacing the non-atomic read-then-dec in
io_zcrx_put_niov_uref() with an atomic_try_cmpxchg loop that atomically
tests and decrements user_refs. This makes the operation safe against
concurrent atomic_xchg from scrub without requiring scrub to acquire
rq_lock.

Fixes: 34a3e60821ab ("io_uring/zcrx: implement zerocopy receive pp memory provider")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Aizen <kai@snailsploit.com>
[pavel: removed a warning and a comment]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 030d632d98392..c524be7109c29 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -336,10 +336,14 @@ static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 static bool io_zcrx_put_niov_uref(struct net_iov *niov)
 {
 	atomic_t *uref = io_get_user_counter(niov);
+	int old;
+
+	old = atomic_read(uref);
+	do {
+		if (unlikely(old == 0))
+			return false;
+	} while (!atomic_try_cmpxchg(uref, &old, old - 1));
 
-	if (unlikely(!atomic_read(uref)))
-		return false;
-	atomic_dec(uref);
 	return true;
 }
 
-- 
2.51.0

