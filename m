Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223A81DF98C;
	Wed,  6 Nov 2024 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896445; cv=none; b=a42OzaRKIRm36a66xJlf+cTipMtgxOfd6Htcdw4V0dkjcjPwp8Sl7KQ8yMoBfM8mDVuCK+NfplGnNE4h2N1u79PA9a875lM2Fo6kbPfIciQ6P/bx4bR+tS0MJDg2mXjO9qGNFJnRqNHv1CNqbdGVSumoWMcGTUV9djVGndwhXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896445; c=relaxed/simple;
	bh=28DNzc9ndE7w33c6uknGSzl5A9ikmllB2d8S+a25Bp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIY+gdYgU+OFBro3rAHp7SRnV+VkXp+Wj3Ftwa8p9SNiDDwI3WIdOQp/tOoZurH3mBslfogORpYuCBbW7qx88K3bzT6c266T8EzRm9g7oXh1xv2ofNQyjdEOAAOAIFSMYRN9Dxx5HQIpSm/KLFJXWLUY7wpiRmjeguJ0R5Qj8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bmF5CyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bmF5CyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DD6C4CED4;
	Wed,  6 Nov 2024 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896445;
	bh=28DNzc9ndE7w33c6uknGSzl5A9ikmllB2d8S+a25Bp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bmF5CyVnRaKJd0AkdObhfgcJnvEG3SjlNcGU8EYDtS57zN4xIwV7Dbmx70y2ddg0
	 Yom8mp0whbmxZHy0GIZtucx8J/5HWnqSbmaDxPrH9BpyBN4FEUcIYC72c0QAHW+jz4
	 c4w9CbkHsTZBgjNHuHS7aOYooKsND0alqsN8xxXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Lance Yang <ioworker0@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 205/245] mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=true
Date: Wed,  6 Nov 2024 13:04:18 +0100
Message-ID: <20241106120324.291084148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanchu Xie <yuanchu@google.com>

[ Upstream commit bceeeaed4817ba7ad9013b4116c97220a60fcf7c ]

When non-leaf pmd accessed bits are available, MGLRU page table walks can
clear the non-leaf pmd accessed bit and ignore the accessed bit on the pte
if it's on a different node, skipping a generation update as well.  If
another scan occurs on the same node as said skipped pte.

The non-leaf pmd accessed bit might remain cleared and the pte accessed
bits won't be checked.  While this is sufficient for reclaim-driven aging,
where the goal is to select a reasonably cold page, the access can be
missed when aging proactively for workingset estimation of a node/memcg.

In more detail, get_pfn_folio returns NULL if the folio's nid != node
under scanning, so the page table walk skips processing of said pte.  Now
the pmd_young flag on this pmd is cleared, and if none of the pte's are
accessed before another scan occurs on the folio's node, the pmd_young
check fails and the pte accessed bit is skipped.

Since force_scan disables various other optimizations, we check force_scan
to ignore the non-leaf pmd accessed bit.

Link: https://lkml.kernel.org/r/20240813163759.742675-1-yuanchu@google.com
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ddd6d8e975b1 ("mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 128f307da6eea..b1f88638c5ab4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3456,7 +3456,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (should_clear_pmd_young())
+			if (!walk->force_scan && should_clear_pmd_young())
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -3543,7 +3543,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (!walk->force_scan && should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
 
-- 
2.43.0



