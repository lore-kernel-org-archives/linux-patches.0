Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8F232ABC0;
	Thu, 28 May 2026 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998497; cv=none; b=p2ILo9yIZrXeVWDlxepO7MrcsIm3LlGTUkYEzJvyBC+6Fbvc4OSeAQbXS9PO/mY2m1fTCitDN6uZuGCqEnFtMtYk7LMTdyMEFv3U0TteigmMAdqj6FioBlRRw2KRlsU77xssKzQpR2lhg+daq7x11bkbEe121HXAGrtQOSeO0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998497; c=relaxed/simple;
	bh=fGUQ3DvRaT1IWgAr72K47uFvjO5PpRV/doGwvBclYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chdbXIPa/ekJsKwp52+sS/emN05DhYpkcLL0CNGrQC5RUasx0hAtVgJ9fGMoj5SVPhidfnX+mQJ1YTx8nddfMbkHSvYhdGQFosbkgNaeQ8ft3/z/H1q8HpCLN0Vgs0pHsJ8p8LKT4jAQWpRq7umecPFo6g+9aeRZkZ8Iekg9dRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpLZ8f0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpLZ8f0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BE1F00A3E;
	Thu, 28 May 2026 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998496;
	bh=8/S+p04B0S6uuG/IaOcWI54HfK6Vxf0GacUBSKTQchA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpLZ8f0VfDvv3e05ugt7p1BrRFCijYBPI6vdwvNqGJY2E6tuJQe6idRhBMFA3zfgU
	 mAJfeiqeryvHYf1kGDUNcYQposFVjM3h/dkt3tBqruDBGHz2StXyNxbMz5tTgABtLK
	 hLTUX0/VzPOldt+XXkMAnGm8e4rDEsjvN8pm0r4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 193/461] riscv: mm: Fixup no5lvl failure when vaddr is invalid
Date: Thu, 28 May 2026 21:45:22 +0200
Message-ID: <20260528194652.667687018@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>

[ Upstream commit db909bd7986c10da074917af3dae83a60fa65093 ]

Unlike no4lvl, no5lvl still continues to detect satp, which
requires va=pa mapping. When pa=0x800000000000, no5lvl
would fail in Sv48 mode due to an illegal VA value of
0x800000000000.

So, prevent detecting the satp flow for no5lvl, when
vaddr is invalid. Add the is_vaddr_valid() function for
checking.

Fixes: 26e7aacb83df ("riscv: Allow to downgrade paging mode from the command line")
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Tested-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Link: https://patch.msgid.link/20260125055212.433163-1-guoren@kernel.org
[pjw@kernel.org: cleaned up commit message]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 811e03786c560..1b221c3fe2750 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -846,6 +846,27 @@ static void __init set_mmap_rnd_bits_max(void)
 	mmap_rnd_bits_max = MMAP_VA_BITS - PAGE_SHIFT - 3;
 }
 
+static bool __init is_vaddr_valid(unsigned long va)
+{
+	unsigned long up = 0;
+
+	switch (satp_mode) {
+	case SATP_MODE_39:
+		up = 1UL << 38;
+		break;
+	case SATP_MODE_48:
+		up = 1UL << 47;
+		break;
+	case SATP_MODE_57:
+		up = 1UL << 56;
+		break;
+	default:
+		return false;
+	}
+
+	return (va < up) || (va >= (ULONG_MAX - up + 1));
+}
+
 /*
  * There is a simple way to determine if 4-level is supported by the
  * underlying hardware: establish 1:1 mapping in 4-level page table mode
@@ -887,6 +908,9 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 			   set_satp_mode_pmd + PMD_SIZE,
 			   PMD_SIZE, PAGE_KERNEL_EXEC);
 retry:
+	if (!is_vaddr_valid(set_satp_mode_pmd))
+		goto out;
+
 	create_pgd_mapping(early_pg_dir,
 			   set_satp_mode_pmd,
 			   pgtable_l5_enabled ?
@@ -909,6 +933,7 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 		disable_pgtable_l4();
 	}
 
+out:
 	memset(early_pg_dir, 0, PAGE_SIZE);
 	memset(early_p4d, 0, PAGE_SIZE);
 	memset(early_pud, 0, PAGE_SIZE);
-- 
2.53.0



