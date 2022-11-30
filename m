Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97363C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 15:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEB6C433C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 15:47:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UqxFpbdn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669823258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yCvHaRii9cD4H3afW0NVdKImLG5V7TKp6UQQ6QaFAP0=;
	b=UqxFpbdngIYp7S50DffZRTSpWKUc8TFn/RU22xIYQn5/yh1I33YVDUXx7UpBVCrrZsfeaw
	Ieg0ROjlLNiwM85ozKoL4VGvIa5UAh8lNz4797T6nV6oC1wCUPbtTC74X1KUtHlVNavJTG
	lWafvnIMGdAzWshrB/68hAyjbMV0ILI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8125303d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Wed, 30 Nov 2022 15:47:38 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id k17so9820870vsr.10
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 07:47:37 -0800 (PST)
X-Gm-Message-State: ANoB5pmiR3JZ9RH/po0g5P3Gdd7ORwlDbwRWbRSl9OijNyTGvpjF2uN/
	y4BW9p281OgvAVthIqoCnOlP3Ii6P6ZdGbClq3Y=
X-Google-Smtp-Source: AA0mqf7z8aJcDmOZHX+ltTpu51goy5ghJZ6Jw1XfAaZPtaySHZYPyWXbzggLHIoKUOp9BreX2663lRUEide944axUnE=
X-Received: by 2002:a05:6102:30bc:b0:3b0:93af:fc3f with SMTP id
 y28-20020a05610230bc00b003b093affc3fmr10408031vsd.55.1669823256925; Wed, 30
 Nov 2022 07:47:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221129210639.42233-1-Jason@zx2c4.com> <20221129210639.42233-4-Jason@zx2c4.com>
 <878rjs7mcx.fsf@oldenburg.str.redhat.com> <Y4dt1dLZMmogRlKa@zx2c4.com>
 <Y4dvz4d0dpFzJZ9L@zx2c4.com> <16ec2a7a-c469-4732-aeca-e74a9fb88d3e@app.fastmail.com>
 <CAHmME9rpdCGLQzfsNkX=mLHfWeEWi4TyrOf_2rP_9hsyX9v6ow@mail.gmail.com> <574ad32d-566e-4c18-a645-1470fc081ede@app.fastmail.com>
In-Reply-To: <574ad32d-566e-4c18-a645-1470fc081ede@app.fastmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 30 Nov 2022 16:47:25 +0100
X-Gmail-Original-Message-ID: <CAHmME9oGffi539nEAJkOjC-2yAR+0Ra+wQw5oG6Y6+CRr5e62g@mail.gmail.com>
Message-ID: <CAHmME9oGffi539nEAJkOjC-2yAR+0Ra+wQw5oG6Y6+CRr5e62g@mail.gmail.com>
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

On Wed, Nov 30, 2022 at 4:29 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > I think it does address the issue. CONFIG_64BIT is a .config setting,
> > not a compiler-derived setting. So a 64-bit kernel will get a u64 in
> > kernel mode, and then it will get a u64 for the 64-bit vdso usermode
> > compile, and finally it will get a u64 for the 32-bit vdso usermode
> > compile. So in all three cases, the size is the same.
>
> I see what you mean now. However this means your vdso32 copies
> are different between 32-bit and 64-bit kernels. If you need to
> access one of the fields from assembler, it even ends up
> different at source level, which adds a bit of complexity.
>
> Making the interface configuration-independent makes it obvious
> to the reader that none of these problems can happen.

Except ideally, these are word-sized accesses (where only compat code
has to suffer I suppose).

> >> > struct vdso_rng_data {
> >> >       vdso_kernel_ulong       generation;
> >> >       bool                    is_ready;
> >> > };
> >>
> >> There is another problem with this: you have implicit padding
> >> in the structure because the two members have different size
> >> and alignment requirements. The easiest fix is to make them
> >> both u64, or you could have a u32 is_ready and an explit u32
> >> for the padding.
> >
> > There's padding at the end of the structure, yes. But both
> > `generation` and `is_ready` will be at the same offset. If the
> > structure grows, then sure, that'll have to be taken into account. But
> > that's not a problem because this is a private implementation detail
> > between the vdso code and the kernel.
>
> I was not concerned about incompatibility here, but rather about
> possibly leaking kernel data to the vdso page.

The vvar page starts out zeroed, no?

Jason
