Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C669D8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3AC433D2;
	Fri, 10 Mar 2023 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459882;
	bh=xOfLYrUwnhjqFGSOp/Z2XcHDuojyZGYC1T8pAK3avx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0jGd2uf10IsqmexoOSi27s7XHwxQeXTPqr1bgBEppuQY8vJBP5kJiBf+TTmIT4mG
	 jIIkamY+Bp0e/hJZVXF4bqwrabyi6+BwiHrNqwvkmvKcYwOwlNsKwMaZAQjhyMv9x0
	 syU8jrJxbUb3QGoyHqFNfeoLxr7+RQMXB2bh/umI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/529] s390/vmem: fix empty page tables cleanup under KASAN
Date: Fri, 10 Mar 2023 14:34:24 +0100
Message-Id: <20230310133810.581992134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 108303b0a2d27cb14eed565e33e64ad9eefe5d7e ]

Commit b9ff81003cf1 ("s390/vmem: cleanup empty page tables") introduced
empty page tables cleanup in vmem code, but when the kernel is built
with KASAN enabled the code has no effect due to wrong KASAN shadow
memory intersection condition, which effectively ignores any memory
range below KASAN shadow. Fix intersection condition to make code
work as anticipated.

Fixes: b9ff81003cf1 ("s390/vmem: cleanup empty page tables")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/vmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index b239f2ba93b09..cbfff2460e58d 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -296,7 +296,7 @@ static void try_free_pmd_table(pud_t *pud, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 	pmd = pmd_offset(pud, start);
@@ -371,7 +371,7 @@ static void try_free_pud_table(p4d_t *p4d, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
@@ -425,7 +425,7 @@ static void try_free_p4d_table(pgd_t *pgd, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
-- 
2.39.2



