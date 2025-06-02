Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2223644F;
	Mon,  2 Jun 2025 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876814; cv=none; b=E/yfBsnRkUvcxnMoRvKpqqkOJFMhzhkpOiAjkdzreUK98qcLdtpp8xVsj5TT1Gk6qzL+vSDCjRCPed7jgbjzmmfix8yfkaB1Eh8etOn5+cBr1qMpT0K6hfnj+ajQX5TDvxBhyn43oNzm7vrT5QAIU2p5hCmY85EtzC8Xq6Y9olk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876814; c=relaxed/simple;
	bh=cY2ny3TSupB+xy+obsMLXMCKNtWfGtp62MypO7UTF0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkuxZ3p/rvIAkWNXGJP+Bke/4c1ldZ7/iJIUvlFav+L3Pb38xdT168FNcW2KTWWEDQ92kFlb7b7JcifNJIB6DHjwQ/I5gKuWFxl96XUIaiYsw+I1MZtDur+mVW8hgegmp7eja04KQOPQ3F0pDzaq/n9wNFhbNJCqrtLPwqYWeWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL1CpPzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL1CpPzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E61C4CEEB;
	Mon,  2 Jun 2025 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876813;
	bh=cY2ny3TSupB+xy+obsMLXMCKNtWfGtp62MypO7UTF0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL1CpPzFkinb2vRs2lb9aNLUS8R5BWAk6QOu/HPTi2ezamgScZ99Xe3tlj3f53x5D
	 7q88f955Pc6r7+97lziIlnECFfpg9ynt5gWhWYe9rctStADHwlZsqBP3pQAkFnlePA
	 uIWjrNPTyvHhQ7Ie9OyUpx31p3Uxyp0wThznWk8A=
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
Subject: [PATCH 6.1 083/325] arm64/mm: Check PUD_TYPE_TABLE in pud_bad()
Date: Mon,  2 Jun 2025 15:45:59 +0200
Message-ID: <20250602134323.154358758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d713cfb0af16..426c3cb3e3bb1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -677,7 +677,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
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



