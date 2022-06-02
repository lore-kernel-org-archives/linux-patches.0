Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45D03D65
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 20:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D2C385A5
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 20:18:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y9AjzC6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1654201097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4X9RFE7u/m9m1zpXuX5bcZxKzb6oraJPXpGtx/XO9Tc=;
	b=Y9AjzC6tvduF4Vi21xfFgKI4bVl5p17TtQ/I9S29w4kDotZyWmPfWsQnuh4LSuqUFtrXyt
	HeII2yQh3hTnY/EOe3eGc50eAKSuOjXldV++K5M71XJXa1F+EC+r1K0odYO2ymlawAUn6K
	t2nmjXtvLiWnAFsSKpIw+g5+sYCER04=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f31e120d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Thu, 2 Jun 2022 20:18:17 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id f34so10256048ybj.6
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 13:18:17 -0700 (PDT)
X-Gm-Message-State: AOAM5300ZaNdmDkWIkhvW4r4cyiNfx8TMIJ0NaZnx5gJJwi+VbCSqNFJ
	ppLvKaCxLR2WFKoSpccWr7KqZyrC8L6YeTWVGLQ=
X-Google-Smtp-Source: ABdhPJzXi+s/TO32ednriWkXhf4jI9E5kn5aAwDIvHX4k5lPCje5vfCCQIh4nBVKCN1a4gxpRPxK/1zwVpwc0X8IEgE=
X-Received: by 2002:a25:890b:0:b0:659:b9d6:a134 with SMTP id
 e11-20020a25890b000000b00659b9d6a134mr7210862ybl.235.1654201095190; Thu, 02
 Jun 2022 13:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220602022109.780348-1-swboyd@chromium.org> <165419885870.2681883.10934677413962491141.b4-ty@arm.com>
 <CAHmME9qBOwb==N9AWSSb8VhCXANsieWi7JpiiiUMvjU2rdb5XA@mail.gmail.com> <YpkTjv6i+IlO32wM@arm.com>
In-Reply-To: <YpkTjv6i+IlO32wM@arm.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 2 Jun 2022 22:18:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9pU+t_rvQULcOwQmhU74ye3ShWi4Tgz5JdGrzW29XO+Kg@mail.gmail.com>
Message-ID: <CAHmME9pU+t_rvQULcOwQmhU74ye3ShWi4Tgz5JdGrzW29XO+Kg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Initialize jump labels before setup_machine_fdt()
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Will Deacon <will@kernel.org>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, 
	Douglas Anderson <dianders@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	Steven Rostedt <rostedt@goodmis.org>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 2, 2022 at 9:46 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Hi Jason,
>
> On Thu, Jun 02, 2022 at 09:42:49PM +0200, Jason A. Donenfeld wrote:
> > On Thu, Jun 2, 2022 at 9:41 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, 1 Jun 2022 19:21:09 -0700, Stephen Boyd wrote:
> > > > A static key warning splat appears during early boot on arm64 systems
> > > > that credit randomness from devicetrees that contain an "rng-seed"
> > > > property. This is because setup_machine_fdt() is called before
> > > > jump_label_init() during setup_arch(). Let's swap the order of these two
> > > > calls so that jump labels are initialized before the devicetree is
> > > > unflattened and the rng seed is credited.
> > > >
> > > > [...]
> > >
> > > Applied to arm64 (for-next/core), thanks!
> > >
> > > [1/1] arm64: Initialize jump labels before setup_machine_fdt()
> > >       https://git.kernel.org/arm64/c/73e2d827a501
> >
> > I'm not sure precisely what your for-next tag corresponds to, but just
> > FYI, this should probably go into 5.19 asap and be marked for stable@.
>
> The for-next/core branch should go in 5.19-rc1 (I'll send a pull request
> tomorrow). There's no need to cc stable since the fixed commit just went
> in (unless you mean something else by "marked for stable").

It is actually in stable, so please do CC. Otherwise I'll just forward manually.

Jason
