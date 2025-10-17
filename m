Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E949330B2E;
	Fri, 17 Oct 2025 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715565; cv=none; b=D0fZLCyEt0aucG5DlGyIem8hA+DTFDBGz1JzPbbj0vWu1I7+RZj+iGfkNjLFYHcNnI0+ixGHg0BoMmei4FAdQ9OZGa++wBA6mO0BfJJG63GdVOYlRdTXrQjBg5dsWotBf8mWeG4b2TVKsQZ56iSHaZet52bTtSj/UCE6xArVcF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715565; c=relaxed/simple;
	bh=dlHYY2HscggKaYOVI2e+c9RWEA/zUB3NInHC+GoAgoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuZwwXQXMm5FfI7iMwntBRJskwqz6KjjKiPTZ8rQgnGEYks6U+bfZLOu45wI9D17jL7ovVIQONOSaozp3pXETQyduDxFNKoNIPQPWy8kcOdpcGYXKNLLW65+p0lTVRUYMWc9L2EF7HhAxNR/qjYhfWb96nXUd+/lunA/BtYcanU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N95Ff9WV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N95Ff9WV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D431C4CEE7;
	Fri, 17 Oct 2025 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715564;
	bh=dlHYY2HscggKaYOVI2e+c9RWEA/zUB3NInHC+GoAgoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N95Ff9WV2kT7TH2ODvj6mUG66jz6GH3IjUBP8jnSbqW79TlkSu3ZQjPDRua6DL/D8
	 q/sk5y3/VJxRI71rGWgzfgIp2c2hZpbumXhB+zxUbvGXcJOC/g6gsWjMGzNvUMGHF3
	 05kLKS5HegV0qVwGF84CNRsivbwpu7qmeWujBtt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 6.17 260/371] sparc64: fix hugetlb for sun4u
Date: Fri, 17 Oct 2025 16:53:55 +0200
Message-ID: <20251017145211.488122457@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,6 +22,26 @@
 
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
 


