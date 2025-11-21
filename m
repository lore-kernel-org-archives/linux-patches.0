Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D431F03D7;
	Fri, 21 Nov 2025 13:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731900; cv=none; b=KFZZoxXa9gCOLw7NQwffR6ulO8d+Y4SBm0FmVM3X6qqxLVdJI2IXcytXq1wkaDgza1INYZOgcSZs9ZNf/DjDMMDKCcSFuVpZroaHcJiGpgjqlMQ2N9RNavimGbmkcGyHc9cPARvGnuCxS2QtWg+GQ2oWiEd0o8OYiRgq0ljagyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731900; c=relaxed/simple;
	bh=/RcQhcYVJl+BAEKfoRI5mSOTL+SdnqCASzXGqtOJgwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR6/WU2kSxqoHOVTkUsbe8dU28MGJKu6a2tsMa4HHjXNaxM/IbIWpsYY3O/DUpA9edicbD7mZEd1e6b9wIMA5ucex6Z7J11qFyOvFW0lRY40T1Z3SuP1w2kRQYA4XYkn9BCs43q/XaXk/ucE+l3htYcYpZe7hatPRvfpa7eDYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u66ZjnMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u66ZjnMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59223C4CEF1;
	Fri, 21 Nov 2025 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731900;
	bh=/RcQhcYVJl+BAEKfoRI5mSOTL+SdnqCASzXGqtOJgwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u66ZjnMhMXlTIEi5SVqyP866WiwSqPo5DOMX5qNV0qPi8uyoWQr5C7HPSwz2JGkQ3
	 zVldpM8S1+1BYf2dNdZSQpbDPDeJAXiY/V0EfOIViL2ckOVzL7J5vgfQ+WiQXzttj3
	 fu364BEQOT1fVwYlbriC8AoXhrajP12gQXUs1HrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liupu Wang <wangliupu@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: [PATCH 6.12 119/185] LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY
Date: Fri, 21 Nov 2025 14:12:26 +0100
Message-ID: <20251121130148.169305670@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,6 +431,9 @@ static inline unsigned long pte_accessib
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
+	if (pte_val(pte) & _PAGE_DIRTY)
+		pte_val(pte) |= _PAGE_MODIFIED;
+
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) |
 		     (pgprot_val(newprot) & ~_PAGE_CHG_MASK));
 }
@@ -565,9 +568,11 @@ static inline struct page *pmd_page(pmd_
 
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


