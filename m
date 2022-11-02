Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B624724F47
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:08:01 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so2758995pjl.3
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vw1PeYfYrmcqxsdFm8vSKj6yNnyKJrjXBsCDkZ8l7vk=;
        b=XNJLSicRjEN8rmTBOFq4nZjBNIwb3bfbU77PQOf7hvq7/KsYyf4RBy+5zc2UAJlGhc
         TMgcRxRmNxosn3VWIIRRCpYt9DoDGwFFE5H6e1NdTJGJbA1bAcnhH8n7lpiKmKZMfShp
         b+fHS0RnxesbdRP/UtHxZ3cWF55CBAMmG0h1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vw1PeYfYrmcqxsdFm8vSKj6yNnyKJrjXBsCDkZ8l7vk=;
        b=UyeVk9A0LuZy2caxALkTGM/uTIMavLr2oKp+u/QtftIt5t/iPZ36bmg5ikZVSp2AqF
         tvJXX/NnQwQz7gxxUXkzAkAtXyZ2s/ypjaSrq8zK/IGcJWkDRjwlW0bd4W+fURnl/zX1
         BmkX+JNSVFtkInI4u5Jq6zugUQyUalkTGjhivrGzEd38b29sNGUdI7EpPK7Ucbgbh0xe
         nU5Uq8dI90TS7YwjrUsu7mH+Mh9Y8nJyc+hnPeBd1D4ym0n2mWzdw2Rofm6eeXkDuFOH
         eKr9zYjUhkKmwXMXLi1CPEj6qH7YtlHpaWdIHInR46XHGGYMNdXHb1r/qP/VHHGOdS4j
         hpQg==
X-Gm-Message-State: ACrzQf2O1YifwKExaZS/64pnBCwkGm08MmziHIrXSQn6arUJ3qsSEj+S
	bH7HZsJSsYCczfPOlal3Xf0lBA==
X-Google-Smtp-Source: AMsMyM7I9I7fudr6NNXqLACM4CekbYXQHH71Q92LDGS3KIiSUx5BXYQkZEVhg3knX05G924q3TSVHA==
X-Received: by 2002:a17:90a:3947:b0:213:ebeb:2cf3 with SMTP id n7-20020a17090a394700b00213ebeb2cf3mr16561908pjf.9.1667416081215;
        Wed, 02 Nov 2022 12:08:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h23-20020aa796d7000000b0056d2e716e01sm8015248pfq.139.2022.11.02.12.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:08:00 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:08:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-hams@vger.kernel.org, netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] hamradio: baycom_epp: Fix return type of
 baycom_send_packet()
Message-ID: <202211021207.E41AE398@keescook>
References: <20221102160610.1186145-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160610.1186145-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 09:06:10AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/net/hamradio/baycom_epp.c:1119:25: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit      = baycom_send_packet,
>                                 ^~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of baycom_send_packet()
> to match the prototype's to resolve the warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Heh, this one was already using the enum for the argument to "return",
too. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
