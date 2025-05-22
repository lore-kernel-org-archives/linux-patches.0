Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57CD517;
	Thu, 22 May 2025 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747896862; cv=none; b=VpKjsSVWn2IS5NTYJ15vnQzFqouRnpQkFTv06udkzD3j7LWLRsuAzBRBFpES+KPndg6ojRr2QmH5wKDJIRdumb67sa+WpkEy/KFh7zfcPWiyxphNBrUivRPuCQ7lEeNSSKn7YWauPtxVIZPMmisdxDR/rb1Ko8IdorIyIviLH0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747896862; c=relaxed/simple;
	bh=kawiY0JhilbZz8Xe2w4qeL4gCrofrUP/ZZz71VqiLyY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=B4JJvImIVdHqBcj1cfgl8R7i7r4Q7oQCk5cGWjYoNaU9HkC1zT0ykyAD/WmFqlRJr7laJYOt55mkNlZ8kFWa/bz9Raoa2M0qO80eau1uKAd00Zq3X34nTFVIqGm1T+1/ULGna3iKQjch2rIvusVFb3/7Ei0V/0X66OO/BnOoYrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdXi97yH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdXi97yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6492C4CEE4;
	Thu, 22 May 2025 06:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747896862;
	bh=kawiY0JhilbZz8Xe2w4qeL4gCrofrUP/ZZz71VqiLyY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gdXi97yH+FlKJerb5KxklLLkduGGoLXoGf+x2bJ7BPqL8IabaTsWCCH+VPtr0RAzm
	 tH1tkCrxj9E4VRWI+m8CuV2SU/ef1zBoqVKfgN3GPhK+f56aMM5jDeI6yxmaXwHENC
	 hHqd2JzzIhKt9W481FHT5I+ilmwqufGGPSGvUL3ecotZAdB8UJXMTdeXONU+/RY3dk
	 HkM6F96w1s9DUXz3PXPwbaiOxx+tdWGeDLbMA02CII01aNVajT+zEquTkE7r7UhUZg
	 aPm/zjbwaUmPRmuvAAALAvm4YkpBa2qbpLBvAnlucry5IxWoiLIqyQGAabnkjiGX6N
	 NOE81qq3bZyOw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,  Boqun Feng <boqun.feng@gmail.com>,
  Gary Guo <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
  Benno Lossin <benno.lossin@proton.me>,  Alice Ryhl
 <aliceryhl@google.com>,  Trevor Gross <tmgross@umich.edu>,  Danilo
 Krummrich <dakr@kernel.org>,  rust-for-linux@vger.kernel.org,
  linux-kernel@vger.kernel.org,  patches@lists.linux.dev
Subject: Re: [PATCH] rust: workaround `bindgen` issue with forward
 references to `enum` types
In-Reply-To: <20250325184309.97170-1-ojeda@kernel.org> (Miguel Ojeda's message
	of "Tue, 25 Mar 2025 19:43:09 +0100")
References: <20250325184309.97170-1-ojeda@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Thu, 22 May 2025 08:50:55 +0200
Message-ID: <874ixddtps.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Miguel Ojeda <ojeda@kernel.org> writes:

> `bindgen` currently generates the wrong type for an `enum` when there
> is a forward reference to it. For instance:
>
>     enum E;
>     enum E { A };
>
> generates:
>
>     pub const E_A: E = 0;
>     pub type E = i32;
>
> instead of the expected:
>
>     pub const E_A: E = 0;
>     pub type E = ffi::c_uint;
>
> The issue was reported to upstream `bindgen` [1].
>
> Now, both GCC and Clang support silently these forward references to
> `enum` types, unless `-Wpedantic` is passed, and it turns out that some
> headers in the kernel depend on them.
>
> Thus, depending on how the headers are included, which in turn may depend
> on the kernel configuration or the architecture, we may get a different
> type on the Rust side for a given C `enum`.
>
> That can be quite confusing, to say the least, especially since
> developers may only notice issues when building for other architectures
> like in [2]. In particular, they may end up forcing a cast and adding
> an `#[allow(clippy::unnecessary_cast)]` like it was done in commit
> 94e05a66ea3e ("rust: hrtimer: allow timer restart from timer handler"),
> which isn't great.
>
> Instead, let's have a section at the top of our `bindings_helper.h` that
> `#include`s the headers with the affected types -- hopefully there are
> not many cases and there is a single ordering that covers all cases.
>
> This allows us to remove the cast and the `#[allow]`, thus keeping the
> correct code in the source files. When the issue gets resolved in upstream
> `bindgen` (and we update our minimum `bindgen` version), we can easily
> remove this section at the top.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3179 [1]
> Link: https://lore.kernel.org/rust-for-linux/87tt7md1s6.fsf@kernel.org/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>


Acked-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg



