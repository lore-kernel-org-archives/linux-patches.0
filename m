Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629E918F2EF;
	Wed,  5 Feb 2025 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768308; cv=none; b=hPQssSKSbtzxZJ//YGcYr9ZBLSQ3rTysUstLXZ1PRDZWl47cW1tR6pw4dqPc87B1fVQ4/uSVZ/hAgsjcPSRlKb1zCd5lHJld4yEO4zhTLYngS6hrvcVSeONMRPRmPmmEoCVr4xhqvMEr4Djafcf039M2kAMJdOn2ordhFfkvHhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768308; c=relaxed/simple;
	bh=fvgcSqRI6OmpdhvAcz5NeYT/TBHlA3A8rNJJ2FGNl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcIUNp7vCkKiL2BJge3Jo6M/GackX4i+FQTOknKo6bkhJEz9tALMuGFAEpnpOK9QurV786kbTYrfyl1bqiHZGJ2RMmhzwOvxUMoDSIb+zsorMNDBZI9orDuF1D7APQ9CMgVrRGn71swLVyYknFaITzZlGYdJULDUDj+i8DrJcTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8R2lBJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8R2lBJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A56C4CED1;
	Wed,  5 Feb 2025 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768308;
	bh=fvgcSqRI6OmpdhvAcz5NeYT/TBHlA3A8rNJJ2FGNl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8R2lBJQBBQKiomm3KvvBCmNiUi/YYeg7Fv2KzOhPqpLQV8Jkv+C971zLeYwHU5AX
	 3v7pMuPrBpKlE4h9jfmVD7mk6G9gWcELxowrORwPxwG3ujvsgAlH8j/EI5YZA/DaBR
	 LMzTf76l4lr6xQAxZ8zyFG3pEsUG6CN0EcBfbIOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 582/590] Revert "s390/mm: Allow large pages for KASAN shadow mapping"
Date: Wed,  5 Feb 2025 14:45:37 +0100
Message-ID: <20250205134517.530629930@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

commit cc00550b2ae7ab1c7c56669fc004a13d880aaf0a upstream.

This reverts commit ff123eb7741638d55abf82fac090bb3a543c1e74.

Allowing large pages for KASAN shadow mappings isn't inherently wrong,
but adding POPULATE_KASAN_MAP_SHADOW to large_allowed() exposes an issue
in can_large_pud() and can_large_pmd().

Since commit d8073dc6bc04 ("s390/mm: Allow large pages only for aligned
physical addresses"), both can_large_pud() and can_large_pmd() call _pa()
to check if large page physical addresses are aligned. However, _pa()
has a side effect: it allocates memory in POPULATE_KASAN_MAP_SHADOW
mode. This results in massive memory leaks.

The proper fix would be to address both large_allowed() and _pa()'s side
effects, but for now, revert this change to avoid the leaks.

Fixes: ff123eb77416 ("s390/mm: Allow large pages for KASAN shadow mapping")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/vmem.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -264,17 +264,7 @@ static unsigned long _pa(unsigned long a
 
 static bool large_allowed(enum populate_mode mode)
 {
-	switch (mode) {
-	case POPULATE_DIRECT:
-	case POPULATE_IDENTITY:
-	case POPULATE_KERNEL:
-#ifdef CONFIG_KASAN
-	case POPULATE_KASAN_MAP_SHADOW:
-#endif
-		return true;
-	default:
-		return false;
-	}
+	return (mode == POPULATE_DIRECT) || (mode == POPULATE_IDENTITY) || (mode == POPULATE_KERNEL);
 }
 
 static bool can_large_pud(pud_t *pu_dir, unsigned long addr, unsigned long end,


