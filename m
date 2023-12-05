Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E5E6FAF;
	Tue,  5 Dec 2023 03:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5BLNqQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA9DC433C8;
	Tue,  5 Dec 2023 03:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746890;
	bh=KYYO21fgxx3h7TXyPuk5q/7TOj/mShQm4cv2BAmXchQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5BLNqQU572JkIHldom6+KGfEhohZWXaeSjYJlQjSNl+tlU2wqI6wDtNR6EAuOd7l
	 PnHha8/nzYjM4y6yQx3BHyL/ZvEUZ/Q2I/yyLn+D6+OJTxegURySNXfFlpzENHTEv4
	 Bu7mnfQWV5uwp+4aDDKTzC9youvmG3K8vDk1sD0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/71] s390/mm: fix phys vs virt confusion in mark_kernel_pXd() functions family
Date: Tue,  5 Dec 2023 12:16:55 +0900
Message-ID: <20231205031521.181116325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 3784231b1e091857bd129fd9658a8b3cedbdcd58 ]

Due to historical reasons mark_kernel_pXd() functions
misuse the notion of physical vs virtual addresses
difference.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 44d930452476 ("s390/cmma: fix detection of DAT pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/page-states.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index dc3cede7f2ec9..5a0460b0fd6ae 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -118,7 +118,7 @@ static void mark_kernel_pmd(pud_t *pud, unsigned long addr, unsigned long end)
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd) || pmd_large(*pmd))
 			continue;
-		page = virt_to_page(pmd_val(*pmd));
+		page = phys_to_page(pmd_val(*pmd));
 		set_bit(PG_arch_1, &page->flags);
 	} while (pmd++, addr = next, addr != end);
 }
@@ -136,7 +136,7 @@ static void mark_kernel_pud(p4d_t *p4d, unsigned long addr, unsigned long end)
 		if (pud_none(*pud) || pud_large(*pud))
 			continue;
 		if (!pud_folded(*pud)) {
-			page = virt_to_page(pud_val(*pud));
+			page = phys_to_page(pud_val(*pud));
 			for (i = 0; i < 3; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
@@ -157,7 +157,7 @@ static void mark_kernel_p4d(pgd_t *pgd, unsigned long addr, unsigned long end)
 		if (p4d_none(*p4d))
 			continue;
 		if (!p4d_folded(*p4d)) {
-			page = virt_to_page(p4d_val(*p4d));
+			page = phys_to_page(p4d_val(*p4d));
 			for (i = 0; i < 3; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
@@ -179,7 +179,7 @@ static void mark_kernel_pgd(void)
 		if (pgd_none(*pgd))
 			continue;
 		if (!pgd_folded(*pgd)) {
-			page = virt_to_page(pgd_val(*pgd));
+			page = phys_to_page(pgd_val(*pgd));
 			for (i = 0; i < 3; i++)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
-- 
2.42.0



