Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F21153517
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712680739; cv=none; b=JleSU6qonG7l3SocPMMFRDIhBIa4FYEBlBAb9GGwmKihpECNho+PjWC16VlPMBAnWYX48pMjvP35+hGjI96h4kWHWsH0r8gdZWe7SWDd7GLDJqsl90zMhLjLFELZtNXX1RLmYRYayAS3Shf1ewV1F6Awr4c88aRl46VmoahPAcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712680739; c=relaxed/simple;
	bh=qRtkAgaN4Lb+qn/3KSd46ZsCG7YCmm4KuRGmnz4jCtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rB0tGC05tOqdkWnWBoZdToCqcy3GX5rFqdEURgVptPoBBJ0LeHFZ3apDp/BJXBAie2hFM0buaj4ELdtavzcowNNzYU649R8PqYySTK5Dq7cU7QnDpgmbVSezNEhOIMz8Att1nZrmdLq25ODrCQKkQHZq3SMhAFQMP2EsUJaa3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=rn/8KInD; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="rn/8KInD"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1712680734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqMVO9k5+54X6UY1REXjyd335+oRZro3n1lllOsjgQQ=;
	b=rn/8KInD36YS2BaxeheBZZd5TY5vPz9KbneKqijOiOhlktJ2PfPLkh7p9fHgHxOk48Hjkw
	CqJg5oXGR6k63yCA==
