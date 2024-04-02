Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FBF2260B
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 23:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712099573; cv=none; b=lxDV/cpC+estomBA07wsX2K1sX3hutZWQtoklDxRW4MqvUTXpmz2JecRIu54e7+VEbKG9Ew+H56sLsDS5m8uetAomysQYIBRkVS7JyTkgfaSylTsmS8Q1HbJaRPvsP4IDR71WxF4jdSMY4TBckhuAWrTXrXNP4IB/4OSFVCq4zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712099573; c=relaxed/simple;
	bh=ISUfOU57QgrLWxhCGJ/GHKVno9fuuJDzYoEuzYMJAlM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDEVhAfd+V++gF+FE7ILJzMgwSglfFw7G+hjtrkJh4PYR2CNbwz+OJPl5sRtpbjEmQTn/ke2Guw2lLZ6WInHZp6lahfXrHHWW/X8guGPgrVZxZsNqaW8dvAxJ1qLfEiTiXnd/hwOJ8ICGazWVbIuzeL9DmJDV0Zk+d5dSXfWH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=fBq6ghhy; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="fBq6ghhy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=udn2gpk5o5abrkg5wd27zn4c7i.protonmail; t=1712099570; x=1712358770;
	bh=a9z7KkY1+VPo5bgUnt999smbqG9zGxvsVoJhcl2u2YU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fBq6ghhyMkczJShIhIj7q3jMiQonmrv0u5/Jxt8kS+1uxdrFkddxiHkrWfMdaa9nL
	 P9/v/DZ9TnAkQDRI8jFZxu2QC+IRKmBuStd4x3hCBbQdJPtsPUy1vjzMWKfUxOKQak
	 bBDoxH85PlKUdI6wxbx92gevDGQig3xI24XViNJcOoWbwkPwSna2gLHwvzh4lDr558
	 zqmMyabkyxtnqmz14PAWpgYx8MR2ObHK2Pfk00xUm+uwGwnsh16cAqPL2Km+ZmGZ8t
	 MGPx2gKMUztbkhs0ggH/GCOUTyWTImn7S71dbjh9v9N1qqSvIcBuOI4X8SI+epLLS1
	 B3jxXQtqxQc4A==
Date: Tue, 02 Apr 2024 23:12:45 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] rust: sync: implement `Default` for `LockClassKey`
Message-ID: <0d6378ce-8099-4e04-b4a2-3663f01b8d9e@proton.me>
In-Reply-To: <20240401212303.537355-2-ojeda@kernel.org>
References: <20240401212303.537355-1-ojeda@kernel.org> <20240401212303.537355-2-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.04.24 23:23, Miguel Ojeda wrote:
> In the upcoming Rust 1.78.0, Clippy suggests to implement `Default` even
> when `new()` is `const`, since `Default::default()` may call `const`
> functions even if it is not `const` itself [1]:
>=20
>      error: you should consider adding a `Default` implementation for `Lo=
ckClassKey`
>        --> rust/kernel/sync.rs:31:5
>         |
>      31 | /     pub const fn new() -> Self {
>      32 | |         Self(Opaque::uninit())
>      33 | |     }
>         | |_____^
>=20
> Thus implement it.
>=20
> Link: https://github.com/rust-lang/rust-clippy/pull/10903 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   rust/kernel/sync.rs | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

--=20
Cheers,
Benno

