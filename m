Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4665030D3FA;
	Thu, 10 Sep 2026 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002207; cv=none; b=Aq9XH/asiTjUGrh6+lg8hUQdccYNE3fcEi9o0n54IMu/hJjb4VKaoTwwZKC0jpY04iX5qrjR6BnEctVZow41QZ+zjzEnXH+xFggymSNtcu9ucRBmNIwJFpfjGRgQKnoBtXnqHOzrNey5PP/6vxat3Ci4pVDZTbGj32JnFCOo+K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002207; c=relaxed/simple;
	bh=xb7+ZUruM1MJTCPd1YL0SgedH7s3Jo7Il8pcGJEyajc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiONrMWnZLtqW+4sIYnmr+ow2W/BMFUavxapsUApNBtZkhqHLM7WCUS5IDdJO5tF5vMr4xxtltpV8chc1r5ZUZRNHl+Qmz6E19y9A+v4dq/iZFnxutxQTKuWYkEgrbadtD64uPSJfj6YA4hbbWwcr4CTtSRMOur0Syge9+pYQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/+plz5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/+plz5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27BC1F000FF;
	Thu, 10 Sep 2026 01:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002206;
	bh=TIG2T2i4jA9WjB+FPHW3l0yqt0ufR3BV4sxNXqQXvbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/+plz5Jh01msgLnAOw6O9rOmCvIUQCuKf6y16U4QTaMj+o08bMbhENcCLTw2LUBD
	 ztHlidR4af6Y9OPnAsIqLHlFoYNh4Z0XLJUYsZvatv0qIMFXX/Y0pZHozWRk5jBTLO
	 OG7uMzM3CzSjjwkczQARyIOqFx99BhQofcuCuf+dYGg0rld2xoVx0Ro6PjW5+XYgCN
	 wMze7vliC92EwG4Y+OKm5Sjid6kOKZvhKeZeIxQoZAfBjd1QZzgWHW7UZXJJNwtfs6
	 UGcc5ZdDQkvtQQwS+8uwaBKmWvdDcVlvqej3KUrK4jJt+s+n3OPrKRD/ePFKONoyLp
	 6P2nfljn1XLig==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: aliceryhl@google.com,
	boris.brezillon@collabora.com,
	dakr@kernel.org,
	markus.probst@posteo.de,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	driver-core@lists.linux.dev
Subject: Re: [PATCH 6.18 445/583] rust: devres: fix race condition due to nesting
Date: Thu, 10 Sep 2026 03:03:10 +0200
Message-ID: <20260910010310.429807-1-ojeda@kernel.org>
In-Reply-To: <20260909134253.387396612@linuxfoundation.org>
References: <20260909134253.387396612@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 09 Sep 2026 15:42:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> -        try_pin_init!(&this in Self {
> +        let callback = Self::devres_callback;
> +        let inner = Arc::pin_init(
> +            try_pin_init!(Inner {
> +                data <- Revocable::new(data),
> +            }),
> +            GFP_KERNEL,
> +        )?;
> +        let devres_inner = inner.clone();

The compiler complains here:

    error[E0277]: the trait bound `impl pin_init::PinInit<Inner<T>, error::Error>: pin_init::PinInit<_, E>` is not satisfied
       --> rust/kernel/devres.rs:141:13
        |
    140 |           let inner = Arc::pin_init(
        |                       ------------- required by a bound introduced by this call
    141 | /             try_pin_init!(Inner {
    142 | |                 data <- Revocable::new(data),
    143 | |                 revocation <- Completion::new(),
    144 | |             }),
        | |              ^
        | |              |
        | |______________the trait `pin_init::PinInit<_, E>` is not implemented for `impl pin_init::PinInit<Inner<T>, error::Error>`
        |                this tail expression is of type `impl PinInit<Inner<T>, Error>`
        |
        = help: the following other types implement trait `pin_init::PinInit<T, E>`:
                  <AlwaysFail<T> as pin_init::PinInit<T, ()>>
                  <ChainPinInit<I, F, T, E> as pin_init::PinInit<T, E>>
                  <ChainInit<I, F, T, E> as pin_init::PinInit<T, E>>
                  <core::result::Result<T, E> as pin_init::PinInit<T, E>>
    note: required by a bound in `init::InPlaceInit::pin_init`
       --> rust/kernel/init.rs:155:31
        |
    155 |     fn pin_init<E>(init: impl PinInit<T, E>, flags: Flags) -> error::Result<Self::PinnedSelf>
        |                               ^^^^^^^^^^^^^ required by this bound in `InPlaceInit::pin_init`

    error[E0282]: type annotations needed for `Arc<T>`
       --> rust/kernel/devres.rs:140:13
        |
    140 |         let inner = Arc::pin_init(
        |             ^^^^^
    ...
    147 |         let devres_inner = inner.clone();
        |                                  ----- type must be known at this point
        |
    help: consider giving `inner` an explicit type, where the type for type parameter `T` is specified
        |
    140 |         let inner: Arc<T> = Arc::pin_init(
        |                  ++++++++

    error[E0282]: type annotations needed
       --> rust/kernel/devres.rs:158:17
        |
    158 |                 Arc::as_ptr(&inner).cast_mut().cast(),
        |                 ^^^^^^^^^^^         -------- type must be known at this point
        |                 |
        |                 cannot infer type of the type parameter `T` declared on the struct `Arc`
        |
    help: consider specifying the generic argument
        |
    158 |                 Arc::<T>::as_ptr(&inner).cast_mut().cast(),
        |                    +++++

This diff would work, similar to commit 9aa64d2503c6 ("rust: devres:
embed struct devres_node directly"), but I wonder if the sequence of
backports was not intended like this:

    diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
    index 67471946f2b5..0cafe7ba28c8 100644
    --- a/rust/kernel/devres.rs
    +++ b/rust/kernel/devres.rs
    @@ -137,7 +137,7 @@ pub fn new<E>(dev: &Device<Bound>, data: impl PinInit<T, E>) -> Result<Self>
             Error: From<E>,
         {
             let callback = Self::devres_callback;
    -        let inner = Arc::pin_init(
    +        let inner = Arc::pin_init::<Error>(
                 try_pin_init!(Inner {
                     data <- Revocable::new(data),
                     revocation <- Completion::new(),

I hope that helps!

Cc: Markus Probst <markus.probst@posteo.de>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: driver-core@lists.linux.dev

Cheers,
Miguel
