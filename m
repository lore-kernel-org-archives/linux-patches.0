Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C1725E444;
	Tue, 25 Mar 2025 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906431; cv=none; b=owm/wWgC4+p0c7/si4rBAbTWEb+7ehj9sLptDeXU3WCCD/ioAmxPzEpxDvrnuvu8HZQGgd/T419+1Q3IB22ea9+PnXEdKAOja/baEFae0xkVl/UK3ShR5wCfnf+WJ8D6iAwA9snb4Ayp8INE+K5ivBhtwTkK0pBB3tH6Hpq5dFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906431; c=relaxed/simple;
	bh=eqjxK2UXxrUYWn51YSVzOFb4SRHzRoAc5hmnX5Lg5w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRiVXlZhIctzuL4TWeKxdxg/QiGR7qEghfK8jva3VHYdI0f3a4u+5sS6LUb7RTtp4JX491TGedlSQpQX0HoLQe98geSQq5cuvj1eRLc8Q9dqJgAEG9LACqXol7GI/Zn64JZDh3+eRePVU5eFgkDGlYtHB0bkuJR5bxLKfoIYTXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5hSh02n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5hSh02n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63745C4CEE4;
	Tue, 25 Mar 2025 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906431;
	bh=eqjxK2UXxrUYWn51YSVzOFb4SRHzRoAc5hmnX5Lg5w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5hSh02nE6M1AusQrk5AmtdLnEyzkMat5T7VJnH3NEYYFlX7w8s5doO1bTbLfyMwB
	 PfA4pY+kqdPpBI43iDi0n8PWQYy2GMFF2p1i1U6yTaFL9NX29G9bccB7AQchGfh4+t
	 1c1F8O/2oYNbiwx9X4wARy7e97r/9DGbG+6Idq3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Kirill A. Shuemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 115/116] mm/huge_memory: drop beyond-EOF folios with the right number of refs
Date: Tue, 25 Mar 2025 08:23:22 -0400
Message-ID: <20250325122152.146866223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 14efb4793519d73fb2902bb0ece319b886e4b4b9 upstream.

When an after-split folio is large and needs to be dropped due to EOF,
folio_put_refs(folio, folio_nr_pages(folio)) should be used to drop all
page cache refs.  Otherwise, the folio will not be freed, causing memory
leak.

This leak would happen on a filesystem with blocksize > page_size and a
truncate is performed, where the blocksize makes folios split to >0 order
ones, causing truncated folios not being freed.

Link: https://lkml.kernel.org/r/20250310155727.472846-1-ziy@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/all/fcbadb7f-dd3e-21df-f9a7-2853b53183c4@google.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3224,7 +3224,7 @@ static void __split_huge_page(struct pag
 				folio_account_cleaned(tail,
 					inode_to_wb(folio->mapping->host));
 			__filemap_remove_folio(tail, NULL);
-			folio_put(tail);
+			folio_put_refs(tail, folio_nr_pages(tail));
 		} else if (!PageAnon(page)) {
 			__xa_store(&folio->mapping->i_pages, head[i].index,
 					head + i, 0);


