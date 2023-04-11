Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F4128EE
	for <patches@lists.linux.dev>; Tue, 11 Apr 2023 15:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0237DC433EF;
	Tue, 11 Apr 2023 15:17:38 +0000 (UTC)
Date: Tue, 11 Apr 2023 16:17:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 1/6] module: fix kmemleak annotations for non init ELF
 sections
Message-ID: <ZDV6DzePHI3KLISY@arm.com>
References: <20230405022702.753323-1-mcgrof@kernel.org>
 <20230405022702.753323-2-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405022702.753323-2-mcgrof@kernel.org>

On Tue, Apr 04, 2023 at 07:26:57PM -0700, Luis Chamberlain wrote:
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 5cc21083af04..d8bb23fa6989 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2233,11 +2233,23 @@ static int move_module(struct module *mod, struct load_info *info)
>  		ptr = module_memory_alloc(mod->mem[type].size, type);
>  
>  		/*
> -		 * The pointer to this block is stored in the module structure
> -		 * which is inside the block. Just mark it as not being a
> -		 * leak.
> +		 * The pointer to these blocks of memory are stored on the module
> +		 * structure and we keep that around so long as the module is
> +		 * around. We only free that memory when we unload the module.
> +		 * Just mark them as not being a leak then. The .init* ELF
> +		 * sections *do* get freed after boot so we treat them slightly
> +		 * differently and only grey them out -- they work as typical
> +		 * memory allocations which *do* eventually get freed.
>  		 */
> -		kmemleak_ignore(ptr);
> +		switch (type) {
> +		case MOD_INIT_TEXT: /* fallthrough */
> +		case MOD_INIT_DATA: /* fallthrough */
> +		case MOD_INIT_RODATA: /* fallthrough */
> +			kmemleak_ignore(ptr);
> +			break;
> +		default:
> +			kmemleak_not_leak(ptr);
> +		}

This works as well but if you want to keep it simple, just call
kmemleak_not_leak() in all cases. When freeing the init sections, they
would be removed from the kmemleak tracing anyway.

-- 
Catalin
