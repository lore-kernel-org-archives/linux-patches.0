Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDA23A9BE;
	Thu, 13 Feb 2025 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739455158; cv=none; b=BastS8pUujXM+dqKojrLCzLvV7zh/7O75nb42mm8eJsiT/RpAjy95LBkleaGaHefwjKDkfDzm92GIt1BpMDQDlfOEaGB3T/ieA7N93WbLaAGRu/t6AloqgOHyYXfWvQl3Piok//lUIjNcSdr9zS5stYVZ3MpkZaXDm85TvxRWmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739455158; c=relaxed/simple;
	bh=kv8C+kxdksKQcbyaE9UMSrjCRll+aHQKDRacT2Sl+DY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4e+2/YIITT7acJJA+gNPwzgBZi8t9oDobbpxEJ/qZKrabFQ3mqsi9DICHl+LobxeH2e6sZg4Bmz0URnhlHJrn0PwnPmjMCWkUFLvhUVxeJ89VdwBnyOO1QrYqErcoTRqHzME8DV25vLPj3l++HINXcD67xqJUZtjpqSJO87P2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qn6f0oGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qn6f0oGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F22C4CED1;
	Thu, 13 Feb 2025 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739455155;
	bh=kv8C+kxdksKQcbyaE9UMSrjCRll+aHQKDRacT2Sl+DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qn6f0oGkfzm3ZF9c8O9NpMF2Q7fffS0EaCnoaKJ6Eb93wi7isvxhmY7HYv66J/L0o
	 LPxRdwJGBa92FKp35t7YYtP3kS8vQsxcgj1zRbHE7LU18NonBDr/m7+N/rEzSt6y5H
	 +nyidMsO87ldbfNBgD48xh3+tJm0jfTWCHn3XdzJQ1W/dQ4nsDlQ6NnRy5Kt3yQrmr
	 isfhA7Yiqa6By/qm3oA8K74ldOI+OTCTjlQIkEXOEso5aGVeonJOl5iWCtAMBZUQHv
	 rCah0T0Ly/TM07li5RwXINzwO7uKIXJpVgfF/dqwjxEPyVcpH3RGHtRPSejKJU+04f
	 B52m23KMCijaw==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Matthew Maurer <mmaurer@google.com>,
	Ralf Jung <post@ralfj.de>,
	Jubilee Young <workingjubilee@gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
Date: Thu, 13 Feb 2025 13:59:03 +0000
Message-Id: <173944714987.2610867.13703061512287477883.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250210163732.281786-1-ojeda@kernel.org>
References: <20250210163732.281786-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 10 Feb 2025 17:37:32 +0100, Miguel Ojeda wrote:
> Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
> [1] about disabling neon in the aarch64 hardfloat target:
> 
>     warning: target feature `neon` cannot be toggled with
>              `-Ctarget-feature`: unsound on hard-float targets
>              because it changes float ABI
>       |
>       = note: this was previously accepted by the compiler but
>               is being phased out; it will become a hard error
>               in a future release!
>       = note: for more information, see issue #116344
>               <https://github.com/rust-lang/rust/issues/116344>
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: rust: clean Rust 1.85.0 warning using softfloat target
      https://git.kernel.org/arm64/c/446a8351f160

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
