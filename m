Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC970433BE;
	Tue, 14 May 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682274; cv=none; b=PvyUICYBpKObgBy+5DkZHqPmI1qhHBFIa2Jn7XUp/Sz5eWTlCx6qcbgPsH0R+LSBYHTEQxl2KY0VlMSZFJjzZT1WOPjqmfJRqKVfDP4+4ce6b4D/HC/yyTVwISDzgcAHykcrOpJ1V3MbSvc17aywNTI4t2UrDE3e5HF7+qCBo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682274; c=relaxed/simple;
	bh=KvKN2+tzcLEM5tEfwyVw8Gw2KjbyVthQbfX4iUSiv0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdnjDrCgY9pEKexwIP8Z9vCzDizNtWvlt/5IJ8vlPtXj6yuKXscPKoPrUrZ9xX+W0RwqYwXQD+0S1tqJp8LFioWL03NeZVuF6OwDG/hcvqf7uCYnJHBLmgCfOn58v/DZFjBGpnXvLF/2Loktvu+3VmjvSiXQk4gBMC3Cf1/ShDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzS4r7Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzS4r7Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284A9C2BD10;
	Tue, 14 May 2024 10:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682274;
	bh=KvKN2+tzcLEM5tEfwyVw8Gw2KjbyVthQbfX4iUSiv0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzS4r7Ghn5iwziri570n93oLrj/HdtksZXcxBYGAAzCCmTQs+H8qQ77sO+/POQC6N
	 FMaLzte9n8EdZ7MVveVAIKuDCxSliU52JRbkymehm9yyOPq+jySv/xGIR3fW/On5i4
	 nHLyAWrHqMEqwZL9QDnvluo7nWeVx80X5C1QhCDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 038/336] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:14:02 +0200
Message-ID: <20240514101040.047089059@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 08a7eca03daf7..41a4a60c5e651 100644
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



