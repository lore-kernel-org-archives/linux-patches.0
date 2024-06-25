Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7891149C4F;
	Tue, 25 Jun 2024 09:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309302; cv=none; b=Y3yA9ps/StCI2IRvqVO5q4hmEF7BlDaFMCfDbBrF5Xye9UARrEdct8WKqdQ088nAJyiZxWyDBc7kMXvLPmQqmdvxA3OUbLsyNWRG09O3TtUunAU9lTgmg+0sjuhtP5Dh6oxXGxVoKJcqwEyrhIw22GNIJ5ATSHURxjSJxJgSjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309302; c=relaxed/simple;
	bh=E7fCWrLVoQyvvTcNJXWCXXwFXBOy4iZX405u48nx7lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdMWCPelL4QBIBlEsxt7ooCyFwyOQQAhlJkxPFFNgHqssr7CFVohDcILcdNG0w1wnellbXlpz5bX/uPe2GfP8rwSRCnYDoj0zAMHK/yHuA8qxK2+Mpy6eVh/vBTIBa86oEQ0FN4VearoZVwrXic8S1CDOhbU7iMyx3WfQaKVzPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJucmBV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJucmBV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E1C32781;
	Tue, 25 Jun 2024 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309302;
	bh=E7fCWrLVoQyvvTcNJXWCXXwFXBOy4iZX405u48nx7lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJucmBV1KbOLUhPhs5/G0i5HeNBFDNj3dspGm4rBlDDhTk1F3AQWdpDlK70nUeQGV
	 sCU8Zn1ohh/6b78zaWeK4Xbzd+CwgvUM+Awun902HFvSzz8CGzT5BaFcG0rA80T/Ye
	 mm2+DECdIc/gb/SSOblIcguDnt4YiCkyAMHgV9Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 164/192] mm/page_table_check: fix crash on ZONE_DEVICE
Date: Tue, 25 Jun 2024 11:33:56 +0200
Message-ID: <20240625085543.456911845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,6 +71,9 @@ static void page_table_check_clear(unsig
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -108,6 +111,9 @@ static void page_table_check_set(unsigne
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
 


