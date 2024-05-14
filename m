Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AF12FB08;
	Tue, 14 May 2024 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686197; cv=none; b=bsXno0DkDpoHumuOGG6PCBounV01hZObKX36LpqBmJFqfSlfQ8WeaLi781W+BUY7pWhq0WNvK8HDDrp+ab6demzjblkOZUiMgGDyAwibk5Sa3qbyMh6vZL8vn453URAjvWDeKu1vNgXDGdjCOYT27H5qx34JTM8V2JxYUGgCbLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686197; c=relaxed/simple;
	bh=dPxV57ca2ctIhLx/DeJNvp6t9fs9C53weCfPPMHSNXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn2rEmfo/tEi0EUTfWd7Wuhj8tLZYYmYqIWaDJxs3gXxuCMY2ec3cDBTsjbFOGifKLwYn8pKu8h4BTIe2NP0/lZRGjwEvnhaHwBg3VV44q9WJegtkvbmLEZ6NThloViBg35McpQ3TDsc9Iz89EmUXk+rbIzPaz1rqOuhJ6aQltE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6xflSzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6xflSzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A932CC2BD10;
	Tue, 14 May 2024 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686197;
	bh=dPxV57ca2ctIhLx/DeJNvp6t9fs9C53weCfPPMHSNXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6xflSzYnEWJjF9K+P8MKt0c+0HdLUf81R15JkMSc8B2AkEHhRRbqOvIBKSlKuqQ7
	 83LOo2itVE5Ei+6aO8shBxDfidTdwUSQOdJX0eg3+jOm/hyTvvwZ1qSECv54STmmg5
	 WTWfseiUwRloHKWIjrEvlmGvZ/cNz7r2lwvvm7G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/236] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:16:57 +0200
Message-ID: <20240514101022.436410405@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 662cf23a1b44b..59657e0363e7c 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2642,7 +2642,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 		return 0;
 
 	start = pmd_val(*pmd) & HPAGE_MASK;
-	end = start + HPAGE_SIZE - 1;
+	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
 	cond_resched();
-- 
2.43.0



