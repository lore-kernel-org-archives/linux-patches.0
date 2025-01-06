Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21C15A842;
	Mon,  6 Jan 2025 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176993; cv=none; b=sT31Dn7fw4aLT1dQdwTRJGvuthzGMZ8aGc0OW18gQQdQZVibw5gNjW0m5LmOwBn1i/fph0VV8Lvyf5n81k9uNqBUPFhgCj2Nr9o9F+tt4132B9qtwvSzlD5V6ac25dX7A6fdlYYyTU33MvfyNGw3ULZtCVc85xUaJiGhlGbb24U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176993; c=relaxed/simple;
	bh=CuzSKuEOPNaI0a5H6ApNSuvgB0iZ9kU0FExb4/bDhKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udz1FuJk3nI9b6leL+t9KKvEnC1CsuS/UfTIESHZCUnHNv0vx8z7LGnwTP5lW86h+JeCMu81F5yu54HcLvsTkmgzLp2eH3Ve+LYreNHE65tJxdhkbFscXGjoyodO1YG99eqDf0BmP3Sq+y4zwUagfeTakZQX/W6oIULYe29wL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNDJsAvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNDJsAvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C87C4CED2;
	Mon,  6 Jan 2025 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176993;
	bh=CuzSKuEOPNaI0a5H6ApNSuvgB0iZ9kU0FExb4/bDhKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNDJsAvbjSfWIgaVuMReIeh7pKz+siWLCEgzwHD6AURF7rDOXll4xc3ZixkfYV9Ge
	 6KGfuUupWIQRc+gzJg+hajEQWYRySPxi5Wn8G2E5X0LsFNTLYf4FTxEzaulr+LIuBD
	 nG774JnDhlAb1AbtWPA5dX0jKyuD9H//Nf6SQtPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/222] rust: relax most deny-level lints to warnings
Date: Mon,  6 Jan 2025 16:13:40 +0100
Message-ID: <20250106151151.215498316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit f8f88aa25a03ce1e0fc8a9842840988b870f0c37 ]

Since we are starting to support several Rust toolchains, lints (including
Clippy ones) now may behave differently and lint groups may include
new lints.

Therefore, to maximize the chances a given version works, relax some
deny-level lints to warnings. It may also make our lives a bit easier
while developing new code or refactoring.

To be clear, the requirements for in-tree code are still the same, since
Rust code still needs to be warning-free (patches should be clean under
`WERROR=y`) and the set of lints is not changed.

`unsafe_op_in_unsafe_fn` is left unmodified, i.e. as an error, since it is
becoming the default in the language (warn-by-default in Rust 2024 [1] and
ideally an error later on) and thus it should also be very well tested. In
addition, it is simple enough that it should not have false positives
(unlike e.g. `rust_2018_idioms`'s `explicit_outlives_requirements`).

`non_ascii_idents` is left unmodified as well, i.e. as an error, since
it is unlikely one gains any productivity during development if it
were a warning (in fact, it may be worse, since it is likely one made
a typo). In addition, it should not have false positives.

Finally, put the two `-D` ones at the top and take the chance to do one
per line.

Link: https://github.com/rust-lang/rust/pull/112038 [1]
Reviewed-by: Finn Behrens <me@kloenk.dev>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Link: https://lore.kernel.org/r/20240709160615.998336-5-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 60fc1e675013 ("rust: allow `clippy::needless_lifetimes`")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile      | 24 +++++++++++++-----------
 rust/Makefile |  4 ++--
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index ec4d9d1d9b7a..0be58613bfe0 100644
--- a/Makefile
+++ b/Makefile
@@ -457,17 +457,19 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 # host programs.
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
-			    -Dunsafe_op_in_unsafe_fn -Drust_2018_idioms \
-			    -Dunreachable_pub -Dnon_ascii_idents \
+			    -Dunsafe_op_in_unsafe_fn \
+			    -Dnon_ascii_idents \
+			    -Wrust_2018_idioms \
+			    -Wunreachable_pub \
 			    -Wmissing_docs \
-			    -Drustdoc::missing_crate_level_docs \
-			    -Dclippy::correctness -Dclippy::style \
-			    -Dclippy::suspicious -Dclippy::complexity \
-			    -Dclippy::perf \
-			    -Dclippy::let_unit_value -Dclippy::mut_mut \
-			    -Dclippy::needless_bitwise_bool \
-			    -Dclippy::needless_continue \
-			    -Dclippy::no_mangle_with_rust_abi \
+			    -Wrustdoc::missing_crate_level_docs \
+			    -Wclippy::correctness -Wclippy::style \
+			    -Wclippy::suspicious -Wclippy::complexity \
+			    -Wclippy::perf \
+			    -Wclippy::let_unit_value -Wclippy::mut_mut \
+			    -Wclippy::needless_bitwise_bool \
+			    -Wclippy::needless_continue \
+			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::dbg_macro
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) $(HOSTCFLAGS)
@@ -572,7 +574,7 @@ KBUILD_RUSTFLAGS := $(rust_common_flags) \
 		    -Csymbol-mangling-version=v0 \
 		    -Crelocation-model=static \
 		    -Zfunction-sections=n \
-		    -Dclippy::float_arithmetic
+		    -Wclippy::float_arithmetic
 
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
diff --git a/rust/Makefile b/rust/Makefile
index 333b9a482473..12b9d78fd25c 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -422,7 +422,7 @@ ifneq ($(or $(CONFIG_ARM64),$(and $(CONFIG_RISCV),$(CONFIG_64BIT))),)
 endif
 
 $(obj)/core.o: private skip_clippy = 1
-$(obj)/core.o: private skip_flags = -Dunreachable_pub
+$(obj)/core.o: private skip_flags = -Wunreachable_pub
 $(obj)/core.o: private rustc_objcopy = $(foreach sym,$(redirect-intrinsics),--redefine-sym $(sym)=__rust$(sym))
 $(obj)/core.o: private rustc_target_flags = $(core-cfgs)
 $(obj)/core.o: $(RUST_LIB_SRC)/core/src/lib.rs scripts/target.json FORCE
@@ -433,7 +433,7 @@ $(obj)/compiler_builtins.o: $(src)/compiler_builtins.rs $(obj)/core.o FORCE
 	$(call if_changed_dep,rustc_library)
 
 $(obj)/alloc.o: private skip_clippy = 1
-$(obj)/alloc.o: private skip_flags = -Dunreachable_pub
+$(obj)/alloc.o: private skip_flags = -Wunreachable_pub
 $(obj)/alloc.o: private rustc_target_flags = $(alloc-cfgs)
 $(obj)/alloc.o: $(src)/alloc/lib.rs $(obj)/compiler_builtins.o FORCE
 	$(call if_changed_dep,rustc_library)
-- 
2.39.5



