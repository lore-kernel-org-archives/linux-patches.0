Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF02580D6;
	Mon, 10 Feb 2025 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739205502; cv=none; b=Und1rJkP5VqP1LilWqgvn3sSKkCbMoH867y8j+arO9PKp7Cq976XVI+DJTdHy79J3mNE3obYzpDR8TjBgwBfIArbeQB3HIBhy09Mipdghf5ReR0XBoo2EbtU7ZsA867LOakgg1V3e7ijDeNfUKyCfx3aw4vJvbN8O3wxLzBfCsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739205502; c=relaxed/simple;
	bh=BrlyBYOHdwmEYDayFxtlpA2iHNc6mrkE85rK5gs1YDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JQiGGGh5WpkH8JH3AefoqYgN4zXv0j+7V+qpDdQ4y6aIfuXVCvTGUCBa16fWdfeFhliWJQ/IGA2Kuogvi5FgCsrSv00Xzj+YTJlIZ0r3KsEcn16rWlsrKsbDG0sREOLKqQbz49Tf5nzPW2UjeNSB5gE56LR9zbi2Ysp9LHhbcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5rBXBsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5rBXBsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF6EC4CEDF;
	Mon, 10 Feb 2025 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739205501;
	bh=BrlyBYOHdwmEYDayFxtlpA2iHNc6mrkE85rK5gs1YDc=;
	h=From:To:Cc:Subject:Date:From;
	b=j5rBXBskdQQ38yxaaxqxcwOdrQ2n2Dl6Zq0oIrI3k4mWojL9/cCGlYVeEp5XEJOS7
	 jPngsYrLr1GuSsaEL/WxEmMAUXLp1GtbV4VPsi7DAmD9g1x0jAQpgG1VtrK1O+ED9/
	 7JOvaJJSZhi7B8TbX4SUrdvRZ6ARbeFOmTUkaD5QYU+xk1QUL/uh6sORIBnS8SUk67
	 ult7oNQFW7EQubwCCSO4IbkaZyRPoXApc9QXXUHZit8/w5bgyDLRbH0b2qmTpxWOJa
	 q8F1/Xa/7x2y8pISaNDSMlW4ZbsFGAgWSzraNt6ZRni6ttjiNkg+lN9WnEGUnAzxdx
	 io3Bh9dt7+mBQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org (moderated for non-subscribers),
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
Subject: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
Date: Mon, 10 Feb 2025 17:37:32 +0100
Message-ID: <20250210163732.281786-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
[1] about disabling neon in the aarch64 hardfloat target:

    warning: target feature `neon` cannot be toggled with
             `-Ctarget-feature`: unsound on hard-float targets
             because it changes float ABI
      |
      = note: this was previously accepted by the compiler but
              is being phased out; it will become a hard error
              in a future release!
      = note: for more information, see issue #116344
              <https://github.com/rust-lang/rust/issues/116344>

Thus, instead, use the softfloat target instead.

While trying it out, I found that the kernel sanitizers were not enabled
for that built-in target [2]. Upstream Rust agreed to backport
the enablement for the current beta so that it is ready for
the 1.85.0 release [3] -- thanks!

However, that still means that before Rust 1.85.0, we cannot switch
since sanitizers could be in use. Thus conditionally do so.

Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Ralf Jung <post@ralfj.de>
Cc: Jubilee Young <workingjubilee@gmail.com>
Link: https://github.com/rust-lang/rust/pull/133417 [1]
Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/topic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
Link: https://github.com/rust-lang/rust/pull/135905 [3]
Link: https://github.com/rust-lang/rust/issues/116344
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Matthew: if you could please give this a go and confirm that it is fine
for Android (with sanitizers enabled, for 1.84.1 and 1.85.0), then a
Tested-by tag would be great. Thanks!

I would like to get this one into -rc3 if possible so that by the time
the compiler releases we are already clean.

I am sending another patch to introduce `rustc-min-version` and use it
here, but I am doing so after this one rather than before so that this
fix can be as simple as possible.

 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 358c68565bfd..2b25d671365f 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,7 +48,11 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU) \
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(compat_vdso)

+ifeq ($(call test-ge, $(CONFIG_RUSTC_VERSION), 108500),y)
+KBUILD_RUSTFLAGS += --target=aarch64-unknown-none-softfloat
+else
 KBUILD_RUSTFLAGS += --target=aarch64-unknown-none -Ctarget-feature="-neon"
+endif

 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
 KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)

base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
--
2.48.1
