Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6534450E2;
	Sun, 18 Aug 2024 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723990380; cv=none; b=ewSALmNUEGSfEcpUGkDBz7foa5GqVr7mD2EYBTd9lmHevh3id8D5qDAR03eLq256IxdmjlJniNVSpJozop40Eer1DmkM3uZ9gfuibGMFRo/GLkaK3z8soPv1ouPdfmbMEi+De2HzwSzeEszAO6K93Y1+Djj27cbcbgSmg9z85vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723990380; c=relaxed/simple;
	bh=zGM+UT9oq8bGJfotirHww7TPVe1zVtlsHDkNzKJAFOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hwXQ2bp/oQ8F4qQvQ58OYUI6+viJFyg95gp4ghCMBY4gb5mN5QhNMIBJBZKtcsSvY+X8zfJdncVpBjpWvB0LMy9q8eJ9ylMrAiml5ZL3GRgqI1hZI3NhpPJY/qYplBpMzK85dlw0I7ik8AcyM9wpBx1CN4XVOHDeH0noqDY0oRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnhGZKb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnhGZKb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B497C32786;
	Sun, 18 Aug 2024 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723990380;
	bh=zGM+UT9oq8bGJfotirHww7TPVe1zVtlsHDkNzKJAFOM=;
	h=From:To:Cc:Subject:Date:From;
	b=JnhGZKb1bZ+07HabqiKsINDcZMO50BhBTq510XovrEs5Gy3huTk7cVmTCGoOPcclL
	 kdwKyTGu7NaEvErBVXe7pPOgig0BCtHfJy07KsZCbei/4xMefrE/+BYcGaz8f1AFB5
	 OC4ou2dBwxYy+E0Ig0Q8py9NkV7r8Hj5SMlscoyluzVkU6Z9K74ib71NrFt1TTceSB
	 WNS84Yz82K932qw0WhxvmLE5qhL1n9yIWZ+E4GyMCweayQptt2blRLLxpwEd4c6e+j
	 0s0kXcZRoD+VvgdAqKi4eXopwyKBQpy8kWhxsTL2d8id9Qu9Hdl8YZaSWRQN/KlyQ2
	 oVNzA5o6x6/WA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Subject: [RFC PATCH] rust: enable rustdoc's `--generate-link-to-definition`
Date: Sun, 18 Aug 2024 16:12:49 +0200
Message-ID: <20240818141249.387166-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Rust 1.56.0 [1], rustdoc introduced the "jump to definition"
feature [2], i.e. the unstable flag `--generate-link-to-definition`.
It adds links to the source view of the documentation.

For instance, in the source view of `rust/kernel/sync.rs`, for this code:

    impl Default for LockClassKey {
        fn default() -> Self {
            Self::new()
        }
    }

It will add three hyperlinks:

  - `Default` points to the rendered "Trait `core::default::Default`"
    page (not the source view, since it goes to another crate, though
    this may change).

  - `LockClassKey` points to the `pub struct LockClassKey(...);` line
    in the same page, highlighting the line number.

  - `Self::new()` points to the `pub const fn new() -> Self { ... }`
    associated function, highlighting its line numbers (i.e. for the
    full function).

This makes the source view more useful and a bit closer to the experience
in e.g. the Elixir Cross Referencer [3].

I have provisionally enabled it for rust.docs.kernel.org [4] -- one can
take a look at the source view there for an example of how it looks like.

Thus enable it.

Cc: Guillaume Gomez <guillaume1.gomez@gmail.com>
Link: https://github.com/rust-lang/rust/pull/84176 [1]
Link: https://github.com/rust-lang/rust/issues/89095 [2]
Link: https://elixir.bootlin.com [3]
Link: https://rust.docs.kernel.org [4]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/Makefile b/rust/Makefile
index 1f10f92737f2..d311bcc30226 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -63,6 +63,7 @@ quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
 	OBJTREE=$(abspath $(objtree)) \
 	$(RUSTDOC) $(if $(rustdoc_host),$(rust_common_flags),$(rust_flags)) \
 		$(rustc_target_flags) -L$(objtree)/$(obj) \
+		-Zunstable-options --generate-link-to-definition \
 		--output $(rustdoc_output) \
 		--crate-name $(subst rustdoc-,,$@) \
 		$(if $(rustdoc_host),,--sysroot=/dev/null) \

base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.46.0

