Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B67C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 00:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6488C433C0;
	Fri, 16 Jun 2023 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686874612;
	bh=agYLlcXyXImEwHhAG9238V5StoEG6ffUqnfcPJUkDhY=;
	h=From:To:Cc:Subject:Date:From;
	b=RdUlqeEeIerwSxnIKM+oTlLgs9z1X/J8q/p1BsJUYzzYaSH6kzOyqyqvh/U/ZBaJc
	 V5nall2wXJTd8/Zy6CsdPlTEJwxo9VY1IBIISxqB27eHTUD69Kiad0315t/8Cm1mEM
	 Z7LwUJo/V+6bSTHPEO0dKUZBP4cTotj9f+8F07ZhLSoiJ2zY+9f0eXpLyHA8UemcMX
	 /EgRWiYThKHdZKJj50EjQ2i8ePTfkTvg0g7hp3oZ2+Wj3n3nH0iMkb5IVvjMFFwTu5
	 lvR5GTzp09n2bvGXXdz2Za3u3PQ++8Sp9TzDgdiSHHiPm5EoB3pCKiqDXFRkg5pdKZ
	 +UcHPJ8OvNM1Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 00/11] `scripts/rust_is_available.sh` improvements
Date: Fri, 16 Jun 2023 02:16:20 +0200
Message-ID: <20230616001631.463536-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the patch series to improve `scripts/rust_is_available.sh`.

The major addition in v2 is the test suite in the last commit. I added
it because I wanted to have a proper way to test any further changes to
it (such as the suggested `set --` idea to avoid forking by Masahiro),
and so that adding new checks was easier to justify too (i.e. vs. the
added complexity).

In addition, there are also a few new checks in the script, to cover for
even some more cases, which hopefully make problematic setups easier to
identify and solve by users building the kernel. For instance, running
the script externally gives:

    $ scripts/rust_is_available.sh
    ***
    *** Environment variable 'RUSTC' is not set.
    ***
    *** This script is intended to be called from Kbuild.
    *** Please use the 'rustavailable' target to call it instead.
    *** Otherwise, the results may not be meaningful.
    ***
    *** Please see Documentation/rust/quick-start.rst for details
    *** on how to set up the Rust support.
    ***

I also changed it to avoid setting `-e` as Masahiro suggested.
Similarly, I now check for `$RUSTC`, `$BINDGEN` and `$CC`, instead of
`$MAKEFLAGS`, as he also suggested (but I gave it their own error
message rather than use the `${CC?: is not set}` approach. This goes in
line with the reasons outlined above, i.e. trying to give users a clear
error of what step exactly failed).

In the test suite I included previously problematic compiler version
strings we got reports for. The test suite covers all current branches
in the script, and we should keep it that way in the future.

The patch series also include Masahiro's patch to remove the `-v`
option, as well as Russell's patch for supporting multiple arguments
in `$CC`.

All in all, this should solve all the issues we got so far (unless I
have missed something) and improve things further with the new checks
plus the test suite to hopefully have an easier time in the future.

Testers for this one are appreciated, especially if you have uncommon or
custom setups for building the kernel.

This could go through either the Kbuild or the Rust tree.

Masahiro Yamada (1):
  kbuild: rust_is_available: remove -v option

Miguel Ojeda (9):
  docs: rust: add paragraph about finding a suitable `libclang`
  kbuild: rust_is_available: print docs reference
  kbuild: rust_is_available: add check for `bindgen` invocation
  kbuild: rust_is_available: check that environment variables are set
  kbuild: rust_is_available: fix confusion when a version appears in the
    path
  kbuild: rust_is_available: normalize version matching
  kbuild: rust_is_available: handle failures calling `$RUSTC`/`$BINDGEN`
  kbuild: rust_is_available: check that output looks as expected
  kbuild: rust_is_available: add test suite

Russell Currey (1):
  kbuild: rust_is_available: fix version check when CC has multiple
    arguments

 Documentation/rust/quick-start.rst |  17 ++
 Makefile                           |   4 +-
 scripts/rust_is_available.sh       | 233 +++++++++++++------
 scripts/rust_is_available_test.py  | 346 +++++++++++++++++++++++++++++
 4 files changed, 532 insertions(+), 68 deletions(-)
 create mode 100755 scripts/rust_is_available_test.py


base-commit: 858fd168a95c5b9669aac8db6c14a9aeab446375
-- 
2.41.0

