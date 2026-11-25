Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622903;
	b=0RodQfWszc/a9X8f9reH7zGP4Uv6Iru4Lm8IW5o9Wm5K++2iFrTNMXBJB7MiNINQrSC5
	 vJOs4Nrzd3aXRzvja8fmLb1lqIm+wieZDN8S4eh2SifaA7z/e4hY/DMGJlpsmhv3rKEbP
	 O4IIn//LrrIFpi0aSRoJTwTsZqFE1tmP2Hh/lP6pKLd8oCA735VYWB76vYux49l2/y7UG
	 AE6wtTiVgizIqxLJDwfmI2pI3blkiilCPaZ9LR65MoNesQEH+TjlPKLGWGPGzmDON3xnM
	 ascMGJPiLFBpu3ZrxUAPDNl327yb+B2gSlLRJDGAfMzmbZipnNTFYrUfjDXMCxlwQSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=smdQVbGphZLqPptqEsYuNSNoAB+SE925KacA4saMXFc=;
	b=nV7vxfXagpb1BOcxUU/3zO0HKVhKC1mp1TMLnGQ6pailDD9ki4Yz9IOpXTGslG6AtZR+
	 D0vKkMwYtn4/rm1JdquzvZTyqz1a1u3Nu92B3ia1aGJFhY+jMv3hzd1rXf0zye0yhrqda
	 xE4prgjoMsc2sqfYTGMJMZXl4WtzKCv5sOHIVBLaA+xtHekHDE7HPDRqV+ZURoW/RAGUT
	 MvPaoobtAX3SVOnw9UHiWGNnuv/AiYQj1LUeT2LkPsOpqR9zK/vDHJPl53zX9UStHt8zD
	 j+kQDJ2gPums00BbQaJvlLcC9lntySL/pwnDYwD2opk6aMlClpNEc4UAYJPONnS4YAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyOivMai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC5606A323;
	Wed, 25 Nov 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyOivMai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA4A1F000C4;
	Wed, 25 Nov 2026 16:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622903;
	bh=smdQVbGphZLqPptqEsYuNSNoAB+SE925KacA4saMXFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyOivMaiGfwIQX4ccoFcdro42zpd28UnNvuV1LW8Q7ngQfH7A5Bx97HYvsoomPQEV
	 X8WR6wwt0DIkRhZ+/bbEYjMxtwrKvPyOlVxZ0N7hjAkCL3a3eBGKyEnJFjnprbQq+G
	 R7JILIuqa1Hg9Mt7LIMsUEB/raKS6+p4ILv+F/wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.18 685/990] mm/page_alloc: snapshot the preferred zone against shrink rebuilds
Date: Wed, 25 Nov 2026 15:34:12 +0100
Message-ID: <20261125143838.131489393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

commit b3e3a760eb68449e2794ef68ab212173d9c3e8c7 upstream.

get_page_from_freelist() and alloc_pages_bulk_noprof() reread
ac->preferred_zoneref->zone at every use. Offlining a zone's last block
rebuilds the zonelists in place, and the shrunk list's NULL terminator
can land on the preferred slot mid-walk:

  CPU 0                             CPU 1
  get_page_from_freelist(GFP_KERNEL | __GFP_THISNODE)
    zone = NORMAL (slot 1)
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    rmqueue(zonelist_zone(slot 1), zone)
      zone_statistics(NULL, zone)

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:get_page_from_freelist+0x6a5/0x15f0
  Call Trace:
   __alloc_frozen_pages_noprof+0x125/0x330

Read the slot once. Zones are never freed, so a stale zone is safe, and
a NULL slot fails the same way as walking off the end.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://patch.msgid.link/20261101021340.2251928-7-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3793,12 +3793,21 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
+	/*
+	 * A concurrent zonelist rebuild can NULL or replace this slot. Zones
+	 * are never freed, so reading it once keeps a usable zone.
+	 */
+	preferred_zone = zonelist_zone(ac->preferred_zoneref);
+	if (!preferred_zone)
+		return NULL;
+
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -3845,7 +3854,7 @@ retry:
 		}
 
 		if (no_fallback && !defrag_mode && nr_online_nodes > 1 &&
-		    zone != zonelist_zone(ac->preferred_zoneref)) {
+		    zone != preferred_zone) {
 			int local_nid;
 
 			/*
@@ -3853,7 +3862,7 @@ retry:
 			 * fragmenting fallbacks. Locality is more important
 			 * than fragmentation avoidance.
 			 */
-			local_nid = zonelist_node_idx(ac->preferred_zoneref);
+			local_nid = zone_to_nid(preferred_zone);
 			if (zone_to_nid(zone) != local_nid) {
 				alloc_flags &= ~ALLOC_NOFRAGMENT;
 				goto retry;
@@ -3917,7 +3926,7 @@ check_alloc_wmark:
 				goto try_this_zone;
 
 			if (!node_reclaim_enabled() ||
-			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
+			    !zone_allows_reclaim(preferred_zone, zone))
 				continue;
 
 			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
@@ -3939,7 +3948,7 @@ check_alloc_wmark:
 		}
 
 try_this_zone:
-		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
+		page = rmqueue(preferred_zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
@@ -5156,6 +5165,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 	struct page *page;
 	unsigned long __maybe_unused UP_flags;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
@@ -5206,6 +5216,11 @@ unsigned long alloc_pages_bulk_noprof(gf
 		goto out;
 	gfp = alloc_gfp;
 
+	/* Read once; see get_page_from_freelist(). */
+	preferred_zone = zonelist_zone(ac.preferred_zoneref);
+	if (!preferred_zone)
+		goto failed;
+
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
@@ -5216,8 +5231,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
-		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
+		if (nr_online_nodes > 1 && zone != preferred_zone &&
+		    zone_to_nid(zone) != zone_to_nid(preferred_zone)) {
 			goto failed;
 		}
 
@@ -5225,7 +5240,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
 		if (zone_watermark_fast(zone, 0,  mark,
-				zonelist_zone_idx(ac.preferred_zoneref),
+				zone_idx(preferred_zone),
 				alloc_flags, gfp)) {
 			break;
 		}
@@ -5284,7 +5299,7 @@ retry_this_zone:
 	pcp_trylock_finish(UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	zone_statistics(preferred_zone, zone, nr_account);
 
 out:
 	return nr_populated;


