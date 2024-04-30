Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0D12C499;
	Tue, 30 Apr 2024 10:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474635; cv=none; b=XttT2IzimYMUXm44XR2HqIV+ayK1bI3tr+EvZAu8CIs9azZhNKKpBq6S6ax4S58JgrRUw09Iop2BVQ2Ll3tC+wzb6lLA+ujmBCTXw0Ic+DUfwTA/hBm6/gP7rJMMq0TNx+YykZdy0SDfeE6b9YvGyMBmj95OD5dhCcOaEDTCScA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474635; c=relaxed/simple;
	bh=XplUxNMzggqqgj7viqwY8T7U7rWBPVzDqqvnVgibDK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dttmv2WBfIr+ghutCpibBJFhJ/1FAVqY2awSzB2R1AAgs03grriWfZmT3N1qeRR7Gzh0eHpR8v4BjpPc5BIFqe7Uq9xtUzns0msq1igO72d3ttYWdn4KdeDk7kMq8hagKbmNpMRk4BhwQ9uXVtk9X4WqRYHytwOuyv5LWi1VXvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A68H9a83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A68H9a83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3FBC2BBFC;
	Tue, 30 Apr 2024 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474635;
	bh=XplUxNMzggqqgj7viqwY8T7U7rWBPVzDqqvnVgibDK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A68H9a83e+UMPNnoA+GBO8vGPhxJoe2CvddwqEoAFVRbNtgaU0+Z6aLOUG6KuktrO
	 cO9KnlE5rCdRpPxX4bUgWti6keCWKDHcWDlUJCYDAW3NNfxonVUcxKFidZuZEj2lA1
	 dOOc60F20cDVR4SuF62gFOoljhucQty2PeZHpoQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 215/228] riscv: Fix loading 64-bit NOMMU kernels past the start of RAM
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103110.009652974@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit aea702dde7e9876fb00571a2602f25130847bf0f ]

commit 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear
mapping") added logic to allow using RAM below the kernel load address.
However, this does not work for NOMMU, where PAGE_OFFSET is fixed to the
kernel load address. Since that range of memory corresponds to PFNs
below ARCH_PFN_OFFSET, mm initialization runs off the beginning of
mem_map and corrupts adjacent kernel memory. Fix this by restoring the
previous behavior for NOMMU kernels.

Fixes: 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear mapping")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240227003630.3634533-3-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h | 2 +-
 arch/riscv/mm/init.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 57e887bfa34cb..94b3d6930fc37 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -89,7 +89,7 @@ typedef struct page *pgtable_t;
 #define PTE_FMT "%08lx"
 #endif
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 /*
  * We override this value as its generic definition uses __pa too early in
  * the boot process (before kernel_map.va_pa_offset is set).
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fa34cf55037bd..0c00efc75643a 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -232,7 +232,7 @@ static void __init setup_bootmem(void)
 	 * In 64-bit, any use of __va/__pa before this point is wrong as we
 	 * did not know the start of DRAM before.
 	 */
-	if (IS_ENABLED(CONFIG_64BIT))
+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_MMU))
 		kernel_map.va_pa_offset = PAGE_OFFSET - phys_ram_base;
 
 	/*
-- 
2.43.0



