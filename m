Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC248CFC;
	Sun, 23 Nov 2025 20:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763929551; cv=none; b=lnIs833Kyvz9y5RWlKf0Z4Uh9fwqK8DodyeU1MZ0IQmqxHRytPYl3vRf1Nb7NO8AnAlPTOcuey0gK313eQ7q4hB4JL1ndi4c7sG1ylZ5oHs1tx7McHIAfHNs5rCdbQnCVfMUKraJPPimFhbjK85H4WICmjaY37JOrp1mlUy1V3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763929551; c=relaxed/simple;
	bh=wh7RccjyDJD2jcJ3VNpQfrJiY0kJ2+Aa8jfu5mYV9VA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=q8p5QNG0BOARZx/n+eAOZM8vTlr8ponKmyn7aMsHdVu2OSVM3p2EGf4nvcG2lOhmDnU0thLzQYF7I/a+lXMeXknDT5vb580MScVghXcIwUX8+nDAeIcZE2qzaCIOX+JdwGAI3a47OiJN64i5Q0+GVScyzadQ5P71jMXgAfmRKNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udnKUXq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udnKUXq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B40C113D0;
	Sun, 23 Nov 2025 20:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763929550;
	bh=wh7RccjyDJD2jcJ3VNpQfrJiY0kJ2+Aa8jfu5mYV9VA=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=udnKUXq0WePQWzhx7q+9X0rirHnMX6lOqazwicffyz95Aojey/w6ZOe9Nj3j40s22
	 wsIWJHxTnd+K9KpkdhpWnIhDRmcKp6RV++iZkc9wkcm50pVuyoYhpT1IMi/n8nWaBM
	 wmW6IgKzncebeXgUZ50D8CmncAmtI35xnURzr18pvSaSWu4HGiiadrv8T0quSsmcov
	 tQ2qzgNMPhzjpxOohoHvgTh1pea/W9f13sPuiRZ9QzhpnTHDnFo30kaAe3f7kn6SUn
	 EvNzIRw8Q5lG1dDZUKIU8XvxA5WfieqLXqG/gZqQOGr1IMzFiE1Obd7zWkxdxu4rMi
	 Cg5E0H2fBLDoA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2025 09:25:44 +1300
Message-Id: <DEGCU5OZP560.SWESWJ4G920F@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: i2c: prepare for `core::ffi::CStr`
Cc: "Igor Korotin" <igor.korotin.linux@gmail.com>, "Stephen Rothwell"
 <sfr@canb.auug.org.au>, "Greg KH" <greg@kroah.com>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Daniel Almeida" <daniel.almeida@collabora.com>,
 <rust-for-linux@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
References: <20251123163536.1771801-1-ojeda@kernel.org>
In-Reply-To: <20251123163536.1771801-1-ojeda@kernel.org>

On Mon Nov 24, 2025 at 5:35 AM NZDT, Miguel Ojeda wrote:
> The rust-next tree contains commit:
>
>     3b83f5d5e78a ("rust: replace `CStr` with `core::ffi::CStr`")
>
> which, when merged together with commits:
>
>     57c5bd9aee94 ("rust: i2c: add basic I2C device and driver abstraction=
s")
>     f3cc26a417b7 ("rust: i2c: add manual I2C device creation abstractions=
")
>
> from this tree (driver-core), produces errors like the following:
>
>     error[E0599]: no method named `len_with_nul` found for reference `&'s=
tatic ffi::CStr` in the current scope
>       --> rust/kernel/i2c.rs:48:16
>        |
>     48 |             id.len_with_nul() <=3D Self::I2C_NAME_SIZE,
>        |                ^^^^^^^^^^^^ method not found in `&CStr`
>
>     error[E0599]: no method named `as_bytes_with_nul` found for reference=
 `&'static ffi::CStr` in the current scope
>       --> rust/kernel/i2c.rs:51:22
>        |
>     51 |         let src =3D id.as_bytes_with_nul();
>        |                      ^^^^^^^^^^^^^^^^^
>        |
>     help: there is a method `to_bytes_with_nul` with a similar name
>        |
>     51 |         let src =3D id.to_bytes_with_nul();
>        |                      ~~~~~~~~~~~~~~~~~
>
> which were detected in linux-next by Stephen [1].
>
> The `i2c` code can be independently prepared to be ready for the change,
> thus do so.
>
> The change is similar to the one done by Tamir in commit 657403637f7d
> ("rust: acpi: use `core::ffi::CStr` method names").
>
> Link: https://lore.kernel.org/all/20251120181111.65ce75a0@canb.auug.org.a=
u/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to driver-core-next, thanks!
