Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FE427A44A;
	Mon, 18 Aug 2025 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522755; cv=none; b=mAYOZxRQlCM0QFFovBv3CHt84QFRAsqjgfXHdRPSMrsnmfR2AjU5h3CXW6eQY0imK/9meLJ9+6SLSl6Bhkh2kaSsdEV0mS84vvqGJczRA4aFY6oYf8aEX0cWGImCZLTumbyx6mZf1Q53ynaxYhLdq3iX5mUfX1ImUj2HHfbOW9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522755; c=relaxed/simple;
	bh=9o2XpxvpIwk6PJEGSIfosQOjVrkA78RBX8RXtYsCdHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSvOCsfmiFm7gz+IWZ00p71xN+yTJNG4juOMz7n+MFy6/OqSRv801Pxl3FNXtHeJz2DTi8mxgFgeCfm9JK4PJYODJHt2Q09tHjdO7/wmAlZj8/t9zGLRAcMOuoZugI9qUb2GjVWqN6WGjtJ1XBOiZfo8ebYJD6oNtfrjVuXInII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZh6bucP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZh6bucP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5049CC4CEEB;
	Mon, 18 Aug 2025 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522754;
	bh=9o2XpxvpIwk6PJEGSIfosQOjVrkA78RBX8RXtYsCdHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZh6bucPKadcGpXoyDNgQUU0j6qcaQNJDeyhopee1qnFj3Cyn/943X5tULIPL7X3/
	 mrDkwjO/lxC7LQ+ToeMZ2eWR8DHdHTXwU3VGrm0qQz930k7hu4VHRts13VAjLXsGfz
	 BJWTpMbM8nIGCdqmbuzAClAMYHsD6JcNQ9qO0XuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 412/444] mm, slab: restore NUMA policy support for large kmalloc
Date: Mon, 18 Aug 2025 14:47:18 +0200
Message-ID: <20250818124504.376499747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit e2d18cbf178775ad377ad88ee55e6e183c38d262 upstream.

The slab allocator observes the task's NUMA policy in various places
such as allocating slab pages. Large kmalloc() allocations used to do
that too, until an unintended change by c4cab557521a ("mm/slab_common:
cleanup kmalloc_large()") resulted in ignoring mempolicy and just
preferring the local node. Restore the NUMA policy support.

Fixes: c4cab557521a ("mm/slab_common: cleanup kmalloc_large()")
Cc: <stable@vger.kernel.org>
Acked-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4225,7 +4225,12 @@ static void *___kmalloc_large_node(size_
 		flags = kmalloc_fix_flags(flags);
 
 	flags |= __GFP_COMP;
-	folio = (struct folio *)alloc_pages_node_noprof(node, flags, order);
+
+	if (node == NUMA_NO_NODE)
+		folio = (struct folio *)alloc_pages_noprof(flags, order);
+	else
+		folio = (struct folio *)__alloc_pages_noprof(flags, order, node, NULL);
+
 	if (folio) {
 		ptr = folio_address(folio);
 		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,


