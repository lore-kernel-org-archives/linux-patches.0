Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEF3307D;
	Fri, 24 Nov 2023 19:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl15H0CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CAAC433C8;
	Fri, 24 Nov 2023 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853515;
	bh=+XHqD6FsTEoBEthyNcHUR8aDsw08YPJWnQLYfBsfCJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vl15H0CCjW4OfuZ+ac5j1aAkotP8vhucCCBK8KvCT9/Qp+zZ0pUNW4Ddvuwkj1J8a
	 ke1JwUeuMCdNJ//uk+y9CxLz2fVnEl4I1cmz7nnAikYrGcP7WPq9AWMxfg8crw7a86
	 ws2tF0ODz7dx8HtLhexw4w3wz4V28SJ8w4heJ/M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 220/297] s390/cmma: fix detection of DAT pages
Date: Fri, 24 Nov 2023 17:54:22 +0000
Message-ID: <20231124172007.915820418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 44d93045247661acbd50b1629e62f415f2747577 upstream.

If the cmma no-dat feature is available the kernel page tables are walked
to identify and mark all pages which are used for address translation (all
region, segment, and page tables). In a subsequent loop all other pages are
marked as "no-dat" pages with the ESSA instruction.

This information is visible to the hypervisor, so that the hypervisor can
optimize purging of guest TLB entries. The initial loop however is
incorrect: only the first three of the four pages which belong to segment
and region tables will be marked as being used for DAT. The last page is
incorrectly marked as no-dat.

This can result in incorrect guest TLB flushes.

Fix this by simply marking all four pages.

Cc: <stable@vger.kernel.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/page-states.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -131,7 +131,7 @@ static void mark_kernel_pud(p4d_t *p4d,
 			continue;
 		if (!pud_folded(*pud)) {
 			page = phys_to_page(pud_val(*pud));
-			for (i = 0; i < 3; i++)
+			for (i = 0; i < 4; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
 		mark_kernel_pmd(pud, addr, next);
@@ -152,7 +152,7 @@ static void mark_kernel_p4d(pgd_t *pgd,
 			continue;
 		if (!p4d_folded(*p4d)) {
 			page = phys_to_page(p4d_val(*p4d));
-			for (i = 0; i < 3; i++)
+			for (i = 0; i < 4; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
 		mark_kernel_pud(p4d, addr, next);
@@ -181,7 +181,7 @@ static void mark_kernel_pgd(void)
 			continue;
 		if (!pgd_folded(*pgd)) {
 			page = phys_to_page(pgd_val(*pgd));
-			for (i = 0; i < 3; i++)
+			for (i = 0; i < 4; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
 		mark_kernel_p4d(pgd, addr, next);


