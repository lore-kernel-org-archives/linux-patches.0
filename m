Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97668836;
	Sun, 13 Jul 2025 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752417719; cv=none; b=pXJPc6XLUGOORMUFPcSMkh9ESlCqzZffWpyx/iE0R9zXes+A5N6ep21M2CxKd4U8WAgNV6cCOKmeirxcUKRW/s4HcMhXUodPoTys88U8MMEFYNEsqV2xW+O6P24dtYIllCnYzkYDR0LPD0HG4cvUpmfhISH4q1H/GiDYXgv7m3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752417719; c=relaxed/simple;
	bh=gB1jqi5LgzW94AvIRE03EfjOH2ASn9e19gKaS+AxytA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiHtimOavM3HaX/oFrqO3/HizbSeZ8R/67D0G5A3a/gN3jqjRfOfF/HtkoC2+MoJ1folzGyBEPeCm+CV7CKxmkx4jevH4uIL8aiEoNdyPRKPXDZ8Bc9+E2DY3Nz4Ni3oxaPUDTQYmmbxc/jJc6lqqM/FpFi4OE57HS+Ee2Xk0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhJ25fD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhJ25fD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C609DC4CEE3;
	Sun, 13 Jul 2025 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752417719;
	bh=gB1jqi5LgzW94AvIRE03EfjOH2ASn9e19gKaS+AxytA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KhJ25fD2q8imQFUA8s64v2ESJnw7nqTaiTN9dHi85I2rqbcySeNXDjj0VdEC9FB47
	 t5N/xU84pm6n6/roHkRYnVT5h+/laalTvM3poVM7oQm8QMze0UH5pu4pY26BZcB7G8
	 hr096Cg2VSkFkaWiIlkd32T7xlfyA+NkX8J2bTjo=
Date: Sun, 13 Jul 2025 16:41:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, stable@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y] rust: init: allow `dead_code` warnings for Rust
 >= 1.89.0
Message-ID: <2025071348-jogger-clarity-641c@gregkh>
References: <20250712171038.1287789-1-ojeda@kernel.org>
 <DBA9X9FU5M9A.14RBXD887DKB1@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBA9X9FU5M9A.14RBXD887DKB1@kernel.org>

On Sat, Jul 12, 2025 at 08:04:48PM +0200, Benno Lossin wrote:
> On Sat Jul 12, 2025 at 7:10 PM CEST, Miguel Ojeda wrote:
> > Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler
> > may warn:
> >
> >     error: trait `MustNotImplDrop` is never used
> >        --> rust/kernel/init/macros.rs:927:15
> >         |
> >     927 |         trait MustNotImplDrop {}
> >         |               ^^^^^^^^^^^^^^^
> >         |
> >        ::: rust/kernel/sync/arc.rs:133:1
> >         |
> >     133 | #[pin_data]
> >         | ----------- in this procedural macro expansion
> >         |
> >         = note: `-D dead-code` implied by `-D warnings`
> >         = help: to override `-D warnings` add `#[allow(dead_code)]`
> >         = note: this error originates in the macro `$crate::__pin_data`
> >                 which comes from the expansion of the attribute macro
> >                 `pin_data` (in Nightly builds, run with
> >                 -Z macro-backtrace for more info)
> >
> > Thus `allow` it to clean it up.
> 
> This is a bit strange, I can't directly reproduce the issue... I already
> get this warning in 1.88:
> 
>     https://play.rust-lang.org/?version=stable&mode=debug&edition=2024&gist=465f71a848e77ac3f7a96a0af6bc9e2a
> 
> > This does not happen in mainline nor 6.15.y, because there the macro was
> > moved out of the `kernel` crate, and `dead_code` warnings are not
> > emitted if the macro is foreign to the crate. Thus this patch is
> > directly sent to stable and intended for 6.12.y only.
> >
> > Similarly, it is not needed in previous LTSs, because there the Rust
> > version is pinned.
> >
> > Cc: Benno Lossin <lossin@kernel.org>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Anyways the patch itself looks fine, nobody should care about the
> dead-code warning (since it is in fact used to prevent `Drop` being
> implemented).
> 
> Acked-by: Benno Lossin <lossin@kernel.org>

Thanks, now queued up.

greg k-h
