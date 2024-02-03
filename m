Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6874101C6;
	Sat,  3 Feb 2024 04:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933322; cv=none; b=q/9vbkL+f27apPyxPRodWrAOMAAcBrxX250/h6Qgx7ECJyUpBzW7XzvnTtCawwRCPD+GWZN/a2M+k+1igWtlppcwHPoK/jKc7y/FIXm9W7BY1Vk38qtknCE2xqBF4d5+Fuqkb3UtKZ1KCByepmuzCFGkaBQTpbIbbHtVEvhsifg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933322; c=relaxed/simple;
	bh=wogkyy7hKcDuE47eETUbekm2iYlloKdGhUEX3Plgjlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPKi7T7m0fO+MWI5KHKH0IAPix6VvDDi0lDCBikzw0k0tou3p/4t53RXFa+xxcFJbhlj8d03nZrupN69paZhlCm6qSyIQ7H+xT5kNEfapRe9nY5Xt6jxIBXFCLW7cWqDy1vx6QpBEbwpKGDaeYsDv+ZnNN5aR153WvGw8X/as/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guXtG+lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guXtG+lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623A4C433C7;
	Sat,  3 Feb 2024 04:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933322;
	bh=wogkyy7hKcDuE47eETUbekm2iYlloKdGhUEX3Plgjlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guXtG+lf72Fxihr8ws0Kp/evKD2fhFPLhYa/VceJtbg0wDzCpzs8tFlJHRA4k6ZGD
	 Mpl9rsnvnA0cfeZAKNOa8voKg6GHhMY1/oZguDnPXZtT+h/KKb+sDJn8UdfA+5qn6B
	 bh7LwIMLiqtQKuaSLwpx5UZjnXKgs6ek8zMfyzS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/219] powerpc/64s: Fix CONFIG_NUMA=n build due to create_section_mapping()
Date: Fri,  2 Feb 2024 20:03:00 -0800
Message-ID: <20240203035318.010856221@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd9784f77f2e..71250605b784 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -179,3 +179,8 @@ static inline bool debug_pagealloc_enabled_or_kfence(void)
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



