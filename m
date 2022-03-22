Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0046453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89519C340EC;
	Tue, 22 Mar 2022 21:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985482;
	bh=ReSpgwCOC8EZ2mYlf7ddgCC1InqFtXZHECYBWEiCYJQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=MzfJP7rUJL3GWG7O/a/WgQZ/k2lq2alx0GB3hQX/2VabhjDG5n/AtKLkwfLMicuJg
	 BH5vTQXLAjNv+JGByjecCBvEnIewsHq7lCULbh1Ra+BRQhbP1lT8Ox3RlrpQFRVkkX
	 S2607Aru71r3zQkwuYYc6suH7MsjOKns73tf8gMA=
Date: Tue, 22 Mar 2022 14:44:41 -0700
To: tony.luck@intel.com,tglx@linutronix.de,naoya.horiguchi@nec.com,mingo@redhat.com,linmiaohe@huawei.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,luofei@unicloud.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 122/227] mm/hwpoison: add in-use hugepage hwpoison filter judgement
Message-Id: <20220322214442.89519C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement

After successfully obtaining the reference count of the huge page, it is
still necessary to call hwpoison_filter() to make a filter judgement,
otherwise the filter hugepage will be unmaped and the related process may
be killed.

Link: https://lkml.kernel.org/r/20220223082254.2769757-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement
+++ a/mm/memory-failure.c
@@ -1534,6 +1534,14 @@ static int memory_failure_hugetlb(unsign
 	lock_page(head);
 	page_flags = head->flags;
 
+	if (hwpoison_filter(p)) {
+		if (TestClearPageHWPoison(head))
+			num_poisoned_pages_dec();
+		put_page(p);
+		res = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
_
