Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C516F8E9;
	Mon,  4 Aug 2025 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754337692; cv=none; b=A2XiLboV7WdGZY0NcnHPLTMg2EAsAFaTyK1fB49/dHKt+LMbCIgdLfxhbJYSPh+F+KtlTvJZBxJDr1lxFLibztI5aZEH5yKMtb+/HErhwZ1FcHJVgWDcZxpbyNNpLbFJ0SFylocffAq47nzZAhd6nkcj32nW/bwbD+DPwVosZwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754337692; c=relaxed/simple;
	bh=3wXg1isZ6lxHlpd3i0U0vaueMgZ8obo0IlMsyyDjL6k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=SXXFAAaWYUpYxjhGg9jGhhdfh+GDaSol6abzRaNYV8QB/EuRGNQAxcbkWVS5oEoUVqt1v2UP24vDRxW7eWHggIN8MbZVExulLcBmioMm1f2XM9ON+lM1UkmN5hn71+26JRe3fFnsUaLLbkvpnoclfpZfFykkiOYSvkivQE/RZ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXb93zCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXb93zCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B124DC4CEE7;
	Mon,  4 Aug 2025 20:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754337691;
	bh=3wXg1isZ6lxHlpd3i0U0vaueMgZ8obo0IlMsyyDjL6k=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=hXb93zCflF2GraAtcpywerQpJVKt14hK5ryzD100/1mxQvw+Pbr2FmtKsn9RkkY/e
	 PNtHy9eFStE6q8rFTOMa0hM95AQgWbheFZHIzhHpxyXPKxdcjK5qsL/m6Pfbp4rhba
	 FxGffF4b0RqK0QUu5t2xoMckV4MJ8ZsVNQAkPz9qgIbnJ6ycl/B5gjpjGD5rEMT+Dn
	 93sofNEa9xeKH2jfWI9FHR5PNh9DPGb//g82L1pyaU947HyhIrZiJpZH2k8pu2ITYE
	 nUm1VA/kUnNAa1rq1SbXb9o+mLmoIZYxMVimr78sQPtYa78XoXuPVYIQof+pqfg1XZ
	 UzVsJyJXoK7+g==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Aug 2025 22:01:26 +0200
Message-Id: <DBTWT3AYHLLR.2NC0F6MRMZPCY@kernel.org>
Subject: Re: [PATCH] rust: faux: fix C header link
From: "Benno Lossin" <lossin@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Danilo Krummrich" <dakr@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250804171311.1186538-1-ojeda@kernel.org>
In-Reply-To: <20250804171311.1186538-1-ojeda@kernel.org>

On Mon Aug 4, 2025 at 7:13 PM CEST, Miguel Ojeda wrote:
> Starting with Rust 1.91.0 (expected 2025-10-30), `rustdoc` has improved
> some false negatives around intra-doc links [1], and it found a broken
> intra-doc link we currently have:
>
>     error: unresolved link to `include/linux/device/faux.h`
>      --> rust/kernel/faux.rs:7:17
>       |
>     7 | //! C header: [`include/linux/device/faux.h`]
>       |                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ no item named `includ=
e/linux/device/faux.h` in scope
>       |
>       =3D help: to escape `[` and `]` characters, add '\' before them lik=
e `\[` or `\]`
>       =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D warni=
ngs`
>       =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_in=
tra_doc_links)]`
>
> Our `srctree/` C header links are not intra-doc links, thus they need
> the link destination.
>
> Thus fix it.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/rust-lang/rust/pull/132748 [1]
> Fixes: 78418f300d39 ("rust/kernel: Add faux device bindings")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
> It may have been in 1.90, but the beta branch does not have it, and the
> rollup PR says 1.91, unlike the PR itself, so I picked 1.91. It happened
> just after the version bump to 1.91, so it may have to do with that.
>
>  rust/kernel/faux.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
