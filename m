Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A9224A078;
	Tue, 21 Jul 2026 20:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664668; cv=none; b=OdTMjV3HfDPlIP+vMCc+jIclvQQ+JOhuXZcJha1L+SjVbiLFnbeNDtj1f6ZUUS93ONbiUgiTiEP/QH8Lv14Wxamd5VBHwUl/VAWdNzD3nvb1e0XQTOkRiPNuQG6Hr9gy54PavZdz2ee0kpmzYskyX3m8OPMfHBX+fhS271KNIxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664668; c=relaxed/simple;
	bh=htEVW+87Ths95mvje/DrYMA6vTjxsmTXGbySykMucfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PELc9uJrc1eISBMWyOO+mJi15iB8Jz/SFsg7hq6VX9n/e6Yjioz8G8npzrhm1mtitUl8xm+xTA2H3di5hh/09rx41rzXX+SNH6vuiTsSxLGRRe3FytfTUYgkk8ox4B49Xve1PxvB94yKUcJ6tmlvd1QAGUY25HTNdysuOU5xFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1jLbwEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1jLbwEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948A31F000E9;
	Tue, 21 Jul 2026 20:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664667;
	bh=MI9aXVSEOmaIwMDZ56/keaNzsrFXtqe8DceagusPvWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1jLbwElJNAqlDm+WEL0yXVMbCgl8WhebtyVhCl0CyVZoKDyspnS07v/Za8ZMk4LT
	 sYYK4LZCbpA/DRUnd/bU6VE2NcP6L1nZVrl8LixCASG/GKlWze49SqUq3SqVb2qU8b
	 gs3aoSr0M9uxade5I4KdXrbz7cjzkUFYsCHLaZbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0014/1266] userfaultfd: gate must_wait writability check on pte_present()
Date: Tue, 21 Jul 2026 17:07:31 +0200
Message-ID: <20260721152442.109476761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau <kas@kernel.org>

[ Upstream commit 8e80af52db652fbc41320eee45a4f73bc029faf2 ]

userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
without taking the page table lock and then apply pte_write() /
huge_pte_write() to it.  Those accessors decode bits from the present
encoding only; on a swap or migration entry they read the offset bits that
happen to share the same position and return an undefined result.

The intent of the check is "is this fault still WP-blocked?".  A
non-marker swap entry means the page is in transit -- the userfault
context the original fault delivered against is no longer the same, and
the swap-in or migration completion path will re-deliver a fresh fault if
userspace still needs to handle it.  Worst case under the current code the
garbage write bit says "wait", and the thread stays asleep until a
UFFDIO_WAKE that may never arrive.

Gate the writability check on pte_present() so the lockless re-check only
inspects present-PTE bits when the entry is actually present.  The
non-present, non-marker case returns "don't wait" and lets the fault path
retry.

Link: https://lore.kernel.org/20260529172331.356655-6-kas@kernel.org
Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ kas: apply to fs/userfaultfd.c and fold the pte_present()/
  huge_pte_present() gate into the existing writability checks; this tree
  predates the marker/return-style refactor of these functions ]
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 74c468cc432e7f..49f07426259818 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -300,7 +300,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (huge_pte_none_mostly(pte))
 		ret = true;
-	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
+	/*
+	 * Gate the writability check on pte_present(): huge_pte_write() on a
+	 * non-present migration entry decodes random offset bits. The
+	 * migration completion path re-delivers the fault if still needed.
+	 */
+	if (pte_present(pte) && !huge_pte_write(pte) && (reason & VM_UFFD_WP))
 		ret = true;
 out:
 	return ret;
@@ -375,7 +380,12 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	ptent = ptep_get(pte);
 	if (pte_none_mostly(ptent))
 		ret = true;
-	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
+	/*
+	 * Gate the writability check on pte_present(): pte_write() on a
+	 * non-present swap/migration entry decodes random offset bits. The
+	 * page-in path re-delivers the fault if it still needs userspace.
+	 */
+	if (pte_present(ptent) && !pte_write(ptent) && (reason & VM_UFFD_WP))
 		ret = true;
 	pte_unmap(pte);
 
-- 
2.53.0



