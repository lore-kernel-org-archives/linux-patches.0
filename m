Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F11079D
	for <patches@lists.linux.dev>; Thu, 25 May 2023 13:46:53 +0000 (UTC)
Date: Thu, 25 May 2023 13:46:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1685022411; x=1685281611;
	bh=61hvWsMU7lXC84Xrt2kc9OPqYj0r7Uqdnc1xD7J8Q8g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=d37z04qn6hsgDWNDNykUzBqjii9W8Zw2MIvtrqUoQe1zFzE2d9tdu32FaY7OyKZVd
	 oIdvaS9f3/dVi25EOXV06rokcjRN8qDcxGC3pMEzzLDwu8NKQt5bfV+ZfE0s+987Yi
	 9Kpvd5ZHV/cl5LQUWgp/QcEjuolXQ1j+hENOKLqcfnbprZTb5rjn+/7kRWVvSjI2ct
	 l1d4o5o0UOn9BHkKbjcHrfZ61LIyIrl3UHKWqC3aQiSV1E6tR3beeZzXr1SSS9ipfC
	 p/yuRWlg10eYq65UkUmOdbp67oQIHt6Ij12JzPgdDsNWdcCBQYpX/ioMC8ULYe5xRr
	 Fioe5PANVaUug==
To: Alice Ryhl <aliceryhl@google.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v2 4/4] rust: task: add `Send` marker to `Task`
Message-ID: <dnJLgoTsedSzBtTbF5y4YNlm5JHim7JkprBI5XMM87lP_5wHOmjv_rw6MwuverqDnA7KGWJsGVf2D5KEywOgMH9-BVQP3edDLJWJPI7diSc=@proton.me>
In-Reply-To: <20230523144418.1250547-5-aliceryhl@google.com>
References: <20230523144418.1250547-1-aliceryhl@google.com> <20230523144418.1250547-5-aliceryhl@google.com>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/23/23 16:44, Alice Ryhl wrote:
> When a type also implements `Sync`, the meaning of `Send` is just "this
> type may be accessed mutably from threads other than the one it is
> created on". That's ok for this type.
>=20
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   rust/kernel/task.rs | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
> index 526d29a0ae27..7eda15e5f1b3 100644
> --- a/rust/kernel/task.rs
> +++ b/rust/kernel/task.rs
> @@ -64,8 +64,14 @@ macro_rules! current {
>   #[repr(transparent)]
>   pub struct Task(pub(crate) Opaque<bindings::task_struct>);
>=20
> -// SAFETY: It's OK to access `Task` through references from other thread=
s because we're either
> -// accessing properties that don't change (e.g., `pid`, `group_leader`) =
or that are properly
> +// SAFETY: By design, the only way to access a `Task` is via the `curren=
t` function or via an
> +// `ARef<Task>` obtained through the `AlwaysRefCounted` impl. This means=
 that the only situation in
> +// which a `Task` can be accessed mutably is when the refcount drops to =
zero and the destructor
> +// runs. It is safe for that to happen on any thread, so it is ok for th=
is type to be `Send`.
> +unsafe impl Send for Task {}
> +
> +// SAFETY: It's OK to access `Task` through shared references from other=
 threads because we're
> +// either accessing properties that don't change (e.g., `pid`, `group_le=
ader`) or that are properly
>   // synchronised by C code (e.g., `signal_pending`).
>   unsafe impl Sync for Task {}
>=20
> --
> 2.40.1.698.g37aff9b760-goog
>=20

--=20
Cheers,
Benno
