Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF701DE2A5;
	Tue,  8 Oct 2024 13:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392762; cv=none; b=Pm7IteE+cmDuXiCuatoYRbibd+U92u6d2Ert0ek9uaAALr1ARM4CQaEkCU+Fi2iowGNbE/lulr6LIKuo0R7NPhc6zKlF6vXgKGSgb4QplNKbthuqxn6SsxGVZWhYXuXMK1h+Ky3YeP5trT5nPG2BTXJMGKU/7QDPe3yLPUXzL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392762; c=relaxed/simple;
	bh=Z5TDdAQZ63xndN1moF2wjHlJvWZDVBaSH6hvdSu1Ow4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htc9I1nCGK6O8cq6g/m2PKsSBi4J6VDNiyD0KFgi0QtSjFDeQSWO7SszVNG1K/rHVYHuJRQ3no/NF7oeB0ijAkWgaVgiJE7rS/Ze5eHzXK/Vy+TjXQJqKlExsf/NbXwifpviv4Bi5s8Gk15k5K654T8bFx31ogKE+SwYivd0sIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cphpgdxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cphpgdxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F33C4CEC7;
	Tue,  8 Oct 2024 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392761;
	bh=Z5TDdAQZ63xndN1moF2wjHlJvWZDVBaSH6hvdSu1Ow4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CphpgdxhucxD3D4K0Th+akNhNgrkeCKBQ9INfMvXQl5TJki7vC9N/Sj/NOIyplkQd
	 PlVA4BQ1QjOPtKURE0gGg4OmgXjedoyrSYXJP4xXAS8MVo2Dpzb7Iv4lE1+CxY1LBC
	 LpRnzomnZbzDvh/r+nEzv8TA0cN53+u0gTruJWzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sistare <steven.sistare@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 480/558] mm/filemap: fix filemap_get_folios_contig THP panic
Date: Tue,  8 Oct 2024 14:08:30 +0200
Message-ID: <20241008115721.126838926@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Sistare <steven.sistare@oracle.com>

commit c225c4f6056b46a8a5bf2ed35abf17a2d6887691 upstream.

Patch series "memfd-pin huge page fixes".

Fix multiple bugs that occur when using memfd_pin_folios with hugetlb
pages and THP.  The hugetlb bugs only bite when the page is not yet
faulted in when memfd_pin_folios is called.  The THP bug bites when the
starting offset passed to memfd_pin_folios is not huge page aligned.  See
the commit messages for details.


This patch (of 5):

memfd_pin_folios on memory backed by THP panics if the requested start
offset is not huge page aligned:

BUG: kernel NULL pointer dereference, address: 0000000000000036
RIP: 0010:filemap_get_folios_contig+0xdf/0x290
RSP: 0018:ffffc9002092fbe8 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000002 RCX: 0000000000000002

The fault occurs here, because xas_load returns a folio with value 2:

    filemap_get_folios_contig()
        for (folio = xas_load(&xas); folio && xas.xa_index <= end;
                        folio = xas_next(&xas)) {
                ...
                if (!folio_try_get(folio))   <-- BOOM

"2" is an xarray sibling entry.  We get it because memfd_pin_folios does
not round the indices passed to filemap_get_folios_contig to huge page
boundaries for THP, so we load from the middle of a huge page range see a
sibling.  (It does round for hugetlbfs, at the is_file_hugepages test).

To fix, if the folio is a sibling, then return the next index as the
starting point for the next call to filemap_get_folios_contig.

Link: https://lkml.kernel.org/r/1725373521-451395-1-git-send-email-steven.sistare@oracle.com
Link: https://lkml.kernel.org/r/1725373521-451395-2-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2181,6 +2181,10 @@ unsigned filemap_get_folios_contig(struc
 		if (xa_is_value(folio))
 			goto update_start;
 
+		/* If we landed in the middle of a THP, continue at its end. */
+		if (xa_is_sibling(folio))
+			goto update_start;
+
 		if (!folio_try_get(folio))
 			goto retry;
 


