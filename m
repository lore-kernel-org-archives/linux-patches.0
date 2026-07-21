Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAC375AC3;
	Tue, 21 Jul 2026 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654485; cv=none; b=jY3A8pUQuiLwO8L35/5vccxjw5bzWXqYxT+Yc89DWmtuuCF7XXsPjAJMZlFSj9p5b18cEo4fR3pM2RvPWBoSRdjyK2ENv1fNNJbzPRNCm+HVoYx6nP1AbWywECF+uQ4HgK7q3iI3ab/++4MM0wCTWSm2oa1KW/5kjfYeD9ajayQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654485; c=relaxed/simple;
	bh=Sw66FNoFPIqUf+0QhmiqGhAkrgmBBgdqDaoaI5A5nOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPQ5v/zFzROyGTTdGKl5DIYfPQKuJukxh3WOTEGV6XUaVoeGgGHJGPtUFI3IaqtAsBH9B/p5xWaKgghxOLDce57T58d0CkfKwiLqyqaCZpXdRVRFMSheJjkNpbHrHKAQaYs8fPr6uwNKhEJzHh0PSwEXuRVcakhF8+YuHmcwX74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcYpLhWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcYpLhWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AE11F000E9;
	Tue, 21 Jul 2026 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654483;
	bh=QAOkohJk/eIvQlDAO0NIvRM1zEgLmVScLFNdwHZgXVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcYpLhWOVOCjjnYtbfnUnEvVQSNdxtYfaNulyHkeCDU4zKRVQ8W2XWqjcWq+EmADf
	 3ZFQvXkTsfM40g4o4fm9FMeiL12Fd3Qejt4q6QVGOhNCgVwcZMnVkpTAjnEgGUSWPF
	 7B15sGFs3nAzpdYXnBpjogMyc4+E7dJmTY1K4+Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1723/2077] mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152633.391707898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit f7e2c21bd1f57cd5350eecdfdb5d6025ca6afbab upstream.

change_non_present_huge_pmd() rewrites a writable device-private PMD swap
entry into a readable one without carrying pmd_swp_uffd_wp() across.  The
PTE-level change_softleaf_pte() does this correctly; mirror that here,
matching what copy_huge_pmd() does for the fork path.  Without the carry,
a plain mprotect() over a UFFD_WP-marked device-private THP strips the bit
and the trap is bypassed on swap-in.

Link: https://lore.kernel.org/20260529172331.356655-5-kas@kernel.org
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2638,6 +2638,8 @@ static void change_non_present_huge_pmd(
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpmd = swp_entry_to_pmd(entry);
+		if (pmd_swp_uffd_wp(*pmd))
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
 		newpmd = *pmd;
 	}


