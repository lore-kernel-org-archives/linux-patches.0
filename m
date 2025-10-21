Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589C2877C3;
	Tue, 21 Oct 2025 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061101; cv=none; b=ZFpt+tLViCObv9BdwkyvI1slmVA31dsk7VUUkSHldLe1vGfia2hRO6n3vdlzIMZd/85JaumqC2UNuJElpnyXKZt5D7dQ6CtnHhfpGhXVWHCdk5fo5LdeaEuU+7RVRM4GRK8qHTOFOp7zEZYRTbH+cI7nTCDQXVw4Fsp4Xehtkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061101; c=relaxed/simple;
	bh=5etIGE2OHwhU92WTs3d63na2/ThIShYOmX9X+eSxnPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyxPLO1PE9pNFhkgUcogZiP7RYaOcCC3nLpNU+FCvbYJGkzJdcfpxsdOvdZqxi3QpOx5bmPbE5GPJT79OEWmLcltplLs4CdmwP/N3RzmzPNb/E5iSDgOiNIrgrGum6VQkt1xvtLarFP5V5riceayp74EjIxg2OEBJJFNr40SVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4rKw2KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4rKw2KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07788C4CEF1;
	Tue, 21 Oct 2025 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761061101;
	bh=5etIGE2OHwhU92WTs3d63na2/ThIShYOmX9X+eSxnPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m4rKw2KPUhHxUczR8vbiOSJoBoQ5rS9af/XsuLMCp/2VZFoL7Y9lfJDsyyQEImdmo
	 /Me0t9Sivpgbdjtvmy7EvFWt5ka4MSdKWpXsE+ULNAfyOnxkbIuZx3Hy+y0akCt3Jt
	 OFJPcU3sKOvPyE/0BGk4pc4iQnUPjkfDXl3dSZHMfxe137oHVEmd76upbDJowj/xEr
	 goKe/vZYgmkouZzUCqod10EYUAw7tgja2BqA332rBIPw1lxrN4XZVBPYL3k0Cws1BT
	 L7nBFCe9oP7ye2b+EcBL50ewY2cxMBd1aMVcNvDY80BwEkjsCrSGBqF0MP2pATCxgF
	 Qhwycwh2fj7xA==
Date: Tue, 21 Oct 2025 11:38:19 -0400
From: Sasha Levin <sashal@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH AUTOSEL 6.17-6.16] arm64: realm: ioremap: Allow mapping
 memory as encrypted
Message-ID: <aPeo6wkISV_rH4Kc@laps>
References: <20251002153025.2209281-1-sashal@kernel.org>
 <20251002153025.2209281-8-sashal@kernel.org>
 <1f47887b-90d5-425c-b80f-9fa8855a6837@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f47887b-90d5-425c-b80f-9fa8855a6837@arm.com>

On Thu, Oct 02, 2025 at 05:43:18PM +0100, Suzuki K Poulose wrote:
>Hello !
>
>On 02/10/2025 16:29, Sasha Levin wrote:
>>From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>>[ Upstream commit fa84e534c3ec2904d8718a83180294f7b5afecc7 ]
>>
>>For ioremap(), so far we only checked if it was a device (RIPAS_DEV) to choose
>>an encrypted vs decrypted mapping. However, we may have firmware reserved memory
>>regions exposed to the OS (e.g., EFI Coco Secret Securityfs, ACPI CCEL).
>>We need to make sure that anything that is RIPAS_RAM (i.e., Guest
>>protected memory with RMM guarantees) are also mapped as encrypted.
>>
>>Rephrasing the above, anything that is not RIPAS_EMPTY is guaranteed to be
>>protected by the RMM. Thus we choose encrypted mapping for anything that is not
>>RIPAS_EMPTY. While at it, rename the helper function
>>
>>   __arm64_is_protected_mmio => arm64_rsi_is_protected
>>
>>to clearly indicate that this not an arm64 generic helper, but something to do
>>with Realms.
>>
>>Cc: Sami Mujawar <sami.mujawar@arm.com>
>>Cc: Will Deacon <will@kernel.org>
>>Cc: Catalin Marinas <catalin.marinas@arm.com>
>>Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
>>Cc: Steven Price <steven.price@arm.com>
>>Reviewed-by: Gavin Shan <gshan@redhat.com>
>>Reviewed-by: Steven Price <steven.price@arm.com>
>>Tested-by: Sami Mujawar <sami.mujawar@arm.com>
>>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>Signed-off-by: Will Deacon <will@kernel.org>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>
>>LLM Generated explanations, may be completely bogus:
>
>Indeed, some are clearly incorrect.
>
>>
>>Based on my comprehensive analysis of this commit, I can now provide my
>>determination.
>>
>>## Analysis Summary
>>
>>### Code Change Analysis
>>
>>The commit makes a **critical logic change** in
>>`arch/arm64/kernel/rsi.c:104`:
>>
>>**Before**: `if (ripas != RSI_RIPAS_DEV) break;`
>>- Only returns true if **all** regions are RIPAS_DEV (device memory)
>>- Other states (RIPAS_RAM, RIPAS_DESTROYED) cause early exit → mapped as
>>   **decrypted**
>>
>>**After**: `if (ripas == RSI_RIPAS_EMPTY) break;`
>>- Returns true for RIPAS_RAM, RIPAS_DESTROYED, and RIPAS_DEV
>>- Only RIPAS_EMPTY (unprotected/shared) regions are mapped as
>>   **decrypted**
>>
>>### Problem Being Fixed
>>
>>The original implementation from commit 371589437616f (Oct 2024) only
>>encrypted RIPAS_DEV regions. However, **firmware-reserved memory
>>regions** use RIPAS_RAM state:
>>
>>- **EFI Coco Secret Securityfs** areas
>>- **ACPI CCEL** (Confidential Computing Event Log) tables
>>
>>Without this fix, these RIPAS_RAM regions are incorrectly mapped with
>>`pgprot_decrypted()`, which sets `PROT_NS_SHARED`, making them
>
>The Realm would have mapped them as decrypted and might have consumed
>untrusted information from (a malicious) hypervisor
>
>>**accessible to the untrusted hypervisor**.
>
>No, hypervisor doesn't get access to the protected data.
>
>>
>>### Security Impact
>>
>>This is a **security and data integrity bug**:
>>1. **Confidential data leakage**: Hypervisor can read protected firmware
>>    secrets
>
>Wrong
>
>>2. **Data corruption**: Hypervisor can modify what should be protected
>>    memory
>
>Absolutely NO
>
>>3. **Violation of ARM CCA guarantees**: Breaks confidential computing
>>    promises
>
>Not really. The Guest could consume "untrusted" data, thats the only
>violation here.

Thanks for the review! I'll drop it.

-- 
Thanks,
Sasha
