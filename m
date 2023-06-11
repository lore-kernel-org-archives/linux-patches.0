Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D8C121
	for <patches@lists.linux.dev>; Sun, 11 Jun 2023 16:01:18 +0000 (UTC)
Date: Sun, 11 Jun 2023 16:01:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1686499276; x=1686758476;
	bh=kYAUFYLzaiAX52hQfJ1MUOd0KMtIuNz3QI77YeCuRe4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Df1dBfWS+x56HZNpJC1DD90F2+NBfpRlehzNABiikAp5kvYzFP67yUtDPdVXQW0rw
	 e0axP3VrTTCwZoGEKOwGjCmUR/99oF/RenObRZEob935GlsGPsQnPvxyqB39Mw00fT
	 eGmUUCzHxd88VB8tbkyLDfNxweoCFLzicxsfjItwSlEZlUscDJ5/pjlPUTJ3WqQx54
	 n8vZ4nOlzViOhWac7cxOteuxnguSBzRh7JRlAeAYaKnZfoFl3y4/eBTxa4LwW7jh+T
	 W82aYRLp7DjjAhj0bCW7RGoxwAdM8HO7m6Z9G5m0EQYqgQxNYW8ADqKB5pun0tGCav
	 psKcGCwgoOcyw==
To: Alice Ryhl <aliceryhl@google.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 6/8] rust: workqueue: implement `WorkItemPointer` for pointer types
Message-ID: <E9xrq6_A6ATQnbV1U8f-DJTmDdXv2Xr_c0btYWfWA_eTBQnCzqJbI7DT1OG2FoHw8n71jUFqk014uJv06P1rx-179jMPJHrTSjf3Zj-HOuc=@proton.me>
In-Reply-To: <20230601134946.3887870-7-aliceryhl@google.com>
References: <20230601134946.3887870-1-aliceryhl@google.com> <20230601134946.3887870-7-aliceryhl@google.com>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.06.23 15:49, Alice Ryhl wrote:
> This implements the `WorkItemPointer` trait for the pointer types that
> you are likely to use the workqueue with. The `Arc` type is for
> reference counted objects, and the `Pin<Box<T>>` type is for objects
> where the caller has exclusive ownership of the object.
>=20
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

I have a small nit below.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   rust/kernel/workqueue.rs | 97 +++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 96 insertions(+), 1 deletion(-)
>=20
> diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
> index dbf0aab29a85..f06a2f036d8b 100644
> --- a/rust/kernel/workqueue.rs
> +++ b/rust/kernel/workqueue.rs
> @@ -28,8 +28,10 @@
>   //!
>   //! C header: [`include/linux/workqueue.h`](../../../../include/linux/w=
orkqueue.h)
>=20
> -use crate::{bindings, prelude::*, types::Opaque};
> +use crate::{bindings, prelude::*, sync::Arc, types::Opaque};
> +use alloc::boxed::Box;
>   use core::marker::{PhantomData, PhantomPinned};
> +use core::pin::Pin;
>=20
>   /// A kernel work queue.
>   ///
> @@ -323,6 +325,99 @@ unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crat=
e::workqueue::Work<$work_typ
>       )*};
>   }
>=20
> +unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
> +where
> +    T: WorkItem<ID, Pointer =3D Self>,
> +    T: HasWork<T, ID>,
> +{
> +    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
> +        // SAFETY: The `__enqueue` method always uses a `work_struct` st=
ored in a `Work<T, ID>`.
> +        let ptr =3D ptr as *mut Work<T, ID>;
> +        // SAFETY: This computes the pointer that `__enqueue` got from `=
Arc::into_raw`.
> +        let ptr =3D unsafe { T::work_container_of(ptr) };
> +        // SAFETY: This pointer comes from `Arc::into_raw` and we've bee=
n given back ownership.
> +        let arc =3D unsafe { Arc::from_raw(ptr) };
> +
> +        T::run(arc)
> +    }
> +}
> +
> +unsafe impl<T, const ID: u64> RawWorkItem<ID> for Arc<T>
> +where
> +    T: WorkItem<ID, Pointer =3D Self>,
> +    T: HasWork<T, ID>,
> +{
> +    type EnqueueOutput =3D Result<(), Self>;
> +
> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutpu=
t
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool,
> +    {
> +        // Casting between const and mut is not a problem as long as the=
 pointer is a raw pointer.
> +        let ptr =3D Arc::into_raw(self) as *mut T;

I personally would prefer `cast_mut()` here.

--=20
Cheers,
Benno

> +
> +        // SAFETY: Pointers into an `Arc` point at a valid value.
> +        let work_ptr =3D unsafe { T::raw_get_work(ptr) };
> +        // SAFETY: `raw_get_work` returns a pointer to a valid value.
> +        let work_ptr =3D unsafe { Work::raw_get(work_ptr) };
> +
> +        if queue_work_on(work_ptr) {
> +            Ok(())
> +        } else {
> +            // SAFETY: The work queue has not taken ownership of the poi=
nter.
> +            Err(unsafe { Arc::from_raw(ptr) })
> +        }
> +    }
> +}
> +
> +unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<Box<T>>
> +where
> +    T: WorkItem<ID, Pointer =3D Self>,
> +    T: HasWork<T, ID>,
> +{
> +    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
> +        // SAFETY: The `__enqueue` method always uses a `work_struct` st=
ored in a `Work<T, ID>`.
> +        let ptr =3D ptr as *mut Work<T, ID>;
> +        // SAFETY: This computes the pointer that `__enqueue` got from `=
Arc::into_raw`.
> +        let ptr =3D unsafe { T::work_container_of(ptr) };
> +        // SAFETY: This pointer comes from `Arc::into_raw` and we've bee=
n given back ownership.
> +        let boxed =3D unsafe { Box::from_raw(ptr) };
> +        // SAFETY: The box was already pinned when it was enqueued.
> +        let pinned =3D unsafe { Pin::new_unchecked(boxed) };
> +
> +        T::run(pinned)
> +    }
> +}
> +
> +unsafe impl<T, const ID: u64> RawWorkItem<ID> for Pin<Box<T>>
> +where
> +    T: WorkItem<ID, Pointer =3D Self>,
> +    T: HasWork<T, ID>,
> +{
> +    type EnqueueOutput =3D ();
> +
> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutpu=
t
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool,
> +    {
> +        // SAFETY: We're not going to move `self` or any of its fields, =
so its okay to temporarily
> +        // remove the `Pin` wrapper.
> +        let boxed =3D unsafe { Pin::into_inner_unchecked(self) };
> +        let ptr =3D Box::into_raw(boxed);
> +
> +        // SAFETY: Pointers into a `Box` point at a valid value.
> +        let work_ptr =3D unsafe { T::raw_get_work(ptr) };
> +        // SAFETY: `raw_get_work` returns a pointer to a valid value.
> +        let work_ptr =3D unsafe { Work::raw_get(work_ptr) };
> +
> +        if !queue_work_on(work_ptr) {
> +            // SAFETY: This method requires exclusive ownership of the b=
ox, so it cannot be in a
> +            // workqueue.
> +            unsafe { ::core::hint::unreachable_unchecked() }
> +        }
> +    }
> +}
> +
>   /// Returns the system work queue (`system_wq`).
>   ///
>   /// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU m=
ulti-threaded. There are
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>=20

