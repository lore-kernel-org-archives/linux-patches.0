Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710862BF3E2;
	Thu, 28 May 2026 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000746; cv=none; b=S08CYpjuyaCvpUymvvej4G6gRb/qvj50TGtl56imOC9lfuAMq8Z1jAuRt6RKpCAZXhCfOafcSFHYmCy4R6QTEDxFPnRChblmh4JP93hQYoH0+YEp+hKmkKoR7rtWvVIY4mis8MA2qbVOr3KOImk1Ezg1QZoYOBjBJoPEYramvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000746; c=relaxed/simple;
	bh=xKhChc27Br+7gomp/gmHqZwiGP+IjTZOPZNIetCRmos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jF4nWFKG2JKDnJNVbBDkV6QwWPsCg64KsgVsoF+DVdbz1SDeoHqELUu2nPs7879NsSDlXcp5q8SENIvISB651q7BAuEcO8+4Sghfg1y3CrYgnwAZvYZUoCOOstYQiqDSIniGmIzWc01eewVfeyrXOKzNtnAVDjzjsyx39O1Sens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeTkz5Bc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeTkz5Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26641F000E9;
	Thu, 28 May 2026 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000745;
	bh=n4De4b7CpclY9KhR+4xa3GGtXtwoPUav4Nywpdqibmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeTkz5Bc6Y9WSaI9NPXyucVFQ6fAaQ8IcRny4p5VSYy/TrtprHyLy4p0AdLIsOEZH
	 2RL/3xP/ALEV4EcoJRHdMmk2Cf7KtstbLSd0GiXFtiIdp67gJKA7emCtDjeKXuWz/E
	 /YQhkoYRI7yl5hXwOqmDfDW/VvR0wFp7kiUe2fKk=
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
Subject: [PATCH 6.12 154/272] riscv: mm: Fixup no5lvl failure when vaddr is invalid
Date: Thu, 28 May 2026 21:48:48 +0200
Message-ID: <20260528194633.672206086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d167e09f1fea..8cd8bc9b82cb2 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -807,6 +807,27 @@ static void __init set_mmap_rnd_bits_max(void)
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
@@ -842,6 +863,9 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 			   set_satp_mode_pmd + PMD_SIZE,
 			   PMD_SIZE, PAGE_KERNEL_EXEC);
 retry:
+	if (!is_vaddr_valid(set_satp_mode_pmd))
+		goto out;
+
 	create_pgd_mapping(early_pg_dir,
 			   set_satp_mode_pmd,
 			   pgtable_l5_enabled ?
@@ -864,6 +888,7 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 		disable_pgtable_l4();
 	}
 
+out:
 	memset(early_pg_dir, 0, PAGE_SIZE);
 	memset(early_p4d, 0, PAGE_SIZE);
 	memset(early_pud, 0, PAGE_SIZE);
-- 
2.53.0



