Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CC0A498
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 21:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319F0C43147
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 21:29:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O8+J0w7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669670982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FDwebM2uChEaCsi7MjosOH4+1tmg5eYzvcVHA1vHqwc=;
	b=O8+J0w7nm1u1C2pniytxA8ewP3/rfWk30E/nTkJpDltBj9Z9JT4504xRuwSXOjDSImv8hY
	rDH4eOoF9kMaUA5YyZ8Vs6m3tWGIUwHo8jcZCDvRhHrXFdbjFOHLKgeGL/PAfhj+qDtPX5
	qX31szZE1/vZ/ohSQngxnuu9hdBjMxA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 58de59eb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Mon, 28 Nov 2022 21:29:41 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id v81so5945622vkv.5
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 13:29:41 -0800 (PST)
X-Gm-Message-State: ANoB5pnLvxYPRhDNZastvgNUQpV+kyXm3XDE+GQy7sjNrNB0nc6QsQQq
	2NDAUH5B8GU8EGiNWYWDbT+qLuf3aBADPxCWFAE=
X-Google-Smtp-Source: AA0mqf6jEGtcBl+CWgyFJVs2ZeS81nOnWmoaLX1ReySbgTep0RXOEgf8bO6Lcga/AMkFmEat1SFfN9/9OHr2MrzzgUY=
X-Received: by 2002:ac5:cdc7:0:b0:3bb:ddbe:899d with SMTP id
 u7-20020ac5cdc7000000b003bbddbe899dmr22572652vkn.41.1669670980428; Mon, 28
 Nov 2022 13:29:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221128111829.2477505-1-Jason@zx2c4.com> <20221128111829.2477505-4-Jason@zx2c4.com>
 <8f9326ba-f879-4b9e-9e5d-b65cad7cd726@app.fastmail.com> <Y4UKpP7/NOwPIkYe@zx2c4.com>
 <cd01e0b4-579f-48fc-995f-6e1acebd02af@app.fastmail.com> <CAHmME9rp+Nx_S8OgABzadc1+j_FrSRbUvGu2r9W_svrr+HMjSg@mail.gmail.com>
 <2cb4b4a7-1d39-4f63-aee0-b4fc43efa68d@app.fastmail.com>
In-Reply-To: <2cb4b4a7-1d39-4f63-aee0-b4fc43efa68d@app.fastmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 28 Nov 2022 22:29:29 +0100
X-Gmail-Original-Message-ID: <CAHmME9r6Hqy3KTJoNpXzJ4weUyFs=5xEPQEe94x4hO6QZWo-5g@mail.gmail.com>
Message-ID: <CAHmME9r6Hqy3KTJoNpXzJ4weUyFs=5xEPQEe94x4hO6QZWo-5g@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] x86: vdso: Wire up getrandom() vDSO implementation
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Christian Brauner <brauner@kernel.org>, Samuel Neves <sneves@dei.uc.pt>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 28, 2022 at 10:13 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Nov 28, 2022, at 21:02, Jason A. Donenfeld wrote:
> > On Mon, Nov 28, 2022 at 8:57 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> > Okay, I can split it that way. If I gather your meaning correctly:
> >
> > 1) generic syscall C code
> > 2) #define __NR_... in asm-generic/unistd.h x86/.../unistd.h,
> > x86/.../syscall_64.tbl
>
> I mean all syscall*.tbl files, not just x86. There are currently
> eight architectures using asm-generic/unistd.h, the rest use
> syscall.tbl.

Oh okay, I'll add this to all of the *.tbl files.

Jason
