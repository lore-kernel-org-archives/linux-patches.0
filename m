Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F11F4295;
	Tue, 11 Feb 2025 10:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739270020; cv=none; b=SEjra9fEnZKHqpyCW8ox8BP6fqapgV+ZnnYwG3UuoDqWhJqaKptHUcWpO0K5ovRARAf7dOPYZ5yZg7d5L4UCf42rR1nYUWmCdIgBedJNKPj70Bsbf2PMKUfAqvQXsKaRUbWnRhXkXXgOwk2QiTOm2HNpg2E6chLyt8wWlerNdY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739270020; c=relaxed/simple;
	bh=PquzBB/oX7egHymBp+a6B/TaN2ihpzSc+j9dImCu2IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp3+9tEz0UgSE9L7RUDXwjRdP5hL6PDk3ZPrAmZ+jyCrlyTnKaqmMJ2F91DD46liKyhDhYz58yq15Zt6kaAWJc7ct+lx/gxGKYy8bSjKEaBiScrrebef4vlUd5bMGWo994zqShi4TM0aHXDaD8tHahqV54Zmse8+4J0AH7R6yTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQHS5bOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQHS5bOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD89EC4CEE7;
	Tue, 11 Feb 2025 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739270019;
	bh=PquzBB/oX7egHymBp+a6B/TaN2ihpzSc+j9dImCu2IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BQHS5bOKvoiVMPGh7qf8LYf4J9+tJWgM8GbiFoUwZLrDAKub6cdlgLNUzhT1kU4YN
	 4ocP9I5pp1pMbnKBAzuFLhs1S+lXy5h+k6Bx5ohEa9P3sVaBv/WwXgklP7kfUwFpJ6
	 duSrPvzOGEJJvwoxqI8Z9YN6vS9qjfypf1xuY55rmm/ulzPehfjDYv30KeNrEX760R
	 PObIad9+Gsij7RfvEJ0/l4cJcjLYaRG6su/s1q1a6V1gq4Jcg+kHWRgTtVvDHYsT8q
	 3RiAbclp1tfY2e4Y6oGlTfpaV6ZRNJq5JYu+Hb/oLGHGw69iQQgG17gSdr5eZyesWA
	 kR4LDQQ59QSOg==
Date: Tue, 11 Feb 2025 10:33:33 +0000
From: Will Deacon <will@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, stable@vger.kernel.org,
	Matthew Maurer <mmaurer@google.com>, Ralf Jung <post@ralfj.de>,
	Jubilee Young <workingjubilee@gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat
 target
Message-ID: <20250211103333.GB8653@willie-the-truck>
References: <20250210163732.281786-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210163732.281786-1-ojeda@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 10, 2025 at 05:37:32PM +0100, Miguel Ojeda wrote:
> Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
> [1] about disabling neon in the aarch64 hardfloat target:
> 
>     warning: target feature `neon` cannot be toggled with
>              `-Ctarget-feature`: unsound on hard-float targets
>              because it changes float ABI
>       |
>       = note: this was previously accepted by the compiler but
>               is being phased out; it will become a hard error
>               in a future release!
>       = note: for more information, see issue #116344
>               <https://github.com/rust-lang/rust/issues/116344>
> 
> Thus, instead, use the softfloat target instead.
> 
> While trying it out, I found that the kernel sanitizers were not enabled
> for that built-in target [2]. Upstream Rust agreed to backport
> the enablement for the current beta so that it is ready for
> the 1.85.0 release [3] -- thanks!
> 
> However, that still means that before Rust 1.85.0, we cannot switch
> since sanitizers could be in use. Thus conditionally do so.
> 
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Ralf Jung <post@ralfj.de>
> Cc: Jubilee Young <workingjubilee@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/133417 [1]
> Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/topic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
> Link: https://github.com/rust-lang/rust/pull/135905 [3]
> Link: https://github.com/rust-lang/rust/issues/116344
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Matthew: if you could please give this a go and confirm that it is fine
> for Android (with sanitizers enabled, for 1.84.1 and 1.85.0), then a
> Tested-by tag would be great. Thanks!

Patch looks fine to me, but I'll wait for Matthew to confirm that it
works for them. I'm also fine with adding the rustc-min-version helper
at the same time, tbh -- it's not exactly rocket science, but it would
need an Ack from Masahiro.

Will
