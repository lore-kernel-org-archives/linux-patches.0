Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6E7263F49
	for <patches@lists.linux.dev>; Thu,  2 Oct 2025 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759423404; cv=none; b=oaL00KUfmMkygw1Jsbl6XOFJKpCvKHEy6EA39l9hI8ZY6+Un4MDnhboGblnpYDA/h25M+iVM8e6MW6O8O9aDL85v+t4bLcG8rs9F+2FG04RGj5kiVDsTCkNjBGfKrVCOZQP3n/tRdnbf3zOksr1G81U+I+4wx+nClMI8l51ZVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759423404; c=relaxed/simple;
	bh=HYxaEfMtws/N8gZt/uBZJZ+9NzkvYoUL1fvuo/x2hns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TK9lGy4gJmufXKCMHO1PRq4/jL2O4p1Zrz4bOMvim8uVsTUZpHeNNQ8hdMx6S42rMG4yoZP3RJD3QQjGvRy3zNhMOL5ncmapL1HGVaplY7cYX9mLvonTA04jCdJ0kGTTH83dQkXHF6XEtyZZnwJG1bz1TYvE11MI/QRBuq7S1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6911C1FCD;
	Thu,  2 Oct 2025 09:43:13 -0700 (PDT)
Received: from [10.57.3.58] (unknown [10.57.3.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47F683F66E;
	Thu,  2 Oct 2025 09:43:20 -0700 (PDT)
Message-ID: <1f47887b-90d5-425c-b80f-9fa8855a6837@arm.com>
Date: Thu, 2 Oct 2025 17:43:18 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-6.16] arm64: realm: ioremap: Allow mapping
 memory as encrypted
Content-Language: en-GB
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>
References: <20251002153025.2209281-1-sashal@kernel.org>
 <20251002153025.2209281-8-sashal@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251002153025.2209281-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello !

On 02/10/2025 16:29, Sasha Levin wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit fa84e534c3ec2904d8718a83180294f7b5afecc7 ]
> 
> For ioremap(), so far we only checked if it was a device (RIPAS_DEV) to choose
> an encrypted vs decrypted mapping. However, we may have firmware reserved memory
> regions exposed to the OS (e.g., EFI Coco Secret Securityfs, ACPI CCEL).
> We need to make sure that anything that is RIPAS_RAM (i.e., Guest
> protected memory with RMM guarantees) are also mapped as encrypted.
> 
> Rephrasing the above, anything that is not RIPAS_EMPTY is guaranteed to be
> protected by the RMM. Thus we choose encrypted mapping for anything that is not
> RIPAS_EMPTY. While at it, rename the helper function
> 
>    __arm64_is_protected_mmio => arm64_rsi_is_protected
> 
> to clearly indicate that this not an arm64 generic helper, but something to do
> with Realms.
> 
> Cc: Sami Mujawar <sami.mujawar@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> Tested-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:

Indeed, some are clearly incorrect.

> 
> Based on my comprehensive analysis of this commit, I can now provide my
> determination.
> 
> ## Analysis Summary
> 
> ### Code Change Analysis
> 
> The commit makes a **critical logic change** in
> `arch/arm64/kernel/rsi.c:104`:
> 
> **Before**: `if (ripas != RSI_RIPAS_DEV) break;`
> - Only returns true if **all** regions are RIPAS_DEV (device memory)
> - Other states (RIPAS_RAM, RIPAS_DESTROYED) cause early exit → mapped as
>    **decrypted**
> 
> **After**: `if (ripas == RSI_RIPAS_EMPTY) break;`
> - Returns true for RIPAS_RAM, RIPAS_DESTROYED, and RIPAS_DEV
> - Only RIPAS_EMPTY (unprotected/shared) regions are mapped as
>    **decrypted**
> 
> ### Problem Being Fixed
> 
> The original implementation from commit 371589437616f (Oct 2024) only
> encrypted RIPAS_DEV regions. However, **firmware-reserved memory
> regions** use RIPAS_RAM state:
> 
> - **EFI Coco Secret Securityfs** areas
> - **ACPI CCEL** (Confidential Computing Event Log) tables
> 
> Without this fix, these RIPAS_RAM regions are incorrectly mapped with
> `pgprot_decrypted()`, which sets `PROT_NS_SHARED`, making them

The Realm would have mapped them as decrypted and might have consumed
untrusted information from (a malicious) hypervisor

> **accessible to the untrusted hypervisor**.

No, hypervisor doesn't get access to the protected data.

> 
> ### Security Impact
> 
> This is a **security and data integrity bug**:
> 1. **Confidential data leakage**: Hypervisor can read protected firmware
>     secrets

Wrong

> 2. **Data corruption**: Hypervisor can modify what should be protected
>     memory

Absolutely NO

> 3. **Violation of ARM CCA guarantees**: Breaks confidential computing
>     promises

Not really. The Guest could consume "untrusted" data, thats the only
violation here.

