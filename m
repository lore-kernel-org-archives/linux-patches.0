Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6159519415E;
	Mon, 18 Nov 2024 10:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731926045; cv=none; b=IbAITGgkEgT97tB6LZfT3RynS66BFsps/PddHTziERMgXuO2MJVMzvMOU1/R6xX3aYzjKUyRB1fHYjX9/xBKbvNZnI0A6OH0aIoYMfRbeBbLeDmUDSmMfD7AyTbrN9Gz0v5Ml7PVlibMPXX+QH3iSs1LnTlUe/nwtsM5RGbgDfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731926045; c=relaxed/simple;
	bh=E4ANi0ufgkTOjdoIU/sCeV7rHrR5kvtRV1MyqV1mUDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Uva8pqzcEqm43xDzIH5pPXya5itjtg41iXkjfRAR93Ae1zXXvUesO6V2VKhnpsflposxmIGNgMCKbN6KGwjhbRG70wMS7DpXmzt2ZQJeKIZloM2IqSL+4bp09iyMKvHiRc643MgAwL7SB4zZESOeBceQB7v+mgIBH7bnOVzl/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKVcCoaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKVcCoaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D959C4CED0;
	Mon, 18 Nov 2024 10:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731926045;
	bh=E4ANi0ufgkTOjdoIU/sCeV7rHrR5kvtRV1MyqV1mUDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CKVcCoaW0+LwwAQP0QtWiZqKOv13GcFbv5Jvvq2gqVdtQ8eMzb9MaoJ6QVMgc8MPH
	 wxsesKDt15OMeEEZCx31Reg7r9qgGM5HYhKDwmwq/mSUzPQFoxt2eYZCHeLOMw6IQf
	 9xIzcDIUS2X6Lo0YVIbuZwBKGQxoT9lc2jThDQwKoOjzkDn86Sfr9cmBD7Ay/yhdsH
	 velqfBuXZMGJry10NkP7XAFSn53GURIzwRyld0aT4ZvA1dbEMfLadbWYfwXjJeGTnM
	 MuwByiLoMOyls+EDlpUzE97RPVdbfT9ARznF//CNS0Qu8P9MhK/B6kbNHl/6Z7VXsp
	 etqJcDuX937ug==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>,  "Boqun Feng"
 <boqun.feng@gmail.com>,  "Gary Guo" <gary@garyguo.net>,  =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  "Benno Lossin" <benno.lossin@proton.me>,
  "Alice Ryhl" <aliceryhl@google.com>,  "Trevor Gross" <tmgross@umich.edu>,
  <rust-for-linux@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <patches@lists.linux.dev>
Subject: Re: [PATCH] rust: allow `clippy::needless_lifetimes`
In-Reply-To: <20241116181538.369355-1-ojeda@kernel.org> (Miguel Ojeda's
	message of "Sat, 16 Nov 2024 19:15:37 +0100")
References: <EFX-31VoeCMlETFeBCV5AsLQH8mV4szc26gB1uEEnYvF2z6YRevjYkQV7KZpoyoVFkoukFyYBc35hVpVzivEvg==@protonmail.internalid>
	<20241116181538.369355-1-ojeda@kernel.org>
Date: Mon, 18 Nov 2024 11:26:29 +0100
Message-ID: <87mshw6dnu.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Miguel Ojeda" <ojeda@kernel.org> writes:

> In beta Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
> been extended [1] to suggest eliding `impl` lifetimes, e.g.
>
>     error: the following explicit lifetimes could be elided: 'a
>     --> rust/kernel/list.rs:647:6
>         |
>     647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
>         |      ^^                                                                  ^^
>         |
>         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_lifetimes
>         = note: `-D clippy::needless-lifetimes` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(clippy::needless_lifetimes)]`
>     help: elide the lifetimes
>         |
>     647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
>     647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'_, T, ID> {}
>
> A possibility would have been to clean them -- the RFC patch [2] did
> this, while asking if we wanted these cleanups. There is an open issue
> [3] in Clippy about being able to differentiate some of the new cases,
> e.g. those that do not involve introducing `'_`. Thus it seems others
> feel similarly.
>
> Thus, for the time being, we decided to `allow` the lint.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
> Link: https://lore.kernel.org/rust-for-linux/20241012231300.397010-1-ojeda@kernel.org/ [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/13514 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg


