Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6AD33BBD9;
	Fri,  9 Oct 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555409; cv=none; b=R14U9wdsxhpnYibZh8kK06nTkcSKVWxpKgh7q29aHpczGQ7yyTxq1vAD4ltNZ8LPKV7Yq4fM8MomqnB6YPvGYkmvYcG7BuSg4GFBk7kr1M/3laj9RfkfbSodnZ0ocTrhUu24iuC/s3uK3CHdkMkqub7esTQyx6kW3kRysn1S6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555409; c=relaxed/simple;
	bh=Ea4Z+2gwydj5R+58chjobNVTEZYK8JSFjjSo5wU/giQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr+mT0NwGqeJHf5/1SE3T/SYwcMZ9bLARBc5Y+QjizjRb65UhukjRqXW/6nUYJpO/vYlk7qhxoUHpSkOe5c7KD87HFpB2CBH5EAmqgqeHogfXMPDC3KJD0JJTLxQgtmrR0f7WZQhi0ZnNI9FF6ZupkuEnGkoNwXvJtsRo46UxRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6FC5V0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6FC5V0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940721F000FF;
	Fri,  9 Oct 2026 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555404;
	bh=CUKOpvx+Avc7dWhxerlH7Q+8X4SsaNGrMSxbY+yUB8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6FC5V0EX7oz7LCVxDKbQedtcLxWa5p4vKaRzbm7KDXPtv2+d1pT/P3o/uhWZcJFm
	 tSKUFZxVrUMpaYoK5MnhX7cYv8RZQZ/Tga6JUpKniBMd1TKhDvYXTQxBzguXAdPbCm
	 +I8SqfGJfw4cv6+Sv/lFJqKYobRBdvW1xUPFIxtk=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/403] mm/huge_memory: initialise workingset state before folio split
Date: Fri,  9 Oct 2026 16:06:47 +0200
Message-ID: <20261009140953.181813409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit aca1f2d5de17e138bc6c4859126b77e516b82541 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e0c7b7efd38a2..df4a3e6215d4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3797,7 +3797,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
@@ -3811,6 +3811,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		if (uniform_split) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, folio_order(folio), gfp);
-- 
2.53.0



