Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289C12F39B;
	Tue, 14 May 2024 11:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686757; cv=none; b=dj3l2qTkXVCPgCAAHtg+qZUjcDxSrG6SkmmxnEixdBHgzytf6BqsHbj6iEnviluFcr0aiW2hk9DfN5LRAF2p63zHYGCoUuekE+G3CMSvcc0vPJCR21A/ptK2dTZXzjTDWa1pQ6UOLTGYCWaHFnZXYTRUOxM0eLQ2IORTxoOUriE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686757; c=relaxed/simple;
	bh=gddW+gbe5YKl44H5DgRpozB8aJJ35FpATZ68qVzxIX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqqjpXIU6BIvdK70wrTgTWZrink3eqgCkrMG1NigePNKEdjPXINbPlQIsoA2jeuB2rNwIKTMmRiK7t2rSStuIhZ5PyMbQ6p0IW5389K8AQxArJeFhipG8Nc5XcSar+K5+JqpStxcNRNnpAYtl0dBr1TVyUUIE3Pkn61qU3tK1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idvN2zZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idvN2zZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC81C32782;
	Tue, 14 May 2024 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686757;
	bh=gddW+gbe5YKl44H5DgRpozB8aJJ35FpATZ68qVzxIX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idvN2zZWzkUThO+v1aVivzhWGFO75t9/XZJEHg1MghAgwwGi5Kj78G/e7+Vmw5dfC
	 n4PtcdVvuc44kA+l6PTv0BpHEVvHI+KmY+p7r8YuSwqGD1oiYKBMBKAg2Ljkt5BrZ6
	 Z2MuwqJrsVKTOl1w7utwH62S4Zs7auSIKNwApNTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/63] s390/mm: Fix storage key clearing for guest huge pages
Date: Tue, 14 May 2024 12:19:33 +0200
Message-ID: <20240514100948.478314118@linuxfoundation.org>
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
index 65ccb9d797270..3c1217d341099 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2583,7 +2583,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 		return 0;
 
 	start = pmd_val(*pmd) & HPAGE_MASK;
-	end = start + HPAGE_SIZE - 1;
+	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
 	return 0;
-- 
2.43.0



