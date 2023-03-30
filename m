Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0CA8477
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 15:37:30 +0000 (UTC)
Date: Thu, 30 Mar 2023 15:37:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680190648; x=1680449848;
	bh=8Ckr3U3t4v65Ys60F1em+mj+qQLDAHD7DjiGBhJTkTs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZgF7AqEPozgajYN4fveEAtHr/jgGXLuAhkOHhx0PeQrx6dqC634OWN7hDz2k2IXjN
	 YpwGHan3Njm8+wDCzenB9xuo2rbdDI7C4hg3dWDBECSX+N8XG/jaX4xDBidcy8Dp6C
	 muInA75JR2pwzyAQcbXzuNeXInVPmdw+IKxIrgP16ueTqZPEf7D4UCoVWZh2qTy2uZ
	 zEDoKcECf8QzF2hzeI6OKiIGl2PWztwBdILLv7bRO+eDrkMumIpgxSFpUkWu3YW9pJ
	 5mB7CA8DTvoRHLdfIDi17VbfkPQmV/3UWZplnn4rZX6D0wgLPymWnK+jrpYG+lwM1L
	 LFITn+/piG3sQ==
To: Andreas Hindborg <nmi@metaspace.dk>, Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v3 04/13] rust: add pin-init API core
Message-ID: <caade38e-89ca-a689-7a75-1851025baa51@protonmail.com>
In-Reply-To: <878rfe493r.fsf@metaspace.dk>
References: <20230329223239.138757-1-y86-dev@protonmail.com> <20230329223239.138757-5-y86-dev@protonmail.com> <ce17f68e-521f-f55e-8ae2-35bcd6ebd709@ryhl.io> <878rfe493r.fsf@metaspace.dk>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.03.23 16:16, Andreas Hindborg wrote:
>
> Alice Ryhl <alice@ryhl.io> writes:
>
>> On 3/30/23 00:33, y86-dev@protonmail.com wrote:
>>> From: Benno Lossin <y86-dev@protonmail.com>
>>> This API is used to facilitate safe pinned initialization of structs. I=
t
>>> replaces cumbersome `unsafe` manual initialization with elegant safe ma=
cro
>>> invocations.
>>> Due to the size of this change it has been split into six commits:
>>> 1. This commit introducing the basic public interface: traits and
>>>      functions to represent and create initializers.
>>> 2. Adds the `#[pin_data]`, `pin_init!`, `try_pin_init!`, `init!` and
>>>      `try_init!` macros along with their internal types.
>>> 3. Adds the `InPlaceInit` trait that allows using an initializer to cre=
ate
>>>      an object inside of a `Box<T>` and other smart pointers.
>>> 4. Adds the `PinnedDrop` trait and adds macro support for it in
>>>      the `#[pin_data]` macro.
>>> 5. Adds the `stack_pin_init!` macro allowing to pin-initialize a struct=
 on
>>>      the stack.
>>> 6. Adds the `Zeroable` trait and `init::zeroed` function to initialize
>>>      types that have `0x00` in all bytes as a valid bit pattern.
>>> Co-developed-by: Gary Guo <gary@garyguo.net>
>>> Signed-off-by: Gary Guo <gary@garyguo.net>
>>> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
>>
>> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>>
>>> +//! Aside from pinned initialization, this API also supports in-place =
construction without pinning,
>>> +//! the marcos/types/functions are generally named like the pinned var=
iants without the `pin`
>>> +//! prefix.
>>
>> Typo: Should be "macros".
>>
>>> +type Invariant<T> =3D PhantomData<fn(*mut T) -> *mut T>;
>>
>> I think it would make sense to include a link to the nomicon on the
>> documentation for the Invariant type.
>>
>> E.g. this link: https://doc.rust-lang.org/nomicon/subtyping.html
>
> That would be nice. I think this also applies: https://doc.rust-lang.org/=
nomicon/phantom-data.html#table-of-phantomdata-patterns

Yeah I very commonly use that one as well.

>
>>
>>> +// This is the module-internal type implementing `PinInit` and `Init`.=
 It is unsafe to create this
>>> +// type, since the closure needs to fulfill the same safety requiremen=
t as the
>>> +// `__pinned_init`/`__init` functions.
>>> +struct InitClosure<F, T: ?Sized, E>(F, Invariant<(E, T)>);
>>
>> Documentation for a type should use /// rather than //.
>>
>> I think it would help to call out explicitly in the documentation on thi=
s type
>> that it is an implementation detail of the pin_init_from_closure and
>> init_from_closure methods.
>

--
Cheers,
Benno


