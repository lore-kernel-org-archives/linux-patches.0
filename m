Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B397231C91;
	Fri,  9 Oct 2026 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556371; cv=none; b=G2MoNq3cPTUHQxA6AClD/uhrRW5RMlVDWhG0u0CskV+XCut+AhqbrUAFH++2sxiANxTyAtP9nc0NTvncwEPi/1oN9+61NNSqhNdM+YutzI8baaRjta54hEhn0IiPWhKs4MbChUO1Un34GWd3pLqClv0osodzLxZx+tmSlgp1I7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556371; c=relaxed/simple;
	bh=LUF9au/GEuB/7f0O63N/i6DBYQ5cdej8KzX9hfMsphQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcGyH3iP9gGMWkpVCKtHtxPFdqHAxUc8eKOIW+EsKu3DBrzGfvZ4R4NEiqFfk2Wq4qx9cSh0ugbJCrxbBBk0uEWdwmjjIuB7kVcKU3w4MUnw706L8wQ5wCP8Qz4GKcH4gIGoga08jE/0WJUBcgySBpS9tRrAaKAoWPY6Q45K3/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pq+77vrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pq+77vrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710551F000FF;
	Fri,  9 Oct 2026 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556370;
	bh=PV6cEkWDg7pKzshskG6TLjG5i+IYkDsq62C8wmeV8Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pq+77vrvjbEo9vmYxAqgAHs/5HU/gurs/8+LofoGHxK/HEEoCDJT8owIuupNWbOh9
	 tARvUA5eXKrOQ9MRVJEJLDnM3rKx2n11FKDkhIk70uZQyA61CnI8kztSFrnLEN2aIY
	 g0KCs4apXWXFD+cbhcYf1GAfyLxqjaz1rpMpbq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 165/428] futex: Fix private hash use-after-free on resize
Date: Fri,  9 Oct 2026 16:08:22 +0200
Message-ID: <20261009140949.782552538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit f35e3b5784221654f9cdbd6222275a7fa203f6c3 ]

poll_state_synchronize_rcu(mm->futex.phash.batches) is used by
futex_ref_drop() to check that a grace period has passed since the
current hash was published. This relies on batches referencing a grace
period which started after the hash pointer was assigned.

__futex_pivot_hash() sets mmph->batches before it replaces mmph->hash:

    scoped_guard(rcu) {
            mmph->batches = get_state_synchronize_rcu();
            rcu_assign_pointer(mmph->hash, new);
    }

The scoped_guard(rcu) doesn't stop new grace periods from starting, and
if one starts between those two assignments, futex_ref_drop() can move
forward while a reader still holds a pointer to the old hash.

Fix things by setting mmph->batches after assigning mmph->hash.  The
scoped_guard(rcu) isn't needed, so let's drop that as well.

Fixes: 56180dd20c19 ("futex: Use RCU-based per-CPU reference counting instead of rcuref_t")
Assisted-by: kres
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://patch.msgid.link/20261001135022.2220288-1-mason@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index be4aeacd4b540..6a1971f9588e4 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -216,10 +216,12 @@ static bool __futex_pivot_hash(struct mm_struct *mm, struct futex_private_hash *
 		futex_rehash_private(fph, new);
 	}
 	new->state = FR_PERCPU;
-	scoped_guard(rcu) {
-		mmph->batches = get_state_synchronize_rcu();
-		rcu_assign_pointer(mmph->hash, new);
-	}
+	rcu_assign_pointer(mmph->hash, new);
+	/*
+	 * mmph->batches must reference a grace period which started after
+	 * mmph->hash was assigned. See futex_ref_drop().
+	 */
+	mmph->batches = get_state_synchronize_rcu();
 	kvfree_rcu(fph, rcu);
 	return true;
 }
-- 
2.53.0



