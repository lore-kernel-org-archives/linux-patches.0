Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E92D210B;
	Fri, 13 May 2022 10:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652436537; x=1683972537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5i3oSmoCYG0z99aFLyfO1/Lffb6G3ID6DMGfB1vnRWE=;
  b=bYwfi9PgG0zZjR8amHbNMmpxp71eY78q2jmG+7hjGJJEZpxYugJTEPtI
   28jyicQ0LhAnqA+PNhix6W9CXSgQILNVdcRkAyGvea1fKxg/N516GhNjb
   ovA5DDa5cKCbHUmooLWnuuInLw9h0PqFK3i48SVOYEUyfv6bRS0DtL6wT
   lh8WENg1WKLa/rNu5iNtqKgHz8Ao4YLZiTz0Vg64X+8iccGc8ptXRcYwM
   +PU/RIVeys7bV8eHkwZEmsI0f5FZxdvJpjmcuQRHBR4slYSFdqpqoIX0J
   ZnT0Gb7Ztn7UWxGnFaII22ZZxmFTxZVk8s9fDM8ETTT5AftBcq5494bW4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270404749"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270404749"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 03:08:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="554167026"
Received: from cpazx-mobl.ger.corp.intel.com (HELO [10.213.209.239]) ([10.213.209.239])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 03:08:52 -0700
Message-ID: <d7fc4f81-1a04-3633-5d6b-ebc35acb5c4a@linux.intel.com>
Date: Fri, 13 May 2022 11:08:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] drm/i915: Fix CFI violation with show_dynamic_id()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Kees Cook
 <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Tom Rix <trix@redhat.com>, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20220512211704.3158759-1-nathan@kernel.org>
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220512211704.3158759-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/05/2022 22:17, Nathan Chancellor wrote:
> When an attribute group is created with sysfs_create_group(), the
> ->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
> callback to kobj_attr_show(). kobj_attr_show() uses container_of() to
> get the ->show() callback from the attribute it was passed, meaning the
> ->show() callback needs to be the same type as the ->show() callback in
> 'struct kobj_attribute'.
> 
> However, show_dynamic_id() has the type of the ->show() callback in
> 'struct device_attribute', which causes a CFI violation when opening the
> 'id' sysfs node under drm/card0/metrics. This happens to work because
> the layout of 'struct kobj_attribute' and 'struct device_attribute' are
> the same, so the container_of() cast happens to allow the ->show()
> callback to still work.
> 
> Change the type of show_dynamic_id() to match the ->show() callback in
> 'struct kobj_attributes' and update the type of sysfs_metric_id to
> match, which resolves the CFI violation.
> 
> Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Merged to drm-intel-gt-next, thanks for the fix and reviews!

Regards,

Tvrtko

> ---
>   drivers/gpu/drm/i915/i915_perf.c       | 4 ++--
>   drivers/gpu/drm/i915/i915_perf_types.h | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 0a9c3fcc09b1..1577ab6754db 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4050,8 +4050,8 @@ static struct i915_oa_reg *alloc_oa_regs(struct i915_perf *perf,
>   	return ERR_PTR(err);
>   }
>   
> -static ssize_t show_dynamic_id(struct device *dev,
> -			       struct device_attribute *attr,
> +static ssize_t show_dynamic_id(struct kobject *kobj,
> +			       struct kobj_attribute *attr,
>   			       char *buf)
>   {
>   	struct i915_oa_config *oa_config =
> diff --git a/drivers/gpu/drm/i915/i915_perf_types.h b/drivers/gpu/drm/i915/i915_perf_types.h
> index 473a3c0544bb..05cb9a335a97 100644
> --- a/drivers/gpu/drm/i915/i915_perf_types.h
> +++ b/drivers/gpu/drm/i915/i915_perf_types.h
> @@ -55,7 +55,7 @@ struct i915_oa_config {
>   
>   	struct attribute_group sysfs_metric;
>   	struct attribute *attrs[2];
> -	struct device_attribute sysfs_metric_id;
> +	struct kobj_attribute sysfs_metric_id;
>   
>   	struct kref ref;
>   	struct rcu_head rcu;
> 
> base-commit: 7ecc3cc8a7b39f08eee9aea7b718187583342a70
