Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A311F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9256C433C9;
	Fri, 21 Jul 2023 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955976;
	bh=9Xdsnlelb2BAtaGP+mGrXUN3w1OprKpMo8jqXsjAp2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5qMhtNykGjvWNIUIJeSa0lUzxi/A6tmjXqISRgNSZKNUob/9Ii9P+LalcWMwJymK
	 LqMavjoWQvqcRC6UeWwdN5vsOpU4uQePfxuzGcGaxuuGLCG/d4GHg8wliAi7etRGrs
	 DfP+IP3VyAlcjbEA0leyGDFFA4qR7j8KocqRxQrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 096/292] riscv: mm: fix truncation warning on RV32
Date: Fri, 21 Jul 2023 18:03:25 +0200
Message-ID: <20230721160532.922755001@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit b690e266dae2f85f4dfea21fa6a05e3500a51054 ]

lkp reports below sparse warning when building for RV32:
arch/riscv/mm/init.c:1204:48: sparse: warning: cast truncates bits from
constant value (100000000 becomes 0)

IMO, the reason we didn't see this truncates bug in real world is "0"
means MEMBLOCK_ALLOC_ACCESSIBLE in memblock and there's no RV32 HW
with more than 4GB memory.

Fix it anyway to make sparse happy.

Fixes: decf89f86ecd ("riscv: try to allocate crashkern region from 32bit addressible memory")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306080034.SLiCiOMn-lkp@intel.com/
Link: https://lore.kernel.org/r/20230709171036.1906-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 1306149aad57a..93e7bb9f67fd4 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1346,7 +1346,7 @@ static void __init reserve_crashkernel(void)
 	 */
 	crash_base = memblock_phys_alloc_range(crash_size, PMD_SIZE,
 					       search_start,
-					       min(search_end, (unsigned long) SZ_4G));
+					       min(search_end, (unsigned long)(SZ_4G - 1)));
 	if (crash_base == 0) {
 		/* Try again without restricting region to 32bit addressible memory */
 		crash_base = memblock_phys_alloc_range(crash_size, PMD_SIZE,
-- 
2.39.2



