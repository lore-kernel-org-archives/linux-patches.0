Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA128EA
	for <patches@lists.linux.dev>; Fri, 24 Mar 2023 08:39:48 +0000 (UTC)
Date: Fri, 24 Mar 2023 08:39:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1679647185; x=1679906385;
	bh=I8/f3JO/VA5KWyLN4wKp4hGSRAS0uOmn5BtDka1Qfpo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=e1OidOwma+seobgitoxy4TukCO+qj4IBs36t91OuEhT4JbWavof1KoVj/j28ytLU0
	 hIbvgvfRf4lbyL0lFIEnuMFSUeNAwvnZWCwHO/QBPBFsX+/8wedn4Cz5slKHxVWbfY
	 rMuc26kQSIHXkdpt4PFYJuY/1+5PyfTNqyEmsqVZUV5A8tO40LQRHUoMvrPIj9ZBpD
	 wxF0758GJJ5aUXpoqqQKpN+23XTPyQg8X5qqPxFZPVQmk4Y4vATeuv2Zj/sKK47viF
	 bgadAFbZJXBRolAEpj33dG0zFGtEed+pV2bPLmMXJ2YrJmg3tvthIaRYwBIh4zWfw3
	 //uFrPn/NLtew==
To: Boqun Feng <boqun.feng@gmail.com>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 3/5] rust: add pin-init API
Message-ID: <15f01078-4756-8f87-fe3c-ab9f433ebe7a@protonmail.com>
In-Reply-To: <ZBvyCwPcpTnk2R7h@Boquns-Mac-mini.local>
References: <20230321194934.908891-1-y86-dev@protonmail.com> <20230321194934.908891-4-y86-dev@protonmail.com> <ZBvyCwPcpTnk2R7h@Boquns-Mac-mini.local>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 23.03.23 07:30, Boqun Feng wrote:
> On Tue, Mar 21, 2023 at 07:50:00PM +0000, Benno Lossin wrote:
> [...]
>> +/// # Syntax
>> +///
>> +/// As already mentioned in the examples above, inside of `pin_init!` a=
 `struct` initializer with
>> +/// the following modifications is expected:
>> +/// - Fields that you want to initialize in-place have to use `<-` inst=
ead of `:`.
>> +/// - In front of the initializer you can write `&this in` to have acce=
ss to a [`NonNull<Self>`]
>> +///   pointer named `this` inside of the initializer.
>> +///
>> +/// For instance:
>> +///
>> +/// ```rust
>> +/// # use kernel::pin_init;
>> +/// # use macros::pin_data;
>> +/// # use core::{ptr::addr_of_mut, marker::PhantomPinned};
>> +/// #[pin_data]
>> +/// struct Buf {
>> +///     ptr: *mut u8,
>> +///     buf: [u8; 64],
>
> Say we have an extra field,
>
>             a: u8,
>
>> +///     #[pin]
>> +///     pin: PhantomPinned,
>> +/// }
>> +/// pin_init!(&this in Buf {
>> +///     buf: [0; 64],
>> +///     ptr: unsafe { addr_of_mut!((*this.as_ptr()).buf).cast() },
>
> And I think we want to disallow:
>
>             a: unsafe { (*addr_of!(*this.as_ptr().buf))[0] }
>
> , right? Because we don't want `pin_init!` to provide any initialization
> order guarantee? If so, maybe add one or two sentences to call it out.
>
> If not sure, I think we can leave it as it is, until someone really uses
> this pattern ;-)

The `pin_init!` macro initializes everything in the order specified, so
if `a` is the last field you initialize, the code above is fine. I think
we could guarantee this. I will add a comment.

--
Cheers,
Benno


