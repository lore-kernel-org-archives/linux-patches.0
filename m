Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EC825B1D2;
	Wed,  3 Dec 2025 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779915; cv=none; b=k4X2dDlMtrZuV7QOMYz7kYENWCBH7frg7ngKAD66DVAlX4zFcFU0zEDoATlT/gE6LZzMG8von6GdHxw4NEbIvYMTo5/HAsAqsjeGOZMX4n9rIIlPVwji0/iTZ2Az8/wKo3vYISJI/BA5jzrcMQKycSIc9yXogvx6WJMD8VBF8Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779915; c=relaxed/simple;
	bh=ZLKOlpAYaDo6CywAo495aGUNXV7fK4JhNrvI9kU/nZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEpt1iYM6F0DPxrMQ6B/53RYUD93Ukfj3WQhwCfEyFQH2LcWo1VfX55WbRrFI04OU0efw6ajwU3bpUqDAgKizJv8U/cOLgQ0K7ElI6DpDpUeVZ/QDlUg9BLLgBefjvoHSFEplop/ZA9ec3j1n8yyXzQ1+GlhtlcYyebNwB/IbeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX26w8JB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX26w8JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E980C4CEF5;
	Wed,  3 Dec 2025 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779914;
	bh=ZLKOlpAYaDo6CywAo495aGUNXV7fK4JhNrvI9kU/nZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IX26w8JBgboexmFv7fRupQyzwEhYgnDM0vVPHvqkfaASwJLFOv0lYRztNhAvrk+1j
	 Dbuq8SdRP5PiVgIjLNJ3rZarxK+ueZTWVEtPsEpAhgqe4fbLB8kS+Rz3Pm7Ro7OL6B
	 5dE+oWQ1EN7ZVSV4aSmMy8sCO761up1jUTXArQpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liupu Wang <wangliupu@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: [PATCH 6.1 401/568] LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY
Date: Wed,  3 Dec 2025 16:26:43 +0100
Message-ID: <20251203152455.377838371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,6 +403,9 @@ static inline unsigned long pte_accessib
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
+	if (pte_val(pte) & _PAGE_DIRTY)
+		pte_val(pte) |= _PAGE_MODIFIED;
+
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) |
 		     (pgprot_val(newprot) & ~_PAGE_CHG_MASK));
 }
@@ -516,9 +519,11 @@ static inline struct page *pmd_page(pmd_
 
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


