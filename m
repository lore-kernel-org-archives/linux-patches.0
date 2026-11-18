Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047545;
	b=SZvtYHX0sAGefaZxZ1oyqmbe2Gq9fD+ysVo3TRicKQodxDjd5n8AvCTOyqnIZsrbSGWF
	 IUYCleh6JhAW8Q0zkyW/Tm1ZN1OzE36r+G7KZtI3io/A6U0djbrgAN583EmolBMXBruDd
	 TEznX3hh3GxDcxq7oiKBHgkq3QXNip4Jc7ByjTP2QL7LM+H1zQ+Gn+STUjUzsX6UNjmGG
	 5J3e+f4cpYUmtXQsL8z6BYJAcTXCPXLedPWtX6A2YrN+RFZ5dmHq7AbrLdKsXElgyafR9
	 sHACAhw7DNx6tk/J9PZh1VUudcylhz092nQcVeq6vyMNteGzqN/T/fybQaFk7T3jz3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bl+Yx3jNb0h/yU07jE5B2PxWbzS5XSecb+NHY1sJiCU=;
	b=BzAAWZKPPLOBWKKHPk8AhfrBfNiqp3H1ak+y8bTbNJ3rzp0r7RZeFeGN8nDnUFNf9xTV
	 uo/xTINESi/fgLFKLWETk4QuAMjf6pg7mwzQSUePJm8lLMnE5HQXsnl34Csp/O6SYw29z
	 IAj6+3wv6qHwevMbIff03cW2JAltDLIZ814lYOLqRJ8S6otK5R2Y6ZuoTACElKDxvQss7
	 +aFwJY3eO1qhSvNv/T5WW5lpMhORCRjnUfQ6sq48T8rnjDlgB+KvUBclhzNufhbcPXWGU
	 S83TgP1fNSRTaVuuq3KElqfQAztOsOWWC0lswKa+2Cr8uyRlQpJEyKCJKAlOrNH0sGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcublHrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1314B606A32A;
	Thu, 19 Nov 2026 00:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcublHrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702541F000C4;
	Thu, 19 Nov 2026 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047544;
	bh=Bl+Yx3jNb0h/yU07jE5B2PxWbzS5XSecb+NHY1sJiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcublHrxM9xnnNp/j60Yku0L9Te1V834ZkjX5+151VpyWUp0mVwWkBLv4f+na21ym
	 8V64Ivm/NKjEa5RIFzpe40ic7iRcbgB4EiZGt3Zn4ut+nEIf06Jxk3okc0YmTxtYCb
	 IuPNafIISvGDJdZNyngpPzmi3kKK6w7puricRKwk=
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
Subject: [PATCH 6.1 1676/2857] mm/mempolicy: apply bind policies against the scoped allocation zone
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118150301.677501338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the MPOL_BIND switch case change to the existing conditional in policy_nodemask() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5bc8ba6fa5189..a8e990a6aa0c0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1838,7 +1838,7 @@ nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(mode == MPOL_BIND) &&
-		apply_policy_zone(policy, gfp_zone(gfp)) &&
+		apply_policy_zone(policy, gfp_zone(current_gfp_context(gfp))) &&
 		cpuset_nodemask_valid_mems_allowed(&policy->nodes))
 		return &policy->nodes;
 
-- 
2.53.0



