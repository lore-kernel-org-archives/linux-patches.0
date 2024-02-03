Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086D11188;
	Sat,  3 Feb 2024 04:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933490; cv=none; b=tJEF+DWV3vuH7AMWGU0agC/yz+mZyd7Plemevpbvn/+LpjeffM+Wmlv+DgeO9bA633h8LrbdgKtKgh9MiNqS1YfBWYpY4xbR3rnHdqtvS5cw0SHUmaOIjIWdzlRiWN983osALfaRsavl4r5xH2TWPupeMOneZdZxFlnpMCzNvrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933490; c=relaxed/simple;
	bh=GF3mz6OwNqYGuaocymJZ/IFpZIbVr7N8BOXMui06+Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryHcKQtbrV83pjq/bsHTUdcn/70HBvLXA07FjxtYyNGrW01Xh2y1eWNznem1WA9Lf5EyO8DJJUzc0N5Fv9a8jJi8qHFHIxfFM16yRmKlObLTk08M3yemNpANpco1ThzSPaLAUmASrNG2fZSV9l2L+XrkHnBRSm59wPlgg05q6N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYNBWyjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYNBWyjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E1CC433C7;
	Sat,  3 Feb 2024 04:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933490;
	bh=GF3mz6OwNqYGuaocymJZ/IFpZIbVr7N8BOXMui06+Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYNBWyjw2MyvwsqLcA+ZS+vDLgT1HshnkRgK45SiO0Fy2Vaolv0O1cGD9+WjPiLjQ
	 RVWgJGsTbf4UIpgs+iaR+6LT4xvCamK3YuawxKz9dYo30FKltgva2Ou4IyNAPdLA6L
	 ZwsrKMFD5pKoHLvFPzX35Se1lN8IqnrOPKhAsTuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/322] powerpc/64s: Fix CONFIG_NUMA=n build due to create_section_mapping()
Date: Fri,  2 Feb 2024 20:01:45 -0800
Message-ID: <20240203035359.318943172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ede66cd22441820cbd399936bf84fdc4294bc7fa ]

With CONFIG_NUMA=n the build fails with:

  arch/powerpc/mm/book3s64/pgtable.c:275:15: error: no previous prototype for ‘create_section_mapping’ [-Werror=missing-prototypes]
  275 | int __meminit create_section_mapping(unsigned long start, unsigned long end,
      |               ^~~~~~~~~~~~~~~~~~~~~~

That happens because the prototype for create_section_mapping() is in
asm/mmzone.h, but asm/mmzone.h is only included by linux/mmzone.h
when CONFIG_NUMA=y.

In fact the prototype is only needed by arch/powerpc/mm code, so move
the prototype into arch/powerpc/mm/mmu_decl.h, which also fixes the
build error.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231129131919.2528517-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmzone.h | 5 -----
 arch/powerpc/mm/mmu_decl.h        | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 3764d3585d30..da827d2d0866 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -43,10 +43,5 @@ u64 memory_hotplug_max(void);
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end,
-				  int nid, pgprot_t prot);
-#endif
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_MMZONE_H_ */
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 7f9ff0640124..72341b9fb552 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -181,3 +181,8 @@ static inline bool debug_pagealloc_enabled_or_kfence(void)
 {
 	return IS_ENABLED(CONFIG_KFENCE) || debug_pagealloc_enabled();
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int create_section_mapping(unsigned long start, unsigned long end,
+			   int nid, pgprot_t prot);
+#endif
-- 
2.43.0



