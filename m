Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8F624F48
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:10:02 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id gw22so4209789pjb.3
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7QvCq6L3fEg9Cb7B3ynZhgXWytU1povf3mcN4zKG3vA=;
        b=j5EjpKnwFpGPWI54aFs6SpTbFSsqGrKfuq+quda/NQZoYD0gSEoywSP5eZRvzSaLkd
         FIVg2ih72vOWT+tdVCFzm8I/hsVNdz3cceLgJed1s8B/lohVui3bMAl6Ct3YSE8+sjMH
         moYKR7weCZMQMj+Vxx6AIBckm1j6znndEtlOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QvCq6L3fEg9Cb7B3ynZhgXWytU1povf3mcN4zKG3vA=;
        b=pBLH/RtduIzRlkHVVhXUR0P0loqa1M87EP1YRq/L4Rpo59kJPyShBTbrdkdMjO/Mvl
         26tM9BYWURqbln2gjIteab5PPWJlFn7AtWVrSktKRBqJbi5FyzMuOtSn8ali6efwVNYY
         htKio3L838nXL+lhlFJ6aO5gqs/VJ9Y0f8vzdq46yQ/2xYwPGQAggrjs6W7TA9v+TfKV
         RXzQuAzBL2ZydceA2KNHjB6FOsC92tOCZhxzJC7yXMXTYcXaUE0Zg/Jr1nR/0SmNJdyw
         1cKJwBsMgkooD0KL3dSHHgKzf0KgxHM2fE+a2SiBB8aOC4ZVUWLd7nlFljzxCGInYPR+
         sU2g==
X-Gm-Message-State: ACrzQf3otd+vXOz6AoTrJvf9j7ZISnwqGJYlELzVdwecBKUrCci4J+BR
	SINtNqZEJawm/1vN90PRi+/P+A==
X-Google-Smtp-Source: AMsMyM52XaRrMFEhUeLc+WxTnLGYyGfkUIj9N2SfCRgaTGhCP6YDMR3160Jr/KuOCNQ2aEx0wIyLkg==
X-Received: by 2002:a17:902:f7d4:b0:188:505b:529 with SMTP id h20-20020a170902f7d400b00188505b0529mr997600plw.173.1667416201882;
        Wed, 02 Nov 2022 12:10:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p68-20020a625b47000000b0056b9c2699cesm8742935pfb.46.2022.11.02.12.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:10:01 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:10:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 3/3] s390/lcs: Fix return type of lcs_start_xmit()
Message-ID: <202211021209.4CDE279A2B@keescook>
References: <20221102163252.49175-1-nathan@kernel.org>
 <20221102163252.49175-3-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102163252.49175-3-nathan@kernel.org>

On Wed, Nov 02, 2022 at 09:32:52AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/s390/net/lcs.c:2090:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = lcs_start_xmit,
>                                     ^~~~~~~~~~~~~~
>   drivers/s390/net/lcs.c:2097:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = lcs_start_xmit,
>                                     ^~~~~~~~~~~~~~
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of lcs_start_xmit() to
> match the prototype's to resolve the warning and potential CFI failure,
> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
