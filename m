Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D3D1F4628;
	Mon, 23 Jun 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714018; cv=none; b=Nmcx0vpAJTDOX0MRdmnYJjOM1RyRh7K9ZJG/5OW82dViMWnbUqofNbyyVWdmlfDLc7C8IDDFksMfcDVzrPH5EwPljQHjYx3O0hcjMewWh0haASX6y4mtVwqvtD7ShHJ1Ogj9dIZvz00swz5bEV8JUcrFdBeDyDUJA/LyJokRqh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714018; c=relaxed/simple;
	bh=z3VTJqxHJ5Qe/J/nLPl/2L2yzrxzSCGEqwU/B3/W5BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjKsDDKMEALiBpSO99h3Cs7GsfhyeDVR0Cf2hwLhxB6cKJvCQfTLKLtQMtwcZGyqXp2LKxh8PUt1e4yjkqepqXw//5qcqTFp66cqRwq2cVRq5IegYfgxlR26mNaO+b5sR25+/8BUFxnVvsTmotmWhek8c3GdtSkZ/k3Lx8DWE6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsu8sz7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsu8sz7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAE8C4CEEA;
	Mon, 23 Jun 2025 21:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714018;
	bh=z3VTJqxHJ5Qe/J/nLPl/2L2yzrxzSCGEqwU/B3/W5BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsu8sz7zxNVzLlW+k8u3u5qwkkaqneYHIZzDGyZGZEInb11tkI1kSBGoC9dgeY+jV
	 ryOW2Xn1oQ/1L/QsUWfmYcUOJ3S5BqowHawctj56WojwpXC050jh9I0DPG8eZO0T09
	 7uII6VIJ8E/FDE5f11D8x+qiKszG14fI62/nY9G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Stutterheim <ross.stutterheim@garmin.com>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 179/355] ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()
Date: Mon, 23 Jun 2025 15:06:20 +0200
Message-ID: <20250623130632.078584187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


