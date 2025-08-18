Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949A335BC9;
	Mon, 18 Aug 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524497; cv=none; b=jBT7sSgzNOcYLSU/WBpeg9i6r3GaocJN8IXF8+IfEUO5sUSlkLEpuC9CQTA1fRBrAqzNrmUicYd2OiRFIGYCpUhXGjLUJ3x7jm4QjyoH4Giq5bCHYk57//694OXbGg84K2XeKafAnRrtY1FLwlHZxHxvU2sfoG+GQpKPrPn4CeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524497; c=relaxed/simple;
	bh=QuSSMCgsxAUCl5PEdMAuJJ5GcRatTrrwQto518NibxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4NzbiZz6XASZZ9IYJhELDbnWTnCCqIhPbLnCCY9DqeRwGAk6ceTc5jFF17NwR6a2FS4sIEq4oBv5kOA7gBOAq3JMmDvJQ6UpROhiKU1H7575tH0cRCO6tSLdTP0GCB+grTb7vWN9WSXxAXQvoP+W1j6kJgynjyRx99wJ1FsFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUxgVJEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUxgVJEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912E0C4AF0B;
	Mon, 18 Aug 2025 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524497;
	bh=QuSSMCgsxAUCl5PEdMAuJJ5GcRatTrrwQto518NibxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUxgVJEvreywUAQf7KsciaLUIKIqTxUThF9gTIrXfD7Z4jrYtK+BA2wIMMOvJ+VXH
	 Q89m0m1COlocaEh40aLjxrJHGUEGQtxXWg8iL0km25FH1DhYB4NnplZ99q8jN5bctd
	 Kt5gdOITTiCGcHGFnflAm+WsVrb+ZUK1Fu58YJCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.15 490/515] mm, slab: restore NUMA policy support for large kmalloc
Date: Mon, 18 Aug 2025 14:47:56 +0200
Message-ID: <20250818124517.299406357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4268,7 +4268,12 @@ static void *___kmalloc_large_node(size_
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


