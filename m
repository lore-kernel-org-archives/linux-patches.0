Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CF033C1BE;
	Thu, 16 Jul 2026 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209470; cv=none; b=n0ZgRnhXApDJtFHGKQC0eCxNR/aKWiQ3vqhdTB1jwxUQLwof8GV157jGViZlaQxj/C8gnpzRFUs789estS/X0fM1ypBCw1Rz8i8E/ft0brFfSbg6xPgJAHQUI3qOnmn4fjQtclRUJ+1tbGKcdStDGxicICro34o4oBvGyB7S/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209470; c=relaxed/simple;
	bh=HqbRNSEowqj2Sv7myHDnGXewwNo8Wcj3O5hAYe+3jXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6Fq58oEl+2G/6H/dK6agkII8EIDVY2cFWtfbtuhY2ebSpnaLUm/Okmmzl45SiaNoEhLlnxMGsJiiXJ+tPo8gDi3UTPV0+XsaaTbSbKDw/vHe+8B9JpI8RDRwbUd5Rzxw99SfUDo/2Rx6BCQCQf6RlvOWoLem+Qw2J28QFCPShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUn6nLEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUn6nLEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8BB1F000E9;
	Thu, 16 Jul 2026 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209466;
	bh=LN4UaWeyHIxo2Cxw7UAjZK7vD2PE3hIs2GqrvtxqtSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUn6nLEv2hrGBwmhRRmok89VcyYnW7ccCqjiR6rGmSUxo75lfu8yXj02RVii5aGtD
	 bCaB6VidTjUH5YwoaX60dlKiPONf08XXU8Wx3UEdnxn9USHTArNFi4U4DnRTgiTp5s
	 e50Iq2NcDHc0n7VhJQaeiLKzdKlLtWcucRs9CCbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 195/518] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Thu, 16 Jul 2026 15:27:43 +0200
Message-ID: <20260716133052.095622851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

commit 63b02a9409cb5180398491b093e48bcb5315f5fb upstream.

lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
__swap_cgroup_id_lookup() without checking that the type was ever
registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
swp_offset().

Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
real swap entry, without first validating it against swap_info[].  A
single PTE corrupted into a type-0 swap entry takes the host down at
process exit.

We hit this in production on a swapless 6.12.58 host: ~1s of
"get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() being
correctly defensive about the same entry) followed by

  BUG: unable to handle page fault for address: 000003f800204220
  RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
  Call Trace:
   swap_pte_batch+0xbf/0x230
   zap_pte_range+0x4c8/0x780
   unmap_page_range+0x190/0x3e0
   exit_mmap+0xd9/0x3c0
   do_exit+0x20c/0x4b0

syzbot has reported the identical stack.

The source of the PTE corruption is a separate bug; this change makes the
teardown path as robust as the fault path already is.  Every other caller
of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
already validated the entry, so the new branch is cold.

Link: https://lore.kernel.org/20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev
Fixes: bea67dcc5eea ("mm: attempt to batch free swap entries for zap_pte_range()")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com
Assisted-by: Claude:unspecified
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -124,6 +124,8 @@ unsigned short lookup_swap_cgroup_id(swp
 		return 0;
 
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (unlikely(!ctrl->map))
+		return 0;
 	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
 }
 


