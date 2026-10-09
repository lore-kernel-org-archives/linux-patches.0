Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E593B582F;
	Fri,  9 Oct 2026 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555739; cv=none; b=Ixz1rT2111ZxYQKwevYAoBQ4wwkyzdGPZYHlRJqDAUswj4Uq1xpcEHx2fLleEhf7feO3Fnd9bf6lC447gTksHKWgcLjiJl3uKQrGJDB6mZo2ykS4zCwj7bXkhYtoYe9wxmp8wGNAkVkQTYC2DhdTC1y4osWOo1l14cpmdd6cURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555739; c=relaxed/simple;
	bh=h/5AXvDzuwBz2FQkKGPNLYSY9ws0XDPGdzGwvhJh4M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6Cl1gs85YHRDrW7O1+YGDP49O3oiCp7CKSWn08lejyjHHu8SKHvGkam80wBtCm92nKP9E1Wt9ukxayG6Jpty/xxwqc8/fC/0MDFWLFH3KGWHfm7zsJGtRrdYNvolHl1eLvFsvF94lN9xzfWT8GzeV95YiC98LffOKudV2jDXFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVtsCA3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVtsCA3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0B51F000FF;
	Fri,  9 Oct 2026 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555738;
	bh=EueAFmKyJMEFpqUZLikErYLnZtczLO4x1Z+iUbWBgss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVtsCA3U+in/2yRDYt8Bh2xrSZBMxq9BbWgoDxuN5KrbuI1ci4mcyjlNlG+F74xUu
	 rKBOftiZZyXF/s0sR3yf6ftLtOt0Ygq9BBcbp/okGmUbFkZiNHoJnW5bSGdeUjZ+Bx
	 59Z9l2kFvdG9bqZMz1M2gno/hGsm7u21m6RdZ4EI=
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
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 7.2 057/428] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Fri,  9 Oct 2026 16:06:34 +0200
Message-ID: <20261009140947.387798262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 72c3d682c165b836b54a3d07a01f72e39c47022c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1831,8 +1831,11 @@ unsigned long shmem_allowable_huge_order
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
-	/* Tmpfs huge pages allocation */
-	if (!vma || !vma_is_anon_shmem(vma))
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
 
 	/*


