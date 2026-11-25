Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619530;
	b=SbbVZ8mTsDs8yJlNBfHNCsuNv/F3om9hso+rtABCrqKReZL9ZRxYdlekm3SOv3j93X9q
	 30k4jnJ7qweAdVkkjkUCrEw82t8rhA6au8XxcySo0uUqan8jcPxV/ApgV3cynWifLBoSY
	 CziXtUPvL2mKLC8uYnYuU3SUUN+tB2kPDk9kbQKiEG57byQle6RF3L4EHPuh0xXXTo7P8
	 rlhApYfLsOXA4RJ8nfos9qjb6HEssXYUuUNoV4eK5TpBSjmRDRKUcl1p7gV22rJ6p7khf
	 T99CGt7s0I6mEGlijqczXsraHy+6FxSFC9I7PVOOMG4wS101czqDn/5c4kXsE63jQNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1CL7QAx95hgxYGefsC72YAa3HMdpmpOL4DT0Tln8vUM=;
	b=SaNGOVtMTFyVqzZLZ7sP3VXX/ynnzPuV22kPDkAth6cVYeWu88NLCLZbTp8DZxemABqO
	 t3mnGshQSp1ggcAi6PyM0gBy1jOBfwaYeCZ3qkWs868ycwteEoGSXDF4Z9ZlPnxYVM1pR
	 4n2QtI38LvOAVr92k4so7JGfwD3z0ewF4hudQ32zewZIFy6MJPdZzXsrCDIrIM2uPMfrm
	 9HHs5tbqVkWDWTRDDDgonfOt9YpNYtREGPMLIbDvFHeYUPD9RK7PrgZpcGBPFfEOb5Vqs
	 1eS92gIm9CipkqBc0IRHP8Qe7vjqNa3hyBpVWQv/kSmu4v5D7dSybgly99xGER8otRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGbkcqdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E23606A321;
	Wed, 25 Nov 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGbkcqdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EEE1F000CA;
	Wed, 25 Nov 2026 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619529;
	bh=1CL7QAx95hgxYGefsC72YAa3HMdpmpOL4DT0Tln8vUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGbkcqdSznxIdwU5i1pT2D/GT5+ALHwtiuxkQvbo2tum+vtLK4/w1xu/Gtoj/p/pO
	 ZhvZaI87EqBSccZqHey05NLPtpOzwGDTvaESVlV/s1ALPJEoELd9XhjVklhBoraNE3
	 omWlStaOgZ9AJcTelcCchNFser/FU2/D7bLyUeDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 7.3 0599/1005] mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
Date: Wed, 25 Nov 2026 15:32:17 +0100
Message-ID: <20261125143835.777647500@linuxfoundation.org>
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
@@ -2159,6 +2159,7 @@ unsigned int mempolicy_slab_node(void)
 	case MPOL_PREFERRED_MANY:
 	{
 		struct zoneref *z;
+		struct zone *zone;
 
 		/*
 		 * Follow bind policy behavior and start allocation at the
@@ -2169,7 +2170,8 @@ unsigned int mempolicy_slab_node(void)
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->nodes);
-		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
+		zone = zonelist_zone(z);
+		return zone ? zone_to_nid(zone) : node;
 	}
 	case MPOL_LOCAL:
 		return node;


