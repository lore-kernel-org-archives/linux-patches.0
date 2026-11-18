Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054446;
	b=yuMk4nLAqVJbfxDvoTW57spktNMXrb27GwsAW0syNxnQ8EXDR0n61ulAs+SuObg8dOn2
	 dnBOxDpzYMv9mGO44jOJLZRvBpy6EqpsN5xgfE88ETuGc82dIO4JrRzHHfYrMB99P4Who
	 dBfFt9ismCWvXhoqYGyyybU1DT314/Sw/aNQ7nGUSDdMcM1BKnqi3WqMx+7ommkQDv5SE
	 s1J/ivc1AVty27cXP5GzAFNikfgAe07PTwiPPgyHpwbvfOQHNoz6vonuE5jkvozvvG+Q3
	 u5ia4sBBtLOhnAkZoDeNWs0JplfdD7PQec5zWyUhVME/2V88EMvwVVVgMJSBH/1PjlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y1QVfMI2c94kLNNnG2LD4QcfMzA+tMN05TkZOosXogc=;
	b=Tze63mazrybUBhIbv1pLkyNxU1olP6t4bL+MQOymSdemTpMZXVtHsaetjm8UZuEBw2FP
	 88uc5+oGc2OMWJ5YBeGPbMSl7frSn3xjwliZPQgFQ5SuLv96zfUE72nu/liisUnCFht8d
	 5u1GcGiA7lbts+e29EQ7IXJpb13sHflMhSVVJe0gwconRsSTBkWm02CqU0tNbfb0Y3IhL
	 MgR8rWqIkO43Kl5N+TNptcuHInmOVeTz4ClsrfWCCrzyD3OWKeltVuc7EsoKp5jqsCBnb
	 qVMxxlsTgnm/Si33VSFA3+/vG7C9gsn+4V9xlUDqAf8sclvvZa8PHnPwYI11i6NO34Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqnd7zyo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D6606A31C;
	Thu, 19 Nov 2026 02:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqnd7zyo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EADD1F000C4;
	Thu, 19 Nov 2026 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054446;
	bh=y1QVfMI2c94kLNNnG2LD4QcfMzA+tMN05TkZOosXogc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqnd7zyoe4nJZroXMmiJsOfjQekRqTJ61yMye4RaQnoyuCdBvB5AXKIdnHjD7TtLa
	 V319kemVSE8si+PEcdqb8rj4YHHf5hjK/233JFWJAqa+NM/hHfMxKmMZ0JphB0j4p/
	 7p7QbI4vyOCOAbLw0tgE2v/yDNdrQPH2o7R0au50=
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
Subject: [PATCH 5.15 1276/2214] mm/mempolicy: apply bind policies against the scoped allocation zone
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118150102.625869492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the MPOL_BIND switch-case change to the existing conditional in policy_nodemask() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 51ec529425118..421a3a3ee85f5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1766,7 +1766,7 @@ nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(mode == MPOL_BIND) &&
-		apply_policy_zone(policy, gfp_zone(gfp)) &&
+		apply_policy_zone(policy, gfp_zone(current_gfp_context(gfp))) &&
 		cpuset_nodemask_valid_mems_allowed(&policy->nodes))
 		return &policy->nodes;
 
-- 
2.53.0



