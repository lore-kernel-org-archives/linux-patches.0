Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B11F8F1D;
	Tue, 17 Dec 2024 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456320; cv=none; b=PKtLVxweWzTxNdIB7mkiu/XxSk43CvGE4ZrNoNtOjRvgVvSz1fqBMI7WXqF28GVj8XRsBUAp/plktSjcmBdio7JsnhTYPO1Nqu0p/X21My5BoNnLwqYF70VNcFQSe3SyNa0i4z9Kf2NWKRN7Kno+cXY3oWu33vxr7RtWXWwPh+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456320; c=relaxed/simple;
	bh=Z+gs4dD6poHXr14U4Q7AGUAAhVcqhpPxsv274ngcut8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZgZaOQGO6zY4/0tiFXDoy98DXT29zaHjNILbDS0CWLqZtBX3N8a559uSn+1IxuR2u6CAJYb8JVRgpPoPZBFqpJfb61yDImWGZkQrSLYjDJnsbeoC/Xn6wbI5oBD8Rh4QIMfg6t4u9AktrZLYAvWwaPx8Y6znJFhcSxmQ1wRJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUqXxPOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUqXxPOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B111C4CED3;
	Tue, 17 Dec 2024 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456319;
	bh=Z+gs4dD6poHXr14U4Q7AGUAAhVcqhpPxsv274ngcut8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUqXxPOZpaUVzBLDUtSRdVo3lHPLZ8/m+sWwa2wY+iRcd8UgvJhJ7b2f0ZSddljgC
	 W9G6RG4f6+EA6U/yEy4i3RzcSDdZiVuO556ClM5rsv7qcitllk3pFw3jU9gh4RBSoo
	 eVStLXBN6nDb6JLrRxGJ4SVaqGcgPfezkN64asrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 022/172] memcg: slub: fix SUnreclaim for post charged objects
Date: Tue, 17 Dec 2024 18:06:18 +0100
Message-ID: <20241217170547.178145464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit b7ffecbe198e2dfc44abf92ceb90f46150f7527a upstream.

Large kmalloc directly allocates from the page allocator and then use
lruvec_stat_mod_folio() to increment the unreclaimable slab stats for
global and memcg. However when post memcg charging of slab objects was
added in commit 9028cdeb38e1 ("memcg: add charging of already allocated
slab objects"), it missed to correctly handle the unreclaimable slab
stats for memcg.

One user visisble effect of that bug is that the node level
unreclaimable slab stat will work correctly but the memcg level stat can
underflow as kernel correctly handles the free path but the charge path
missed to increment the memcg level unreclaimable slab stat. Let's fix
by correctly handle in the post charge code path.

Fixes: 9028cdeb38e1 ("memcg: add charging of already allocated slab objects")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2199,9 +2199,24 @@ bool memcg_slab_post_charge(void *p, gfp
 
 	folio = virt_to_folio(p);
 	if (!folio_test_slab(folio)) {
-		return folio_memcg_kmem(folio) ||
-			(__memcg_kmem_charge_page(folio_page(folio, 0), flags,
-						  folio_order(folio)) == 0);
+		int size;
+
+		if (folio_memcg_kmem(folio))
+			return true;
+
+		if (__memcg_kmem_charge_page(folio_page(folio, 0), flags,
+					     folio_order(folio)))
+			return false;
+
+		/*
+		 * This folio has already been accounted in the global stats but
+		 * not in the memcg stats. So, subtract from the global and use
+		 * the interface which adds to both global and memcg stats.
+		 */
+		size = folio_size(folio);
+		node_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, -size);
+		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, size);
+		return true;
 	}
 
 	slab = folio_slab(folio);


