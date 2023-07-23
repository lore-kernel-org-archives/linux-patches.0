Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5365E15C8;
	Sun, 23 Jul 2023 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4A3C433C8;
	Sun, 23 Jul 2023 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690122109;
	bh=P7IlLhixxEgKf7EpbN4DFFwoc1k1ZVIYZ+hvTtej5ok=;
	h=From:To:Cc:Subject:Date:From;
	b=Nf3VNf1VQPkyJzPRuDrzkcf1vm0BYDCgs5u38VttEdibhXOWuzQQSsD3WNFktN6xR
	 ZgV4t4LN67chHoHXYej97xlQCGNic9iTMRBTL60pA1YBG14IARxvxa7fda8/4kxQK0
	 0/LBixFhlZKzcYZMAG1r5lA6FebXZvQZGDvoSO+/q2QVl7iJa4IeIhVJV3h/EbuIIy
	 Ms1nownVv8FuDcm7l+X5tRzAUjtvWzYpdB4YG5OAjRhMGjIDXyZIU5DgUeuuhePlkb
	 MEavIeV66nZVBoOYLSoc/bPX2f/BwWOdJdREhdEBcorsYvwzxyUZczqxsRtG7ijRo+
	 WrVow2dPnon/w==
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
	Andreas Hindborg <a.hindborg@samsung.com>,
	linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Raphael Nestler <raphael.nestler@gmail.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] kbuild: rust: avoid creating temporary files
Date: Sun, 23 Jul 2023 16:21:28 +0200
Message-ID: <20230723142128.194339-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`rustc` outputs by default the temporary files (i.e. the ones saved
by `-Csave-temps`, such as `*.rcgu*` files) in the current working
directory when `-o` and `--out-dir` are not given (even if
`--emit=x=path` is given, i.e. it does not use those for temporaries).

Since out-of-tree modules are compiled from the `linux` tree,
`rustc` then tries to create them there, which may not be accessible.

Thus pass `--out-dir` explicitly, even if it is just for the temporary
files.

Similarly, do so for Rust host programs too.

Reported-by: Raphael Nestler <raphael.nestler@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/1015
Reported-by: Andrea Righi <andrea.righi@canonical.com>
Tested-by: Raphael Nestler <raphael.nestler@gmail.com> # non-hostprogs
Tested-by: Andrea Righi <andrea.righi@canonical.com> # non-hostprogs
Fixes: 295d8398c67e ("kbuild: specify output names separately for each emission type from rustc")
Cc: stable@vger.kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - Add fix for host programs too (Masahiro).

 scripts/Makefile.build | 5 ++++-
 scripts/Makefile.host  | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 6413342a03f4..82e3fb19fdaf 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -264,6 +264,9 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 rust_allowed_features := new_uninit
 
+# `--out-dir` is required to avoid temporaries being created by `rustc` in the
+# current working directory, which may be not accessible in the out-of-tree
+# modules case.
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
 	-Zallow-features=$(rust_allowed_features) \
@@ -272,7 +275,7 @@ rust_common_cmd = \
 	--extern alloc --extern kernel \
 	--crate-type rlib -L $(objtree)/rust/ \
 	--crate-name $(basename $(notdir $@)) \
-	--emit=dep-info=$(depfile)
+	--out-dir $(dir $@) --emit=dep-info=$(depfile)
 
 # `--emit=obj`, `--emit=asm` and `--emit=llvm-ir` imply a single codegen unit
 # will be used. We explicitly request `-Ccodegen-units=1` in any case, and
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 7aea9005e497..8f7f842b54f9 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -86,7 +86,11 @@ hostc_flags    = -Wp,-MMD,$(depfile) \
 hostcxx_flags  = -Wp,-MMD,$(depfile) \
                  $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(target-stem).o)
-hostrust_flags = --emit=dep-info=$(depfile) \
+
+# `--out-dir` is required to avoid temporaries being created by `rustc` in the
+# current working directory, which may be not accessible in the out-of-tree
+# modules case.
+hostrust_flags = --out-dir $(dir $@) --emit=dep-info=$(depfile) \
                  $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
                  $(HOSTRUSTFLAGS_$(target-stem))
 

base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0

