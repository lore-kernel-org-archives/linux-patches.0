Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD9B79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3059BC433D6;
	Wed, 30 Nov 2022 18:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834345;
	bh=Nz9t804Z8KVza1onBzkxTjVAQKeC4hX8okkIBB5RfnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onFsVoifVbycRUGV//ijlwfMA+6v46U0YOornTvLSwPUgsUAbJol4wEVMorD7HmXT
	 +7qbki8p7KPWad4tu+ZQAgoGFqDk0EbpK02+yd0WgA6bjrAf8aDsI8C9pwsBtz31Pr
	 5YU+JoOY46/mZhCM0XU4zWaf0XO3vv+suWwBy51I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.0 219/289] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()
Date: Wed, 30 Nov 2022 19:23:24 +0100
Message-Id: <20221130180549.083464983@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit bf2f34a506e66e2979de6b17c337c5d4b25b4d2c upstream.

Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this causes
random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
over dirty bit when thp splits on pmd").

The reason is: when fork(), parent process use pmd_wrprotect() to clear
huge page's _PAGE_WRITE and _PAGE_DIRTY (for COW); then pte_mkdirty() set
_PAGE_DIRTY as well as _PAGE_MODIFIED while splitting dirty huge pages;
once _PAGE_DIRTY is set, there will be no tlb modify exception so the COW
machanism fails; and at last memory corruption occurred between parent
and child processes.

So, we should set _PAGE_DIRTY only when _PAGE_WRITE is set in {pmd,pte}_
mkdirty().

Cc: stable@vger.kernel.org
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -349,7 +349,9 @@ static inline pte_t pte_mkclean(pte_t pt
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	pte_val(pte) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
+	pte_val(pte) |= _PAGE_MODIFIED;
+	if (pte_val(pte) & _PAGE_WRITE)
+		pte_val(pte) |= _PAGE_DIRTY;
 	return pte;
 }
 
@@ -475,7 +477,9 @@ static inline pmd_t pmd_mkclean(pmd_t pm
 
 static inline pmd_t pmd_mkdirty(pmd_t pmd)
 {
-	pmd_val(pmd) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
+	pmd_val(pmd) |= _PAGE_MODIFIED;
+	if (pmd_val(pmd) & _PAGE_WRITE)
+		pmd_val(pmd) |= _PAGE_DIRTY;
 	return pmd;
 }
 


