Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065362;
	b=IXkT262Nqcvey7fkykkt2snV1ietm6Xt11BHT6w/op4jLH0V8HgaoGimWRHk6RaXqPqw
	 md46qGiZdn9ifVc0R2+ZBv6nZEYeLhweT1N7J4ajJJBOzDXuha/lzMS/flmkNwxGKFfIv
	 HwLXf9rsYEdu+2LhKF9OmLlYWgbxIsuhIwQC0eYi+Y05Aq5PZTP8uZOaR+99P9cRFxg0G
	 S7IfLqXK9/EDt0WbkyuYkORVwW6YbwbrD+XLdc7bUgNfJKjF2YxTnHaQkKAXHNxmB8Tnf
	 Y6/EwtCHMsNGt3diM1eLCeYezzJ0G7OLvKFAC9f31SeEE/8M2yDT0oSu5OITH/KtOrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IDamCkZBVARrIcoDziVZ03UbHyWnprdhGaq2ygDMC+M=;
	b=bl+VbWoyxwitbjhgiUpvEXZxMX6MHEQa8M7z38fSJwg6g/D6oEQTz4o4tMesQKzbK09W
	 bfevlbsaO0mDmRy6YH1aDeTwJFZiZSdLpfPzytEFlSvW+6wE5b3xvcXiCKvo7VuWxuINU
	 e23fS7O5GxSnbpvbpLqRi8ay201YNJpyWxi2cFONwwZYMt1bwBaL1HymSkOcvFbYaCONF
	 FWf7EUumfXfUk9Y6jYG/SkOkI6pmYb23254oQhpnRr8N89GDe0UbHc9oEcWmH6OLHdcN/
	 KMvPmfPpV/j3mRS8YwnHvotewIJ/bpNkKFD7FRkWedgGyvEjtM/WPASBtcOX2ft4vRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZuMEWDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8B4606A326;
	Sat,  7 Nov 2026 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZuMEWDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCECC1F0089F;
	Sat,  7 Nov 2026 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065362;
	bh=IDamCkZBVARrIcoDziVZ03UbHyWnprdhGaq2ygDMC+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZuMEWDkrSiXbjQiqppWKAQz3QFkRZK+tJaRdFYLwgfz9tEIvhQNS7Xle3Ace+dz2
	 snIGUP8K0SrPXEgjo/gYDVuZ7cxbRTa21FJwpWuoolWvPDTeMJhY8P4lHnMujX82kR
	 5wqRsWctesfAcinQSrqnP9fX1F3rOpoxpYqjNqWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Michal Hocko <mhocko@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1096/1257] mm/mempolicy: apply bind policies against the scoped allocation zone
Date: Sat,  7 Nov 2026 08:56:32 -0500
Message-ID: <20261107135009.530572119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit d4ea410ce4b8aa46a316476ea2624a357bf31fa9 ]

QEMU fails to start a guest with a VFIO device when guest RAM comes
from a memory backend bound to a movable-only node:

  vfio_container_dma_map(0x55b1b1317800, 0x0, 0x10000000,
                         0x7f39a2200000)
    = -12 (Cannot allocate memory)

VFIO pins guest RAM when the device is realized, and the pin faults
the pages in. io_uring fixed buffers fail the same way. Faulting the
range in before pinning lets the same pin succeed, since resident
pages are migrated off the node instead.

A long-term pin faults under memalloc_pin_save(). PF_MEMALLOC_PIN makes
current_gfp_context() clear __GFP_MOVABLE, but policy_nodemask() tests
apply_policy_zone() against the caller's gfp.

The bind keeps its movable-only nodemask, and the allocation finds no
usable zone:

  page allocation failure:
      order:0,
      mode:0x140dc2(GFP_HIGHUSER|__GFP_ZERO|__GFP_COMP),
      nodemask=1,cpuset=/,mems_allowed=0-1

  Call Trace:
   warn_alloc+0x136/0x150
   __alloc_frozen_pages_noprof+0xed8/0x1720
   alloc_pages_mpol+0xaa/0x170
   vma_alloc_folio_noprof+0x65/0xd0
   __handle_mm_fault+0x137b/0x1ac0
   handle_mm_fault+0xa0/0x270
   __get_user_pages+0x250/0xfd0
   __gup_longterm_locked+0x116/0x870
   gup_fast_fallback+0xcfc/0xdf0
   pin_user_pages_fast+0x47/0x60
   io_pin_pages+0x9a/0x110

Base page faults fail with -ENOMEM.
hugetlb faults fail with -EFAULT.

Check the policy zone against current_gfp_context(gfp), so a pin-scoped
fault falls back off the movable-only nodemask, like any other
non-movable allocation under the same bind.

Tested in qemu with a dax/kmem movable-only node 1. io_uring and VFIO
pins of unfaulted base pages and 2MB hugetlb pages now succeed and land
on node 0 (correct). QEMU now starts with the same backend binding.

Link: https://lore.kernel.org/20261018023349.1697434-1-gourry@gourry.net
Fixes: 8e3560d963d2 ("mm: honor PF_MEMALLOC_PIN for all movable pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b63d7f410d145..839c3fe985a0c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2276,7 +2276,7 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
 		break;
 	case MPOL_BIND:
 		/* Restrict to nodemask (but not on lower zones) */
-		if (apply_policy_zone(pol, gfp_zone(gfp)) &&
+		if (apply_policy_zone(pol, gfp_zone(current_gfp_context(gfp))) &&
 		    cpuset_nodemask_valid_mems_allowed(&pol->nodes))
 			nodemask = &pol->nodes;
 		if (pol->home_node != NUMA_NO_NODE)
-- 
2.53.0



