Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356374A00;
	Fri, 15 Aug 2025 21:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292749; cv=none; b=Pmye63jeOUzWGHGHB1Zs5HCVymlemL6lcwRr40X+fEDNIIamRHDmyOlyajcZ4gXCZJgUy+9ba59T67Am9CT/gj2Al+PSXm+LgZ5zAKGCShhfZlQbWmS3nHg71o5TkDgEDTFFoBT4BtnoTjvpPIHb8hhJvTGWZ3d1/Ep1Ix4BDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292749; c=relaxed/simple;
	bh=bhEvK5wK2YtXTqi0pcFGbwLRtRhDbn8qEwcWJyPDIl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZf0nlrj7p7JF+M7RgVKdB2iri556WOgsOuuuGbXD7Ka0KTcA7dFxKYVl037JJzmNw/HHxESIAt6XRyS8R/2c5zVPJJZlG4H1kdlJnluXCxFKQVy4mhmNVU4E5zaBJ2fVfamFUZ5vke3O+jO6UNtj9jGEONai6VwGPQdJtKq+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCEEO9d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCEEO9d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EDBC4CEEB;
	Fri, 15 Aug 2025 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755292748;
	bh=bhEvK5wK2YtXTqi0pcFGbwLRtRhDbn8qEwcWJyPDIl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OCEEO9d414p+6Udjxo+1FmsrM7oKnOJfVjQGPBeV6CGKLFNIaMSbQAR+hILUCH+Cg
	 UnnE+YMqvTgcjPqSJOBLXF5ls7xoCn28hMAvea/nsHFahCND82tEL4asID8M/YsmIR
	 F2BSoAY3rY3Ape6Mvh90d8hzr6ujzF43dswID1gJu5a0HlkxLmCArceaU275JJXaBQ
	 Quh4o95q6sw8mrmt2pQQaxB+Xqc0TQ4vyOxsVZGeaJPi4cc/qPrS+uliMQ/0R3Bc68
	 WUuWEIf+HKXxE1oY5YTgLC4MpsRloH73GHWFTTVmymW+M45xC1j0sY/ngj76qgbqAI
	 SH0za9Qjh/Org==
Message-ID: <1117b9e5-b46a-4661-bfe9-56ff844c1218@kernel.org>
Date: Fri, 15 Aug 2025 23:19:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm: nova-drm: fix 32-bit arm build
To: Miguel Ojeda <ojeda@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Gaynor <alex.gaynor@gmail.com>, nouveau@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250724165441.2105632-1-ojeda@kernel.org>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20250724165441.2105632-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/24/25 6:54 PM, Miguel Ojeda wrote:
> In 32-bit arm, the build fails with:
> 
>      error[E0308]: mismatched types
>        --> drivers/gpu/drm/nova/file.rs:42:28
>         |
>      42 |         getparam.set_value(value);
>         |                  --------- ^^^^^ expected `u64`, found `u32`
>         |                  |
>         |                  arguments to this method are incorrect
>         |
>      note: method defined here
>        --> drivers/gpu/drm/nova/uapi.rs:29:12
>         |
>      29 |     pub fn set_value(&self, v: u64) {
>         |            ^^^^^^^^^        ------
>      help: you can convert a `u32` to a `u64`
>         |
>      42 |         getparam.set_value(value.into());
>         |                                 +++++++
> 
> The reason is that `Getparam::set_value` takes a `u64` (from the UAPI),
> but `pci::Device::resource_len()` returns a `resource_size_t`, which is a
> `phys_addr_t`, which may be 32- or 64-bit.
> 
> Thus add an `into()` call to support the 32-bit case, while allowing the
> Clippy lint that complains in the 64-bit case where the type is the same.
> 
> Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to drm-misc-fixes, thanks!
