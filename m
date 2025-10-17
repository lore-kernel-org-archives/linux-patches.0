Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F397332E15B;
	Fri, 17 Oct 2025 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714496; cv=none; b=o3msPLBmgU1RQPYoTrwCNUkk6MNNOVT3mc/qdYSr2+OxGFH3ZczG9xScSiZoqBR24qlnkJITj0IhMK56A+N5i7swdY8Ozyy89yl1qu5dWmWczV4CrLZEYQQ8bSIqYMYfOai2ZmKpuU9aQyOgdYtaIpUm7HlBI3LgJ7Dw1zR1Nmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714496; c=relaxed/simple;
	bh=BiFKh+lWqtyQEYjcU0KoRXtW+rtQhf3TWf9c4aNT0Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPcSx8QtHA5BDMrjixxxwdd1dH5qugH5hXpRvESdGhpKVEpw7DeqSUI6rsB6UzDfXw8djbw43ElteJOyoTCfuz4NNF+bEa7zH7B4PrqUsIflvpHcdRY3bFsbEotqyLS+e6H1PPmy1vm9ZOjb83T0tHdU+m2XEq79cR+5Sk3hvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rdDYnwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rdDYnwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C68C4CEE7;
	Fri, 17 Oct 2025 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714495;
	bh=BiFKh+lWqtyQEYjcU0KoRXtW+rtQhf3TWf9c4aNT0Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rdDYnwNI2bQTDfSY7ziCaGFqO6Bza3rV7qDsd4xHCodaV+mUzgTJ2ZJ+MyYCOHWF
	 YF0KgXwaAlMpG+UTP6yuVQ3K5T9ba+0TNJhi+8C5IQGIJ1QfF0cV0aqQ1bhvNeFGid
	 CB8S039njFeCkGmQ5F8MSRsMN9HbBT3IzcdJcTlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.12 164/277] sparc64: fix hugetlb for sun4u
Date: Fri, 17 Oct 2025 16:52:51 +0200
Message-ID: <20251017145153.114868887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Anthony Yznaga <anthony.yznaga@oracle.com>

commit 6fd44a481b3c6111e4801cec964627791d0f3ec5 upstream.

An attempt to exercise sparc hugetlb code in a sun4u-based guest
running under qemu results in the guest hanging due to being stuck
in a trap loop. This is due to invalid hugetlb TTEs being installed
that do not have the expected _PAGE_PMD_HUGE and page size bits set.
Although the breakage has gone apparently unnoticed for several years,
fix it now so there is the option to exercise sparc hugetlb code under
qemu. This can be useful because sun4v support in qemu does not support
linux guests currently and sun4v-based hardware resources may not be
readily available.

Fix tested with a 6.15.2 and 6.16-rc6 kernels by running libhugetlbfs
tests on a qemu guest running Debian 13.

Fixes: c7d9f77d33a7 ("sparc64: Multi-page size support")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250716012446.10357-1-anthony.yznaga@oracle.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/hugetlbpage.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -130,6 +130,26 @@ hugetlb_get_unmapped_area(struct file *f
 
 static pte_t sun4u_hugepage_shift_to_tte(pte_t entry, unsigned int shift)
 {
+	unsigned long hugepage_size = _PAGE_SZ4MB_4U;
+
+	pte_val(entry) = pte_val(entry) & ~_PAGE_SZALL_4U;
+
+	switch (shift) {
+	case HPAGE_256MB_SHIFT:
+		hugepage_size = _PAGE_SZ256MB_4U;
+		pte_val(entry) |= _PAGE_PMD_HUGE;
+		break;
+	case HPAGE_SHIFT:
+		pte_val(entry) |= _PAGE_PMD_HUGE;
+		break;
+	case HPAGE_64K_SHIFT:
+		hugepage_size = _PAGE_SZ64K_4U;
+		break;
+	default:
+		WARN_ONCE(1, "unsupported hugepage shift=%u\n", shift);
+	}
+
+	pte_val(entry) = pte_val(entry) | hugepage_size;
 	return entry;
 }
 


