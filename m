Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2691A5258;
	Sat, 12 Jul 2025 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752340253; cv=none; b=m/Fb4QrvX7/SjwZipouYoGFKK4fNL/h14gWIr8A5nkIjBfErZrG+yCvFpnv/la3KpInEKT9zK/BYsTnkceXP2QQAJtOh0Egay45hRIkgD8gVmIAdyqbupzsvsvDz/VMsy+sz8O18wT/s3rDh+cTR+qj1LvukI/h16nQ/YO8YNko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752340253; c=relaxed/simple;
	bh=E12GcqnaAwHtNnICUFIgNVDkr91Rl9UwJTcJJqqFwlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mV8dxX3hUn895NG2v/XagGPweJBrxsRLTRqgp7yIggYS7x+pRTOTfhWhtsrRGPmYlOaQAzUxUkO4ks8CjbtpHrLNXxxpN0C0OJxp67btfwlrzIzpxXykoaaVTAo+OKZJt3oAVaIdheNc1vo5HJldqyW/HAwkTvhjpw73zIBWTLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlyP1JrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlyP1JrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9ECC4CEEF;
	Sat, 12 Jul 2025 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752340252;
	bh=E12GcqnaAwHtNnICUFIgNVDkr91Rl9UwJTcJJqqFwlA=;
	h=From:To:Cc:Subject:Date:From;
	b=VlyP1JrRGEgm4SPzv13vPYKU+fukvi7XlfA/0MAPW9o+lmvDQCiPM1NJD6LZj6p5x
	 w0SPWeXo1EmYu/68LbmLVRx+6mygg6iIXnwqsDGnG4gPP5y/6rTBEPqkKz0z8WRB9N
	 cadaEDvcWltxygF8xK3GLjH/49cvIRA2kl9A28pDHEzU25oMXavpMk+d08YWJEqhlz
	 ofDj8ieeKFjfyBDgaBWDObBZWBakzaG1TFytlTumLuMscqsBSnG1zVDzBd4Jz8EQgQ
	 KulZUSdI6PHM9b5DkzVn2Y+D3v7CRmpa+zBkK2h/NFr1rIS5VISA8mfDvxpKsJsR+6
	 nvFthzrf3gNdQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: stable@vger.kernel.org,
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
	Benno Lossin <lossin@kernel.org>
Subject: [PATCH 6.12.y] rust: init: allow `dead_code` warnings for Rust >= 1.89.0
Date: Sat, 12 Jul 2025 19:10:38 +0200
Message-ID: <20250712171038.1287789-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler
may warn:

    error: trait `MustNotImplDrop` is never used
       --> rust/kernel/init/macros.rs:927:15
        |
    927 |         trait MustNotImplDrop {}
        |               ^^^^^^^^^^^^^^^
        |
       ::: rust/kernel/sync/arc.rs:133:1
        |
    133 | #[pin_data]
        | ----------- in this procedural macro expansion
        |
        = note: `-D dead-code` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(dead_code)]`
        = note: this error originates in the macro `$crate::__pin_data`
                which comes from the expansion of the attribute macro
                `pin_data` (in Nightly builds, run with
                -Z macro-backtrace for more info)

Thus `allow` it to clean it up.

This does not happen in mainline nor 6.15.y, because there the macro was
moved out of the `kernel` crate, and `dead_code` warnings are not
emitted if the macro is foreign to the crate. Thus this patch is
directly sent to stable and intended for 6.12.y only.

Similarly, it is not needed in previous LTSs, because there the Rust
version is pinned.

Cc: Benno Lossin <lossin@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Greg, Sasha: please note that an equivalent patch is _not_ in mainline.

We could put these `allow`s in mainline (they wouldn't hurt), but it
isn't a good idea to add things in mainline for the only reason of
backporting them, thus I am sending this directly to stable.

The patch is pretty safe -- there is no actual code change.

 rust/kernel/init/macros.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
index b7213962a6a5..e530028bb9ed 100644
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -924,6 +924,7 @@ impl<'__pin, $($impl_generics)*> ::core::marker::Unpin for $name<$($ty_generics)
         // We prevent this by creating a trait that will be implemented for all types implementing
         // `Drop`. Additionally we will implement this trait for the struct leading to a conflict,
         // if it also implements `Drop`
+        #[allow(dead_code)]
         trait MustNotImplDrop {}
         #[expect(drop_bounds)]
         impl<T: ::core::ops::Drop> MustNotImplDrop for T {}
@@ -932,6 +933,7 @@ impl<$($impl_generics)*> MustNotImplDrop for $name<$($ty_generics)*>
         // We also take care to prevent users from writing a useless `PinnedDrop` implementation.
         // They might implement `PinnedDrop` correctly for the struct, but forget to give
         // `PinnedDrop` as the parameter to `#[pin_data]`.
+        #[allow(dead_code)]
         #[expect(non_camel_case_types)]
         trait UselessPinnedDropImpl_you_need_to_specify_PinnedDrop {}
         impl<T: $crate::init::PinnedDrop>

base-commit: fbad404f04d758c52bae79ca20d0e7fe5fef91d3
--
2.50.1
