Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C9A6FCD
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 15:16:33 +0000 (UTC)
Date: Thu, 30 Mar 2023 15:16:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680189390; x=1680448590;
	bh=RFJsZt4PoyY34NqeT0ENI5ZWm6qyrS5nHiUvq+C365Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cOof9CWD18CgA86f1wPCs6LHKCiYvfg3NtPnu42gtskj0YfGSo8dJf+7s6QN4g+58
	 DeYkftVFrBPmOl02YrYw44gCxVO66GhuHn5FAX8BJevHqmKvbj/qtGVTOt/uOj5T01
	 I3ItVqd67QmPUb8LGhV/Rmx3LzNO8G3wQx32wgPNxHvzNNkpmMwQE2ls291232cjD3
	 DK+udlLKGLEC0CM2dYGnFlboDS+NJCsDnXJWkZEChNBj7t3r0qtCEI0ccCpjF7QEyI
	 7YRrxJMSYwuit/73PF9ZXi/J+gVayhDAm5NefJopBphXPIKPCxhgHHYbfd/cxfke9+
	 gvAlfpfYlgvDw==
To: David Laight <David.Laight@ACULAB.COM>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3 12/13] rust: sync: reduce stack usage of `UniqueArc::try_new_uninit`
Message-ID: <ed3f5907-bc28-46b5-5a61-79dd2719349f@protonmail.com>
In-Reply-To: <7f55875c46ab4c4989323ede57f6e46d@AcuMS.aculab.com>
References: <20230329223239.138757-13-y86-dev@protonmail.com> <7f55875c46ab4c4989323ede57f6e46d@AcuMS.aculab.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.03.23 16:58, David Laight wrote:
> From: y86-dev@protonmail.com
>> Sent: 29 March 2023 23:34
>>
>> `UniqueArc::try_new_uninit` calls `Arc::try_new(MaybeUninit::uninit())`.
>> This results in the uninitialized memory being placed on the stack,
>> which may be arbitrarily large due to the generic `T` and thus could
>> cause a stack overflow for large types.
>
> Does that mean rust is using (the equivalent of) alloca() ?

No, the compiler knows the size of `T` statically (this is a requirement
for calling `MaybeUninit::uninit()`). It would simply reserve stack
space for a stack variable (like the C compiler would also do) and since
the type is generic and user-specified, it could be larger than the
stack size. The problem is that the Rust compiler does not optimize the
stack variable away. This fix avoids creating a stack variable in the
first place.

--
Cheers,
Benno


>
> That is banned for C code in the kernel for any sizes.
>
> =09David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)


