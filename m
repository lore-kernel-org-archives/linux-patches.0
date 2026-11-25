Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622888;
	b=NddgJ2dTlxtloQZzE+3/yV4E67QxgsxkCjquKjsUYbxa2AS8z1uohNFriVUoQLxhmOWK
	 UiJ6tk3/ZBnlrMNBmDNPD7phAxUCBj6P3QqblziyZD/M6D8Eqiq9Ob+hcJwKZmMmW5s05
	 +B1X4sbwuoKaTiRaCVd2brc4IvJ+zEmoVY++tGKEmEc3Ete81Rz5f88ds8ItjlUCqro2R
	 Ryj8l+yQVgxp9ctwWYieiOkJ7KH+1o3B0DJfhoiR+B5wqs8KLG2EMpLe9paFV7skdiZl8
	 r3K9f9azLwJhm1znURghQwgGYXbl6SuPrAnk/DyCCD99WMUCQeLmr3JicZ/tM4/laNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5blvONKUWx9MFhd6ameo1+9wgZnuie5FEeWbgEMkdaY=;
	b=0aW95c4M401r5zlw4c1MB8CFY6tGRpPCnKwHgthkW0APLFc3uQZrVxv2hFip24VfeIG2
	 qAgmAjTppiCFd4BByvARAuu86vXn4S5VDz25IKhmcYi00L9oaDxPegXy0avhBYjxOEqsF
	 3mrFFgruyPvxEbqfzZH0LgW1ugpTi7RBHyVuNty42FP0wJCrsN+70nGTDHYERaU+JfJrs
	 bfuYCS+ht0sMEiUBBVe4QfbLiS3ep8f/RDpddb3KIcz0cV9++7oDmJdwC3aoQORMRfh5V
	 ho8IEPZe5RQeDmLpx4vAdsZFE0r2HZh64jeA/AWvxb8nkbMVSAUtbcLIgDajpE3bNiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C9g90t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BE5606A31E;
	Wed, 25 Nov 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C9g90t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205C71F000C6;
	Wed, 25 Nov 2026 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622888;
	bh=5blvONKUWx9MFhd6ameo1+9wgZnuie5FEeWbgEMkdaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1C9g90t54Twy5FWUcob4eyGj7B+t4GG62BGymAJEIqCRJJhmcN5fDhT839QZjPiW7
	 u/1BaM7CRGkCGof6aljo3rqGZqi1ij2eOG/kqzx0wXWsvHst9CKmfh6SPR+uHXh+PJ
	 VTWXqbFDupqH2I2vi55iAzGTTSrJj66IKM6BbOf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.18 680/990] mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
Date: Wed, 25 Nov 2026 15:34:07 +0100
Message-ID: <20261125143838.014962545@linuxfoundation.org>
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

commit 4cc1bcdf2e4ebcd319005ce2ea132489f6155139 upstream.

For a bind or preferred-many policy, mempolicy_slab_node() tests the
first matching slot's zone for NULL, then reads the slot again to look
up the zone's node. Offlining a zone's last block rebuilds the
zonelists in place, so the second read can return the terminator:

  CPU 0                             CPU 1
  mempolicy_slab_node()
    zonelist_zone(slot 4)
      = node 2 NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        slot 4 = NULL
    zonelist_node_idx(slot 4)
      zone_to_nid(NULL)

Current GCC merges the two reads, but nothing requires it. With
mm/mempolicy.o built with -fno-inline -fno-ipa-sra, holding a bound
task's slab_strict_numa allocation between the reads while a movable
block earlier in the zonelist goes offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   kmem_cache_alloc_noprof+0x294/0x610
   do_getname+0x34/0x230

mempolicy_slab_node() and zonelist_node_idx() are tail calls here, so
neither appears in the trace.

Read the slot once and use that zone.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://patch.msgid.link/20261101021340.2251928-12-gourry@gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2088,6 +2088,7 @@ unsigned int mempolicy_slab_node(void)
 	case MPOL_PREFERRED_MANY:
 	{
 		struct zoneref *z;
+		struct zone *zone;
 
 		/*
 		 * Follow bind policy behavior and start allocation at the
@@ -2098,7 +2099,8 @@ unsigned int mempolicy_slab_node(void)
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->nodes);
-		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
+		zone = zonelist_zone(z);
+		return zone ? zone_to_nid(zone) : node;
 	}
 	case MPOL_LOCAL:
 		return node;


