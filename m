Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A476F525A6B;
	Wed, 30 Sep 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790518; cv=none; b=MwuuTUV6FEwRqM+ThgHLwvhr23FgNsCUQ/WjyaudU/HWBil2RdY22V487c6Cd9i64Xwwo/HIP+SUIMDQwnYXGQcSshnlp7uQsXUjksHv5Rw0uaaiOFSaF48Ynd0p4vR3f8o0SBM9wDtViWxw74l7WHlg/Uu4v4x4Y7GjqwrWfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790518; c=relaxed/simple;
	bh=wD/DNMDd2nOaZ2+0mxLEmMgLUudnadTAY8x+6x4g050=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRerffEwKcmpLTNk2fOHhFE/v+GlLrWNHdKfypGEPb5fQxsa3RvNXwzFE6Kmk5x5MF9iaG6u3yG6XWs1o7qlUq3HMsHPZd2Q47WuR0ZjPOxHpNub8xDYEHxZ6dTsnNALSMa8UMbXgVTlsNu/+FWNrCxWM+oP+DsOkunSjJ+hzp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzTNQC9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzTNQC9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A65C1F000FF;
	Wed, 30 Sep 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790517;
	bh=xrnSyvEx9gZUY1s/Yc5iPPkGt+uz/hKYkOVJ+yeqvcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzTNQC9tdgptbtea5WMg/ql2FJl/zyGZCazfCFpzwpIBpZqcpGo3NS1JmnycGgbtJ
	 kp9+H5E2tn2SNhW8XKtHKasX07jzVKKnKCPZh45o0+RQSMUnWWp7umi/JMcgggOJ4j
	 vmJolL9Lps0lA15sz+sm0ZEWFcmIWii83aJENGy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 830/877] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Wed, 30 Sep 2026 17:29:01 +0200
Message-ID: <20260930152432.643695142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 39c0ceedd54557bdc1542de08d22b2ed33e534e4 ]

damon_hugetlb_mkold() reads the page table entry into a local variable,
unsets the accessed bit in the variable, and updates the page table entry
with the updated variable value.  If hardware updates the same page table
entry in parallel, the hw updates could be lost.  For example,
hardware-updated dirty bits might be lost.

Avoid the parallel updates by clearing the page table entry when reading
it together, using huge_ptep_get_and_clear().  If a parallel write to the
memory is made after the clearing, the hw will see the page table entry is
cleared, trigger page fault and wait until it is handled.  The page fault
handling will wait for damon_hugetlb_mkold() due to the page table lock.

Because hugetlbfs is an in-memory file system and hugetlb pages cannot be
reclaimed, no critical issue is expected to my best knowledge.  But
definitely this is a nasty bug that should be fixed sooner rather than
later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260907170358.100168-1-sj@kernel.org
Link: https://lore.kernel.org/20260830160545.98969-1-sj@kernel.org [1]
Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.17.x
[ preserved CONFIG_MMU_NOTIFIER guards because this branch lacks the mmu_notifier_clear_young() fallback. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -347,6 +347,7 @@ static void damon_hugetlb_mkold(pte_t *p
 
 	if (pte_young(entry)) {
 		referenced = true;
+		entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
 		entry = pte_mkold(entry);
 		set_huge_pte_at(mm, addr, pte, entry, psize);
 	}


