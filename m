Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509C3283FD9;
	Mon, 13 Apr 2026 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096617; cv=none; b=hncu9aHvJLyCyVPXXYEBCikZsfHIjhS7BM4/kEmF2BgLPGS2aBroICkUsc40IrD+VL/zLpTme4Jd1CTLYA4UWB6mzu6zZvpopVx0Y4IGGe/I/btisTeJL9SVOPSRNiZjoiuTwZ5D47MVHiuRf2etWaWKuaNYOyKfIS9jzDzwXfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096617; c=relaxed/simple;
	bh=9QmWnCRgILZgBTs2kIhikJ1YtF4Vm424GqE9JIxDLNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2Ic3y6FZgjtF5bMImZK/31JXLq/0eUl9z9aOiUEN+eiKBCqc6cDCQzL1aTwbFt+N1VIG8Df0GSCsXVAt668XWSlk3mnHma1W6yb8MNgpdZccSWcjBEf/em/6MTQm6P1wnMCBNCYFzPY9SVq3BtoRhJR3u9tv7YGktbEydK9L5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnTtqmQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnTtqmQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA604C2BCB0;
	Mon, 13 Apr 2026 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096617;
	bh=9QmWnCRgILZgBTs2kIhikJ1YtF4Vm424GqE9JIxDLNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnTtqmQ0lTrAwQdqDq3WcWTnBmFrkFifhrtPjnl0K/7BbLOzvr0fF7AL6Vfom/R+I
	 XHVxaukGqvGjulHnlJx2/KB1Ht3DL9A61EVnKaeUBtRN4R6sBLbGw74uhjspNNB66A
	 kjk3Q++oC9+r1MkURhLeMFlnXTR62fGSY8RRxC9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Li <hao.li@linux.dev>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 48/83] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Mon, 13 Apr 2026 18:00:16 +0200
Message-ID: <20260413155732.811413054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Hao Li <hao.li@linux.dev>

commit 2ecbe06abf9bfb2261cd6464a6bc3a3615625402 upstream.

N_NORMAL_MEMORY is initialized from zone population at boot, but memory
hotplug currently only updates N_MEMORY.  As a result, a node that gains
normal memory via hotplug can remain invisible to users iterating over
N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
incorrectly marked as such.

The most visible effect is that
/sys/devices/system/node/has_normal_memory does not report a node even
after that node has gained normal memory via hotplug.

Also, list_lru-based shrinkers can undercount objects on such a node
and may skip reclaim on that node entirely, which can lead to a higher
memory footprint than expected.

Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
offline_pages().  Set the bit when a node that currently lacks normal
memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
offlining removes the last present pages from zones <= ZONE_NORMAL.

This restores the intended semantics without bringing back the old
status_change_nid_normal notifier plumbing which was removed in
8d2882a8edb8.

Current users that benefit include list_lru, zswap, nfsd filecache,
hugetlb_cgroup, and has_normal_memory sysfs reporting.

Link: https://lkml.kernel.org/r/20260330035941.518186-1-hao.li@linux.dev
Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
Signed-off-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1218,6 +1218,13 @@ int online_pages(unsigned long pfn, unsi
 
 	if (node_arg.nid >= 0)
 		node_set_state(nid, N_MEMORY);
+	/*
+	 * Check whether we are adding normal memory to the node for the first
+	 * time.
+	 */
+	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
+		node_set_state(nid, N_NORMAL_MEMORY);
+
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
 
@@ -1919,6 +1926,8 @@ int offline_pages(unsigned long start_pf
 	unsigned long flags;
 	char *reason;
 	int ret;
+	unsigned long normal_pages = 0;
+	enum zone_type zt;
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
@@ -2067,6 +2076,17 @@ int offline_pages(unsigned long start_pf
 	init_per_zone_wmark_min();
 
 	/*
+	 * Check whether this operation removes the last normal memory from
+	 * the node. We do this before clearing N_MEMORY to avoid the possible
+	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
+	 */
+	if (zone_idx(zone) <= ZONE_NORMAL) {
+		for (zt = 0; zt <= ZONE_NORMAL; zt++)
+			normal_pages += pgdat->node_zones[zt].present_pages;
+		if (!normal_pages)
+			node_clear_state(node, N_NORMAL_MEMORY);
+	}
+	/*
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */


