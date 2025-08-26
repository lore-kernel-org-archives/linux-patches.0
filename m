Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A657529BDBA;
	Tue, 26 Aug 2025 11:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208392; cv=none; b=CkJIbihVYx7MJY0HfC2YMXQhSd+zU9GNbUobLA1WJ8wiwhUm+J5SNijyappmh9tPGmP0XYibAtSd5zbeVcFQFy68ccGffCzhlvg2mnucYGRFOx34BhCp4vxf4ik9zSTfhADOI9bEZ9UuBq4o/gWIN8TJa9yevVwsI4/OSqkgQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208392; c=relaxed/simple;
	bh=yp2K05Q7bEQFV0glmBHBZORIrjMtq8N329TDOpmO0mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKtvQY35rmT5Bf3FzfJp6BNymzVrb5KS3CCGHNrKsqi1EHHBo3Q7A9Kq1zpXjDApygrhI431WHhD6vPGuyomUo02LBx5o2C9idt5W5ydpUbT6xUSOxRuUVO0CKZ7dAuscBTh2uH/Xghq6iacdNHiWPuRFDYqLp5zESbfQ07hZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLDRRRK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLDRRRK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B60C4CEF4;
	Tue, 26 Aug 2025 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208392;
	bh=yp2K05Q7bEQFV0glmBHBZORIrjMtq8N329TDOpmO0mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLDRRRK85FmBtA7hUPA+FelZYVsdSf/9UEe2iddct56dJw0QRZ6K/Bo1gzJCO7lnd
	 dshoOaA/WuEObyfcRrWEZsyjqam3zW197aHYCuR7ZnVMDtzv7K7aAhS61SXxKQO51E
	 Xjpfrt/jdGa1HtdvGzZYs7JnZmwbhfBHUwENpwDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 093/322] parisc: Rename pte_needs_flush() to pte_needs_cache_flush() in cache.c
Date: Tue, 26 Aug 2025 13:08:28 +0200
Message-ID: <20250826110917.970412225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John David Anglin <dave.anglin@bell.net>

commit 52ce9406a9625c4498c4eaa51e7a7ed9dcb9db16 upstream.

The local name used in cache.c conflicts the declaration in
include/asm-generic/tlb.h.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -429,7 +429,7 @@ static inline pte_t *get_ptep(struct mm_
 	return ptep;
 }
 
-static inline bool pte_needs_flush(pte_t pte)
+static inline bool pte_needs_cache_flush(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_NO_CACHE))
 		== (_PAGE_PRESENT | _PAGE_ACCESSED);
@@ -630,7 +630,7 @@ static void flush_cache_page_if_present(
 	ptep = get_ptep(vma->vm_mm, vmaddr);
 	if (ptep) {
 		pte = ptep_get(ptep);
-		needs_flush = pte_needs_flush(pte);
+		needs_flush = pte_needs_cache_flush(pte);
 		pte_unmap(ptep);
 	}
 	if (needs_flush)


