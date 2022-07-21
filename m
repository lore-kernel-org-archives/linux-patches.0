Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B863C0B;
	Thu, 21 Jul 2022 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658406327; x=1689942327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CCvF/jQA8SnTIe9VczL2VpuM9VE4xYLEYmDwOPJyh48=;
  b=cp7/v8x8B8B2ecY4wMDNAS2whdRHpm0ylJS6zpR5sSWRsP+i8zsFRUIX
   d6XLfNeCHpFQ0LIfjnTJURvQPalgwBkI72WGKqMCdX/H69Q7FBJfxnsFQ
   awvz+nO+1Z0gPzR8IstNaFTZQ+dXxz6YoEhfxy/e9Po5mgUYh1xIB1kLk
   9zNdSjf7zx55cnRmmpvKIxS9DIafmGnWowWz87vwaHjWTxdI1PWzErt7R
   G3ps3cYwYt0lDi+Ej3TzuN//l4Ig83kJGFdchK55S0WMEu40bZBMV/GtW
   LZQUzRrRdZQVxhj6bFaRAv3wUSJYo/mOv/AdUz0jfu+McZQQgWmfLXKTM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="266805705"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="266805705"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 05:25:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="656721554"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.99.249.149]) ([10.99.249.149])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 05:25:22 -0700
Message-ID: <c00a8b5e-6def-971a-d4f2-cd65c95fe430@linux.intel.com>
Date: Thu, 21 Jul 2022 14:25:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ASoC: Intel: avs: Mark avs_path_module_type_create() as
 noinline
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Cezary Rojewski <cezary.rojewski@intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Liam Girdwood <liam.r.girdwood@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, Tom Rix <trix@redhat.com>,
 llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20220720185228.3182663-1-nathan@kernel.org>
From: =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?=
 <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <20220720185228.3182663-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/20/2022 8:52 PM, Nathan Chancellor wrote:
> When building ARCH=arm64 allmodconfig with clang, there is a warning
> about high stack usage in avs_path_create(), which breaks the build due
> to CONFIG_WERROR=y:
> 
>    sound/soc/intel/avs/path.c:815:18: error: stack frame size (2176) exceeds limit (2048) in 'avs_path_create' [-Werror,-Wframe-larger-than]
>    struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
>                     ^
>    1 error generated.
> 
> This warning is also visible with allmodconfig on other architectures.
> The minimum set of configs that triggers this on top of ARCH=arm64
> allnoconfig:
> 
>    CONFIG_COMPILE_TEST=y
>    CONFIG_FORTIFY_SOURCE=y
>    CONFIG_KASAN=y
>    CONFIG_PCI=y
>    CONFIG_SOUND=y
>    CONFIG_SND=y
>    CONFIG_SND_SOC=y
>    CONFIG_SND_SOC_INTEL_AVS=y
> 
> When CONFIG_FORTIFY_SOURCE is enabled, memcmp() (called from
> guid_equal()) becomes a wrapper to do compile time checking, which
> interacts poorly with inlining plus CONFIG_KASAN=y.
> 
> With ARCH=arm64 allmodconfig + CONFIG_KASAN=n + CONFIG_FRAME_WARN=128,
> the stack usage is much better:
> 
>    sound/soc/intel/avs/path.c:815:18: warning: stack frame size (624) exceeds limit (128) in 'avs_path_create' [-Wframe-larger-than]
>    struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
>                     ^
>    sound/soc/intel/avs/path.c:873:5: warning: stack frame size (144) exceeds limit (128) in 'avs_path_bind' [-Wframe-larger-than]
>    int avs_path_bind(struct avs_path *path)
>        ^
>    2 warnings generated.
> 
> To avoid this warning, mark avs_path_module_type_create() as
> noinline_for_stack, which redistributes the stack usage across multiple
> functions, regardless of CONFIG_KASAN.
> 
> With ARCH=arm64 allmodconfig + CONFIG_FRAME_WARN=128, the warnings show:
> 
>    avs_path_create():             192
>    avs_path_bind():               272
>    avs_path_module_type_create(): 416
>    avs_mux_create():              160
>    avs_updown_mix_create():       160
>    avs_aec_create():              176
>    avs_asrc_create():             144
> 
> With ARCH=arm64 allmodconfig + CONFIG_FRAME_WARN=128 + CONFIG_KASAN=n,
> the warnings show:
> 
>    avs_path_create():             192
>    avs_path_bind():               144
>    avs_path_module_type_create(): 416
>    avs_mux_create():              176
>    avs_updown_mix_create():       176
>    avs_src_create():              144
>    avs_aec_create():              192
>    avs_asrc_create():             144
>    avs_wov_create():              144
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1642
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   sound/soc/intel/avs/path.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
> index 3d46dd5e5bc4..ec2aa0001f91 100644
> --- a/sound/soc/intel/avs/path.c
> +++ b/sound/soc/intel/avs/path.c
> @@ -449,7 +449,8 @@ static int avs_modext_create(struct avs_dev *adev, struct avs_path_module *mod)
>   	return ret;
>   }
>   
> -static int avs_path_module_type_create(struct avs_dev *adev, struct avs_path_module *mod)
> +static noinline_for_stack int avs_path_module_type_create(struct avs_dev *adev,
> +							  struct avs_path_module *mod)
>   {
>   	const guid_t *type = &mod->template->cfg_ext->type;
>   
> 
> base-commit: ff6992735ade75aae3e35d16b17da1008d753d28

Not a fan of this.

My first question would be what clang does differently in this 
configuration (ARM) than in all other configurations (x86, etc.) and gcc.

Overall as evidenced by:
 >    CONFIG_COMPILE_TEST=y
this is test only and this commit doesn't fix anything for x86 this 
driver targets.

Based on description in message and in github link:
Looking at avs_path_module_type_create() it uses guid_equal() which is 
marked as inline, but is just a wrapper around memcmp(), which in case 
of fortify is still marked as inline... memcmp itself has 2 size_t 
variables for performing fortify check... no matter how I calculate, it 
shouldn't go above stack size, unless clang decides to also inline all 
calls to static avs_xxx_create functions. They are not marked as inline 
or noinline, so in theory compiler is free to do whatever it wants, but 
apparently it goes wrong way? Of course the above may be wrong, because 
I just analyzed code, not real output of clang.

Anyway it is probably ok, to do this, as while it needs to be fast 
module creation is not really time critical, and some time will be spend 
to communicate with DSP instead of calculating things, but still wonder 
if there isn't something that can be done on compiler side...

