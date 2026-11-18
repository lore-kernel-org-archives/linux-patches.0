Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033281;
	b=qx0GlfaTb9ht3HXafM+LP2P11gbjmwyVQjNPihR+4SE7MVFtdW0wEiCikyYimNM7jc+1
	 BLqlyEQX4Wtq0Gna71ejDfM02EmZt64rXdFxQ7mEKoWw9Wn4P36WUE8eTdM2zrln25PN8
	 FQjD6NZEGxOdYcWfEi7mzrVcFkeDNkc4JImqbR4IBz0T3jzA+AXFjBAIp1up99wqQZW3/
	 RAW98f035Erk9Pf5inkTQ2IJBHBzYCR7wIf8t56hO5RAHNMxLyuxRY0xfXWQ6h+TQnncE
	 sNVoXuHeJsHvx/bzhAsi1OgMNXayzpw1mF/zJdM1fqTdeNfZ37sg5pHXnUgVefD1tug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BfB54fxfEJkGfPUky9g6li2+cc0gI4ekKWTzHt6p3b8=;
	b=yISrGPnwVYOXLJLkFCxEd2s0oQw2JnA+d63WvGVx2e4mDr03wII5MSaQZ9lvc7/k6DWR
	 6sqSu8W1fnb/fpHAdOOuIK0LpJ+kMVmRPMhgx74SG6AuG+SkNi4hsIqUWwpEV3yViju2g
	 iKiJJuyY3dzR12ZxaaZPHhRhe3RYyi3hAxAblE59MezWstU/PkNSOGu+DDg9DusqTc8xA
	 gZ6uxzUpVuZ0N/lJs0Z2vZgD9WjJoNepj8jIvAbernNPKD2Q01ZHtkHAzi0V87obALEAl
	 FVyhg1SdhXb1eBvRDVO8jlwEXIGNHyR55fIQgmLpEHeNpY6/vPKtxbs8aeRJ44/QcWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CgG2N9vg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94D4606A325;
	Wed, 18 Nov 2026 20:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CgG2N9vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F0E1F000C4;
	Wed, 18 Nov 2026 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033281;
	bh=BfB54fxfEJkGfPUky9g6li2+cc0gI4ekKWTzHt6p3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgG2N9vgMlFxn9mCrA+MQ/LElAMmejHHep10OsGC+IGaz76scUoLftHF8o8D4ifn3
	 X5B2JLUr0KRUthc14A482ahLHBWUdfThBsStvovt81K4rCTBuEPtoYMDpML0Dn/WQl
	 a0oah7MDAZvVp09X0KuMePZVnoYVdbkCWz67087U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1713/1756] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:04:00 +0100
Message-ID: <20261118150117.808636729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index b731d13e6b766..232705e8375c0 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -294,9 +294,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



