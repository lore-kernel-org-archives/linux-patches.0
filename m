Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C262B23BCF8;
	Wed,  3 Sep 2025 09:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892763; cv=none; b=K66ZRchaYvDlwOKxpXBt/2CAYjF6oD21Zlx38NVnzFSFkW2WuU9ZH1VRX19ydrXRFm+SM9Ow2ysZclHdJsMrp+6xGFPN0wO2ZJV6IBzOYu/ifOr6N5o3L7M8tBBg2WWY/UQTueJlqs6JLZzYE8gerdCsSxyDlMitMj+dd7mnMtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892763; c=relaxed/simple;
	bh=ZKlDPs5tUy7NnCdcegG/WFo2cZdk8beeu3/iLMX0A4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fnAb+Ay0B43CkIdJN9CcH5WeK/OE1BGCZFH8XBGQX4k5gKJR6A+njRHAXKTltJ6/crKTXSbaxQeS8wJPJwSm8zMISdSRHCypaZVKFxD27NY0GEr2Z6qYg0X5GHEB8LvFn8O7RoypPbZA3HU2TLwKHeZ03+LTT08vn2xkAkWtr14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GV0C1yzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GV0C1yzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA252C4CEF0;
	Wed,  3 Sep 2025 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756892762;
	bh=ZKlDPs5tUy7NnCdcegG/WFo2cZdk8beeu3/iLMX0A4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GV0C1yzvREcrwqNjc2PMT67tBBFW/EXhnoIs/QPooaoc8Obdf9N7h3j7PJ5Z/SYjH
	 ee9berSxGonB2lm1cEbUhrSeqH47I7a1xEwd3ldBEe7lDDGP/PYRM66DJWLtT6BJid
	 CZWppXqwnkBGcxaq5o8hmS5jHMhN3xzZSiC11V+8=
Date: Wed, 3 Sep 2025 11:45:58 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with
 `debug_assert!`
Message-ID: <2025090325-drinking-illusion-ef3d@gregkh>
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-4-ojeda@kernel.org>
 <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com>
 <2025083032-barmaid-rising-a977@gregkh>
 <CANiq72nAagBBPhyU3XdETMKBuFPbMMRaSTStWPpyLnByYPP=+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nAagBBPhyU3XdETMKBuFPbMMRaSTStWPpyLnByYPP=+A@mail.gmail.com>

On Sat, Aug 30, 2025 at 01:07:52PM +0200, Miguel Ojeda wrote:
> On Sat, Aug 30, 2025 at 8:28 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > If you wish to state that CONFIG_RUST_DEBUG_ASSERTIONS=y should NEVER be
> > used in ANY shipping Linux system, then yes, we can carve out an
> > exception for this (we do that if lockdep is enabled as that should
> > never be in a running system, only a development one).
> 
> The config option is meant for development purposes ("debug"). We
> don't control all its behavior anyway, because the compiler/stdlib
> will also add many assertions (e.g. for unsafe preconditions). So, for
> instance, it could easily have a non-trivial performance impact.
> 
> For the same reason, it will also change behavior depending on the
> compiler version. So, for instance, new assertions in new compiler
> versions could have an impact that is not seen in previous versions.
> 
> Thus, for this particular config option, we cannot guarantee much, and
> the help text already states "This can be used to enable extra
> debugging code in development but not in production.".
> 
> Having said that, I regularly CI-test our main branches with the
> option enabled, and it has worked fine so far.
> 
> So if a user actually run with such kind of asserts in production,
> because they really want to crash on anything and everything, I don't
> see why they couldn't. It may really be that it actually stops an
> important exploit from going on. Of course, it may also be that it
> elevates a trivial bug into a denial of service elsewhere, but that
> risk may be worth it for certain users.
> 
> In fact, I would say it is a good thing that certain specialized users
> run with it enabled, because then it means they may find potential
> bugs for others, and that makes everyone safer in practice.
> 
> But I don't know what exact constraints the CVE system puts on you, so
> it is hard to assess what the best wording for such an option would
> be.

There are no "constraints" only a definition of a vulnerability that we
must follow.  And for that, any way that a user could cause a reboot or
panic, without having root privileges, gets assigned a CVE.

One exception being if lockdep or a few other "debugging only" options
are enabled.  Those are explicitly stated by their maintainers that they
should NEVER be enabled in a real system.  For those we do not assign
CVEs as they should never be actually triggered by a user.

So I don't know what to recommend here.  I strongly advise against
adding code to the kernel that can cause users to reboot their boxes if
they do something.  But hey, if developers want to do that, I'll gladly
assign CVEs for when it happens :)

thanks,

greg k-h
