Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB13C5552;
	Tue, 12 May 2026 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620440; cv=none; b=CkDVmtF/k5jbZ9LbiSBnYLjulxs8fci6obo6/7J2IVZLlOqAHZxxrXmLNfFftuv1sG5h2TVDHhekPpgrmJ35RD5FtRi4F3t9suX8iK8PPWeCQJHm0PNsZ8iVaIyHE5wElyyktZzE6b0kkcYCJnnAIdYrpz609it0ncQrEKWzLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620440; c=relaxed/simple;
	bh=h4gbD37Rz2ep9V7OBJ01B+g+SZog+1RZ402j6cfob5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQuYvSlXzCC0AhthbJ+bhv2ec4nliz444511SaDocMYANV7bZdE5pcJtJCIMkK+/mXAaMu0pC+o2JaWCilF7Ec7VfHQIFuZEiWAHenX5rQxFbLy2Fibj7AuT+1y41P0iS9WidFYCp8mP0i9Bv2JGBa07sZo9eiGF3s89lPoYqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lkco3IJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lkco3IJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547BFC2BCFA;
	Tue, 12 May 2026 21:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778620439;
	bh=h4gbD37Rz2ep9V7OBJ01B+g+SZog+1RZ402j6cfob5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lkco3IJV4jUcHVYoccfTqS6Z+nO1piQa00AyWj8JhjONl64KryUfC+nYEOVWwlHdX
	 2pF4XFq826k3CDSwh/9IynT3359SZe82DzByPrbyzQraY3gNHLY4RFHaYafjSfBLJN
	 SMNXoukZS/vrR/6f0dKRG51kMR5yWiyoM5YEAUrTnk+jJk+I2RSqWN6JBrZkngOLtL
	 ncNQo2eVlaxUD7X0mcxWv5MY6ZFHq1gt+wQ1reqjPJy1i6fF/HhAkGKx+gw/J1BS/0
	 q4y6hQZveFfI2cOBZa1VwDKdtrbn6z1fxUM1oW8Wc4xrhO7Fnfh614tHRMqJgB2++X
	 FhiCXxeO5e1vQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gary@garyguo.net
Cc: gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.12 204/206] rust: pin-init: fix incorrect accessor reference lifetime
Date: Tue, 12 May 2026 23:13:25 +0200
Message-ID: <20260512211325.316158-1-ojeda@kernel.org>
In-Reply-To: <20260512173937.196814135@linuxfoundation.org>
References: <20260512173937.196814135@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 12 May 2026 19:40:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Gary Guo <gary@garyguo.net>
>
> commit 68bf102226cf2199dc609b67c1e847cad4de4b57 upstream
>
> When a field has been initialized, `init!`/`pin_init!` create a reference
> or pinned reference to the field so it can be accessed later during the
> initialization of other fields. However, the reference it created is
> incorrectly `&'static` rather than just the scope of the initializer.
>
> This means that you can do
>
>     init!(Foo {
>         a: 1,
>         _: {
>             let b: &'static u32 = a;
>         }
>     })
>
> which is unsound.
>
> This is caused by `&mut (*$slot).$ident`, which actually allows arbitrary
> lifetime, so this is effectively `'static`.
>
> Fix it by adding `let_binding` method on `DropGuard` to shorten lifetime.
> This results in exactly what we want for these accessors. The safety and
> invariant comments of `DropGuard` have been reworked; instead of reasoning
> about what caller can do with the guard, express it in a way that the
> ownership is transferred to the guard and `forget` takes it back, so the
> unsafe operations within the `DropGuard` can be more easily justified.
>
> Assisted-by: Claude:claude-3-opus
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I am seeing a few Clippy warnings:

    warning: value assigned to `inner` is never read
        --> rust/kernel/init/macros.rs:1234:18
         |
    1234 |           unsafe { $data.$field(::core::ptr::addr_of_mut!((*$slot).$field), init)? };
         |  __________________^
    ...    |
    1260 | |             let $field = unsafe { $data.[< __project_ $field >]([< __ $field _guard >].let_binding()) };
         | |_____________________________________________________________________________________________________^
         |
        ::: rust/kernel/block/mq/tag_set.rs:62:9
         |
      62 | /         try_pin_init!(TagSet {
      63 | |             inner <- PinInit::<_, error::Error>::pin_chain(Opaque::new(tag_set?), |tag_set| {
      64 | |                 // SAFETY: we do not move out of `tag_set`.
      65 | |                 let tag_set = unsafe { Pin::get_unchecked_mut(tag_set) };
    ...    |
      69 | |             _p: PhantomData,
      70 | |         })
         | |__________- in this macro invocation
         |
         = help: maybe it is overwritten before being read?
         = note: `#[warn(unused_assignments)]` (part of `#[warn(unused)]`) on by default
         = note: this warning originates in the macro `$crate::__init_internal` which comes from the expansion of the macro `try_pin_init` (in Nightly builds, run with -Z macro-backtrace for more info)

It seems the backport dropped the `allow`s for `unused_assignments`:

> -        #[allow(unused_variables, unused_assignments)]

It should be a matter of re-adding them from a quick test.

Thanks!

Cheers,
Miguel
