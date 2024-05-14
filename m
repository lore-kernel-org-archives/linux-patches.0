Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F579136672;
	Tue, 14 May 2024 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684473; cv=none; b=a82okO6jhXnwhX0aRnqxlGHPM/g7kUQBT108LcVpA9RWWuOJXpN2r/kzvuFoP3jM3vlr4fErp0RkDNnrGXtN2chAJfrjwzxTp1vV4appIdP1IiydM7RJNdgxwXF6jwln/FHjW8JsPdFVlteL74X+2blOXuQ3bteAA9/JP+RnDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684473; c=relaxed/simple;
	bh=Wnns6ZtlInXk9DF6KLfRv8uXSc1jlESdWy6GdUHZd+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0XParpyKlSQt3AaVyisDbGI+Ix9Hkjfa9X0czY1FBhNvqgvs4r0Msrd6Fi3CqC+aPfUJ8AngLJBUu91Z22esYnai2+OAJXyhtZSmcBxiHuVgAgxNiSeZrOE+P3bP5Sp8osPrIbU8qn4HOGv0ji1D+2VyzxgGdGGJSSmBAomfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyj1xe1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyj1xe1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E844CC2BD10;
	Tue, 14 May 2024 11:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684473;
	bh=Wnns6ZtlInXk9DF6KLfRv8uXSc1jlESdWy6GdUHZd+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyj1xe1mPHVv2ql899wzAL2hqZqmB+pKup3ywUG65oyEcLCAXfeS7TuCEieJxN1xp
	 weWUuT/YbbX5HJEf80MC8FZfQWpj6QWvXA9dPHZxIHLBu225vT0zBIKyu0Q/bkeZ8f
	 pJ4NTpoTxmYZtkrqFOLJod/WpC3mpsyYkKNP6RCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/301] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:15:17 +0200
Message-ID: <20240514101033.983999137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d17bb1ef63f41..0da54dc9430a9 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2659,7 +2659,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 		return 0;
 
 	start = pmd_val(*pmd) & HPAGE_MASK;
-	end = start + HPAGE_SIZE - 1;
+	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
 	cond_resched();
-- 
2.43.0



