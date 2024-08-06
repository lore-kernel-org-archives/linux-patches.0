Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BEF15444E;
	Tue,  6 Aug 2024 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722973362; cv=none; b=HQMYdYx5QV5MGnpDQG6CyhOEaoH8TIbhKMo5CVCY+jRXDkp4u6ZUGKco3pf0X0+D7ksHjRBzaPrjN2oVtXbmdizC8uClPHqIgXZJ+q4q6h5layfy6mgotdmDHy5d8mUa3CH+HxGjtRDcKNyE64ihP+Au3Pw0nhharxKF4Pah7Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722973362; c=relaxed/simple;
	bh=A6wuRUtfgg1q7zJnhSwgRYW1regIAczoPJ9M7ZNTQPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSnBmrmmOccVWK7DjqYBnOS6weS8xAyLvhg17syy2OMGW4SQucD44lw+Z6WSWEc9MqWIMKUG3e1g5o6tqqLvXcSbi7aIeFEvbrtaUrk4nrfe+KDaoBlJauKRo5tgQzA1pA9oxZkGTfmXzccFSLzkHwyBlcJWtbYc/Ye6cEC2tu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn93Maia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn93Maia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB210C32786;
	Tue,  6 Aug 2024 19:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722973361;
	bh=A6wuRUtfgg1q7zJnhSwgRYW1regIAczoPJ9M7ZNTQPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hn93MaiaMX8jKd2xmiJiNo+7tzNOOV3BEu6J3Q+G9l8enc8swjm4sTKHw0VrwjUu+
	 MkQolnpS0D7YlL1/xbQBXfdsiPzT+JyOCkkNCgNz4xnBpGIP7sHJpAlyy13vLoCekC
	 Lx1JkX7b5TDMsQNXNBVfhIGl/6siwTXMrWtEQWKdzeqYgvXypyaYXVdNm00F5GnmVf
	 68APEYskHQn3fq17vQYouJuihB8Cn4yE94uaWac/MktSfRoQU5Af6VOmDxOTfM4n5W
	 fes0NU13Cu4SJA3EgGESo72co35hb5cPZOQ3A4xQ3NhOh4h8IAJdwLR7zGTW+VI1sD
	 EU4NtdKezNWEA==
Date: Tue, 6 Aug 2024 12:42:41 -0700
From: Kees Cook <kees@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 5/6] objtool/rust: list `noreturn` Rust functions
Message-ID: <202408061241.855CB28@keescook>
References: <20240725183325.122827-1-ojeda@kernel.org>
 <20240725183325.122827-6-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725183325.122827-6-ojeda@kernel.org>

On Thu, Jul 25, 2024 at 08:33:22PM +0200, Miguel Ojeda wrote:
> Rust functions may be `noreturn` (i.e. diverging) by returning the
> "never" type, `!`, e.g.
> 
>     fn f() -> ! {
>         loop {}
>     }
> 
> Thus list the known `noreturn` functions to avoid such warnings.
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     rust/core.o: warning: objtool:
>     _R...9panic_fmt() falls through to next function _R...18panic_nounwind_fmt()
> 
>     rust/alloc.o: warning: objtool:
>     .text: unexpected end of section
> 
> In order to do so, we cannot match symbols' names exactly, for two
> reasons:
> 
>   - Rust mangling scheme [1] contains disambiguators [2] which we
>     cannot predict (e.g. they may vary depending on the compiler version).
> 
>     One possibility to solve this would be to parse v0 and ignore/zero
>     those before comparison.
> 
>   - Some of the diverging functions come from `core`, i.e. the Rust
>     standard library, which may change with each compiler version
>     since they are implementation details (e.g. `panic_internals`).
> 
> Thus, to workaround both issues, only part of the symbols are matched,
> instead of using the `NORETURN` macro in `noreturns.h`.
> 
> Ideally, just like for the C side, we should have a better solution. For
> instance, the compiler could give us the list via something like:
> 
>     $ rustc --emit=noreturns ...

Yeah, having added noreturns to objtool myself a few times, it'd be nice
to have a way to make these manual lists go away some day.

> 
> Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html [1]
> Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguator [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
