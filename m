Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B002E3391;
	Tue, 15 Jul 2025 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586409; cv=none; b=V6S39OQD4JkOt8j+L04XwilWWMYW4/2HQcCfGokDSou0qJ2N1vExOh1lrLN/0PhcD/m6PHWDMUWIJ8YczniUAaBxR9rx1tJoGYy/urhD5fxBn7nopbx+8Ol+pYztO32a1CtiPkYN9+DFzS2LazpTtowtrV/4uIHhPxO2EZKcSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586409; c=relaxed/simple;
	bh=iQi5aQp08sYGwvY4eIk0UOK2xRm47q/X86P4v1LLoOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7SnHog5tFnI70+LrGnxUeyHhfLV7B0QLT44j95dZhd3sqlM5cykUbXh1/imS7pPABdR5fhmaGInuonPTzuOQffT7vIq2Cc4frzfdb/QXFHmJB1D3d0K2cCKKXWY0sUwefMlXgxp3xR3CjWr89vBv4JGuv/FdrkxS8M9u/A95pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fsHyzUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fsHyzUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D33C4CEE3;
	Tue, 15 Jul 2025 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586409;
	bh=iQi5aQp08sYGwvY4eIk0UOK2xRm47q/X86P4v1LLoOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fsHyzUJlsf+P6lhNbkCYbESxxQ/JpoOcpiq5SG6+P02Sx62VJBtJsWsQ1uaR2dlV
	 +s3GiL74O4ZZdCiQOkjiC/WtcGd58FoS66OrndoINGdAjN22QhU9ELW2YJpDvgPPLV
	 y4gqV1WC1idqXDdjDaGQmEyhOXHUEw9WH6CYZSpc=
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
Subject: [PATCH 5.4 054/148] arm64: Restrict pagetable teardown to avoid false warning
Date: Tue, 15 Jul 2025 15:12:56 +0200
Message-ID: <20250715130802.490153148@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1041,7 +1041,8 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
-		pmd_free_pte_page(pmdp, next);
+		if (pmd_present(READ_ONCE(*pmdp)))
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
 	pud_clear(pudp);


