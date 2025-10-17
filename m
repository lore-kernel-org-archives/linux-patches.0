Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CC2330B03;
	Fri, 17 Oct 2025 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715548; cv=none; b=gh6Qh6mV50gpAp3hGBspZBTUesBp0caOUC6NKMm757z/k/YSUzsGxrhW+9VAaRzA/N4jyQESJ8xnVrfbhbwKe+FIysemFWr413ZUthAGuOuhmBXpFxzAX0VL+Utouuel0hvMvhaZrMhAsyoFpP1OG7bjSwV6szJD3/iwzNQBafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715548; c=relaxed/simple;
	bh=K3DWd1bPHL7Zt4lI1IldnI3/Qpm4NofqyWP6TtcJwQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV2oXH1rnmw92Pm/ySQNUy1SuuzGP9g2pcO2y9qFE0V8/E6UweNk+KUFKgQSR7wRhFO60eK027og9+MVZjM7FX4bhiqeb3+QpHR0VRvXBEvTTG9ZIrXR0lGj/k79JpmGORNSKaChI/CaYS9hLU58l01Y71a3BKLDJwg3TWT+NzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTzB2wLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTzB2wLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DF3C4CEE7;
	Fri, 17 Oct 2025 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715547;
	bh=K3DWd1bPHL7Zt4lI1IldnI3/Qpm4NofqyWP6TtcJwQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTzB2wLDPAKKEKu3uIxCfOgk/oTrKNkksi4xN7VUflOoMl8cwl+VzTY/oC4iBeb+b
	 YWii18VpcA8+RNyaa6gCA+90WNQ9Mz9SMipNiOiDDlxBCBtN9MpxV7J16WHkI34ehz
	 thaSvziKSXbbFagJYh2Z5Hp9iTRUbzJ3hkBCw4dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 254/371] riscv: use an atomic xchg in pudp_huge_get_and_clear()
Date: Fri, 17 Oct 2025 16:53:49 +0200
Message-ID: <20251017145211.272190287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit 668208b161a0b679427e7d0f34c0a65fd7d23979 upstream.

Make sure we return the right pud value and not a value that could have
been overwritten in between by a different core.

Link: https://lkml.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com
Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -959,6 +959,17 @@ static inline pud_t pudp_huge_get_and_cl
 	return pud;
 }
 
+#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address, pud_t *pudp)
+{
+	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
+
+	page_table_check_pud_clear(mm, pud);
+
+	return pud;
+}
+
 static inline int pud_young(pud_t pud)
 {
 	return pte_young(pud_pte(pud));


