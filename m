Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EBD14D457;
	Wed,  4 Sep 2024 20:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482711; cv=none; b=AMCn17vJbJn8l8VsUt5Rf286LZwZI6m0eG1Dv7CwWxeyU1IbTLNt8aRuXurh4zrtlAFt2LKiDbTiGdMp6u5quW6OT4pCufGuZct/mwP20pXJiUlLdtYK6UUq1svMTcaOxTBDkTpmKjGfk/cCQtN4jgbCSMrJ2m/ixoXfK+x6Y3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482711; c=relaxed/simple;
	bh=GnSFaYVDAVNJbXv/9AtI8T4gMvVKf3w7/yAPMS4ovFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYaVQJb1ViQV1uGFsB/c03Duu4dc62CPQb/o6trZzNp6F/zBa5M22cqfAFioD/kQBjOjcQW09cdfCwyAqEu8RDqD8Q4hPpFSiJviojPBqOAQwaX4f+tbIHxpXMfMXZrVCY4Nii1kcvBBLC4WEFU8nW7RubBG0Wy43RuZePpmimE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuM1jjIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuM1jjIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA7C4CEC8;
	Wed,  4 Sep 2024 20:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482711;
	bh=GnSFaYVDAVNJbXv/9AtI8T4gMvVKf3w7/yAPMS4ovFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuM1jjIEjSBxKPLvDFYIIfp1iWElwRH2uO37ZDeP7MXAaWQcS48Qx20WxtfSPpwnp
	 F4FEYtwoz59sMzC+ye1fDUqw0D+kckGSBDi78IkzI1l7KXgIL077BeZY97DPR5x1gX
	 1UWhDTSoLep7ymbdQB137YogYuS5g1gM1n3e81r1r/zIE8dDQ+4VNY0TRcprZvjObL
	 Lu9WeVYxSInxY9+/xfdj6+W4NqzoCN4F8qcM+hCh+mjWXUptvrEDxVvxjYaLuN0FOe
	 vb/+stYKYPmUKONZETRWo2EhCAL9/XUpjOXuKcXSegoo1UKmIy/PXFQVdHEkKOBnj2
	 qYCDK8mjs0CvA==
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
Subject: [PATCH 08/19] rust: enable `rustdoc::unescaped_backticks` lint
Date: Wed,  4 Sep 2024 22:43:36 +0200
Message-ID: <20240904204347.168520-9-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Rust 1.71.0, `rustdoc` added the `unescaped_backticks` lint, which
detects what are typically typos in Markdown formatting regarding inline
code [1], e.g. from the Rust standard library:

    /// ... to `deref`/`deref_mut`` must ...

    /// ... use [`from_mut`]`. Specifically, ...

It does not seem to have almost any false positives, from the experience
of enabling it in the Rust standard library [2], which will be checked
starting with Rust 1.82.0. The maintainers also confirmed it is ready
to be used.

Thus enable it.

Link: https://doc.rust-lang.org/rustdoc/lints.html#unescaped_backticks [1]
Link: https://github.com/rust-lang/rust/pull/128307 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile      | 3 ++-
 rust/Makefile | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index cc1b01590227..fc66bac4b4f1 100644
--- a/Makefile
+++ b/Makefile
@@ -460,7 +460,8 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
-			    -Wrustdoc::missing_crate_level_docs
+			    -Wrustdoc::missing_crate_level_docs \
+			    -Wrustdoc::unescaped_backticks
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include
diff --git a/rust/Makefile b/rust/Makefile
index e13d14ec5fe7..bc8ae3cc0537 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -61,7 +61,7 @@ alloc-cfgs = \
 quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
       cmd_rustdoc = \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTDOC) $(if $(rustdoc_host),$(rust_common_flags),$(rust_flags)) \
+	$(RUSTDOC) $(filter-out $(skip_flags),$(if $(rustdoc_host),$(rust_common_flags),$(rust_flags))) \
 		$(rustc_target_flags) -L$(objtree)/$(obj) \
 		-Zunstable-options --generate-link-to-definition \
 		--output $(rustdoc_output) \
@@ -98,6 +98,9 @@ rustdoc-macros: private rustc_target_flags = --crate-type proc-macro \
 rustdoc-macros: $(src)/macros/lib.rs FORCE
 	+$(call if_changed,rustdoc)
 
+# Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
+# not be needed -- see https://github.com/rust-lang/rust/pull/128307.
+rustdoc-core: private skip_flags = -Wrustdoc::unescaped_backticks
 rustdoc-core: private rustc_target_flags = $(core-cfgs)
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
 	+$(call if_changed,rustdoc)
-- 
2.46.0