Message-ID: <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
Date: Tue, 9 Apr 2024 18:38:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240408125317.917032769@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-04-08 14:59] Greg Kroah-Hartman:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> commit 48204aba801f1b512b3abed10b8e1a63e03f3dd1 upstream.
> 
> The .head.text section is the initial primary entrypoint of the core
> kernel, and is entered with the CPU executing from a 1:1 mapping of
> memory. Such code must never access global variables using absolute
> references, as these are based on the kernel virtual mapping which is
> not active yet at this point.
> 
> Given that the SME startup code is also called from this early execution
> context, move it into .head.text as well. This will allow more thorough
> build time checks in the future to ensure that early startup code only
> uses RIP-relative references to global variables.
> 
> Also replace some occurrences of __pa_symbol() [which relies on the
> compiler generating an absolute reference, which is not guaranteed] and
> an open coded RIP-relative access with RIP_REL_REF().
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Link: https://lore.kernel.org/r/20240227151907.387873-18-ardb+git@google.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/x86/include/asm/mem_encrypt.h |    8 +++----
>   arch/x86/mm/mem_encrypt_identity.c |   42 ++++++++++++++-----------------------
>   2 files changed, 21 insertions(+), 29 deletions(-)
> 
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -47,8 +47,8 @@ void __init sme_unmap_bootdata(char *rea
>   
>   void __init sme_early_init(void);
>   
> -void __init sme_encrypt_kernel(struct boot_params *bp);
> -void __init sme_enable(struct boot_params *bp);
> +void sme_encrypt_kernel(struct boot_params *bp);
> +void sme_enable(struct boot_params *bp);
>   
>   int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>   int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> @@ -81,8 +81,8 @@ static inline void __init sme_unmap_boot
>   
>   static inline void __init sme_early_init(void) { }
>   
> -static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
> -static inline void __init sme_enable(struct boot_params *bp) { }
> +static inline void sme_encrypt_kernel(struct boot_params *bp) { }
> +static inline void sme_enable(struct boot_params *bp) { }
>   
>   static inline void sev_es_init_vc_handling(void) { }
>   
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -41,6 +41,7 @@
>   #include <linux/mem_encrypt.h>
>   #include <linux/cc_platform.h>
>   
> +#include <asm/init.h>
>   #include <asm/setup.h>
>   #include <asm/sections.h>
>   #include <asm/coco.h>
> @@ -94,7 +95,7 @@ struct sme_populate_pgd_data {
>    */
>   static char sme_workarea[2 * PMD_SIZE] __section(".init.scratch");
>   
> -static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
> +static void __head sme_clear_pgd(struct sme_populate_pgd_data *ppd)
>   {
>   	unsigned long pgd_start, pgd_end, pgd_size;
>   	pgd_t *pgd_p;
> @@ -109,7 +110,7 @@ static void __init sme_clear_pgd(struct
>   	memset(pgd_p, 0, pgd_size);
>   }
>   
> -static pud_t __init *sme_prepare_pgd(struct sme_populate_pgd_data *ppd)
> +static pud_t __head *sme_prepare_pgd(struct sme_populate_pgd_data *ppd)
>   {
>   	pgd_t *pgd;
>   	p4d_t *p4d;
> @@ -146,7 +147,7 @@ static pud_t __init *sme_prepare_pgd(str
>   	return pud;
>   }
>   
> -static void __init sme_populate_pgd_large(struct sme_populate_pgd_data *ppd)
> +static void __head sme_populate_pgd_large(struct sme_populate_pgd_data *ppd)
>   {
>   	pud_t *pud;
>   	pmd_t *pmd;
> @@ -162,7 +163,7 @@ static void __init sme_populate_pgd_larg
>   	set_pmd(pmd, __pmd(ppd->paddr | ppd->pmd_flags));
>   }
>   
> -static void __init sme_populate_pgd(struct sme_populate_pgd_data *ppd)
> +static void __head sme_populate_pgd(struct sme_populate_pgd_data *ppd)
>   {
>   	pud_t *pud;
>   	pmd_t *pmd;
> @@ -188,7 +189,7 @@ static void __init sme_populate_pgd(stru
>   		set_pte(pte, __pte(ppd->paddr | ppd->pte_flags));
>   }
>   
> -static void __init __sme_map_range_pmd(struct sme_populate_pgd_data *ppd)
> +static void __head __sme_map_range_pmd(struct sme_populate_pgd_data *ppd)
>   {
>   	while (ppd->vaddr < ppd->vaddr_end) {
>   		sme_populate_pgd_large(ppd);
> @@ -198,7 +199,7 @@ static void __init __sme_map_range_pmd(s
>   	}
>   }
>   
> -static void __init __sme_map_range_pte(struct sme_populate_pgd_data *ppd)
> +static void __head __sme_map_range_pte(struct sme_populate_pgd_data *ppd)
>   {
>   	while (ppd->vaddr < ppd->vaddr_end) {
>   		sme_populate_pgd(ppd);
> @@ -208,7 +209,7 @@ static void __init __sme_map_range_pte(s
>   	}
>   }
>   
> -static void __init __sme_map_range(struct sme_populate_pgd_data *ppd,
> +static void __head __sme_map_range(struct sme_populate_pgd_data *ppd,
>   				   pmdval_t pmd_flags, pteval_t pte_flags)
>   {
>   	unsigned long vaddr_end;
> @@ -232,22 +233,22 @@ static void __init __sme_map_range(struc
>   	__sme_map_range_pte(ppd);
>   }
>   
> -static void __init sme_map_range_encrypted(struct sme_populate_pgd_data *ppd)
> +static void __head sme_map_range_encrypted(struct sme_populate_pgd_data *ppd)
>   {
>   	__sme_map_range(ppd, PMD_FLAGS_ENC, PTE_FLAGS_ENC);
>   }
>   
> -static void __init sme_map_range_decrypted(struct sme_populate_pgd_data *ppd)
> +static void __head sme_map_range_decrypted(struct sme_populate_pgd_data *ppd)
>   {
>   	__sme_map_range(ppd, PMD_FLAGS_DEC, PTE_FLAGS_DEC);
>   }
>   
> -static void __init sme_map_range_decrypted_wp(struct sme_populate_pgd_data *ppd)
> +static void __head sme_map_range_decrypted_wp(struct sme_populate_pgd_data *ppd)
>   {
>   	__sme_map_range(ppd, PMD_FLAGS_DEC_WP, PTE_FLAGS_DEC_WP);
>   }
>   
> -static unsigned long __init sme_pgtable_calc(unsigned long len)
> +static unsigned long __head sme_pgtable_calc(unsigned long len)
>   {
>   	unsigned long entries = 0, tables = 0;
>   
> @@ -284,7 +285,7 @@ static unsigned long __init sme_pgtable_
>   	return entries + tables;
>   }
>   
> -void __init sme_encrypt_kernel(struct boot_params *bp)
> +void __head sme_encrypt_kernel(struct boot_params *bp)
>   {
>   	unsigned long workarea_start, workarea_end, workarea_len;
>   	unsigned long execute_start, execute_end, execute_len;
> @@ -319,9 +320,8 @@ void __init sme_encrypt_kernel(struct bo
>   	 *     memory from being cached.
>   	 */
>   
> -	/* Physical addresses gives us the identity mapped virtual addresses */
> -	kernel_start = __pa_symbol(_text);
> -	kernel_end = ALIGN(__pa_symbol(_end), PMD_SIZE);
> +	kernel_start = (unsigned long)RIP_REL_REF(_text);
> +	kernel_end = ALIGN((unsigned long)RIP_REL_REF(_end), PMD_SIZE);
>   	kernel_len = kernel_end - kernel_start;
>   
>   	initrd_start = 0;
> @@ -339,14 +339,6 @@ void __init sme_encrypt_kernel(struct bo
>   #endif
>   
>   	/*
> -	 * We're running identity mapped, so we must obtain the address to the
> -	 * SME encryption workarea using rip-relative addressing.
> -	 */
> -	asm ("lea sme_workarea(%%rip), %0"
> -	     : "=r" (workarea_start)
> -	     : "p" (sme_workarea));
> -
> -	/*
>   	 * Calculate required number of workarea bytes needed:
>   	 *   executable encryption area size:
>   	 *     stack page (PAGE_SIZE)
> @@ -355,7 +347,7 @@ void __init sme_encrypt_kernel(struct bo
>   	 *   pagetable structures for the encryption of the kernel
>   	 *   pagetable structures for workarea (in case not currently mapped)
>   	 */
> -	execute_start = workarea_start;
> +	execute_start = workarea_start = (unsigned long)RIP_REL_REF(sme_workarea);
>   	execute_end = execute_start + (PAGE_SIZE * 2) + PMD_SIZE;
>   	execute_len = execute_end - execute_start;
>   
> @@ -498,7 +490,7 @@ void __init sme_encrypt_kernel(struct bo
>   	native_write_cr3(__native_read_cr3());
>   }
>   
> -void __init sme_enable(struct boot_params *bp)
> +void __head sme_enable(struct boot_params *bp)
>   {
>   	unsigned int eax, ebx, ecx, edx;
>   	unsigned long feature_mask;


Just to make sure this doesn't get lost: This patch causes the kernel to 
not boot on several x86_64 VMs of mine (I haven't tested it on a bare 
metal machine). For details and a kernel config to reproduce the issue, 
see 
https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/


Regards
Pascal
