Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181E9239561;
	Mon,  2 Jun 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873446; cv=none; b=FBmZjzEWnswqxhHJ6Ru/nNDR6YXlafxdhecV0EQonh6+KaDkx8G5CmX0Jw+Led62SSWgypx4ZzS93VzI+QYDvv3u0Gj0kGMijPFkiAd+5KjLJEU2S1YkmcLgdSXX9BOQ3SXPVIwIt4vRtyRb5ZAaDHfcPkV8G6pHcYUVc7Q0MdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873446; c=relaxed/simple;
	bh=N8seNeAUl9s8e3bRXZKsnSUPb4UCADG2BvjRH2kJqFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYyMPDCufwSuwPrC7NefXBmvCDWym/vXk+RYhJv+gsFaRC+5iPu+PzxkzvBpq1nKxuhL6bymBZE2alVimPOCHYAOdtWbluP1Q3Mlw2pckzPQGs4mv5ghZexG0X6Mef/rH/mqe1+pneZfbxxdlzEG6Wfnez9NHKrYd8tieKLFFPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMDtW/Pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMDtW/Pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA87C4CEEB;
	Mon,  2 Jun 2025 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873445;
	bh=N8seNeAUl9s8e3bRXZKsnSUPb4UCADG2BvjRH2kJqFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMDtW/PlKkl/W5OSPzhGcOhoOybZZG+R+wCwuyINVGGoaFo5uxzyBUrIKubF9DwYa
	 PcaT+R8cdMXncXCTr5HmNAUsD2szMSAp9Xap9PNdmIYU6e+0b9W3smmmHgtu7qkogT
	 yRBfL0+0hOe/ER6oaG0fymihnoCkrjqEH6rDAMB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/444] arm64/mm: Check PUD_TYPE_TABLE in pud_bad()
Date: Mon,  2 Jun 2025 15:42:58 +0200
Message-ID: <20250602134345.520529719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit bfb1d2b9021c21891427acc86eb848ccedeb274e ]

pud_bad() is currently defined in terms of pud_table(). Although for some
configs, pud_table() is hard-coded to true i.e. when using 64K base pages
or when page table levels are less than 3.

pud_bad() is intended to check that the pud is configured correctly. Hence
let's open-code the same check that the full version of pud_table() uses
into pud_bad(). Then it always performs the check regardless of the config.

Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250221044227.1145393-7-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 07bdf5dd8ebef..0212129b13d07 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -679,7 +679,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	pr_err("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
 
 #define pud_none(pud)		(!pud_val(pud))
-#define pud_bad(pud)		(!pud_table(pud))
+#define pud_bad(pud)		((pud_val(pud) & PUD_TYPE_MASK) != \
+				 PUD_TYPE_TABLE)
 #define pud_present(pud)	pte_present(pud_pte(pud))
 #define pud_leaf(pud)		(pud_present(pud) && !pud_table(pud))
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
-- 
2.39.5



