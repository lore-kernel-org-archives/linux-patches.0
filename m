Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA3612F39B;
	Tue, 14 May 2024 11:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686760; cv=none; b=WPoiB5pa5Gh+LUqCLaOTikeWxK/t9rC5duamsAoysYPudBJj0HXYIbj8RN9s5UCATslIHd0rk1n+rhA/8TdRzG2jVv8YrrASea8boDAx7G9KMXfPpdKCqEphwHp9SROnGAOeaCnIX6CYy/hl5W/beGTtBZI9bSQIwunUOaJN3go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686760; c=relaxed/simple;
	bh=Oez+cHUfymA/iX5+51K6buopXIhP69WxQjqE/5yBa5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbFO8zBdypyIFrraiuZ+dBgplHXf7LhzbKK050QMv8PFCPoz3u1yf5SLntNvD2p+fmMczPNaEejUGoUZptZFzJTyv6bcCh26nKtbt5diq33qo3eznOUxiSX9W8VeLHoRPVhJ04o3pOpkb/Efoo4sfFQNK+4VBeQK4mMqZoFJIuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJgrr696; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJgrr696"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82FCC2BD10;
	Tue, 14 May 2024 11:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686760;
	bh=Oez+cHUfymA/iX5+51K6buopXIhP69WxQjqE/5yBa5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJgrr696/uiiTX+CQtVZRo1dWE3ZcrUfz2RC7ZC8rab7lFb6xB7S1HYM681iEOalk
	 MLjJ6VdncUQeBQWF0hnD3WZunOx1Oaq7QXSHbHCPBtkn0B+PCSI5DY6KHoo6q4FACi
	 oqUbBIs7zvpqJOZMV+dTumYgafe02xZW3YU+VcmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/63] s390/mm: Fix clearing storage keys for huge pages
Date: Tue, 14 May 2024 12:19:34 +0200
Message-ID: <20240514100948.516058307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 412050af2ea39407fe43324b0be4ab641530ce88 ]

The function __storage_key_init_range() expects the end address to be
the first byte outside the range to be initialized. I.e. end - start
should be the size of the area to be initialized.

The current code works because __storage_key_init_range() will still loop
over every page in the range, but it is slower than using sske_frame().

Fixes: 3afdfca69870 ("s390/mm: Clear skeys for newly mapped huge guest pmds")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416114220.28489-3-imbrenda@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index ff8234bca56cd..6b688e3498c01 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -146,7 +146,7 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 	}
 
 	if (!test_and_set_bit(PG_arch_1, &page->flags))
-		__storage_key_init_range(paddr, paddr + size - 1);
+		__storage_key_init_range(paddr, paddr + size);
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-- 
2.43.0



