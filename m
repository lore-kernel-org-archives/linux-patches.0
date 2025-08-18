Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521FA3570C3;
	Mon, 18 Aug 2025 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526392; cv=none; b=r3pAH9DEfuIOLcCMk8m9tXKiu61qq2MDnjRO/vBSZT3o/QrEqmE5S8Q33uvbFfRf3kzv8V6nKs4LB7jytrO8NByrG7NDp+X2/cWBT9fg8e787qgVX2ODtAAIXfLc69Tj3WeDZYjAa/5QYAsU9hfflLu05VSSznsm9JLL5TQMzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526392; c=relaxed/simple;
	bh=NfornXTN+sgLFkl4FiTjtMy5ZcrPOer0bOPFLGTgJgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3Ss4uHQPzIftyzo/LQZgDarFVXFeerEYMRR6q6devQrHPcHyinc/b+udcbEYcoFtxIVb0I3OKq/d6OQt7jUOURckis6J9Xfjdut19639XOfJNg2QheOQma++ZyN8F1EYq5SCAHAfpFOEAdP0kmoOZ3cbAEiKAqEzZDvGreAI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIeCrnNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIeCrnNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B507AC4CEEB;
	Mon, 18 Aug 2025 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526392;
	bh=NfornXTN+sgLFkl4FiTjtMy5ZcrPOer0bOPFLGTgJgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIeCrnNC0aX3eah4pXrc2FG3d3Oz91C1ijXeDRLXfcCnbvJ/8ctYKexCek/DwDIT3
	 ffREkdWjaSELr12lkTKaPjvdiQ0g8wficSg12muBVktBq0IH7idWPoPna0dXGV5dDS
	 He9D56ZUXWc44Iuz4YkwMSY02QY+hFVAMoXD3gdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.16 542/570] mm, slab: restore NUMA policy support for large kmalloc
Date: Mon, 18 Aug 2025 14:48:49 +0200
Message-ID: <20250818124526.757169614@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4269,7 +4269,12 @@ static void *___kmalloc_large_node(size_
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


