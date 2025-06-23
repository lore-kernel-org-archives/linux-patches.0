Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304D44315A;
	Mon, 23 Jun 2025 21:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714968; cv=none; b=Jo5SXgKcDf8NiCnJ6R35JZuandOGfmiNRpGNZ+FK1ammtQlZGpVvE0aGkIlD4rBimiSKmlGrJLFQzyuWRdFKBZgnb4T9uZgGcazy96AAquPpasCJptySif8bSn5DMy19aqkAPeHI+KXMuRbwIT75xYZhFyMF8hU+o9jfPZGBolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714968; c=relaxed/simple;
	bh=/tUszRO6cePgpFtBQ/DdboO5cuVkKErJ9U6L2nNXinQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXhUmm+zqeuBaeUWxs/IVUCiY4asIYXqAYW1PGsmaQ+9eeiNWCU4QHbHo7wWbH0/aU1n7Ehmyl8Cr0gtP8tXMxGFjCFp9v4J5mbNuZa5go1/eQM2TVB3v2KaEMi/8mGvIw5wgN8xlKw15MXsqbAwjjxI6a4CwQYWXJGrjAMPmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0XkSvbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0XkSvbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B449DC4CEEA;
	Mon, 23 Jun 2025 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714968;
	bh=/tUszRO6cePgpFtBQ/DdboO5cuVkKErJ9U6L2nNXinQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0XkSvbtxMFqOZdItImuMfI1RYqIC9XgIWYv5WCNVPJzDlSP2mfahBwhxjJ1zOjTO
	 gw8q3OKDqptepOkPhPepgTwSCIZLZnGHwA+nezhm3u9/JDnvBEjWOTb2FCv3L2A0V4
	 YHOMZSt8Emfci/edJ+paQPnbfv954dKlPg3TlLeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Stutterheim <ross.stutterheim@garmin.com>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 220/411] ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()
Date: Mon, 23 Jun 2025 15:06:04 +0200
Message-ID: <20250623130639.201972865@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,7 +483,5 @@ void __init early_ioremap_init(void)
 bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
 				 unsigned long flags)
 {
-	unsigned long pfn = PHYS_PFN(offset);
-
-	return memblock_is_map_memory(pfn);
+	return memblock_is_map_memory(offset);
 }


