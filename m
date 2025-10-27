Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6831CA72;
	Mon, 27 Oct 2025 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590626; cv=none; b=SzY62NKKCz+GY/31E6pp0K19IYhkIVPdbpfITs8Ua7vIaBnsflOWU7SMp3RGqDHv4v+FKtrs+q6fXFf+sIcwepUve74uL0id9JDPEchfXlzEFffWgviwsMHiSi7U/A+rb1ZGG8UgXdnl0ro4CzGmWyL90loyEPs142jxtheFiNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590626; c=relaxed/simple;
	bh=fkIExbeuE5D2O1TkLpvLDwiPPbZySnlDzo8gJttMoUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvTJAT5vSPEBMwahDrXeCBTy2F2UckAKEhQLSzHW9X+AXfBlhFzJaQkkGHMtDUtepvOb8DpBR/Hyekjex9EO4vTjHeF92C0zikee4RoDzrMTDbhR5DNQ9VkKUSNaHN8cc/VHfnk0XQEoQ7aW6Tyxu4krP5h1JB19DuWM477u8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzFitbY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzFitbY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5460BC4CEF1;
	Mon, 27 Oct 2025 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590625;
	bh=fkIExbeuE5D2O1TkLpvLDwiPPbZySnlDzo8gJttMoUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzFitbY18fXtTGH/4flehsP8YEVgS1aJ40eQuWXLZCfdDzT/f0UoG7fbHmkoue3u+
	 MR5PpKMeY/DmMVYuUm/UoVTAVG9Ohk9dpTf1+1cTly//H2ARb67NxW2r7vkq4c2dbJ
	 GYBu92QPjanV7UUqrkrFcUlLmcI6Lulm8mVGKWXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 5.4 116/224] sparc64: fix hugetlb for sun4u
Date: Mon, 27 Oct 2025 19:34:22 +0100
Message-ID: <20251027183512.091199089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,6 +134,26 @@ hugetlb_get_unmapped_area(struct file *f
 
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
 


