Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122D015B0FE;
	Tue,  2 Jul 2024 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940421; cv=none; b=pGY2+7qklzZBD2eT01YnZ7SonLES4DId9OI5g1TzUmFou+B0a6ZXy3jxo42qG8aNExyq5KxYkrahccgNrj9rW7nb1vV4VHOjQ+JbmBKNiCJEUxYO2cAA+LkX19HDtF8hNJR9HBcBjBTbMOEkwqrdkFi4uk6ub6fx4KZ3h3Y+fso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940421; c=relaxed/simple;
	bh=LDF2Vi1xMgD7RCJEiA/Zdy/EipmYRAU6c5j8Psplrqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/n33WXAdC3Zhu/Rsfq7yZorkBXgfCeUTQspK2CTJy9YAvPxGlAeR/E2M9dEvbrQ6tpkqEmJoIGeNrRw6ZObChGktPiyx7GNcCZwcx1KA+GkLqTI5sr8TLqIHi3fKUgmCREAFadlqAVbjU+jULUY4xEgns8T3NFlIgzgWhLPXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVYnCZBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVYnCZBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD6CC116B1;
	Tue,  2 Jul 2024 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940420;
	bh=LDF2Vi1xMgD7RCJEiA/Zdy/EipmYRAU6c5j8Psplrqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVYnCZBQrf+3RzDBaLcivbAWEn8dQ9diSn+20j5qx7dIcry5aHBVuju5VclzHKdfF
	 WDZ2KN/a/Px2UVeyu+GztIFx528SzhRMxLdOWaIWl7sBnx8N81OZTC4p5cQmO5pmiY
	 yCC/RRXWYnVOUMPzqD9ouq4lizuugx5v4CVRu2Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 119/222] mm/memory: dont require head page for do_set_pmd()
Date: Tue,  2 Jul 2024 19:02:37 +0200
Message-ID: <20240702170248.518787067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@rivosinc.com>

commit ab1ffc86cb5bec1c92387b9811d9036512f8f4eb upstream.

The requirement that the head page be passed to do_set_pmd() was added in
commit ef37b2ea08ac ("mm/memory: page_add_file_rmap() ->
folio_add_file_rmap_[pte|pmd]()") and prevents pmd-mapping in the
finish_fault() and filemap_map_pages() paths if the page to be inserted is
anything but the head page for an otherwise suitable vma and pmd-sized
page.

Matthew said:

: We're going to stop using PMDs to map large folios unless the fault is
: within the first 4KiB of the PMD.  No idea how many workloads that
: affects, but it only needs to be backported as far as v6.8, so we may
: as well backport it.

Link: https://lkml.kernel.org/r/20240611153216.2794513-1-abrestic@rivosinc.com
Fixes: ef37b2ea08ac ("mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()")
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4583,8 +4583,9 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (page != &folio->page || folio_order(folio) != HPAGE_PMD_ORDER)
+	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
+	page = &folio->page;
 
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise


