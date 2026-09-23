Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4AB49158A;
	Wed, 23 Sep 2026 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174896; cv=none; b=sEtaW6wM+y4RtbYzVM0sm/hnNKmjrWWng4UzxiGiHV3nth2w1cXLUphaZ58TEkbR7pO/vQC6aMOr6Q9Py3q50RR3TMER1p72rgTKYm/VgkKqVF/B1dc23xsCtIzT4ELJfimreXqqFHltm7ILcCK77/p/mHRnLosMHuWKpec6WPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174896; c=relaxed/simple;
	bh=jFn2kCS+xpSuf6kknZWV6d3vcVSIufFb9KrD7gQnPLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nL4BmB4aL+h3mHYDyILrrPOknzH6RlYMnGbKD7wQ5Sp2VY7PQGts3+AcxQWIIm2oklEJfPNHGElXeKAi6LzE2pbte7YE4cnjBBidJR8GADqnAuytX3r4J9L2LPBfcB0NAXUi0kYi0ddXu18z/K+rqY9Q1S9ZJ8xgGsKEUpS7rRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7stviha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7stviha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A30C1F000FF;
	Wed, 23 Sep 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174894;
	bh=ze2du7owbglHMAnHrz3tUkDo+3P3AxMY2V7VkMm/nwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7stvihaypQLyjYUpmtGocIJtSkED2/5srO9mDQxIRi9s2L9Rn8By0bHDUhtBGXyj
	 z7xnbHvrcdvOkunGr+tZ9LI6saOCVgU1bjTfzKrba4ipT33Ji6Z6OpVwX98TI3QXZN
	 UtAun7UtZ7PrpEgAUEtwAxk2WMjVtByzEuQ5IT7Y=
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
Subject: [PATCH 6.18 259/398] mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count
Date: Wed, 23 Sep 2026 16:05:33 +0200
Message-ID: <20260923140650.127432330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,7 +162,7 @@ static inline unsigned char swap_count(u
  * This bit will be set if the device is not on the plist and not
  * usable, will be cleared if the device is on the plist.
  */
-#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
+#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2))
 #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
 static long swap_usage_in_pages(struct swap_info_struct *si)
 {


