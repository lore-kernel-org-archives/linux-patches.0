Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619597;
	b=QONUZjESeCg1IyqnQL5SMLGEDWU8fbE54qVqyONgJqvylsYDqoLNhCD22y+Vl6wUHk8D
	 e5giDcujJBSdA+AHTmc0TJpTkd3bFduyBlUWfGSegJI5GoIhO2KfAUh1IT0lJlnzSd/vK
	 5xcekxyuSa94X4hXLGOVWr6KZz1Tpvw939gbWAXdDlPadMxGAqQliJ7UfZOMaqYuBTqzk
	 59piz3ffEZk0pk0KP7djMSifs469wCHSHp/0neAFNO/pceucRiYlty7os93Oc9m/5ZJAw
	 NA24Y5pfIGNNf1QKdGpurqe6sefLiwiz+fu+eEdLmjoHYfO6kx6hmgVeRREGF/MonqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nyOT/j/zj+XT9PnHqXOEKhmY4ZW0F7uGIOb6OQ+9R8=;
	b=dT1bZtiNTYrviU2lCO/08yja1OJwg0NOMKEnwhjvcEJCrsEev+2xxefVbT+VpXd5DIbR
	 H2wPpG+2PHkDUDha+ZZhE1zorvqZzO6LCeza4iuVc8J+jMfKWuClJ6PbDMW5iRqsOo22U
	 lqD3IgcfIWzDPlPBUadD9qzHVJVPejgjIV11Ai/YrUfzhPYtPayTEdthzCtFQ6Kz7RCO4
	 c8spQ4NVQ+OMaIXYpw6+3yIhAWF6CcV4MkJ4sYmWs7cwdD4oUw3Q1Ub+WRx3UkBjO49x+
	 oUuXk57tDPFAwdbj3zFvEn8k05UJVxilvruuxCcS3922ZZnLkd64i4Pv1itRI7GcMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHOq5iMx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF057606A326;
	Wed, 25 Nov 2026 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHOq5iMx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF35A1F000CA;
	Wed, 25 Nov 2026 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619597;
	bh=6nyOT/j/zj+XT9PnHqXOEKhmY4ZW0F7uGIOb6OQ+9R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHOq5iMxpuIuw95a7A1o/irRAcPM7pJHath0ylyy6ykUMCjsdXiRGqRI7Hx6W5Q/O
	 kO0x1VVHCNomc3PdqePsZ4eQJvi/XnVVtNtPBgA9ZNn8aKleB1YjtHu5iGu+9/9YXD
	 LWbNcADCWFX1XrjcE5rD3jnt4pzYKahFqwRd5rkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0603/1005] mm/page_alloc: dont undo another isolation in alloc_contig_range
Date: Wed, 25 Nov 2026 15:32:21 +0100
Message-ID: <20261125143835.871872144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

commit 7d9c29ed8feec8bfbe5e5f673ba2b5926da11375 upstream.

An alloc_contig_range() that overlaps a block going offline can leave
the offline spinning until it gets a signal, holding the device hotplug
lock.  When isolation fails, alloc_contig_frozen_range() undoes it over
the whole range, clearing the offline's MIGRATE_ISOLATE too:

  CPU 1 (offline_pages)               CPU 2 (alloc_contig_range)
  start_isolate_page_range()
    blocks are MIGRATE_ISOLATE
                                      start_isolate_page_range()
                                        -EBUSY on CPU 1's blocks
                                      undo_isolate_page_range()
                                        blocks are MIGRATE_MOVABLE
  test_pages_isolated()
    never succeeds again

start_isolate_page_range() fails only on a block someone else isolated,
after undoing its own, so this undo only ever clears another caller's.
Return directly, as before alloc_contig_range() went pageblock granular.

With offline_pages() parked after isolating a DIMM block and a 1G
hugetlb allocation made over it, the offline on base still loops 30s
later in 4 of 4 runs:

  offline_pages+0x5b2/0x1570
  memory_subsys_offline+0x17e/0x470
  device_offline+0x250/0x340
  state_store+0x88/0x110

With this patch the allocation still fails, and the offline completes in
3 of 3 runs.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261027042204.3741307-5-gourry@gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7377,9 +7377,13 @@ int alloc_contig_frozen_range_noprof(uns
 	 * put back to page allocator so that buddy can use them.
 	 */
 
+	/*
+	 * On failure this has undone its own isolation, and any other
+	 * isolated blocks in the range belong to someone else, e.g. offline.
+	 */
 	ret = start_isolate_page_range(start, end, mode);
 	if (ret)
-		goto done;
+		return ret;
 
 	drain_all_pages(cc.zone);
 


