Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABB5470121;
	Wed, 23 Sep 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173654; cv=none; b=ssoB/LEqpqGVDSp9yGUzaLpPLfbMriER+dMtsBMQe0pabjEB1W+qMrsA+yqEnU/T+gN1pWjDxj0fbg93AO+YrvXSEryAI8Lk5ic82gYtCg52vT0AbmlsPAfSHBN/aZ6t7LtvZJyflR07UF2ArZTJhK7dr38LZm9f4pyY8eVO+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173654; c=relaxed/simple;
	bh=iBARcU4q1H0NUxBuFLaD+5Gk3zpDWARmWoq6IKOjYTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wf9jslpnptwi0KiX41aJA/8oBgJZ6PmHQ8Iud5Kt8z5QcGQgy4WAtMHIMQ3U0TQNjlFUg76T3i1OUzUTnc/SBFMOX66HwX8qwysUE9dfPyRJsVyB1Pzpn+TfQz+vZcSsI5zFY7l7Tzjlq3B43vO9tYdFot/5m3yygfGDG/nNV0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlSGs+Zd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlSGs+Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD91F000FF;
	Wed, 23 Sep 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173651;
	bh=k0JPni+3kk2Q+CPnMwyp/WwQL+PPkL1CllivE97wG9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlSGs+ZdVxj+MAq4eV4Gj2ip6I5zVEVNmUtcT6qQQrPCzEyWkZibSwgYtOhTlQHqP
	 nbbjWhgwH0N2i9hRj4prtt2YUmvmg/ZJWjl7QHUDEXSyP+3dIbGM+p4c/Ch3GickYx
	 sVksoBpAHHQjaka7GzSPUK5CWiCPdvKJCCfEKHRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nhat Pham <nphamcs@gmail.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH 7.2 313/438] mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count
Date: Wed, 23 Sep 2026 16:05:34 +0200
Message-ID: <20260923140652.895943362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Nhat Pham <nphamcs@gmail.com>

commit 12e9ac7bc5b254048f886bf421e3a15491106c1f upstream.

SWAP_USAGE_OFFLIST_BIT is embedded in the si->inuse_pages usage counter,
and is meant to sit above any value that counter can reach.  However, it
is defined from BITS_PER_TYPE(atomic_t), so it is bit 30.  On a system
with 4 KiB pages the flag collides with the usage count once that count
reaches 4 TiB.

swap_usage_in_pages() masks bit 30 out, so whenever the real count has
that bit set, every caller of it reads 4 TiB low:

* /proc/swaps understates Used by 4 TiB.

* A raw count of exactly 2^30 masks to zero, so try_to_unuse() takes its
  "if (!swap_usage_in_pages(si)) goto success;" early exit and swapoff
  tears the device down while pages are still swapped out. Nothing in
  the rest of swapoff aborts the teardown, so those pages are lost.

Independently of swapoff, the collision also corrupts the counter and the
plist.  On a device in normal use, a free that leaves bit 30 set in the
count makes swap_usage_sub() see the flag where there is only count, and
call add_to_avail_list().  It clears the bit with
fetch_and(~SWAP_USAGE_OFFLIST_BIT), leaving the stored count 4 TiB below
the real one, and calls plist_add() on a device that is already listed,
tripping the WARN_ON(!plist_node_empty(node)) in plist_add() and linking
the node a second time.

Change the definition of SWAP_USAGE_OFFLIST_BIT to be based on
atomic_long_t instead.  Note that the usage counter field itself is of
this same type, so it is still a valid bit.

Link: https://lore.kernel.org/20260828191433.3304458-1-nphamcs@gmail.com
Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs%40gmail.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -156,7 +156,7 @@ static struct swap_info_struct *swap_ent
  * This bit will be set if the device is not on the plist and not
  * usable, will be cleared if the device is on the plist.
  */
-#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
+#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2))
 #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
 static long swap_usage_in_pages(struct swap_info_struct *si)
 {


