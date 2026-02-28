Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A5372255;
	Sat, 28 Feb 2026 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301502; cv=none; b=b6rYAiTGLu2FHccvYMFQ+jHrQTiYnQQXg2xYeBlNlUty/rez1oiKlbSZ55mSl3Y6llaZVRGXXgt2YcBhlHAjinUkFYxZoyXTKo241Y18LUAm6qImv+gBmxCWbpRDTBty0Iy4KwJLFhwQhe/kJi+HRih6ErBOYuVxpZvFyLR72hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301502; c=relaxed/simple;
	bh=LelZWKh7o+l0tdFfERkHKbBg/0WmIA0wNOavyMzkqBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4gFd3UCkDHVJnKSlDQZwZskmQTkssILJu3nmnZJqAxkc+b8sEpw7dq5sYy9zI3ojDlA/CgoxQKTT6Unl2OUhy7DOHYlYvj12KPVkBe7Yz1kvfbTVkinUqPgZy02e+1NEBSYri42d2DWKxuRtW4ol/VFbuv8FxVWgiTy6d003CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNAOLULx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNAOLULx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ED0C19423;
	Sat, 28 Feb 2026 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301502;
	bh=LelZWKh7o+l0tdFfERkHKbBg/0WmIA0wNOavyMzkqBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNAOLULxptmcRVuXoVBHDQdX+lwPTgym1h4wvle/Phepf//0gCsubhdvSG9HkHesl
	 F2AnHH5qQuDXaZQ26K4k93ktpiGjCSDn2rlUF/xtYA9m0AbFOxgzr6Vlu+mN6BkMHu
	 hadDz2HQubEwCp+yFuTUZgcLdEwT0sIjnp1zAl4Cgz3QL5NP0xvHJXIWsvxP1OJlnZ
	 Iqvpa4z5zYmO3w83TN0yPa4lqgKxmqCBVXg4BqCHrEZsNWN3ImHzmWVJ4iyPEFmmjk
	 +/TnsKAIpm+9e1DRvAORDlFz9LzDOl4NtrXaj0CJopOe0CWk/7aYfAjGUv9Wp09zA3
	 01OK1h/tBtWJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harry Yoo <harry.yoo@oracle.com>,
	stable@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 686/752] mm/slab: do not access current->mems_allowed_seq if !allow_spin
Date: Sat, 28 Feb 2026 12:46:37 -0500
Message-ID: <20260228174750.1542406-686-sashal@kernel.org>
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

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit 144080a5823b2dbd635acb6decf7ab23182664f3 ]

Lockdep complains when get_from_any_partial() is called in an NMI
context, because current->mems_allowed_seq is seqcount_spinlock_t and
not NMI-safe:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
  ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+0x58f/0xc00
  {INITIAL USE} state was registered at:
    lock_acquire+0x185/0x320
    kernel_init_freeable+0x391/0x1150
    kernel_init+0x1f/0x220
    ret_from_fork+0x736/0x8f0
    ret_from_fork_asm+0x1a/0x30
  irq event stamp: 56
  hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock_irq+0x27/0x70
  hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8a/0x6630
  softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1dc1/0x6a10
  softirqs last disabled at (0): [<0000000000000000>] 0x0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&____s->seqcount#3);
    <Interrupt>
      lock(&____s->seqcount#3);

   *** DEADLOCK ***

According to Documentation/locking/seqlock.rst, seqcount_t is not
NMI-safe and seqcount_latch_t should be used when read path can interrupt
the write-side critical section. In this case, do not access
current->mems_allowed_seq and avoid retry.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260210081900.329447-2-harry.yoo@oracle.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index bc6156801e8e6..4e2a3f7656099 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3594,6 +3594,7 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
 	struct slab *slab;
 	unsigned int cpuset_mems_cookie;
+	bool allow_spin = gfpflags_allow_spinning(pc->flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3618,7 +3619,15 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = read_mems_allowed_begin();
+		/*
+		 * read_mems_allowed_begin() accesses current->mems_allowed_seq,
+		 * a seqcount_spinlock_t that is not NMI-safe. Do not access
+		 * current->mems_allowed_seq and avoid retry when GFP flags
+		 * indicate spinning is not allowed.
+		 */
+		if (allow_spin)
+			cpuset_mems_cookie = read_mems_allowed_begin();
+
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
@@ -3640,7 +3649,7 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 				}
 			}
 		}
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+	} while (allow_spin && read_mems_allowed_retry(cpuset_mems_cookie));
 #endif	/* CONFIG_NUMA */
 	return NULL;
 }
-- 
2.51.0

