Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC863B3
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 15:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856A7C433C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 15:13:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fAVgMKq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669821191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ehcLEnrmYdooboo6C8RqDRNIDhpqFZtLvwqVG7Hw+8=;
	b=fAVgMKq6Riw/gzU9p3R+4uU7gWKsb4jXNlxQZhG6hZCQjaFHhkn57SCWHgkLuSJlissX9/
	pI83l41q3tknVyPf0sb3Qb59pF4wYDgWLHucwUe+9bk5J6kENcDVprNaqabdY1KwYMdg3S
	0cNjoAQJfonLpTbw9oebQAOyYGIar0k=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3d72301d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Wed, 30 Nov 2022 15:13:11 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id g65so17194210vsc.11
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 07:13:11 -0800 (PST)
X-Gm-Message-State: ANoB5plDCkhqbAAKZNr4ifBZrD0nLsvTlI95F3PQ+JPCQZWtKR6mIKw0
	3seP29lrJqf4dZzV+MS7zHmJ9iIlLE7zPDLv93s=
X-Google-Smtp-Source: AA0mqf6Yl/T+OAmoD0yazsnLCOATWbsGEI4/bldaoexY6SLa+x8gkonaehR/KkIlFpsUee1zbzFLip7zOgDwOVo3DmU=
X-Received: by 2002:a67:f54e:0:b0:3b0:4e31:10f7 with SMTP id
 z14-20020a67f54e000000b003b04e3110f7mr24842897vsn.73.1669821189935; Wed, 30
 Nov 2022 07:13:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221129210639.42233-1-Jason@zx2c4.com> <20221129210639.42233-4-Jason@zx2c4.com>
 <878rjs7mcx.fsf@oldenburg.str.redhat.com> <Y4dt1dLZMmogRlKa@zx2c4.com>
 <Y4dvz4d0dpFzJZ9L@zx2c4.com> <16ec2a7a-c469-4732-aeca-e74a9fb88d3e@app.fastmail.com>
In-Reply-To: <16ec2a7a-c469-4732-aeca-e74a9fb88d3e@app.fastmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 30 Nov 2022 16:12:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9rpdCGLQzfsNkX=mLHfWeEWi4TyrOf_2rP_9hsyX9v6ow@mail.gmail.com>
Message-ID: <CAHmME9rpdCGLQzfsNkX=mLHfWeEWi4TyrOf_2rP_9hsyX9v6ow@mail.gmail.com>
Subject: Re: [PATCH v10 3/4] random: introduce generic vDSO getrandom() implementation
To: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Arnd,

On Wed, Nov 30, 2022 at 4:07 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > +#ifdef CONFIG_64BIT
> > +typedef u64 vdso_kernel_ulong;
> > +#else
> > +typedef u32 vdso_kernel_ulong;
> > +#endif
>
> This does not address the ABI concern: to allow 32-bit and 64-bit
> tasks to share the same data page, it has to be the same width on
> both, either u32 or 64, but not depending on a configuration
> option.

I think it does address the issue. CONFIG_64BIT is a .config setting,
not a compiler-derived setting. So a 64-bit kernel will get a u64 in
kernel mode, and then it will get a u64 for the 64-bit vdso usermode
compile, and finally it will get a u64 for the 32-bit vdso usermode
compile. So in all three cases, the size is the same.

> > struct vdso_rng_data {
> >       vdso_kernel_ulong       generation;
> >       bool                    is_ready;
> > };
>
> There is another problem with this: you have implicit padding
> in the structure because the two members have different size
> and alignment requirements. The easiest fix is to make them
> both u64, or you could have a u32 is_ready and an explit u32
> for the padding.

There's padding at the end of the structure, yes. But both
`generation` and `is_ready` will be at the same offset. If the
structure grows, then sure, that'll have to be taken into account. But
that's not a problem because this is a private implementation detail
between the vdso code and the kernel.

Jason
