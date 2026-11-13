Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591136;
	b=xGvuwHtrDXZAvzXmWpLDjpWkrjZ9fAcVQ9Fl+93jLMT416bH5cCnWAQQDhcx4r3t0atg
	 V1hrTa1Ey9FGZq4izeeFrucADsDYQVm9zXI2QXl3JAxS26PhF03t/S4J0rJlC75Vhrw/l
	 tC60UFI86gbLS8yzIW+DaRKj2Q5g7X76sPFp0OqRuFpsgEl4rwqD4rPZIj0Ja8rscIDqk
	 vKTXv266Eq3pIJj+rXQznXHPPIXgm3cDSWSXoqoXiVSQBGWAlDk4yoE29QSWIx2Vodzfu
	 7oE3PobjahPT6OhZ1Snoq4uFgFqCXYB2BHdmoeu6AuoZ7ALDZN2g1XnHPDwbxS4x2HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7C0kLEXb0AB0aj7Bf7XnpSxG1l5exk2A0MrcEO6w9rw=;
	b=W0NTR136b/nihaEb2U4MdWuzzRjM6fljBROxujd39H4fgqxVECphM6x++Z9r91JNo/oA
	 dahawT3TAbNinaQW8klg6oeol2c5flv+J4t+lE+mCurGOtKGRLmNtnKjscE9ktoEmeP1b
	 sMcUFfkDhmGMOT1L+xCXnO9NYbqj5PAFb/UeP65mha8p93szZgpXB6Q/WW8kMzUYDoFiL
	 +4WY1SuSSivqf7S+TUUgjiYbgObpDRAbiKiI2wujopuyM+bb+jwfel9krgIR7lCvNpts6
	 d+eNiz8O9PS/Z3/87/aWYrH3izwCZCIrjQlwR9ega+6akZ4W6+0tihbCX+XdstFyJTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/phmz69";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7181606A88C;
	Fri, 13 Nov 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/phmz69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A20F1F000C4;
	Fri, 13 Nov 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591136;
	bh=7C0kLEXb0AB0aj7Bf7XnpSxG1l5exk2A0MrcEO6w9rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/phmz69MTbDgGHeLY4c4jBouTIXQLmoRKM5x67nIfUj+SkLkWoI5YUto7vI4How8
	 Laq1ZdNfGC4WQaqLKK9zJ5CWQUCKUYKtD6X2Mv/9ShN55FOL7KgCXqFVJWfKoryDtA
	 NP/aYte9lTVimMuYvhRl/rNEPwrhlq9tzm3ayN8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/670] mm/migrate: snapshot the source nid before the misplaced migration
Date: Fri, 13 Nov 2026 10:47:26 -0500
Message-ID: <20261113153821.436571069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit fe623a81ad9eddf10059b4e44bca0440d9120613 ]

A successful migration frees the source folio before the promotion
counter update, so the folio_nid() read there operates on a freed
folio — which may already have been reallocated. It happens to work
today, as Zi explained:

  : Strictly speaking, it can be seen as a benign UAF. It works, because
  : 1. folio->flags happens to be the same as page->flags,
  : 2. folio/page nid is stored in the ->flags and never changed.
  :
  : In memdesc world, after a folio is freed, I assume folio->flags would be
  : zeroed since struct folio is freed and calling folio_nid() on a freed
  : folio would give a bogus result (yeah, it can be mitigated by not
  : zeroing node field and each node has its own struct folio pool, but that
  : makes folio_nid() implementation dependent).

and Matthew explained further:

  : once struct folio is separately allocated, it's a UAF.  It could be
  : recycled to a different NID or maybe the slab containing the folio could
  : be freed (assuming we're not holding the RCU read lock at this point in
  : migration, and I don't see why we would be).

A separate concern is memory hot-removal.  With memory-tiering mode
enabled, successful migration can release the source before the
promotion-accounting folio_nid() read.  If the task is preempted there,
an otherwise-free source block can be offlined and removed first.  On
the x86 path, removal can unmap the source's vmemmap, so the later read
can fault.  The snapshot avoids that read.

Link: https://lore.kernel.org/20261027021721.95781-1-laoar.shao@gmail.com
Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5711d721425fa..66af1dd6a9411 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2700,6 +2700,7 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = folio_nid(folio);
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -2714,7 +2715,7 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		    && !node_is_toptier(folio_nid(folio))
+		    && !node_is_toptier(src_node)
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
-- 
2.53.0



