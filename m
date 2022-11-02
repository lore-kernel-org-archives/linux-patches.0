Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674124F48
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:09:51 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id g24so17492239plq.3
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rceJbOCflyPx+m+jp0CiAofr11KjGzc/BosMfyINF6Q=;
        b=nTYtdAKQoQK2ASSwLeh5CjtoKDvCTGPFgwhrrlZGkl2cUuG0T1larCOBHjiCgaxcl3
         mR5tmneD4Ly087+iJQrS+9FP1EuHQvmT50wZQm/dGpkkC7/4t0AOPCgKmEPjs3N90ViO
         ZDcJ6MKXWBsJMUwgYDBLNZZT7WVhJVj5MbCXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rceJbOCflyPx+m+jp0CiAofr11KjGzc/BosMfyINF6Q=;
        b=Pn7/4V1Fdvqjrtu6SOchAhCAy2eY5o3ySe5M5PK5kpA+Yqz+zpCpWQxqzqcvpkaoGv
         1sHd/WdeDrCD3IX2kucgBEYVMaKkzwGmPVGIHl+lx+V6IM5UitYtSdqvZfR2fYevJFzg
         vExynk7+ADRK4+IIHLzjtiEqXJ5YUSO3oqyYjuvGpWCpjaPWgPSJALI+pxg669muJeKB
         sq0amcqkJ2Q+eGOFzxQypf1PkpRrxhFIguuQ4io2/h5FspmOAFn7JbBzVBtqf/HHFfqN
         XQUAM/xQx48ZeDVojVwx8T5PfAurqp1rvFdkyEpEdkxPo8De2WuiUOaNXfZGrdKn4tNd
         KSQA==
X-Gm-Message-State: ACrzQf144n5dYcBnTT7n26ODtAVYH+2xlVNiaikujT7pT9qtlbkNqrhb
	GMFzx5iFBS/7dAmhuH0hN7nrgA==
X-Google-Smtp-Source: AMsMyM5iaPa8jHtaXe8TTihPGNBmjZOrJkjawt950HiY8oyo6JC1DPwtgOaOwWhqRWTHHvmX+izChA==
X-Received: by 2002:a17:903:1303:b0:186:969d:97cf with SMTP id iy3-20020a170903130300b00186969d97cfmr25743179plb.17.1667416190610;
        Wed, 02 Nov 2022 12:09:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902ce8300b001782a6fbcacsm8698407plg.101.2022.11.02.12.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:09:50 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:09:49 -0700
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
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Message-ID: <202211021209.276A8BA@keescook>
References: <20221102163252.49175-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102163252.49175-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/s390/net/ctcm_main.c:1064:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = ctcm_tx,
>                                     ^~~~~~~
>   drivers/s390/net/ctcm_main.c:1072:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = ctcmpc_tx,
>                                     ^~~~~~~~~
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of ctc{mp,}m_tx() to
> match the prototype's to resolve the warning and potential CFI failure,
> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
