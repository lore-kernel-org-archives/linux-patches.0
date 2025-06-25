Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06926D4C7;
	Wed, 25 Jun 2025 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890580; cv=none; b=Lt6TCjDZ/fz1fIBglRkmssHxUOHZR5HhDbWD1Q/SvodSN5ycjuW85c9CosYzaG1zoMq7QF0X0EW0ucp4rLdfzTrb1TsDrBaE7pR6G8VysS6bncmeSP4YOrzDIMiSq3WiduHh90zVh6aAGQ4Km/mrjV+BCEPL7hXaaIOA7hQ3L88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890580; c=relaxed/simple;
	bh=65fugPI9FRJsqGGo3gHAxWmOr4BVEX8RKL5+9t0LBHk=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=UfVkfiHZCI2pLhQB1RIs+aKwqnpEHIaAOQfu8B+ia1GiPF87ukX+MTRC3WO0lnnRF7vAVRXhL7ZYe1WyjlRBhNCASo10EHxeVFtbXAFzVBHs1gNrzBdz37gctpiilKw5FiLQNQTHFY9ihkhNteDSidrY2g0tiKZOxG8Nvlc8XrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Efw8FHVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Efw8FHVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D90C4CEEA;
	Wed, 25 Jun 2025 22:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750890580;
	bh=65fugPI9FRJsqGGo3gHAxWmOr4BVEX8RKL5+9t0LBHk=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=Efw8FHVeKi4IxhwYO1QOUPEuNL5FPNa0rLKLLBgiHc6QAnmK5295Vz0Aqf4bIlAAD
	 sVVAxMyXpwoD2vO0+TCCZDATGQgh9k3bjFlqHVY2VPlppXbMPWy6dY9+PgV3p0Skzc
	 fCLkifjGi2m9hZpZBDioTecqIA2QeuYKQJkll+mdrjZpQs9ejOMTOqgS8Smai/DdL8
	 ozY6ye8PJiTx3QAMXR/MgZ7UsMuDmQJwXitMhULL9HVXCoMKb6JKauHpnHTDOAcGKr
	 vTqj0eMOwREY/kINDUuxaiSejdHpvMeYF85KyoXNQOoh6bw74xtRG9lWC0Iwt1rILV
	 RPyq71RZ0I9dA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Jun 2025 00:29:35 +0200
Message-Id: <DAVYWQE2PYZE.3TRIT906A9BJM@kernel.org>
To: "Shankari Anand" <shankari.ak0208@gmail.com>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <patches@lists.linux.dev>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, "Roy Baron" <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to
 sync::aref
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250625111133.698481-1-shankari.ak0208@gmail.com>
In-Reply-To: <20250625111133.698481-1-shankari.ak0208@gmail.com>

On Wed Jun 25, 2025 at 1:11 PM CEST, Shankari Anand wrote:
> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> new file mode 100644
> index 000000000000..93a23b493e21
> --- /dev/null
> +++ b/rust/kernel/sync/aref.rs
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Atomic reference-counted pointer abstraction.

I'd say this module is about supporting objects with builtin reference
counting.

> +//!
> +//! This module provides [`ARef<T>`], an owned reference to a value that=
 implements
> +//! [`AlwaysRefCounted`] =E2=80=94 an unsafe trait for types that manage=
 their own reference count.

I would lead with comparing `ARef<T>` to `Arc<T>` and only later mention
`AlwaysRefCounted`.

> +//!
> +//! It is based on the Linux kernel's manual reference counting model an=
d is typically used
> +//! with C types that implement reference counting (e.g., via `refcount_=
t` or `kref`).
> +//!
> +//! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) ins=
tead.
> +
> +use core::{
> +    marker::PhantomData,
> +    mem::ManuallyDrop,
> +    ops::Deref,
> +    ptr::NonNull,
> +};
> +
> +/// Trait for types that are _always_ reference-counted.
> +///
> +/// This trait allows types to define custom reference increment and dec=
rement logic.
> +/// It enables safe conversion from a shared reference `&T` to an owned =
[`ARef<T>`].
> +///
> +/// This is usually implemented by wrappers around C types with manual r=
efcounting.
> +///
> +/// For purely Rust-managed memory, consider using [`Arc`](crate::sync::=
Arc) instead.
> +///
> +/// # Safety
> +///
> +/// Implementers must ensure that:
> +///
> +/// - Calling [`AlwaysRefCounted::inc_ref`] keeps the object alive in me=
mory until a matching [`AlwaysRefCounted::dec_ref`] is called.
> +/// - The object is always managed by a reference count; it must never b=
e stack-allocated or
> +///   otherwise untracked.
> +/// - When the count reaches zero in [`AlwaysRefCounted::dec_ref`], the =
object is properly freed and no further
> +///   access occurs.
> +///
> +/// Failure to follow these rules may lead to use-after-free or memory c=
orruption.

You also rephrased these docs, can you do that in a separate patch?

> +

Newline?

---
Cheers,
Benno

> +pub unsafe trait AlwaysRefCounted {
> +    /// Increments the reference count on the object.
> +    fn inc_ref(&self);
> +
> +    /// Decrements the reference count on the object.
> +    ///
> +    /// Frees the object when the count reaches zero.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that there was a previous matching increment=
 to the reference count,
> +    /// and that the object is no longer used after its reference count =
is decremented (as it may
> +    /// result in the object being freed), unless the caller owns anothe=
r increment on the refcount
> +    /// (e.g., it calls [`AlwaysRefCounted::inc_ref`] twice, then calls
> +    /// [`AlwaysRefCounted::dec_ref`] once).
> +    unsafe fn dec_ref(obj: NonNull<Self>);
> +}
