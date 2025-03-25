Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0E2690EA;
	Tue, 25 Mar 2025 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906004; cv=none; b=Vwomu4dqRzOnVy8sfd7XRAuRmZM2tNKN1kyXZbAMk/UwmoF6E/myW5kcM82H9AP+EBC0dA6IfIE52bYyYCo69quExMH7oITg6cOIP8o4ab2rLlJtQnVCKYDYUKLXdU9eCLD8ghS6iSzH5Za43aprSLZhrlynZ/Bia2Ya5ksm3BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906004; c=relaxed/simple;
	bh=4HOst9jgk64iAqD53GK/7VkMe1eAtSiCeos/ZQfAhu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUvDmurIvIIVwA4Qum8lwt45NR7pla8Qd7Uk3YM1bzcGr/dEzP9kyhhlOzBr2L79oQ/YgrEedt8evlL7EqFTyOfaoltEKxBih0waKVpdIST8V4Fc2xZ3ue00BPo+uQb8QzYBIR72WN2HQz6uKqxFUNkSDI3foKN/4DglJ7na7MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5aGJ+aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5aGJ+aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E7C4CEE4;
	Tue, 25 Mar 2025 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906004;
	bh=4HOst9jgk64iAqD53GK/7VkMe1eAtSiCeos/ZQfAhu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5aGJ+aNDXwFbAOg2U0cZNShGNAMsI/826zzrMl9pKLw7egx7OWQPuVW63tKm1zaO
	 9xLdosNSyGL8khP3lWEToHrdasXt4igu6jqA/IHP9dasb94nurMWQniP37HkNKAiev
	 Mn//tdJpAld2/SK1qIb44e3FjTT2oQar9aJchE5U=
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
Subject: [PATCH 6.13 082/119] mm/huge_memory: drop beyond-EOF folios with the right number of refs
Date: Tue, 25 Mar 2025 08:22:20 -0400
Message-ID: <20250325122151.156014947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3298,7 +3298,7 @@ static void __split_huge_page(struct pag
 				folio_account_cleaned(tail,
 					inode_to_wb(folio->mapping->host));
 			__filemap_remove_folio(tail, NULL);
-			folio_put(tail);
+			folio_put_refs(tail, folio_nr_pages(tail));
 		} else if (!folio_test_anon(folio)) {
 			__xa_store(&folio->mapping->i_pages, tail->index,
 					tail, 0);


