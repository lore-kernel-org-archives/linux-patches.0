Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831192;
	b=PN79hazpA+rh6fSPWV6q+gsbz72qIdEiisLoUAlwslSsyqex+Bx3PABD/9n4LeRmPE/3
	 RIiNWRhqYq+Fj57uQ1bQ/wI4j4GaeBdAjfJCpQo23VFWC0MQUveHw4uQeQg8vEz06BYy7
	 l8XTkLv3Nou/Hv/VAxU32PUc+zU9DZisz2D2FUTA3W7bOgmi0oranuPpHwssSxp3VkgkF
	 yFSRqOaO9aE55fnuXrDF1F0X6GV8Cv6N37N8siJtPxSt7nlWzcnchUTUpvHajjjjkIqlX
	 kNsOs7ODFSg6N1+je5n8s5knkU3rtWa6wm/0bpDcNeWHMbsWvtiWTl2LP2N+Xsewqgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jeqOZi5jxT5e+IY0ajYeOA7eYIbLQuP8mLnDPsC0bmw=;
	b=Bx0V6T2QvhsbczlvV7WvME5mmvXDMlr0TUPe/MPWG6rV/0bOdMnKZqejKT5CholnUF/I
	 Z0czki/6L1yQG80lnoBezOptfEuK7gNEOsLqmNjq9HCZDp2DqQPiDHl6CEwwgbMyKbul3
	 8pHW6df0Ad53oswlUWz5iWh7yxYioOZdifSU3erdagB9MgDij/+sbCiBVnTFDviCm9LLo
	 up2kgIJZrGuLmr+r9AynIHGF5uRgO53XvJmcjP8usTGrj48czEhtTl7IhDx+rNp3ST6+N
	 Wyt8N3eXNJkrmaeHutMhD4jnEZpXuIN0egfqxq3EFlQtJU4NCH9FDGjKO5fdhBnmb4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LCAf6bt/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2997606A84F;
	Wed,  4 Nov 2026 22:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCAf6bt/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A73E1F000C1;
	Wed,  4 Nov 2026 22:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831191;
	bh=jeqOZi5jxT5e+IY0ajYeOA7eYIbLQuP8mLnDPsC0bmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCAf6bt/lD2pPN3KBhQ5ofw7q55olWVkN2kt6IQ+8bRJvHkGhQ0q8tdPCgk91HSsJ
	 MkVSs+jjz90HcZbKO94W55meACnL/xEQPIyO7w5PIkirEeemevnIlpGczaDjRN35hV
	 JGxFi7n3S2zW2tO+nCyVGjC5HvDiAkaG6tFMP0S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Jackman <jackmanb@google.com>,
	sashiko-bot@kernel.org,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0547/1005] mm/page_alloc: dont spin_trylock() when disallowed in free_one_page()
Date: Wed,  4 Nov 2026 16:04:40 -0500
Message-ID: <20261104211059.217913905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Jackman <jackmanb@google.com>

[ Upstream commit 52dcc33881e55189650404f833c0e6b7913d6c16 ]

__free_frozen_pages() checks can_spin_trylock() before entering into the
main free_frozen_page_commit()/free_one_page() path, but before this it
can get to free_one_page() via the !pcp_allowed_order() and
MIGRATE_ISOLATE paths.

The !pcp_allowed_order() path depends on usage by callers so might not be
possible in practice.  The MIGRATE_ISOLATE path probably means kernel
crashes and privilege escalation if anyone ever did memory hotplug and BPF
tracing on a PREEMPT_RT or !SMP build.

Link: https://lore.kernel.org/20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5fe5ed00%40google.com?part=2
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Replaced the missing can_spin_trylock() helper call in free_one_page() with its equivalent inline condition, matching the existing open-coded checks in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ec5ca89cbc000..ff863a87f2b85 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1585,7 +1585,9 @@ static void free_one_page(struct zone *zone, struct page *page,
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags)) {
+		if ((IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq())) ||
+		    (!IS_ENABLED(CONFIG_SMP) && in_nmi()) ||
+		    !spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
-- 
2.53.0



