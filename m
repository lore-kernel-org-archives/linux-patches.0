Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363C6BFA3;
	Wed,  4 Sep 2024 20:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482682; cv=none; b=sr2GS43ycjVCwkzfqk7jwd4Yc4+O2XxK0scNdngO0rA0P7PbeX5rYEfrwBqoipySUhrYvUM19lVBUmjC0Z6kmhxL+a/2D7KzjjWJz/Hy2aKbHvVh5IGZsVHfNTSKezK3H93RKZ/omkBeBpeguqOeMT8BhbChfboUv21g6CptcN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482682; c=relaxed/simple;
	bh=SBKjKR9UywiT/YrakD74KwJyxS3i7hFuPCh59TC5Yps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jUqLyl0zQXhlt1q9BC7wsMMWlmr19hrlv9BZs0TwAtHDfuJAjpmR/9U0MFgrABa9Dxd4BYySRvJQnHC3tGPoiVokQD1GNSOJdd6lNw4QF2Xmh9IH3AGD9nCqtD1mxUzrbYjGSJYzU8jwWUd3jOUucI9cwbCvafWlnU6qWJi9C/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vz/B48BF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vz/B48BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD434C4CEC2;
	Wed,  4 Sep 2024 20:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482682;
	bh=SBKjKR9UywiT/YrakD74KwJyxS3i7hFuPCh59TC5Yps=;
	h=From:To:Cc:Subject:Date:From;
	b=Vz/B48BFYG5q+b5/OqymbvsaXsgBc1hAuLnoKQv5mmNAqecpVD3aA4yY4BDtspNTE
	 xMUghXFy8mw03W3dCk6+ZChNaxoz4QHrQYCJVIrEvYtjFQhamcoFC1F+29XFEMmWvW
	 7LTwBeO3bdpAwNiztLFXu3GCQ0nyLd0Y107hI1dfVbCjdcGr3451pyORWKjcc+w8dY
	 mWIrAw+upgMbn5BaAEuoWJvdkJlUv6AHCJ7+K2puS9OFbEIWSV4X3BNnl2hSwJtrfm
	 wX+XTkRi3+FDk4pJGVDyCdlKQnVrk/Ju/Wj6RTbEdjXN6GwAFvVwzZeaLTqB+NYC6g
	 3GBK16z2TbRyA==
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
Subject: [PATCH 00/19] rust: lint improvements
Date: Wed,  4 Sep 2024 22:43:28 +0200
Message-ID: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is a series that contains a series of lint-related things:

  - Cleanups and other improvements and fixes, including removing `allow`s that
    are not needed anymore for different reasons and a workaround for
    `dbg_macro` detection.

  - The enablement of some safety lints so that the toolchain enforces that we
    write `// SAFETY` comments and `# Safety` sections properly.

  - The addition of `.clippy.toml`, which allows us to take advantage of a few
    configuration options.

  - Start using the new `#[expect(...)]` feature and add documentation on it as
    well as lints in general.

Overall, this should improve the quality of the code and documentation as well
as reduce the time needed in reviews.

I want to mention Trevor's nice work on lints from a while ago [1]. I think we
should still do something like that: discuss which lints we would like to have
one-by-one and start enabling them (and perhaps have a file like Trevor proposed
etc.).

For the moment, though, I am sending these, since we would like to have at least
the safety-related ones enabled soon [2]: now that more code and developers
are joining, it sounds like a good time to start enforcing it -- it should make
new Rust kernel developers aware of the need of writing them, which has proven
to be a common request from reviewers.

If needed, the series can be applied partially or split, but most of it should
be fairly uncontroversial.

Link: https://github.com/Rust-for-Linux/linux/pull/1025 [1]
Link: https://lore.kernel.org/rust-for-linux/CD29DF8F-7FF3-466F-9724-BC92C14A68BD@collabora.com/ [2]

Miguel Ojeda (19):
  rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
  rust: sort global Rust flags
  rust: types: avoid repetition in `{As,From}Bytes` impls
  rust: enable `clippy::undocumented_unsafe_blocks` lint
  rust: enable `clippy::unnecessary_safety_comment` lint
  rust: enable `clippy::unnecessary_safety_doc` lint
  rust: enable `clippy::ignored_unit_patterns` lint
  rust: enable `rustdoc::unescaped_backticks` lint
  rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
  rust: sync: remove unneeded
    `#[allow(clippy::non_send_fields_in_send_ty)]`
  rust: introduce `.clippy.toml`
  rust: replace `clippy::dbg_macro` with `disallowed_macros`
  rust: rbtree: fix `SAFETY` comments that should be `# Safety` sections
  rust: provide proper code documentation titles
  rust: enable Clippy's `check-private-items`
  Documentation: rust: add coding guidelines on lints
  rust: start using the `#[expect(...)]` attribute
  Documentation: rust: discuss `#[expect(...)]` in the guidelines
  rust: std_vendor: simplify `{ .. macro! .. }` with inner attributes

 .clippy.toml                             |   9 ++
 .gitignore                               |   1 +
 Documentation/rust/coding-guidelines.rst | 139 +++++++++++++++++++++++
 MAINTAINERS                              |   1 +
 Makefile                                 |  15 ++-
 rust/Makefile                            |   5 +-
 rust/bindings/lib.rs                     |   1 +
 rust/kernel/alloc/allocator.rs           |   2 +
 rust/kernel/error.rs                     |  11 +-
 rust/kernel/init.rs                      |  30 ++---
 rust/kernel/init/__internal.rs           |  11 +-
 rust/kernel/init/macros.rs               |  18 ++-
 rust/kernel/ioctl.rs                     |   2 +-
 rust/kernel/lib.rs                       |   1 +
 rust/kernel/list.rs                      |   1 +
 rust/kernel/list/arc_field.rs            |   2 +-
 rust/kernel/print.rs                     |   5 +-
 rust/kernel/rbtree.rs                    |   9 +-
 rust/kernel/std_vendor.rs                |  16 ++-
 rust/kernel/str.rs                       |   7 +-
 rust/kernel/sync/arc.rs                  |   2 +-
 rust/kernel/sync/arc/std_vendor.rs       |   2 +
 rust/kernel/sync/condvar.rs              |   1 -
 rust/kernel/sync/lock.rs                 |   6 +-
 rust/kernel/types.rs                     |  74 ++++++------
 rust/kernel/workqueue.rs                 |   9 +-
 rust/uapi/lib.rs                         |   1 +
 samples/rust/rust_print.rs               |   1 +
 scripts/Makefile.build                   |   2 +-
 29 files changed, 293 insertions(+), 91 deletions(-)
 create mode 100644 .clippy.toml


base-commit: 68d3b6aa08708bb3907c2c13eaf4b3ccf4805160
--
2.46.0
