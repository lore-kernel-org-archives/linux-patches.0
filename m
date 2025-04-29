Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8768214234;
	Tue, 29 Apr 2025 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745963559; cv=none; b=FY5LGCRvXao19URFkwUeQL27AprZUnPARB3h1r3oXycAteEmsznt3Kha0jdW4+rMtIfSHQCDmlgT90TbcAL+w49a47HtJTWjusYpdHln1ZWMCxQdwgCNJ5FTtVdlLCtGmUrfQMjtxEqe0bxOoDWMkEQFjC9FwmnmGSEES1Ht3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745963559; c=relaxed/simple;
	bh=FxQBQd6WDeShNQc4GAnsjZILLoOhNVV6GGXUuNB48TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bahsGFDavzJqBOql2Fevi712H+onZxpdR0GSPuQrRGhbeMuXgmWSWYF2zwjY/KsiF6ux8X1AIPTsUJ+JRyd0vEOZ6oTIFDU1Uz+QYW8ju3+pkmJAMIGKkQE1hw+oI7TGwnhA0X58BD3q2MuRKu9ZpjFhbTipP/BG1ZOiN3yOH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGx2QGDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGx2QGDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DDEC4CEE3;
	Tue, 29 Apr 2025 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745963558;
	bh=FxQBQd6WDeShNQc4GAnsjZILLoOhNVV6GGXUuNB48TA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hGx2QGDJwL+PvhXo17zBJDJyiRi3mjSN7SiA02EODNe8GYgDAEY7enJJj2WR0HHUb
	 FaKIlw46EQoLPyHNXWAYCNrWh8MHT5cl37UqXpsewnAV62VMI95TplgHKtiM9cuuG3
	 /5cL/hccPuBYPz8z5BOLhvU/W+0caqdhGGnZ7oO3eLfwNs5ZfR4RkAiOenyNOSCBCT
	 Gab0mXBlGJIgtYRBTCRJnhdIJDMG3Ry84muksN4Wayh/CIX0YQ3ahGoWWcFpaFRgPQ
	 4nYPyBryStCGLFGbqVztkpMt630ds4C0AUyFKf5kGf/rU0NxEfJyVzt0gnLdjGUPmA
	 bKnnwR27lVr2A==
Date: Tue, 29 Apr 2025 23:52:32 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] rust: device: allow `Device<DeviceContext>::parent()`
Message-ID: <aBFKII5I7R2piEcA@pollux>
References: <20250429210629.513521-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429210629.513521-1-ojeda@kernel.org>

On Tue, Apr 29, 2025 at 11:06:29PM +0200, Miguel Ojeda wrote:
> When `CONFIG_AUXILIARY_BUS` is disabled, `parent()` is still dead code:
> 
>     error: method `parent` is never used
>       --> rust/kernel/device.rs:71:19
>        |
>     64 | impl<Ctx: DeviceContext> Device<Ctx> {
>        | ------------------------------------ method in this implementation
>     ...
>     71 |     pub(crate) fn parent(&self) -> Option<&Self> {
>        |                   ^^^^^^
>        |
>        = note: `-D dead-code` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(dead_code)]`
> 
> Thus reintroduce the `expect`, but now as a conditional one. Do so as
> `dead_code` since that is narrower.
> 
> An `allow` would also be possible, but Danilo wants to catch new users
> in the future [1].
> 
> Link: https://lore.kernel.org/rust-for-linux/aBE8qQrpXOfru_K3@pollux/ [1]
> Fixes: ce735e73dd59 ("rust: auxiliary: add auxiliary device / driver abstractions")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to nova-next, thanks!

[ Adjust commit subject to "rust: device: conditionally expect
  `dead_code` for `parent()`". - Danilo ]
