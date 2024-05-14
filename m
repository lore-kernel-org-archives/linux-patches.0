Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE3A136648;
	Tue, 14 May 2024 11:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686970; cv=none; b=nIIaSQSoLCIGlqgFXNIf06E3bMR9Pgk+K0mNLQhVmnWQVfHuzUbb3p+SqgRVGitYmuwjzNx63gReif5Mxz2VG96445sKvPkHTsoYA/gRdkNrLhWrb5g8ALBDfr6TMadiq7t0cqy/rX89rRgwifKgt9B+7iehfDKRhWJV5l+aGeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686970; c=relaxed/simple;
	bh=IE/J9FVin4CcLoAyEONvEwPthLpn0G/hjFhibTmYpUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2rBS8WHZUH+Q9/ks70mcgKeswibxInVZJTiqe0i8rMniBjIVzCkh6UT2Im+zD40mrcp6I/X1pZJzBXCRW8Fz0TYQUxwTc4L6niC986M1+7PSe0Xui0KhampGl4dPzDkwbyBaIbzHq1lS4wRVIpx1wttPaDLRaWK9iTMS5ESHiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5yPE6Bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5yPE6Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC87C2BD10;
	Tue, 14 May 2024 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686969;
	bh=IE/J9FVin4CcLoAyEONvEwPthLpn0G/hjFhibTmYpUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5yPE6BmlAXw44poRlPygS+5Tzc2ZdipQfnpNzRQD+p0N0hp5ZyiedBp28Y5gyS4u
	 MQtkhhwOacyGqg0ADaTL9lInvexfx6k2x7Dl5WSvxJQMkngMhPqkYHbp1BXOECjnaW
	 6R9xCz60fgFkLzo1JZ+92r4+kbQB/7mK8Y9JpEsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/84] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:19:31 +0200
Message-ID: <20240514100952.454929224@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 843c3280686fc1a83d89ee1e0b5599c9f6b09d0c ]

The function __storage_key_init_range() expects the end address to be
the first byte outside the range to be initialized. I.e. end - start
should be the size of the area to be initialized.

The current code works because __storage_key_init_range() will still loop
over every page in the range, but it is slower than using sske_frame().

Fixes: 964c2c05c9f3 ("s390/mm: Clear huge page storage keys on enable_skey")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416114220.28489-2-imbrenda@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 19ee8355b2a7f..5c41d1ab2a622 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2610,7 +2610,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 		return 0;
 
 	start = pmd_val(*pmd) & HPAGE_MASK;
-	end = start + HPAGE_SIZE - 1;
+	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
 	cond_resched();
-- 
2.43.0



