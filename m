Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8788424F47
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:08:31 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 128so17077640pga.1
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=btNV1F5raSfgVHS1/gKMO9RappBFKUG6No8ZOPbnTjE=;
        b=WnF/CAavVaQFZ6hu1mucTiUFMFRH07YS8pP+nQhN6HJJeWng0qN/pqcGUZWF8DF3YJ
         UKrrhCuT8pZe5efQKDQYbL4sl4O0d0Yq7dniUij9mlyoue48MfGSkAiZceOt6LH7Zyla
         DMmq4Zy98pWpB2nYorJEhV8afi41FbMNfLd98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btNV1F5raSfgVHS1/gKMO9RappBFKUG6No8ZOPbnTjE=;
        b=QWglLfoslBZ27ZECDBSXgtX81BSP2DauI9fCFp39UkN3jh6jFSl1ZQXn04osC53SDJ
         RCGaByCNlbAjettxYCm2L2LWLsr9rbiLGjnnwsuKvvTYcwRbmA3010VanzQreXsrRcLp
         1KRy8kGAyKGD80hBHVKdgm1IqImTO8PEscrIWjLVSbzNmBU4fQtxtfRXtDWvOwemA+1B
         KeQINns8/+O7/WCC0NNcdwtsALo13f1wvlgwcisUcV+E1gx0eJ5mIxXPuwrFwcX0IyIJ
         XRV8WuY1zAcJsYzTfjn9VdSsrqDvcYY2D6PN1V5whYOzlHGVL20ey21eD3y7Ot4GNs+e
         6kng==
X-Gm-Message-State: ACrzQf2rqG1sXVNT80Yo01/GKsb4OrK2gZRXJ1rZ+ubDyuuY5J72qxR0
	dYQzs2FNBTgWaYHT2dCDQozhAQ==
X-Google-Smtp-Source: AMsMyM50I03PG/OQ4Z3UbjQlDLWWsbg4/BuY9JFwssVj3kEUSn2BZVgoliMdNU8wDNVwlvCFhiI/zg==
X-Received: by 2002:a63:501f:0:b0:46f:a711:c455 with SMTP id e31-20020a63501f000000b0046fa711c455mr18062893pgb.402.1667416111214;
        Wed, 02 Nov 2022 12:08:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v20-20020a63f214000000b0045ff216a0casm4784265pgh.3.2022.11.02.12.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:08:30 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:08:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] scsi: elx: libefc: Fix second parameter type in state
 callbacks
Message-ID: <202211021208.055D396D8E@keescook>
References: <20221102161906.2781508-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102161906.2781508-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 09:19:06AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ctx->current_state = state;
>                                     ^ ~~~~~
>   drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           node->nodedb_state = state;
>                             ^ ~~~~~
>   drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' from 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
>                   pf = node->nodedb_state;
>                     ^ ~~~~~~~~~~~~~~~~~~
> 
>   drivers/scsi/elx/libefc/efc_device.c:455:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   node->nodedb_state = __efc_d_init;
>                                     ^ ~~~~~~~~~~~~
> 
>   drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>                   ctx->current_state = state;
>                                     ^ ~~~~~
> 
> The type of the second parameter in the prototypes of ->current_state()
> and ->nodedb_state() ('u32') does not match the implementations, which
> have a second parameter type of 'enum efc_sm_event'. Update the
> prototypes to have the correct second parameter type, clearing up all
> the warnings and CFI failures.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
