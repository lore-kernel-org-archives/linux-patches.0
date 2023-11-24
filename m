Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929C39FE8;
	Fri, 24 Nov 2023 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdOUYCap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64679C433C7;
	Fri, 24 Nov 2023 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849990;
	bh=mNuqoWVMZ661f5MuBfpoamWo5HN+gUmlBPunnqVmB08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdOUYCapA791VpQQNLsks7DLEm8HLV8trYxenMLJFXUNDxa/OeHzK15/9lGp70J7T
	 I67+7JFgcGoMWbEyjOHPFUjSPhsXxpZqNHFdScYqYfpS10+gs5FMHTyh+OzdVyeun+
	 y0Gx+2iEd9dXVQbUAxARQ/5nveFEkMjH22jbDChw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 377/530] s390/cmma: fix initial kernel address space page table walk
Date: Fri, 24 Nov 2023 17:49:03 +0000
Message-ID: <20231124172039.486929745@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 16ba44826a04834d3eeeda4b731c2ea3481062b7 upstream.

If the cmma no-dat feature is available the kernel page tables are walked
to identify and mark all pages which are used for address translation (all
region, segment, and page tables). In a subsequent loop all other pages are
marked as "no-dat" pages with the ESSA instruction.

This information is visible to the hypervisor, so that the hypervisor can
optimize purging of guest TLB entries. The initial loop however does not
cover the complete kernel address space. This can result in pages being
marked as not being used for dynamic address translation, even though they
are. In turn guest TLB entries incorrectly may not be purged.

Fix this by adjusting the end address of the kernel address range being
walked.

Cc: <stable@vger.kernel.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/page-states.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -151,15 +151,22 @@ static void mark_kernel_p4d(pgd_t *pgd,
 
 static void mark_kernel_pgd(void)
 {
-	unsigned long addr, next;
+	unsigned long addr, next, max_addr;
 	struct page *page;
 	pgd_t *pgd;
 	int i;
 
 	addr = 0;
+	/*
+	 * Figure out maximum virtual address accessible with the
+	 * kernel ASCE. This is required to keep the page table walker
+	 * from accessing non-existent entries.
+	 */
+	max_addr = (S390_lowcore.kernel_asce.val & _ASCE_TYPE_MASK) >> 2;
+	max_addr = 1UL << (max_addr * 11 + 31);
 	pgd = pgd_offset_k(addr);
 	do {
-		next = pgd_addr_end(addr, MODULES_END);
+		next = pgd_addr_end(addr, max_addr);
 		if (pgd_none(*pgd))
 			continue;
 		if (!pgd_folded(*pgd)) {
@@ -168,7 +175,7 @@ static void mark_kernel_pgd(void)
 				set_bit(PG_arch_1, &page[i].flags);
 		}
 		mark_kernel_p4d(pgd, addr, next);
-	} while (pgd++, addr = next, addr != MODULES_END);
+	} while (pgd++, addr = next, addr != max_addr);
 }
 
 void __init cmma_init_nodat(void)


