Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7037F7A
	for <patches@lists.linux.dev>; Mon,  4 Apr 2022 23:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9695C2BBE4
	for <patches@lists.linux.dev>; Mon,  4 Apr 2022 23:09:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i6zHgw58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649113774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f03Sgznwk70QYZSWwxV+lkMyUN0TDnERCd80Ff7+eOo=;
	b=i6zHgw58b+jZ5J1txC/wyd7yFiWEs/TAZl2+wVE2yhb8Q/c/cxq/AZLubnzy5F8+KP3+CU
	0xXjEairFRsHoQNjoHUZfqe1hIJnzdR/AyaKqDJfhCxZXB3+ZHwOROmo6uEMP9KIEvD9Wq
	i0m5pgF7SrdqdKj6pUt6XFWat0+MvlE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f047ef7a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Mon, 4 Apr 2022 23:09:34 +0000 (UTC)
Date: Tue, 5 Apr 2022 00:47:21 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
Message-ID: <Ykt1cj0wPKEsHL2q@zx2c4.com>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com>
 <202204041144.96FC64A8@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202204041144.96FC64A8@keescook>

Hi Kees,

On Mon, Apr 4, 2022 at 8:49 PM Kees Cook <keescook@chromium.org> wrote:
> This mixes two changes: the pRNG change and the "use urandom if
> non-deterministic" change. I think these should be split, so the pRNG
> change can be explicitly justified.

Alright, I'll split those. Or, more probably, just drop the xorshift
thing. There's not actually a strong reason for preferring xorshift. I
did it because it produces more uniformity and is faster to compute and
all that. But none of that stuff actually matters here. It was just a
sort of "well I'm at it..." thing.

> >  static struct plugin_info latent_entropy_plugin_info = {
> > -     .version        = "201606141920vanilla",
> > +     .version        = "202203311920vanilla",
>
> This doesn't really need to be versioned. We can change this to just
> "vanilla", IMO.

Okay. I suppose you want it to be in a different patch too, right? In
which case I'll leave it out and maybe get to it later. (I suppose one
probably needs to double check whether it's used for anything
interesting like dwarf debug info or whatever, where maybe it's
helpful?)

> > +     if (deterministic_seed) {
> > +             unsigned HOST_WIDE_INT w = deterministic_seed;
> > +             w ^= w << 13;
> > +             w ^= w >> 7;
> > +             w ^= w << 17;
> > +             deterministic_seed = w;
> > +             return deterministic_seed;
>
> While seemingly impossible, perhaps don't reset "deterministic_seed",
> and just continue to use "seed", so that it can never become "0" again.

Not sure I follow. It's an LFSR. The "L" is important. It'll never become
zero. It's not "seemingly". We can prove it trivially in Magma:

    > w := 64;
    > K := GF(2);
    > I := IdentityMatrix(K, w);
    > SHL := HorizontalJoin(RemoveColumn(I, 1), ZeroMatrix(K, w, 1));
    > SHR := HorizontalJoin(ZeroMatrix(K, w, 1), RemoveColumn(I, w));
    > M :=  (I + SHL^17) * (I + SHR^7) * (I + SHL^13);
    > Order(M) eq 2^64 - 1;
    true
    > P<x> := MinimalPolynomial(M);
    > IsPrimitive(P);
    true
    > IsInvertible(M);
    true 
    > Rank(M);
    64

And more obviously, splitting this into "seed" and "deterministic_seed",
as you suggested, wouldn't actually do much in the case when seed=0,
since 0<<N==0 and 0^0==0.

Jason
