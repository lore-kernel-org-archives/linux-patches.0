Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1636D18F2FC;
	Tue, 26 Aug 2025 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213883; cv=none; b=SwC3k1R2jq8HPurqFEum/2U9r/MQo4Ydcp7osJ2AsUOCyTBwIgYC1ZC7NfaGueqoaWNK6H596gzFp0w1NlOHN7uzGvLOntAxao8jkDPOkFreiJJSFoRRfIA3aI7wrGEvhRoMD+K6SrSZFYAVfvAR4lQL79Fz8uBTYeevsb5eTww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213883; c=relaxed/simple;
	bh=SJI6MADQKff94JN8TsiUWX/UG/TLLgKER9QG82nIs3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlv/Ss6ITZVr8Ws4Cgn4Ok73dynQp80PfN++w80+yWatiM5Xaql4LwziG7w7RJ8jarXlAAiXP8ZprV/Saa6+7v1yuADdGikeOSFKSIuu4WQymjzyetE26OjnD8Si/DrGOCTLBLzZx00szWKn0+4e9/RHvX8AP4g1YvV6Q8nX0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1Y12Y+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1Y12Y+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716B2C4CEF1;
	Tue, 26 Aug 2025 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213883;
	bh=SJI6MADQKff94JN8TsiUWX/UG/TLLgKER9QG82nIs3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1Y12Y+Tk66sAiQA2PbUGQJ7dS1Idnwakqbo7Oo3BEhPTmd3ajRkmiONpImazY7Zw
	 5sjjcz/c6/QF2UDmnBegidz11jKPvf/7hEV1fldg2eT61kjS04x7iKbcgSH8qbr/8z
	 eLmzby+/+nhI9ywaj9jJS8FGB0trcOkFbYug2UxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 484/587] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Tue, 26 Aug 2025 13:10:33 +0200
Message-ID: <20250826111005.286867401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 2e6053fea379806269c4f7f5e36b523c9c0fb35c upstream.

When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task.  However, if
the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means UCE is handled properly, but it doesn't actually.  In such
case, the user task will trigger UCE infinitely.

To fix it, add .test_walk callback for hwpoison_walk_ops to scan all vmas.

Link: https://lkml.kernel.org/r/20250815073209.1984582-1-tujinjiang@huawei.com
Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -835,9 +835,17 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	/* We also want to consider pages mapped into VM_PFNMAP. */
+	return 0;
+}
+
 static const struct mm_walk_ops hwpoison_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
+	.test_walk = hwpoison_test_walk,
 	.walk_lock = PGWALK_RDLOCK,
 };
 


