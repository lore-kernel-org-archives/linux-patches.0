Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C314A4E7;
	Tue, 17 Dec 2024 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456019; cv=none; b=nhmHCtjf4E++eNiswdrF/UeZrqlj4tZvHDGWJlLcGeHtWXTbsjrAKri+Y4iSUzSaCSSYEJo53lEunFa/Tvx1vMzKdc235IamYXD85GznjDo/VIS1OqUVOcbhc00bCcay4Jh74MnjpnsUgZ1SCPEIs1t1KAA6Wju3/kQgAjySOQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456019; c=relaxed/simple;
	bh=HFJufqE+e2GrBUW7QerLs9I/HGC5G+U4efUhER7Efhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx47WmAwuKGKXY7LuXYLLBsnpMhPTxOLpv/Wdaa6Q2clT/ctrb7pRP+pp5AUXR+PN3DGoqE67KwXr9sebD2SSjyzre+mWSGsopnlrWUgmZHZOVLtmHr3uLcaCwigbnLmod6Z9LV7js9GXYetokE/LpqEf7idRrOCrGuGTh0oqso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2clmcHAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2clmcHAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AEBC4CED3;
	Tue, 17 Dec 2024 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456019;
	bh=HFJufqE+e2GrBUW7QerLs9I/HGC5G+U4efUhER7Efhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2clmcHArx1h/omvuL8jK3nWO5wCQ94Hbnyi/Hzr0SyvDDwJ2wc0MJEqXW9S/JV8qK
	 wjTFv5AZKXhjkzz3eg7rQsDOU8tPN+7mCuhb8he1BPwk5Fm12f3qS2H0vGGBbKmhDo
	 t32Wdb1+nbiE+mIj52R3zc+9KyTuoflOCXVz5Y0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 006/109] riscv: Fix wrong usage of __pa() on a fixmap address
Date: Tue, 17 Dec 2024 18:06:50 +0100
Message-ID: <20241217170533.608046931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit c796e187201242992d6d292bfeff41aadfdf3f29 upstream.

riscv uses fixmap addresses to map the dtb so we can't use __pa() which
is reserved for linear mapping addresses.

Fixes: b2473a359763 ("of/fdt: add dt_phys arg to early_init_dt_scan and early_init_dt_verify")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241209074508.53037-1-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -246,7 +246,7 @@ static void __init init_resources(void)
 static void __init parse_dtb(void)
 {
 	/* Early scan of device tree from init memory */
-	if (early_init_dt_scan(dtb_early_va, __pa(dtb_early_va))) {
+	if (early_init_dt_scan(dtb_early_va, dtb_early_pa)) {
 		const char *name = of_flat_dt_get_machine_name();
 
 		if (name) {


