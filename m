Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3FB6136;
	Mon, 23 Jun 2025 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715971; cv=none; b=qZROU9yihDWezgl2dKlrDlStVGo7Fe2N/1XkkJEbqTNHHN0iWzPVAp3p+SnvafaKLzxMiZg+4b4poJvDuDTC/67ck4AxFcmyZXtfSMSAKISVwJwo/yRPUKlWdaM7qn7d2MDCvi/NtIxPpK6NGBL3VGSQjWhixv5/z5q49lZPdDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715971; c=relaxed/simple;
	bh=dTXXHWrYcazqJapTs1bSB9wafvfXS+zUm8b1SrPaqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Auej81lJKjZiZdkKeMPhTKJq0i/YzKOVgGwO0wTDRYz78yo9bK1jjGuSM2UaRkdzweHBz/Mc9e74bj5huQonoxr2lkEkftHDb4iK7UtK2CDhlUcXvduo+Ix0DLw8oz9xU2jtFkGHc790vn5F0MtKiAmzRnFDu2AWUtWR2BObww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrTABY+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrTABY+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D7EC4CEEA;
	Mon, 23 Jun 2025 21:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715970;
	bh=dTXXHWrYcazqJapTs1bSB9wafvfXS+zUm8b1SrPaqF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrTABY+NXZBTX6s0/+38NSMyddNbN7ITyPmtzLEhz107AmR7J5vOWSqHWOqus63rC
	 r3Cl5EK5Rvc0fpSk/e9UoSGIXDCKw7ArXf1ccycP3pKxdps6xgCx2VuEGVmJwoDna6
	 28ZV+VPC73YFxI135thyYZTKfMgJP+4ngq24as38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 232/290] arm64: Restrict pagetable teardown to avoid false warning
Date: Mon, 23 Jun 2025 15:08:13 +0200
Message-ID: <20250623130633.903176177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

commit 650768c512faba8070bf4cfbb28c95eb5cd203f3 upstream.

Commit 9c006972c3fe ("arm64: mmu: drop pXd_present() checks from
pXd_free_pYd_table()") removes the pxd_present() checks because the
caller checks pxd_present(). But, in case of vmap_try_huge_pud(), the
caller only checks pud_present(); pud_free_pmd_page() recurses on each
pmd through pmd_free_pte_page(), wherein the pmd may be none. Thus it is
possible to hit a warning in the latter, since pmd_none => !pmd_table().
Thus, add a pmd_present() check in pud_free_pmd_page().

This problem was found by code inspection.

Fixes: 9c006972c3fe ("arm64: mmu: drop pXd_present() checks from pXd_free_pYd_table()")
Cc: stable@vger.kernel.org
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20250527082633.61073-1-dev.jain@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1253,7 +1253,8 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
-		pmd_free_pte_page(pmdp, next);
+		if (pmd_present(pmdp_get(pmdp)))
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
 	pud_clear(pudp);


