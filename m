Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39CF16D9BF;
	Mon, 23 Jun 2025 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717150; cv=none; b=cbzF9U+2rWse6wx604oNfrpn6C1UWJ7M5Mhmms0tTx8Gdoxy5zvtrO9I+zKv+uHE7Ha+lNIDv7MyWSuWqgByrekl7dKRxUIQlYt1qIpYbTAao+ouWEFQFYQmFdvzxlBycrb2MFLbnO6Vr1xE60zmOrq9eiI8CzSGBQRcinL/1Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717150; c=relaxed/simple;
	bh=aetSlRL3gFebaGGZenFP9w1cgcSeaCpNDykah8esWhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqQi/961hkjFQroA7+vklyzR7sGpPg/Jhels0fyfY/aJehJ1O67/HWXnFvqS/M0T8rC36Ro6YCHGyoRHynmeAl6qXonH6Db+19v7SqYSnGl9yqR0N3ykI4a5sN8BWWpxnWWbuVfXNnnVn1yuZviNxlKNgNN3FYWQNz4lfAK1F9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDqSYtql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDqSYtql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AECCC4CEED;
	Mon, 23 Jun 2025 22:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717150;
	bh=aetSlRL3gFebaGGZenFP9w1cgcSeaCpNDykah8esWhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDqSYtqlodJVyOm7fyxTZ1hGu/yL2ub7aaqghiyG7UKb1GRL7ENz+d2Wa7FN291Yu
	 cnY/ljZfa2BzEK/dhr+SYLWfOOX05ZX1PnvU1ZNeo6ay53bcTWjlEHBbjTLpVmSJ0T
	 Q9ZCcFuDNYcYT+yttlE8PEGBO1ETsNX0TRqvvJtA=
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
Subject: [PATCH 6.12 330/414] arm64: Restrict pagetable teardown to avoid false warning
Date: Mon, 23 Jun 2025 15:07:47 +0200
Message-ID: <20250623130650.239017164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1285,7 +1285,8 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
-		pmd_free_pte_page(pmdp, next);
+		if (pmd_present(pmdp_get(pmdp)))
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
 	pud_clear(pudp);