Suzuki






> 
> ### Dependencies
> 
> Two related commits were **already backported** (based on "Upstream
> commit" tags):
> - `bda90416d53f`: "arm64: Enable EFI secret area Securityfs support"
> - `09b8e2bf3bf1`: "arm64: acpi: Enable ACPI CCEL support"
> 
> Both depend on this fix to function correctly.
> 
> ### Risk Assessment
> 
> **LOW RISK**:
> - Isolated to ARM64 Realm subsystem (v6.13+)
> - Only affects ARM CCA Realm guests
> - Simple, well-understood logic inversion
> - Multiple reviewers (Gavin Shan, Steven Price) and testers (Sami
>    Mujawar)
> - No follow-up fixes or reverts found
> - Function rename improves code clarity
> 
> ### Stable Tree Rules
> 
> ✅ Fixes important security/correctness bug
> ✅ Small and contained (3 files, ~30 lines)
> ✅ No new features or architectural changes
> ✅ Minimal regression risk
> ✅ Well-tested and reviewed
> 
> ---
> 
> ## **Answer: YES**
> 
> **This commit should be backported to stable kernel trees that include
> ARM64 Realm support (v6.13+).**
> 
> **Rationale**: This fixes a security vulnerability where firmware-
> reserved protected memory (RIPAS_RAM) is incorrectly mapped as decrypted
> instead of encrypted, violating ARM CCA confidential computing
> guarantees. The bug allows the untrusted hypervisor to access or corrupt
> protected firmware data (EFI secrets, ACPI CCEL tables). The fix is
> small, contained, well-tested, and has minimal regression risk.
> Additionally, two dependent features (EFI Secret and ACPI CCEL support)
> were already backported and require this fix to work correctly.
> 
>   arch/arm64/include/asm/io.h  |  2 +-
>   arch/arm64/include/asm/rsi.h |  2 +-
>   arch/arm64/kernel/rsi.c      | 26 ++++++++++++++++++++++----
>   3 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 9b96840fb979b..82276282a3c72 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -311,7 +311,7 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
>   static inline bool arm64_is_protected_mmio(phys_addr_t phys_addr, size_t size)
>   {
>   	if (unlikely(is_realm_world()))
> -		return __arm64_is_protected_mmio(phys_addr, size);
> +		return arm64_rsi_is_protected(phys_addr, size);
>   	return false;
>   }
>   
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> index b42aeac05340e..88b50d660e85a 100644
> --- a/arch/arm64/include/asm/rsi.h
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -16,7 +16,7 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
>   
>   void __init arm64_rsi_init(void);
>   
> -bool __arm64_is_protected_mmio(phys_addr_t base, size_t size);
> +bool arm64_rsi_is_protected(phys_addr_t base, size_t size);
>   
>   static inline bool is_realm_world(void)
>   {
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index ce4778141ec7b..c64a06f58c0bc 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -84,7 +84,25 @@ static void __init arm64_rsi_setup_memory(void)
>   	}
>   }
>   
> -bool __arm64_is_protected_mmio(phys_addr_t base, size_t size)
> +/*
> + * Check if a given PA range is Trusted (e.g., Protected memory, a Trusted Device
> + * mapping, or an MMIO emulated in the Realm world).
> + *
> + * We can rely on the RIPAS value of the region to detect if a given region is
> + * protected.
> + *
> + *  RIPAS_DEV - A trusted device memory or a trusted emulated MMIO (in the Realm
> + *		world
> + *  RIPAS_RAM - Memory (RAM), protected by the RMM guarantees. (e.g., Firmware
> + *		reserved regions for data sharing).
> + *
> + *  RIPAS_DESTROYED is a special case of one of the above, where the host did
> + *  something without our permission and as such we can't do anything about it.
> + *
> + * The only case where something is emulated by the untrusted hypervisor or is
> + * backed by shared memory is indicated by RSI_RIPAS_EMPTY.
> + */
> +bool arm64_rsi_is_protected(phys_addr_t base, size_t size)
>   {
>   	enum ripas ripas;
>   	phys_addr_t end, top;
> @@ -101,18 +119,18 @@ bool __arm64_is_protected_mmio(phys_addr_t base, size_t size)
>   			break;
>   		if (WARN_ON(top <= base))
>   			break;
> -		if (ripas != RSI_RIPAS_DEV)
> +		if (ripas == RSI_RIPAS_EMPTY)
>   			break;
>   		base = top;
>   	}
>   
>   	return base >= end;
>   }
> -EXPORT_SYMBOL(__arm64_is_protected_mmio);
> +EXPORT_SYMBOL(arm64_rsi_is_protected);
>   
>   static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
>   {
> -	if (__arm64_is_protected_mmio(phys, size))
> +	if (arm64_rsi_is_protected(phys, size))
>   		*prot = pgprot_encrypted(*prot);
>   	else
>   		*prot = pgprot_decrypted(*prot);

