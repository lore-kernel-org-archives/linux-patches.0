Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7512F12B0;
	Fri, 17 Oct 2025 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713860; cv=none; b=j8IimXkEdETKfz1nOw/SaMXxjz9bS7MGjh6wW4NxJHpdz+93Kc9S6lqsUVHPuG1vtoCdImzj3riO8AiHL8UGPshPxAFlOeEZI9oAgE8AyPWNXF7SZV82AmsuXC+0FeGlZQ7gEGhxMLwVWcRUBmsMTbW5ms7H952M8+WRdfOcMuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713860; c=relaxed/simple;
	bh=vfeoTf7yIk5zCc7twm8ecnZkOjqDaqS2D5+Harpa148=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqRC1hPaVCNxRhEGSVlLYCibeztdV8nno2KfCeosgkv0rGoRrtciPOV5qWySeG/xxpyB8+u9KA2JUVawQdCwYhuRQhx8np0SmWC+N2C6ZWn6+39C+4zY1VQjRHJ+hosMUtz5/ibDsyteBP2WogHz2cC6mbmMj6Wxkp3dlp0FOq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtmTfgtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtmTfgtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F8EC4CEE7;
	Fri, 17 Oct 2025 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713860;
	bh=vfeoTf7yIk5zCc7twm8ecnZkOjqDaqS2D5+Harpa148=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtmTfgtNDvg+umVU10OrSPSBYsK7SStwcsDBC7C6TQTyWsNf5O04sWWX6TUVWXKZl
	 Uj7ookuuX8F42LpploQLirQyhBwne1OksV8HocUQ9msamW5XCD+DGLSrpXwubIYOHp
	 X/KbUmtqICcVPvHXKEiTNggIVG5alzko3PFRJ9dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 144/201] mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Fri, 17 Oct 2025 16:53:25 +0200
Message-ID: <20251017145140.023350650@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit b322e88b3d553e85b4e15779491c70022783faa4 upstream.

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, avoiding unnecessary CPU cycles and the below log
message when hugepages aren't configured in the kernel command line.
[    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

Link: https://lkml.kernel.org/r/20250814102333.4428-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3298,6 +3298,9 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	for_each_online_node(i) {
 		if (h->max_huge_pages_node[i] > 0) {


