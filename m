Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A024F48
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:07:03 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id f63so863725pgc.2
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Al21TcPJt8to6DKIHKPsHPs63wTLg/3m3c5X1IY9ZVk=;
        b=OcMa2PXvffEHTQunOgnNyVVSveU1Xb65KX1gioYtZk3gy2NegHqZ67GKmvzpjPnDJl
         zKfuWdA2xd3gYCvHb+t/2yRIVb2JA+hl9J9vsDf3NoLYr2nWYglOAJ7O3AmVFD3BBhXm
         60sjC1gk9vHdyyZ1gOJyAbff5s4FGFzZCbOtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Al21TcPJt8to6DKIHKPsHPs63wTLg/3m3c5X1IY9ZVk=;
        b=47zLAxGZXUA99ZKmtZcMUhL7qjPzQ8RXSq30I/Yn1Oe5Ndk9Yb7UCKjcpmC+56xFnd
         HD7ZJyS6FS3ETiVK+SJJFEm0KcvQ8Ucy0IHNuXEiUL+7Qj6Ekwnm70EN8vKgW4dzbLZi
         weYRZSllxV2reGLa49uNS34c5ollbVGyZhMlY61CfV4LI4KsCc26IXPeEA1QirYl/PiR
         Nc3s73y4ADbMv8UFw24cd6zshBGzmlwZP3wszQJUdEa/QJsCN/fnAXcvFwyjajoLu8j7
         AQne+s0SatByeLGv/ZPdkn4dAkCWOT3tl5zSiXn5rs6/uNNFRd3ce0zhwxNzmuF33WQG
         TUGA==
X-Gm-Message-State: ACrzQf0WWMBnBjvNIOAlguB3DZy7F9R0CpdXrA2jryiVDBU183TzfYQs
	rqYcqu15ThKBN1QlXBpj5MFooA==
X-Google-Smtp-Source: AMsMyM7e7i+B4cU9w/Cyv/Fyf+gg4EoaUzMwpOjPVeEN10vhsy2lFnKC9AXyAPa+74dzy4vTvNDnfw==
X-Received: by 2002:a05:6a00:140d:b0:528:5a5a:d846 with SMTP id l13-20020a056a00140d00b005285a5ad846mr27168744pfu.9.1667416023443;
        Wed, 02 Nov 2022 12:07:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e64-20020a621e43000000b0056be7ac5261sm8822038pfe.163.2022.11.02.12.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:07:02 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:07:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sebastian Reichel <sre@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] HSI: ssi_protocol: Fix return type of ssip_pn_xmit()
Message-ID: <202211021207.8F7604C860@keescook>
References: <20221102160233.4042756-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160233.4042756-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 09:02:33AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/hsi/clients/ssi_protocol.c:1053:20: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit = ssip_pn_xmit,
>                             ^~~~~~~~~~~~
>   1 error generated.
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of ssip_pn_xmit() to
> match the prototype's to resolve the warning and CFI failure.
> Additionally, use the enum 'NETDEV_TX_OK' instead of a raw '0' for the
> return value of ssip_pn_xmit().
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
