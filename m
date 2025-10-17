Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5478132C92B;
	Fri, 17 Oct 2025 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713246; cv=none; b=qP9n2w0mOEplKwFAjd/FL28kADETtKaZa45tMEDxGY1HofFoX/cjGY2vWrZrNN+tMFHv4yXlkDKWdwbehZZilTxTR0qSgkd7duwci/kWHOmwXLg9k/d1ZwZkjYJVtgCECpyS6lcCasAwih7qO3TRTUm028ZWAoh91SXcDmajR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713246; c=relaxed/simple;
	bh=aHub4z773bHMZtzrng7UmVVziu/PPNlKiduVsCGn/8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uneVtVHKITNQHA4HIuE+ysgsBRvekeX6tEyCaosUiLxVKRIpZ7qQb939kI0rmdob+M1DDzvO63zBZEFq3f5m/oyckvC/JEsy6Bs5mA1M/3eNo6pxdPUQl6vMl/5OFmQrp7t3HytpFDW2EuutLA0bj6/F2m6JMpLOEypRAHqagLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKqrws5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKqrws5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD16AC4CEF9;
	Fri, 17 Oct 2025 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713246;
	bh=aHub4z773bHMZtzrng7UmVVziu/PPNlKiduVsCGn/8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKqrws5jZbbxET+r4fsDWYMzVfRbA0mwkgUYVuEvRJXR4y2e0WoKZqYMeQuNn3JT/
	 c9e4M7GOHEx9cTMBStz2GwQbesTnKR9D9gtGXw9XN0gopFBBDlO0MRv0RTzN65VArj
	 CkAZpY0hvGyZwJD7M1Nurn6BNQhVMvULQ2GeJITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.1 099/168] sparc64: fix hugetlb for sun4u
Date: Fri, 17 Oct 2025 16:52:58 +0200
Message-ID: <20251017145132.675333477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,6 +133,26 @@ hugetlb_get_unmapped_area(struct file *f
 
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
 


