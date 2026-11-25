Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625595;
	b=1zOddoLySutyTXvj2fdnsD7EjrDVTVkoNebtGv7Z5orns+HQsqVezOFP+B5GBQbgdA67
	 P0ebasA1WjqZ9aIXjkwXbipDpb8kM8IELt7tPF9mzriX2ddABTCSiSQu/L39ZTpF9HTVL
	 k917k2Qy3LdJEFjsCRA4v+ze0plgUNx/CBl9bVPx6ny9OdfskDd2sneC5AMrYjHzh7VXL
	 27siZLptdwhCAf/v77X+nnoITsTdDfqdz5wP1Btuw8WNMaZahBmlLQ5szwO11PU0n3oP4
	 h6wIecZDJ55dxGlEEq6xyjUh7ik+684Bdkrcpa/YSVCdHQynuAR2MUIJDwWkg9hS+PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJL5p6HKwzpRACD4JUM5HjYA0B6yhP2PRxgp6OvMYj4=;
	b=f+zMsOuRx39AaMAZ7xttK+/ovcdWna4LW+eEj3dh0O+AeLN0s1DOXZ+7TNECUvXn+CaX
	 eFFB97SY109sq/yE+o+ualuQhx7nbZOJeZlo/fTQ2Yt1UC1zgqzilSymJFyMHCnWT0S29
	 wwrLXeTUbS9LS2hkL/Lhs12y/W4Abm6cRndei86nICWq+wOst8n5fDvHFnX0i5OWclCut
	 8j8CXksEmtKbnGF41BgcOQ+HgB7ZScAZMHx2nxR4KFRk9q2OsbocvoHd+g2VqNsAOwvvs
	 baiH4mTAumbSqfsK7BCE2R3pqiudB21S+7lpxr7K72wl4qvm6FHD3a8TMbyTcrRxtUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItDNe3kx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4B606A31E;
	Wed, 25 Nov 2026 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItDNe3kx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D51F000C4;
	Wed, 25 Nov 2026 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625595;
	bh=rJL5p6HKwzpRACD4JUM5HjYA0B6yhP2PRxgp6OvMYj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItDNe3kxBOg26WzAeYegK7taT8WAWPuvbIaAWE9niffpQ4nU5UitR59UNCJEp4TJD
	 OXQcX0wZRhNzLFu53p7iDxNDJI1k39b2qCXkkbKrOzUctWAcz2MDsSJy6IiLuH5W17
	 Mhbag9X+tfJIIp0TGmwanc8oi2dmt0h3MRuJ4+gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.12 569/816] mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
Date: Wed, 25 Nov 2026 15:35:17 +0100
Message-ID: <20261125143902.353023836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1937,6 +1937,7 @@ unsigned int mempolicy_slab_node(void)
 	case MPOL_PREFERRED_MANY:
 	{
 		struct zoneref *z;
+		struct zone *zone;
 
 		/*
 		 * Follow bind policy behavior and start allocation at the
@@ -1947,7 +1948,8 @@ unsigned int mempolicy_slab_node(void)
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->nodes);
-		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
+		zone = zonelist_zone(z);
+		return zone ? zone_to_nid(zone) : node;
 	}
 	case MPOL_LOCAL:
 		return node;


