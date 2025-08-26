Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D78A327797;
	Tue, 26 Aug 2025 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208645; cv=none; b=p6UiLs8eATKk9Ra45urSQAjz/ghUVgcCf7H/p/QC1IybNdyrNvMnNnbp+wudiQ3sCKbe9payXc3iL8NITp2VcuEU6QProt6FQjeZVHBHd4Ec8E31++B0EgxqvRCIYnZ1ZSloRWn1DSjRE7OV4U3DtUaLMBxwh/ZDMgpR6RFMnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208645; c=relaxed/simple;
	bh=26knWlcpi9QVXZoZyAaF7owUjqgrrN2ZYN5srZKwRcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOdbeFajVxeUciU/aKPmZ1VJZIpMAZ1im1sax47qAfAYJo1dSgu6tKRfJS6fRpxFRj5HJwrMlL2aOYDhWYyy57sd6fKtKGPMKmqryeSQ8REH+eEYFZETOaLphOyv5CLcJvijfPq03o+bGGZgMWQwGzapF0SMsiRizgocVJpIt3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i60St2ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i60St2ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B82CC4CEF1;
	Tue, 26 Aug 2025 11:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208645;
	bh=26knWlcpi9QVXZoZyAaF7owUjqgrrN2ZYN5srZKwRcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i60St2obbpVDk5Za8eESWjWseBDzqn16lfYJ6sjP00/HnCJ9K5fMyCEep3rKHKJmN
	 ev97peHymBeULGCmJJ8BxbsTGmGNHpDp6h7K9clA1xnK2/D2vP4/bfTlkV5VKNF3G8
	 3uIlv9cycpOEnfJy9G9ElcALs1jaxgQKV4Af7yXo=
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
Subject: [PATCH 6.12 173/322] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110920.130078528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -845,9 +845,17 @@ static int hwpoison_hugetlb_range(pte_t
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
 


