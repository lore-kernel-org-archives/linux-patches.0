Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43D199EF;
	Thu, 20 Jul 2023 08:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689842592; x=1721378592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=di9h+46ohxqoEGRZiCGzN9lOQ5UWLl/5Mvmelef0gBg=;
  b=Ip7OJqiTK7jPtNhY75k+qypLcxQijaY6SA2oRrbQt9WPIb+Vo09OK5k9
   T6OIyCupR6wEsUWg69Gd7EK1firwbHAQHFHtVlBNsfjp2DK4gKrbwiPDB
   c7BrbUQNEz3XpvHQSSrV1tUDYjE9BHi8vWd16d08Bxju8XMyr00+787QV
   yKSchrHf1sd+e2xvjVjM6lEodMULGC0G0Jfv9636wWB52fhVm/J2875ut
   z+w77MhG51mqxvI27I2+ZLRQ9wYskX1gSXqNwuWB4mUWZL+M6mUhysy33
   chxvk0sALwXV3xRi3p8JtnpK6umx2xz0fCgAPxsRtz5mo83Ch2LgV64Hq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="365558096"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="365558096"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 01:43:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="718317662"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="718317662"
Received: from ctuohy-mobl1.ger.corp.intel.com (HELO [10.213.193.21]) ([10.213.193.21])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 01:43:07 -0700
Message-ID: <1a2aeca6-12f7-6316-c6e2-8474fd17255e@linux.intel.com>
Date: Thu, 20 Jul 2023 09:43:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] drm/i915: Avoid -Wconstant-logical-operand in
 nsecs_to_jiffies_timeout()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, jani.nikula@linux.intel.com,
 joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, emma@anholt.net,
 mwen@igalia.com
Cc: ndesaulniers@google.com, justinstitt@google.com, trix@redhat.com,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-0-36ed8fc8faea@kernel.org>
 <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-2-36ed8fc8faea@kernel.org>
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-2-36ed8fc8faea@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 18/07/2023 22:44, Nathan Chancellor wrote:
> A proposed update to clang's -Wconstant-logical-operand to warn when the
> left hand side is a constant shows the following instance in
> nsecs_to_jiffies_timeout() when NSEC_PER_SEC is not a multiple of HZ,
> such as CONFIG_HZ=300:
> 
>    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: warning: use of logical '&&' with constant operand [-Wconstant-logical-operand]
>      189 |         if (NSEC_PER_SEC % HZ &&
>          |             ~~~~~~~~~~~~~~~~~ ^
>    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: note: use '&' for a bitwise operation
>      189 |         if (NSEC_PER_SEC % HZ &&
>          |                               ^~
>          |                               &
>    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: note: remove constant to silence this warning
>    1 warning generated.
> 
> Turn this into an explicit comparison against zero to make the
> expression a boolean to make it clear this should be a logical check,
> not a bitwise one.

So -Wconstant-logical-operand only triggers when it is a constant but 
not zero constant? Why does that make sense is not a kludge to avoid too 
much noise?

Personally, it all feels a bit over the top as a warning,  since code in 
both cases should optimise away. And we may end up papering over it if 
it becomes a default.

Then again this patch IMO does make the code more readable, so I am 
happy to take this one via our tree. Or either give ack to bring it in 
via drm-misc-next:

Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Let me know which route works best.

Regards,

Tvrtko

> Link: https://reviews.llvm.org/D142609
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_wait.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_wait.c b/drivers/gpu/drm/i915/gem/i915_gem_wait.c
> index 4a33ad2d122b..d4b918fb11ce 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_wait.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_wait.c
> @@ -186,7 +186,7 @@ i915_gem_object_wait(struct drm_i915_gem_object *obj,
>   static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
>   {
>   	/* nsecs_to_jiffies64() does not guard against overflow */
> -	if (NSEC_PER_SEC % HZ &&
> +	if ((NSEC_PER_SEC % HZ) != 0 &&
>   	    div_u64(n, NSEC_PER_SEC) >= MAX_JIFFY_OFFSET / HZ)
>   		return MAX_JIFFY_OFFSET;
>   
> 
