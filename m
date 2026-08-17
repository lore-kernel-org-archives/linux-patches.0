Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE091439F73;
	Mon, 17 Aug 2026 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974529; cv=none; b=o4Nj3xkyHD7Bha6g/3lJW1XMHNNSyyEzGzpY34AK6/Uw0SdtvT7qYJT85g5nyI5sG4mZr2IVdp4N0RKgJ87HZgcGreMy93/YutTWczKbURYrJeokTNs3UfRuBQTzrTA2cpBO49M+I5pTWGB4r6ClIjsyvKdV0nmG2+EWrXtaCBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974529; c=relaxed/simple;
	bh=bgHMUZ4GHGdnqw0IUlA+jancH4eq/+aA5Fkkk58u8nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1FFyIlVX1FaIseGDRRwni4ZKLIH8xpMo4jL5DLaAjJkIe4yTlYlDcnE9N49ckGMSt81pbctNKd/XG+dFKe3hVi88pTa7eGXF3RgwmNMBqELn4y1L/+Fd8XCf51z4iTdeHLRoq6NW0W/mx059XPl8xymMe6sb9tGGC6USl594xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1q13ZVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1q13ZVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0D21F00A3A;
	Mon, 17 Aug 2026 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974526;
	bh=3hZ4sT7Xmt1GEiLUpncAJ5dK0XZLaxHkwliSfuNGm3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1q13ZVLOQiUM4leTCxPsL3B6KG8LQCLdUVLMi2joD2vm7+arBFxn+bTthsvb57Nc
	 Ddgs8UPBsmOnESrX2KjUEvrYlQWleeLqBG/TuZSkbmXoBkXawtLPaK1wF/TnuqfTdj
	 bbq90hHbWF8IlSP1eqAG3QreWRj+saLjmNaklUMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Dev Jain <dev.jain@arm.com>,
	Kairui Song <ryncsn@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 209/271] mm/huge_memory: initialise workingset state before folio split
Date: Mon, 17 Aug 2026 15:32:14 +0200
Message-ID: <20260817132545.405809222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

commit aca1f2d5de17e138bc6c4859126b77e516b82541 upstream.

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset.  That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Link: https://lore.kernel.org/20260725101419.3938406-1-matt@readmodwrite.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4108,7 +4108,7 @@ static int __folio_split(struct folio *f
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
@@ -4122,6 +4122,8 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);


