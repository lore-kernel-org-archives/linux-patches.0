Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20929226888;
	Mon, 23 Jun 2025 22:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716745; cv=none; b=oWg6Vk5VyBcpPj8T52NLt30ncyv6azYoWLi8hgM9LRDdQL+ZcU8E+wvtzJUjzD0IZETZj6AZ0VahtNl2+qTfL0jpXbKgG6Bksp3jEIyk0ausKaXAMlw0W97cmA5/X7Z0oDrcZ1d4hl0GUv8N8qrU0ufUfdoHcLlo2Yjf/sETav4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716745; c=relaxed/simple;
	bh=D6m7ggV1cgeXqjaos+fclKsK3T74yq+Q3u2gNyx4DYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOqvNRaytH0fMKagkY7ABFoZqUSi5qMCoHG8wmN461YKMCwCrpqNKfeeKF9ic/6lmuzHxB8rVSJrmDHhED3eTZoCIiEnsV6UfxVSRvMVjUkh9gWcDJwcme8oazMcBoQnODzgynmXtCyNba8UfYc/5ELvsOg38rxmOJiW7NkgTyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAb4+EBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAb4+EBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6C0C4CEEA;
	Mon, 23 Jun 2025 22:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716745;
	bh=D6m7ggV1cgeXqjaos+fclKsK3T74yq+Q3u2gNyx4DYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAb4+EBDBQjcxtLVEMnbvRABNJJR91lhahnbYd5+6FrByYX+7Gx3eGimTwEHqiTuI
	 OQmkiQpdf0AeWjoKuClcA20goHfm7/BVPfvGF2FQVx/GRPQKBtRVQan+189EItiAex
	 OK3GWv8pg44qGyl91CuVTYCg6F84QiRh6qMS6ry0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Stutterheim <ross.stutterheim@garmin.com>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 325/508] ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130653.323474224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Ross Stutterheim <ross.stutterheim@garmin.com>

commit 96e0b355883006554a0bee3697da475971d6bba8 upstream.

arm/memremap: fix arch_memremap_can_ram_remap()

commit 260364d112bc ("arm[64]/memremap: don't abuse pfn_valid() to ensure
presence of linear map") added the definition of
arch_memremap_can_ram_remap() for arm[64] specific filtering of what pages
can be used from the linear mapping. memblock_is_map_memory() was called
with the pfn of the address given to arch_memremap_can_ram_remap();
however, memblock_is_map_memory() expects to be given an address for arm,
not a pfn.

This results in calls to memremap() returning a newly mapped area when
it should return an address in the existing linear mapping.

Fix this by removing the address to pfn translation and pass the
address directly.

Fixes: 260364d112bc ("arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map")
Signed-off-by: Ross Stutterheim <ross.stutterheim@garmin.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/ioremap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -515,7 +515,5 @@ void __init early_ioremap_init(void)
 bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
 				 unsigned long flags)
 {
-	unsigned long pfn = PHYS_PFN(offset);
-
-	return memblock_is_map_memory(pfn);
+	return memblock_is_map_memory(offset);
 }


