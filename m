Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E681CFB2;
	Tue, 14 May 2024 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687566; cv=none; b=hjlDLX9V63lI1bFm9zbDZkK2Sgw8tBfbIo9ohWVQ1OHUZsv+vqPu0+HynjYa0UeORRg3Akmj/Gh7Bjm1TzzAJvyPDjPEyUDmffy7pxxzNVvtCi5SHo00Pnz8xyKmncuxknQyuBEZ6GHn80IWB1Y4GoUOhXX0Do/77aF0SY8fqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687566; c=relaxed/simple;
	bh=+yqKCUNrcGMSxZ9g2BBNVQ1L6m+ag7RoI308HbrGbDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKd+iBHNshdZtfSCFjIfG2ZhJRgu7K0B8Krku5TlZpWGbHvZsUZWL7zLM+IjDYAFTEg2xr06W7+X26YEA1+KdfNq0MByH7i/zBb/sqSyCjc0lctHHNosavB5E7kF5wIGajO4kmqSL3femxiQEfLkhQUSjqSgAmGVsr9gmT5Jl3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OOh+9/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OOh+9/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE4AC2BD10;
	Tue, 14 May 2024 11:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687566;
	bh=+yqKCUNrcGMSxZ9g2BBNVQ1L6m+ag7RoI308HbrGbDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OOh+9/RiZL/IBjz0vvG7uQYiuHzhuPkvcOQ7kkM1s7RmjilyztqsGx3Jh1RmuTE9
	 LqCYK90Y7gcWtCx0YgLplOKPmSFzP7loGrwXR5EqEV+42mQ8/AN7qdSt1pXQbuH+pS
	 PZlf0JYiX6fUfNDP+NAssYTZIb36gFOjFlCnSg2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/168] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:18:46 +0200
Message-ID: <20240514101007.753123526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2c872de29a66..32d9db5e6f53c 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2632,7 +2632,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 		return 0;
 
 	start = pmd_val(*pmd) & HPAGE_MASK;
-	end = start + HPAGE_SIZE - 1;
+	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
 	cond_resched();
-- 
2.43.0



