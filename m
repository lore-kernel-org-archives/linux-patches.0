Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0642819924;
	Tue, 30 May 2023 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685472848; x=1717008848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0kulKMLy7Yg0yE/BDh7sWLThl83dTtSuMe48DHfeets=;
  b=IuL/bkgXQhAIh4IEZho/w9SWhQ+FaFChrwkMlTijfnPshTjOG85T5Qp6
   cdl7aMFd/VsA9RgQMxh6AxQoNz9bbZGbE0XEqPGH34ms2443Pe8dYiBlT
   3igrNBUAbhpV3+ZBGk9VUK5A4RUI7HL9EX8EOp8WmXLI0hoNpzgeCOb+z
   PsEnynsasNCHBsPfq2j93zKLVb51pdW3dOgXRsoM3rGFwc5Uc/+VvL0qW
   SyUAnOBFxUEr9z1kiOzG25EDVXlGX8zBs80hALvk28Fif6ew+mftDP4H1
   10n2gJJLtboa0lRpV7sj5Ae08Th+xw8QjViYxsf9wJmmR5zfsU74hxkfs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418504062"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418504062"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 11:54:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796381521"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="796381521"
Received: from amyachev-mobl3.ccr.corp.intel.com (HELO intel.com) ([10.252.53.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 11:54:04 -0700
Date: Tue, 30 May 2023 20:54:01 +0200
From: Andi Shyti <andi.shyti@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
	ndesaulniers@google.com, trix@redhat.com,
	andi.shyti@linux.intel.com, fei.yang@intel.com,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] drm/i915/gt: Fix second parameter type of pre-gen8
 pte_encode callbacks
Message-ID: <ZHZGSbiIG3PNAfCQ@ashyti-mobl2.lan>
References: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>
 <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-1-54501d598229@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-1-54501d598229@kernel.org>

Hi Nathan,

On Tue, May 30, 2023 at 11:24:38AM -0700, Nathan Chancellor wrote:
> When booting a kernel compiled with CONFIG_CFI_CLANG (kCFI), there is a
> CFI failure in ggtt_probe_common() when trying to call hsw_pte_encode()
> via an indirect call:
> 
>   [    5.030027] CFI failure at ggtt_probe_common+0xd1/0x130 [i915] (target: hsw_pte_encode+0x0/0x30 [i915]; expected type: 0xf5c1d0fc)
> 
> With kCFI, indirect calls are validated against their expected type
> versus actual type and failures occur when the two types do not match.
> 
> clang's -Wincompatible-function-pointer-types-strict can catch this at
> compile time but it is not enabled for the kernel yet:
> 
>   drivers/gpu/drm/i915/gt/intel_ggtt.c:1155:23: error: incompatible function pointer types assigning to 'u64 (*)(dma_addr_t, unsigned int, u32)' (aka 'unsigned long long (*)(unsigned int, unsigned int, unsigned int)') from 'u64 (dma_addr_t,
>   enum i915_cache_level, u32)' (aka 'unsigned long long (unsigned int, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ggtt->vm.pte_encode = iris_pte_encode;
>                                       ^ ~~~~~~~~~~~~~~~
>   drivers/gpu/drm/i915/gt/intel_ggtt.c:1157:23: error: incompatible function pointer types assigning to 'u64 (*)(dma_addr_t, unsigned int, u32)' (aka 'unsigned long long (*)(unsigned int, unsigned int, unsigned int)') from 'u64 (dma_addr_t,
>   enum i915_cache_level, u32)' (aka 'unsigned long long (unsigned int, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ggtt->vm.pte_encode = hsw_pte_encode;
>                                       ^ ~~~~~~~~~~~~~~
>   drivers/gpu/drm/i915/gt/intel_ggtt.c:1159:23: error: incompatible function pointer types assigning to 'u64 (*)(dma_addr_t, unsigned int, u32)' (aka 'unsigned long long (*)(unsigned int, unsigned int, unsigned int)') from 'u64 (dma_addr_t,
>   enum i915_cache_level, u32)' (aka 'unsigned long long (unsigned int, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ggtt->vm.pte_encode = byt_pte_encode;
>                                       ^ ~~~~~~~~~~~~~~
>   drivers/gpu/drm/i915/gt/intel_ggtt.c:1161:23: error: incompatible function pointer types assigning to 'u64 (*)(dma_addr_t, unsigned int, u32)' (aka 'unsigned long long (*)(unsigned int, unsigned int, unsigned int)') from 'u64 (dma_addr_t,
>   enum i915_cache_level, u32)' (aka 'unsigned long long (unsigned int, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ggtt->vm.pte_encode = ivb_pte_encode;
>                                       ^ ~~~~~~~~~~~~~~
>   drivers/gpu/drm/i915/gt/intel_ggtt.c:1163:23: error: incompatible function pointer types assigning to 'u64 (*)(dma_addr_t, unsigned int, u32)' (aka 'unsigned long long (*)(unsigned int, unsigned int, unsigned int)') from 'u64 (dma_addr_t,
>   enum i915_cache_level, u32)' (aka 'unsigned long long (unsigned int, enum i915_cache_level, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ggtt->vm.pte_encode = snb_pte_encode;
>                                       ^ ~~~~~~~~~~~~~~
>   5 errors generated.
> 
> In this case, the pre-gen8 pte_encode functions have a second parameter
> type of 'enum i915_cache_level' whereas the function pointer prototype
> in 'struct i915_address_space' expects a second parameter type of
> 'unsigned int'.
> 
> Update the second parameter of the callbacks and the comment above them
> noting that these statements are still valid, which matches other
> functions and files, to clear up the kCFI failures at run time.
> 
> Fixes: 9275277d5324 ("drm/i915: use pat_index instead of cache_level")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

That's correct!

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks,
Andi
