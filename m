Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9441D4F7CDB;
	Tue, 13 Oct 2026 12:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895430; cv=none; b=XQzMq5WShLUTcZQbXxHYJJ97G4pinqm2D2Op7q0oZtYfzZ/FcrqPth/hZtY+xAU1p38ICnciRgWz2xfExdqJj2jANXaMZptZyq3oCdKEOL7Lc74NSgxsyPQOEQnwpcGKVkNS6MpnGuujNTDeylvupiHWfIPJqFRAaGuorHIpJKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895430; c=relaxed/simple;
	bh=u7HzEvDpUbX/VefHX12rDp47Fgze3pG93T/5rITK/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=On53mgPhgNwiJoAXJdC6eKgqc0vOkFFFfuO01rgkfALh8/cpmM/EyKMFK/zb94E4YkAWZOptjIR8j+KBHSFAmZC2Daq9ZQ90i8DDc2CALMXq1jVXQ08sE6secR09v9ypMu5GK/vouXH2iln99qgr+cRof2avsc3YR1wnk7TQHKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP+zRic5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP+zRic5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39111F000FF;
	Tue, 13 Oct 2026 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895429;
	bh=wOjJiRYBr9ZL6w9GgAE/JQhemCEd563Q2pFA+L02wos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pP+zRic5AsTlouJdXzOtSHQWJ/QE1LBZ9ykOaviW6f4YIlPUeEHC8IpjzE5er1OiN
	 rps+00AOp/B+vVrJ0hh4g1GyPgwXl6DIDA7nd3J8nIo226ujkciKatQOmXmVL6HwtS
	 or9YZapvAQ37lb0eFjulkfHAclD7L26lveMu6Ay0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/497] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Tue, 13 Oct 2026 13:37:17 +0200
Message-ID: <20261013112914.302019684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 72c3d682c165b836b54a3d07a01f72e39c47022c ]

According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
ignore any THP or mTHP interface settings.

However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible"
semantics for mTHP with anonymous shmem"), performing MADV_COLLAPSE on
shmem will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to
"inherit" (although that is the default), which can cause MADV_COLLAPSE to
fail unexpectedly.

This could cause a userspace-visible performance regression.

Fix this by returning the result of shmem_huge_global_enabled() directly
when MADV_COLLAPSE is requested, allowing PMD-order collapse while
ignoring shmem THP/mTHP settings.

Link: https://lore.kernel.org/063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com
Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
[ sashal: Kept the shmem_huge_global_enabled() call without upstream’s extra vma argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1a5932bda558f..9166d9c455abd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1713,13 +1713,12 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vm_flags);
-	if (!vma || !vma_is_anon_shmem(vma)) {
-		/*
-		 * For tmpfs, we now only support PMD sized THP if huge page
-		 * is enabled, otherwise fallback to order 0.
-		 */
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
-	}
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
-- 
2.53.0



