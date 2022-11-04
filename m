Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C11849D
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 19:16:59 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id p12so263435plq.4
        for <patches@lists.linux.dev>; Fri, 04 Nov 2022 12:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwf9cNrPS5Rc31CwAis9I5k42+w3JYRmcdVU7DdGiu4=;
        b=N6TFAIctV4hgpYE38ZyX/b+J/o7aIK0+cR8rBnXD24Pic0BLxQcHU237p09FZeLrX9
         6yj0AmbLE6V1HcPmWLID7VETZlaV+M9dng3VlpfIN3WNRO3xTYAAiE2momLGKWMNEkhQ
         G4VT1cqNjnQ6Oe4tlUOO1WbSzvJVPgeHtyRA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwf9cNrPS5Rc31CwAis9I5k42+w3JYRmcdVU7DdGiu4=;
        b=SgKe65cVtPlBaFxen2iOq8UH47ugMaLC4ObffjHFLeWFcLfp2pC+jG5OQmiz7af+cM
         ZEZHg4/IRlbOZ91Ra7HNuraiZIJuEXVH/JnIOm1QupG/m5JAML027W9+4wiRSsLQF2TW
         1fmlpDe1iHGgGBP+sEmPjgX/oU/B5YjO19vKM5Jf904KASzmmaZa+bobDDJ2yoveQTj/
         XBw8/RQVreIpfob7JQIsfvtTjSisGy/YC6tg+fDg+qUPYfNH5VV6MYE1mb30frX1N5nn
         O0uEaGlAWfRm4pLSzcwqJwVbee6ezK0ZXFc7vcDwGLb4QqdDi4Q4Mk+to8gzWUGvP4O3
         RMeg==
X-Gm-Message-State: ACrzQf0wXp92Jn6aC5HYZLAUaQrAb70ZFk+bfF0Xi+yacwqeAZ21IPjF
	mUgNMJBojjzn1mPC3s22d6rOng==
X-Google-Smtp-Source: AMsMyM723xbKuDkCJ7wXLAB+SxhuL5RfQWSJSVDW6OhzUsKHC44G/DKWPnsbHUAvL7N0/sG7WSCPRg==
X-Received: by 2002:a17:902:8693:b0:17a:f71:98fd with SMTP id g19-20020a170902869300b0017a0f7198fdmr37053238plo.25.1667589419426;
        Fri, 04 Nov 2022 12:16:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e38-20020a631e26000000b0046497308480sm74704pge.77.2022.11.04.12.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 12:16:58 -0700 (PDT)
Date: Fri, 4 Nov 2022 12:16:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH net-next] net: ethernet: renesas: Fix return type of
 rswitch_start_xmit()
Message-ID: <202211041216.AEE2A8A353@keescook>
References: <20221103220032.2142122-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103220032.2142122-1-nathan@kernel.org>

On Thu, Nov 03, 2022 at 03:00:32PM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/net/ethernet/renesas/rswitch.c:1533:20: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit = rswitch_start_xmit,
>                           ^~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of rswitch_start_xmit()
> to match the prototype's to resolve the warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
