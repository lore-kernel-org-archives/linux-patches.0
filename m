Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6316349AF7;
	Fri, 21 Nov 2025 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733439; cv=none; b=OP8QByzQ+zZWn7Qd9mbk+/HM3f1oBKYIPkx2/xsqBvXL+xLuYhGY20z/SfYtE0w2FcSNjbqn6rheCbrsT1bW8q3keuqBA/I7HPyVucpmrtBnJNH4M5hbZQgku2EfpQJfTXzSWn8a93qwjyq1LXkLz1tzJ5PXXnfMs6C7z2znhF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733439; c=relaxed/simple;
	bh=BUGhI/q2XTyMML8q6BX6aFGnEsm2CqeVXKsq4ZKD7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIz9Jo42SCIBTO4vdfgDRyEABQtVpg1r0v5yPCquasEk8Qo+ed+b3XKRgJ+HnVad+EROrxCbJJKmlA4IXs49p0v/gma5l4WTO4m1s7d7FJyukuzMT41C85aaZMIGX9CeorjpvB+wY1oDQwqBOPIylUugeW8Ww6Q23AL7oncLV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXmBtIti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXmBtIti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F264EC4CEF1;
	Fri, 21 Nov 2025 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733439;
	bh=BUGhI/q2XTyMML8q6BX6aFGnEsm2CqeVXKsq4ZKD7cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXmBtItib4PDcn4QkB6wsGr0Ig9curzQJEaJfpVWKJ43EUH0cLu1IWAFmIMEoLiJD
	 eVggVntQV8Q0HU84ha+k4DRIE0LdEjHJiVJe1N9upxDzS5SQwqJK95lFKyG/8Q+4sa
	 BfD/ZIhWtLn3wmf31DbqyyAb5yWyRW4pzusryRbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liupu Wang <wangliupu@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: [PATCH 6.6 469/529] LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY
Date: Fri, 21 Nov 2025 14:12:48 +0100
Message-ID: <20251121130247.697858281@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tianyang Zhang <zhangtianyang@loongson.cn>

commit a073d637c8cfbfbab39b7272226a3fbf3b887580 upstream.

Now if the PTE/PMD is dirty with _PAGE_DIRTY but without _PAGE_MODIFIED,
after {pte,pmd}_modify() we lose _PAGE_DIRTY, then {pte,pmd}_dirty()
return false and lead to data loss. This can happen in certain scenarios
such as HW PTW doesn't set _PAGE_MODIFIED automatically, so here we need
_PAGE_MODIFIED to record the dirty status (_PAGE_DIRTY).

The new modification involves checking whether the original PTE/PMD has
the _PAGE_DIRTY flag. If it exists, the _PAGE_MODIFIED bit is also set,
ensuring that the {pte,pmd}_dirty() interface can always return accurate
information.

Cc: stable@vger.kernel.org
Co-developed-by: Liupu Wang <wangliupu@loongson.cn>
Signed-off-by: Liupu Wang <wangliupu@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -448,6 +448,9 @@ static inline unsigned long pte_accessib
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
+	if (pte_val(pte) & _PAGE_DIRTY)
+		pte_val(pte) |= _PAGE_MODIFIED;
+
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) |
 		     (pgprot_val(newprot) & ~_PAGE_CHG_MASK));
 }
@@ -570,9 +573,11 @@ static inline struct page *pmd_page(pmd_
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
-	pmd_val(pmd) = (pmd_val(pmd) & _HPAGE_CHG_MASK) |
-				(pgprot_val(newprot) & ~_HPAGE_CHG_MASK);
-	return pmd;
+	if (pmd_val(pmd) & _PAGE_DIRTY)
+		pmd_val(pmd) |= _PAGE_MODIFIED;
+
+	return __pmd((pmd_val(pmd) & _HPAGE_CHG_MASK) |
+		     (pgprot_val(newprot) & ~_HPAGE_CHG_MASK));
 }
 
 static inline pmd_t pmd_mkinvalid(pmd_t pmd)


