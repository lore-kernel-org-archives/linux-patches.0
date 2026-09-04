Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA37D3AA187;
	Fri,  4 Sep 2026 05:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498388; cv=none; b=VC/5Kp6OxFMpocPvCi+qGCxy3c6AJ/cXdn4ImLFErsuz2jhbICRf2lQNgXFAHwUCPAFn+tW8IuU4LMZOIRJA2A77lOlyeIKf6c3wRw/USl65W3acO9ocxgaK0mxux/NAsPM3A4AM6Pvr8eYht7IqaiGaUuT4z7j2SOd3nAqtIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498388; c=relaxed/simple;
	bh=T+lWbtOGTgHEqAofPkJ1j7qPmev+8BINtMtE/caiYls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBqyOAKSnSfPECVgg+iLOouiP9LRrbsOuJ7dDd8/G8ly7lD8zyMBKVZFoaGOCSdIhNx77C8HZgPPnDgZbpmZFIAvY8DicPKlaTPno2Afs0UZpSrSbW9BPaxky2whvBeA3cWx+zPW7tz8vABNrLIwfXYgZRTvmNyndemHYwjX12Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhveuxq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhveuxq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D161F00A3D;
	Fri,  4 Sep 2026 05:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498386;
	bh=8eTir/Uk+s2gvttk7jn9Xe8bzDQhsOY91akHwvdiO8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhveuxq+xP12hOWNbQjnJcc0SpOzA3hJ7XijcC0PsTfEK4UTY8W77IWNBjMh+xswp
	 uIu/u/o3Wu4yntD4cNzNVX2vuMA27a96hH33rjSUf3+dH+ywqKpnbaXP5DuClZO+0O
	 rttot4wXMBnx9HWn5nnJw55hDrod0c3ZvC5dTK4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Park <youngjun.park@lge.com>,
	Kairui Song <kasong@tencent.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 045/713] mm, swap: dont free a hibernation slot that is in the swap cache
Date: Fri,  4 Sep 2026 06:50:13 +0200
Message-ID: <20260904045804.840049243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Youngjun Park <youngjun.park@lge.com>

commit 10d9012e83efedde8718ceaa5053f836e0c8596c upstream.

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone
else.

This bug can trigger silent memory corruption, process crashes, or data
instability across completely unrelated userspace applications - typically
occurring when uswsusp is preparing the hibernation image.

I found this while working on giving hibernation slots their own marker in
the swap table, which I had discussed with Kairui.
(https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/) As far as
I know there are no reports, so there is no Reported-by/Closes to add.

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when
the folio leaves the cache, either through the reclaim below or through
normal reclaim later.

Link: https://lore.kernel.org/20260811132209.2862708-2-youngjun.park@lge.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2196,7 +2196,14 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */


