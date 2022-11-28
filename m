Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAF8A461
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 20:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC589C43470
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 20:03:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ANgoiN5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669665779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3abNITP0dzAb4S+Ys/N4ktn79tvtLrAVp0KnndQQeQg=;
	b=ANgoiN5/DzPsE7NInUnHVXjdtzboZOf/VjIBRG+BW3kDUneiTj7LQLt58UD7stOajqEl5g
	CZ2WpjAd0YSOzB7rw/CAuMEAy8F2QnmOwvsj2h7Q8zDvkg15tVw2HUvK3+nCJ4Ey1DsAzG
	2YDBQ+ItutUQCay0oOWJuPvUMg7C6dc=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e5d7f9ee (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Mon, 28 Nov 2022 20:02:59 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id k17so3914548vsr.10
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 12:02:59 -0800 (PST)
X-Gm-Message-State: ANoB5pnMO9zZpNvvQl6y0F67YhwcdiNO3SbHY3NfXxUYLeUvBSPopovr
	S091smf5nT81VFv+hSgXzJsDER3IdvbhUyWhJTg=
X-Google-Smtp-Source: AA0mqf5cX87+Dzqv5dsvQPzXX+ACSAgn3+NnHk6t8bD7/9VXA7phYasi8Xi6M8nM7bGSqgRv5Mh405sAFnNKGR0AFK0=
X-Received: by 2002:a67:f54e:0:b0:3b0:4e31:10f7 with SMTP id
 z14-20020a67f54e000000b003b04e3110f7mr19050387vsn.73.1669665778586; Mon, 28
 Nov 2022 12:02:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221128111829.2477505-1-Jason@zx2c4.com> <20221128111829.2477505-4-Jason@zx2c4.com>
 <8f9326ba-f879-4b9e-9e5d-b65cad7cd726@app.fastmail.com> <Y4UKpP7/NOwPIkYe@zx2c4.com>
 <cd01e0b4-579f-48fc-995f-6e1acebd02af@app.fastmail.com>
In-Reply-To: <cd01e0b4-579f-48fc-995f-6e1acebd02af@app.fastmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 28 Nov 2022 21:02:47 +0100
X-Gmail-Original-Message-ID: <CAHmME9rp+Nx_S8OgABzadc1+j_FrSRbUvGu2r9W_svrr+HMjSg@mail.gmail.com>
Message-ID: <CAHmME9rp+Nx_S8OgABzadc1+j_FrSRbUvGu2r9W_svrr+HMjSg@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] x86: vdso: Wire up getrandom() vDSO implementation
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Christian Brauner <brauner@kernel.org>, Samuel Neves <sneves@dei.uc.pt>
Content-Type: text/plain; charset="UTF-8"

Hi Arnd,

On Mon, Nov 28, 2022 at 8:57 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Nov 28, 2022, at 20:23, Jason A. Donenfeld wrote:
> > On Mon, Nov 28, 2022 at 08:18:12PM +0100, Arnd Bergmann wrote:
> >> On Mon, Nov 28, 2022, at 12:18, Jason A. Donenfeld wrote:
> >
> > That's more or less how v7 was, but Thomas thought the x86 stuff should
> > be separate. So for v8, the organization is:
> >
> > 1) generic syscall
> > 2) generic vdso
> > 3) x86 wiring
> >
> > The primary advantage is that future archs wanting to add this now can
> > just look at commit (3) only, and make a similar commit for that new
> > arch.
> >
> > If you think a different organization outweighs that advantage, can you
> > spell out what division of patches you want, and I'll do that for v9?
> > Or maybe this v8 is okay?
>
> My interest is that at the end of the series, all architectures
> are hooked up with the same syscall number, which avoids confusion
> and merge conflicts when we add the next syscall to all tables.
>
> How about one patch to add all the syscall table entries, and then
> have the x86 specific change just turn on the Kconfig symbol that
> actually enables the syscall?

Okay, I can split it that way. If I gather your meaning correctly:

1) generic syscall C code
2) #define __NR_... in asm-generic/unistd.h x86/.../unistd.h,
x86/.../syscall_64.tbl
3) generic vdso C code
4) hook up x86 vdso, and select the right Kconfig symbol to start
compiling the code

Is that what you have in mind? If so, I'll name (2) "arch: wire up
vgetrandom_alloc() syscall number".

Jason
