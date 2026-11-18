Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047372;
	b=bS5SL0St31lcS/mNA7vBZS8DjGHMrQObmLXiLy+IUtkt99EzScgZJjhYWtThkIdEvR9W
	 h2MHP8itSnjL6E3c0XPkNHdhM85gsXMGoVmEkE4DWFBOAxSVIK1NntX4GjNOpBgWpyPJ5
	 jO+5gKvkXHJGtxKnoUM2n4Vo7XTpjPZdcZ7rZuC3THp2E0bYcPpKlV05Dv9UjWlhPvJlP
	 CF8upxHJvfJ4oDSDbw1Byj7aRD4gWpXXczboRDrwyi9G/2HDAH8cGPp990Yl0cZfvAbcO
	 9BRG4VXEMtbHJsMnwwf9aTf7pEF9hMiRuzDHCc+1savskSLbXNPJ0mgV0iaGlUJ35dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCwSJl0r/G5nkwNP1g9EmC+VjAHGNWTsIOUN7T2T7t4=;
	b=fNGvoegCF4jn4fDIERiXQDH5mQ7UBMLxP4WshJHx3T/qxfnbCnqDo6pPLXldf146BYLR
	 GCbzn38jVdwe1yJ75RYOpvvjENxgcUvqSuOZMpu1n97y7+Het9WDuxJYsy2SbZvT593d6
	 Bz8oZ/ZISo5OFCjVlHu5GHhOnohSe7vioORHGkfOp4LbcN5eRWz9X43neeEWllV+4YU2r
	 Kes9WIoPFWuCa/Vt03jraKU/ZlhL06CgWlNYkBfX5BdnJezMUU0ZmS0Nm9IEAkSJsHHjY
	 TQqp7VjXGlHkY+uGcLto0Tqj88Ci9G/jd6iPB/MGCa7YPTpcIAkZb8soeIw/MBcMcgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1XQ1Jq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A40606A33E;
	Thu, 19 Nov 2026 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1XQ1Jq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549EC1F000C6;
	Thu, 19 Nov 2026 00:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047372;
	bh=jCwSJl0r/G5nkwNP1g9EmC+VjAHGNWTsIOUN7T2T7t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1XQ1Jq35ZGhk2UcMLEuFi8FflVCVuv2DkJCZf3JjWeKIk+E6l9v0t67LKfF1urII
	 1sbi6ScqxbnO66IMSa46Q2/zesWAoodA2Lopm+3QWJZkctIGJG2OIg6Ssti6ST41EO
	 eTkDRkw7alLUvTJvg9ZbOqf7X9iB3+aIuVkN9sWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1615/2857] mm/hugetlb: fix endless write fault on a leftover uffd bit
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150259.501218395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f61e1cf15fb44f9cf89d43d8ef01f926322bb1c4 ]

hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
registered for userfaultfd write protection, and hugetlb_wp() bails out
for any entry with the uffd bit set assuming hugetlb_fault() has already
resolved it.

When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
that is not registered for uffd-wp, a write fault to it never makes
progress. If the access comes from the kernel, e.g. read(2) from
/dev/zero into such page, the task spins in the page fault handler,
ignores SIGKILL and keeps holding the locks taken by the system call.

Such entries should not exist, but an unprivileged user can create them,
for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Clear the uffd bit when the VMA is not registered for uffd-wp and let the
fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.

Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
a private VMA that was made PROT_NONE now drops the RWP protection of
that page.

Original fix generated by an LLM and sent in private by Josef.

[rppt@kernel.org: massage commit message]
[david@kernel.org: convert comment into a TODO]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted userfaultfd write-protection handling to older synchronous-only interfaces. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ec557c2b1ab63..9660566a1ba4b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6195,23 +6195,33 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
+	if (huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
-		struct vm_fault vmf = {
-			.vma = vma,
-			.address = haddr,
-			.real_address = address,
-			.flags = flags,
-		};
+		if (userfaultfd_wp(vma)) {
+			struct vm_fault vmf = {
+				.vma = vma,
+				.address = haddr,
+				.real_address = address,
+				.flags = flags,
+			};
 
-		spin_unlock(ptl);
-		if (pagecache_page) {
-			unlock_page(pagecache_page);
-			put_page(pagecache_page);
+			spin_unlock(ptl);
+			if (pagecache_page) {
+				unlock_page(pagecache_page);
+				put_page(pagecache_page);
+			}
+			hugetlb_vma_unlock_read(vma);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
-		hugetlb_vma_unlock_read(vma);
-		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-		return handle_userfault(&vmf, VM_UFFD_WP);
+
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
+		entry = huge_pte_clear_uffd_wp(entry);
+		set_huge_pte_at(mm, haddr, ptep, entry);
+		/* Fallthrough to CoW */
 	}
 
 	/*
-- 
2.53.0



