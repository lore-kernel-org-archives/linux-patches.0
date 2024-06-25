Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356913C90B;
	Tue, 25 Jun 2024 10:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309718; cv=none; b=Fygn7IsLBTj35kjkOtoOslZvdPxqRVvoZKJOaEQC1lZXokCiNpsrKWPoLCH9NiucPSYMtRCaRiR1O7qMDGJ45iFRdIWlEIEkZx8WcIltR8N5spqxd39873NnuWwMGUI93Q/lW1uJRFDz2XaUwG7YfgHbBEQ7Bj+auz7q4TUBJbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309718; c=relaxed/simple;
	bh=a5z+44Jpdgs5uL3mqxmECSHEQq/38OLqQmBNh5LvEkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDUlb7BBkE2ZxnP3FDot/4csoCBXUNUlY9Mhzz1YeZQh4lJcV4gvruT9f+18rLJ9yEsghZrkzhQHAPX1YRoR/8pNzN8ajIPPIbSrcThhXha/F8FbmwTTCWMyOjJ8jrgDLeUXXCU2RpinWvt2mckv0MDps17ToP36d8yZawJbiIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GbsuFdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GbsuFdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EF5C32781;
	Tue, 25 Jun 2024 10:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309718;
	bh=a5z+44Jpdgs5uL3mqxmECSHEQq/38OLqQmBNh5LvEkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GbsuFdulyGo2+Xm8dYZ1Ij6f63BUjoF3VDZ68huoGqqZdIrwHauK4o9GE0KXmArt
	 UM77hq6dOYQ4r9QQ8+L8H5Gw2T2deg3gX0HN1FL7FqHqh7euGDp+n61E+/szdtDWoO
	 kpmw3TUsqtCSU9aBtXR6ckmYixdYSKfcObZRblRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 111/131] mm/page_table_check: fix crash on ZONE_DEVICE
Date: Tue, 25 Jun 2024 11:34:26 +0200
Message-ID: <20240625085530.157087398@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

commit 8bb592c2eca8fd2bc06db7d80b38da18da4a2f43 upstream.

Not all pages may apply to pgtable check.  One example is ZONE_DEVICE
pages: they map PFNs directly, and they don't allocate page_ext at all
even if there's struct page around.  One may reference
devm_memremap_pages().

When both ZONE_DEVICE and page-table-check enabled, then try to map some
dax memories, one can trigger kernel bug constantly now when the kernel
was trying to inject some pfn maps on the dax device:

 kernel BUG at mm/page_table_check.c:55!

While it's pretty legal to use set_pxx_at() for ZONE_DEVICE pages for page
fault resolutions, skip all the checks if page_ext doesn't even exist in
pgtable checker, which applies to ZONE_DEVICE but maybe more.

Link: https://lkml.kernel.org/r/20240605212146.994486-1-peterx@redhat.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_table_check.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -70,6 +70,9 @@ static void page_table_check_clear(struc
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -108,6 +111,9 @@ static void page_table_check_set(struct
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -138,7 +144,10 @@ void __page_table_check_zero(struct page
 	BUG_ON(PageSlab(page));
 
 	page_ext = page_ext_get(page);
-	BUG_ON(!page_ext);
+
+	if (!page_ext)
+		return;
+
 	for (i = 0; i < (1ul << order); i++) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 


