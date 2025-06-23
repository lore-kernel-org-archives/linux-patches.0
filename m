Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C84E2505CB;
	Mon, 23 Jun 2025 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684502; cv=none; b=qey24LWJJKGmNVuS3QLAf/NvOJzZl0B/P/ATT7M1f40LSP77Qovepxmopa82JRqFdIODK4zWKuiVuLbixU4aAngCxBV+QQHGRmrzUxVxGilMllCi8PZxzuG1odHRjdrpNR/a08jcmZ8jecaX0WxEi1zKX05XzMR+r3uNiMI1oBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684502; c=relaxed/simple;
	bh=iRnweNH7PawYuTLZehxbdg1AVYfVgu/cgXC2zfeBeCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vClLjTPb11PK+/exlNnX7mIsRlWCqU2wxG1SLjugLiE30LYS6UXQvqat5uwTsZAF77h5ybrfD+zaFy8edzdzBIx3EOr8gLmjqGbWfssaxG7uQGqyBbG60L4a2tqYnNlHbG+KYhQO3bpGyel7rFv+Ohw2DDK2R0UGXVmT8qep1GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4OaeC+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4OaeC+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D8C4CEEA;
	Mon, 23 Jun 2025 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684502;
	bh=iRnweNH7PawYuTLZehxbdg1AVYfVgu/cgXC2zfeBeCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4OaeC+udjjk+TOSFHOItGM0RfJhAMgSm2eJQTJ2V6CHzBs8yvh2QyAZEgyWKwAze
	 tZLw8kAfJ3NmRMPkp6BDe8PlduUFRy1+kcmeqHtwFDSyJY8mVa7NgaKEtAsQ8XlDnX
	 CyrP2LYy6hpBENhOHlK12+PMGTLo4GLQaLR087hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Stutterheim <ross.stutterheim@garmin.com>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.15 093/592] ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()
Date: Mon, 23 Jun 2025 15:00:51 +0200
Message-ID: <20250623130702.493258612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


