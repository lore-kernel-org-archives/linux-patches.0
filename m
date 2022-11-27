Received: from smtp.dei.uc.pt (smtp.dei.uc.pt [193.137.203.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD22F29
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 22:45:12 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(user=sneves mech=PLAIN bits=0)
	by smtp.dei.uc.pt (8.15.2/8.14.4) with ESMTPSA id 2ARMe3ad059041
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 22:40:09 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.dei.uc.pt 2ARMe3ad059041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dei.uc.pt;
	s=default; t=1669588810;
	bh=pP7EychdTeHb0EDOPmOHs6dm6IB9tlMRybklmtPiPxs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BnF2cBlZt/LCj3M2/jQ3OOOaEwa79yopZUi0vLxFss1ur9YzMHWSDvVh1v0yLwuyM
	 Hmiv0rnRxusOYlYdMISjJUjytaQNTnGJwk+QuDUsznO9aZXTwPDUSoVpDuV/XN6MK8
	 hNAmpr/RCcMsiYpR3wjZhaF2GdrJiRqwW687Ks5A=
Received: by mail-lf1-f43.google.com with SMTP id s8so14804478lfc.8
        for <patches@lists.linux.dev>; Sun, 27 Nov 2022 14:40:09 -0800 (PST)
X-Gm-Message-State: ANoB5pkYSLReCKL+F93/JXRl50ydY91brcxqeejm3vTGVI/pqXiKmakc
	gUdxD50m55b9YCBzRnpg1pkP3gs1XrG2r1b4jzs=
X-Google-Smtp-Source: AA0mqf6/QqYK8Ow78Dq/iCZ+7AyFn1rnL14fN4db8EpNio8qIMAF6I4CpzY2inQz7lBHVHBN7nbuUBKchS1L7zCQpz4=
X-Received: by 2002:a19:675c:0:b0:4a2:5be6:c0bf with SMTP id
 e28-20020a19675c000000b004a25be6c0bfmr18154758lfj.390.1669588803552; Sun, 27
 Nov 2022 14:40:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221124165536.1631325-1-Jason@zx2c4.com> <20221124165536.1631325-4-Jason@zx2c4.com>
 <874jumy6me.ffs@tglx> <Y4PfjcQRfezjH4f+@zx2c4.com>
In-Reply-To: <Y4PfjcQRfezjH4f+@zx2c4.com>
From: Samuel Neves <sneves@dei.uc.pt>
Date: Sun, 27 Nov 2022 22:39:27 +0000
X-Gmail-Original-Message-ID: <CAEX_ruEq8_W8i-+cfri2-BYBNDgZCinsfFKVeFjxNSfnGxW1xg@mail.gmail.com>
Message-ID: <CAEX_ruEq8_W8i-+cfri2-BYBNDgZCinsfFKVeFjxNSfnGxW1xg@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] x86: vdso: Wire up getrandom() vDSO implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-FCTUC-DEI-SIC-MailScanner-Information: Please contact helpdesk@dei.uc.pt for more information
X-FCTUC-DEI-SIC-MailScanner-ID: 2ARMe3ad059041
X-FCTUC-DEI-SIC-MailScanner: Found to be clean
X-FCTUC-DEI-SIC-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-59.69, required 3.252, autolearn=not spam, ALL_TRUSTED -10.00,
	BAYES_00 -0.10, DKIM_SIGNED 0.10, KAM_DMARC_STATUS 0.01,
	L_SMTP_AUTH -50.00, T_DKIM_INVALID 0.30)
X-FCTUC-DEI-SIC-MailScanner-From: sneves@dei.uc.pt
X-Spam-Status: No

On Sun, Nov 27, 2022 at 10:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Thomas,
>
> On Sat, Nov 26, 2022 at 12:08:41AM +0100, Thomas Gleixner wrote:
> > Jason!
> >
> > On Thu, Nov 24 2022 at 17:55, Jason A. Donenfeld wrote:
> > > +++ b/arch/x86/entry/vdso/vgetrandom-chacha.S
> > > +/*
> > > + * Very basic SSE2 implementation of ChaCha20. Produces a given positive number
> > > + * of blocks of output with a nonce of 0, taking an input key and 8-byte
> > > + * counter. Importantly does not spill to the stack. Its arguments are:
> >
> > Basic or not.
>
> Heh, FYI I didn't mean "basic" here as in "doesn't need a review", but
> just that it's a straightforward technique and doesn't do any
> complicated multiblock pyrotechnics (which frankly aren't really
> needed).
>
> > This needs a Reviewed-by from someone who understands SSE2
> > and ChaCha20 before this can go anywhere near the x86 tree.
>
> No problem. I'll see to it that somebody qualified gives this a review.
>

I did look at this earlier. It looks fine. I would recommend changing

+ /* copy1,copy2 = key */
+ movdqu 0x00(key),copy1
+ movdqu 0x10(key),copy2

to

+ /* copy1,copy2 = key */
+ movups 0x00(key),copy1
+ movups 0x10(key),copy2

which has the same semantics, but saves a couple of code bytes. Likewise for

+ movdqu state0,0x00(output)
+ movdqu state1,0x10(output)
+ movdqu state2,0x20(output)
+ movdqu state3,0x30(output)

Otherwise,

Reviewed-by: Samuel Neves <sneves@dei.uc.pt> # for vgetrandom-chacha.S
