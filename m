Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3169C381C8;
	Thu, 25 Jul 2024 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929520; cv=none; b=u4RpLISBhN5gRBlhI9SoWrpjkOVv/nuujlFi4KMWQUd0gmwpth7lVYHS5M3p/X9fDkQXncKduydRywm08qkEEgkvxJQkzfu/EYQYS0TbtaaFoULsh3BQvYwasaHF5d3zMAPoeaq3wlssJ8iJSB9mBW4PFrE/9UmgKV8MH+Ko0yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929520; c=relaxed/simple;
	bh=kKdCpSwcV4ucTAk7AOlpt3jPIzmwlNsjUHXXsUaItlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7lO4bSutGkPT8taEOKPAsAQnHHIbquVd9/gtnf6rwQMNdVf/E/3CwfgkLFknKJKtN87LrzTogjzwdDWBTX8SR4zoc6Fo+r7Ic/ZTy583qMKx0S9XzS4IBxgU/JEpu7HvPEcNzYLAo2aoTr0BV32WqrLYpjqKLZcf9DXFhga2H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEWbXfDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEWbXfDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D6C116B1;
	Thu, 25 Jul 2024 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721929519;
	bh=kKdCpSwcV4ucTAk7AOlpt3jPIzmwlNsjUHXXsUaItlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEWbXfDyZuIHwdeeGnbcEhrHKtCZ0+AdKh5xcZUZSI+ZsdzZZgO+eQ+taH0Kpb8m3
	 NNMu2RYDT8t5Nty2NQDOhZXqlFvesWM1YyOoYfXFL5q+xybD1TwQz/6ux3fZcAy6DY
	 RtVucDuJ8kGbihNGBjfDhOzi2ZHTRDzIOxfMyBbSWTmSBbd0DLFa6OGbuaaYNIs7sO
	 bLkM2WrRGoClrHGKHPVrprXVG93pMf/9oJFQ9hCRiVP1Oy1ZZ+Lrs/2l6Ygh2sB33L
	 v8amRTk5b39iK00SSkFM47Zsntg7PyGmpeyBp03pUTZ78s/BFOfDCaHiKAVghRuUcs
	 JHbckgca0nRSw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gary@garyguo.net
Cc: a.hindborg@samsung.com,
	alex.gaynor@gmail.com,
	aliceryhl@google.com,
	benno.lossin@proton.me,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	jpoimboe@kernel.org,
	linux-kernel@vger.kernel.org,
	masahiroy@kernel.org,
	mingo@redhat.com,
	nathan@kernel.org,
	nicolas@fjasle.eu,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	peterz@infradead.org,
	rust-for-linux@vger.kernel.org,
	tglx@linutronix.de,
	wedsonaf@gmail.com,
	x86@kernel.org
Subject: Re: Re: [PATCH v2 1/6] rust: module: add static pointer to `{init,cleanup}_module()`
Date: Thu, 25 Jul 2024 19:44:49 +0200
Message-ID: <20240725174449.102724-1-ojeda@kernel.org>
In-Reply-To: <20240724204649.7de3ffed.gary@garyguo.net>
References: <20240724204649.7de3ffed.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 24 Jul 2024 20:46:49 +0100 Gary Guo <gary@garyguo.net> wrote:
>
> On Wed, 24 Jul 2024 18:14:54 +0200
> Miguel Ojeda <ojeda@kernel.org> wrote:
>
> > Add the equivalent of the `___ADDRESSABLE()` annotation in the
> > `module_{init,exit}` macros to the Rust `module!` macro.
> >
> > Without this, `objtool` would complain if enabled for Rust, e.g.:
> >
> >     samples/rust/rust_print.o: warning: objtool: cleanup_module(): not an indirect call target
> >     samples/rust/rust_print.o: warning: objtool: init_module(): not an indirect call target
> >
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  rust/macros/module.rs | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/rust/macros/module.rs b/rust/macros/module.rs
> > index 411dc103d82e..571ffa2e189c 100644
> > --- a/rust/macros/module.rs
> > +++ b/rust/macros/module.rs
> > @@ -256,6 +256,12 @@ mod __module_init {{
> >                          unsafe {{ __init() }}
> >                      }}
> >
> > +                    #[cfg(MODULE)]
> > +                    #[doc(hidden)]
> > +                    #[used]
> > +                    #[link_section = \".init.data\"]
>
> Should this be in section `.discard.addressable` instead?
>
> > +                    static __UNIQUE_ID___addressable_init_module: unsafe extern \"C\" fn() -> i32 = init_module;
> > +
> >                      #[cfg(MODULE)]
> >                      #[doc(hidden)]
> >                      #[no_mangle]
> > @@ -269,6 +275,12 @@ mod __module_init {{
> >                          unsafe {{ __exit() }}
> >                      }}
> >
> > +                    #[cfg(MODULE)]
> > +                    #[doc(hidden)]
> > +                    #[used]
> > +                    #[link_section = \".exit.data\"]
> > +                    static __UNIQUE_ID___addressable_cleanup_module: extern \"C\" fn() = cleanup_module;
> > +
> >                      // Built-in modules are initialized through an initcall pointer
> >                      // and the identifiers need to be unique.
> >                      #[cfg(not(MODULE))]

Boot-tested under QEMU for Rust:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
