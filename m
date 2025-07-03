Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1359715442C;
	Thu,  3 Jul 2025 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556309; cv=none; b=mNZeRkWIpLX2y/+HRqB0ex8Umwu4qXP2pPb6W0xYiqGU31Rov365/IxTrCo8UELPcXlLrcoR33mpBxwPt1xAsY22mQBQcTPn4jI5LeQYGvzdknEhlVKFL1M4d7gyW6mPG/bghdgbPc81nI7Y9w1/bcQ+V6S5Luu2CpQl0JGXHzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556309; c=relaxed/simple;
	bh=ROkcBbG8frlwnAFEjcHqozes5VWSbEsbMls1iCth7w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrjZxkOV2QqcgM4PlesBGP4BrLAwXLaKXLm5jziHUyQWqTDkrHPZpEGgMzUpDVm4ffC2BkKNC2V4jXcAMqrgqtvFWl3SIge8ksDc14o2C/q64NziHsgvKItjc4IWTZ0ySTVg4HND5LzBpxwb4nibAQZIoEdxzXLqZtTqv9V01Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igxeeWZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igxeeWZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9243CC4CEE3;
	Thu,  3 Jul 2025 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556309;
	bh=ROkcBbG8frlwnAFEjcHqozes5VWSbEsbMls1iCth7w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igxeeWZgIjs9NK4WMzoI3dGJ1LE2JPTyx/XggqcMnC7g4oxCxrvv6/mtbAsGdGRiH
	 JbFJjIpzOlCyrtLGAh4oZU9HZUfPaINWmi4+jvam8YiwZ4KUqm2DlEpkJasoZjRZlk
	 ky4SEbU65Xq0tFJ+KS3LussUFgnwJE6ZdBX4gEmg=
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
Subject: [PATCH 6.1 132/132] arm64: Restrict pagetable teardown to avoid false warning
Date: Thu,  3 Jul 2025 16:43:41 +0200
Message-ID: <20250703143944.565513090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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
@@ -1503,7 +1503,8 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
-		pmd_free_pte_page(pmdp, next);
+		if (pmd_present(READ_ONCE(*pmdp)))
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
 	pud_clear(pudp);


