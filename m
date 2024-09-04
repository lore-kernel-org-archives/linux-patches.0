Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1C317BEBA;
	Wed,  4 Sep 2024 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482741; cv=none; b=XPR6j2i4fxybQtcCNLlnZ6/PRLJZ2Fp4+u/Do4g2i/paHFT8BFqn5DU4l04Z3JXC+4O54M9YWbkXvN3pqPvHlpi70ovpn0Qddt5ilRSxcVE/eKgu+gelvCX9l+HdpJpwgwPkxskIhfkjxwVOZiY3j9uhGcoYUUs5O0H5WMTa/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482741; c=relaxed/simple;
	bh=9m9JuBDyRlVPdIAlBLEt9SXRJe2c6TVhJRYZmonhyAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRchWZOw/gfu1hb2XfQ7zoRPvP23Tnkscrbs57VKKVQM4383xuJ+yirvGTGaNglrgwYxrxOmia9bLa/SqbOJ2SGWAsjBLwZWOVA+C9ipw46lnxGvfsZu9y2mPbyt2lGGa79k/zPmkSqoGkWwPiIAsswdYqxLZYq4bKaeps9y/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGC3OYSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGC3OYSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D61C4CEC2;
	Wed,  4 Sep 2024 20:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482740;
	bh=9m9JuBDyRlVPdIAlBLEt9SXRJe2c6TVhJRYZmonhyAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGC3OYSNmww7COr3wah7oXCH76t16EyGHkkxPKuvAZFXR+knc7VHX1tBtYsvR/JJ9
	 0rNCR3Jpq/VW91wEHz6Fy0WLigsmpvhKk5YJNh1FtOXzg5WqmjunTKSMTkOWHNOY/3
	 3eqJd2Y5xs2yPKlRWSPCm9BYS/bD1gCs5zOpLJTBl/fwC/oKJ/uqrRflSoWoBBRztd
	 1opz1yXNEHz5BgJ/eYXxso63ARNNxgYkkck7ysIqx7uuzqwHINSVQkR63WkwcHw2Fu
	 A3JGmzyLtrxTKMaZT8rxNA1gv52ympt7eXn7t+/seNtfyQs8FPnW5CbHlBdijMWObm
	 VGdXKIoGX9+sA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
Date: Wed,  4 Sep 2024 22:43:44 +0200
Message-ID: <20240904204347.168520-17-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the C side, disabling diagnostics locally, i.e. within the source code,
is rare (at least in the kernel). Sometimes warnings are manipulated
via the flags at the translation unit level, but that is about it.

In Rust, it is easier to change locally the "level" of lints
(e.g. allowing them locally). In turn, this means it is easier to
globally enable more lints that may trigger a few false positives here
and there that need to be allowed ocally, but that generally can spot
issues or bugs.

Thus document this.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 29 ++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 05542840b16c..185d3b51117d 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -227,3 +227,32 @@ The equivalent in Rust may look like (ignoring documentation):
 That is, the equivalent of ``GPIO_LINE_DIRECTION_IN`` would be referred to as
 ``gpio::LineDirection::In``. In particular, it should not be named
 ``gpio::gpio_line_direction::GPIO_LINE_DIRECTION_IN``.
+
+
+Lints
+-----
+
+In Rust, it is possible to ``allow`` particular warnings (diagnostics, lints)
+locally, making the compiler ignore instances of a given warning within a given
+function, module, block, etc.
+
+It is similar to ``#pragma GCC diagnostic push`` + ``ignored`` + ``pop`` in C:
+
+.. code-block:: c
+
+	#pragma GCC diagnostic push
+	#pragma GCC diagnostic ignored "-Wunused-function"
+	static void f(void) {}
+	#pragma GCC diagnostic pop
+
+But way less verbose:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn f() {}
+
+By that virtue, it makes it possible to comfortably enable more diagnostics by
+default (i.e. outside ``W=`` levels). In particular, those that may have some
+false positives but that are otherwise quite useful to keep enabled to catch
+potential mistakes.
-- 
2.46.0

