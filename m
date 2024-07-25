Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541B25588F;
	Thu, 25 Jul 2024 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721932508; cv=none; b=AqsdX3EP0U/GUaeo0xWR60i73k8/n3gb/ib2meZzb+Cb4AC8kbPhKrZBQnQMo3N0VYn3JD5hpPyhFXT31DvlEf5odO6VX6u+Gkm1FoE1CKMhazxpGER96s/6yo5b3XihQJdV//d7GKL1PK2FXVpQaCABbVhFx218TtBjaWx7aew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721932508; c=relaxed/simple;
	bh=sgFv2c8rLqTbaCNyIFrfSFEuE+PAnpzFiH2IQFlVHME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKzIcASS3n1yviSp43iXdo9wzfma1IQlrcCJgoShYKDt6dvX6Krdqv/SDfObPwUDZ7eXG96fFDGF9EQd2yh4v0YxEJ9usJFagtaj6GY7Mx6LwzxdAec7goD+qPP/qAnxhX7vcTXjEM/hrcHCDHn6p1/PHy3tLk+IQZXb0g/pJ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyJgy333; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyJgy333"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9493EC4AF0B;
	Thu, 25 Jul 2024 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721932507;
	bh=sgFv2c8rLqTbaCNyIFrfSFEuE+PAnpzFiH2IQFlVHME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyJgy333uzUCHlAUPCjafmLc3ey7h8nKBQUHlgx03/QZwwioMvbVI6fsucYZPbihh
	 wCEPNvPcxoOM7GAeefPPOQ03DcjhF8nAiSbhPGA4DfNCxKa5wcYiawbyrR8wFUAVnL
	 kgxBCvKnsLefT2sWRz9I8kas98dXH/wtb+wQ+0oG7tfWIN+ZInH4k0KATIygyHMnft
	 WGGrp4m5w23Rnnalkp/vTatLp0cob2zTNCx3TP+LyFRyrsPPpNAwIB2GHQZL00B76t
	 6m6nzv29yHSs18ww5NUVEiB0HjHxkXEHF28uPYt1Jh3vu3o56GP926Cn9hB/7rAuBj
	 dll7i2iPqaf7g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 1/6] rust: module: add static pointer to `{init,cleanup}_module()`
Date: Thu, 25 Jul 2024 20:33:18 +0200
Message-ID: <20240725183325.122827-2-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-1-ojeda@kernel.org>
References: <20240725183325.122827-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the equivalent of the `___ADDRESSABLE()` annotation in the
`module_{init,exit}` macros to the Rust `module!` macro.

Without this, `objtool` would complain if enabled for Rust (under IBT
builds), e.g.:

    samples/rust/rust_print.o: warning: objtool: cleanup_module(): not an indirect call target
    samples/rust/rust_print.o: warning: objtool: init_module(): not an indirect call target

Tested-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/macros/module.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index 411dc103d82e..571ffa2e189c 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -256,6 +256,12 @@ mod __module_init {{
                         unsafe {{ __init() }}
                     }}
 
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[used]
+                    #[link_section = \".init.data\"]
+                    static __UNIQUE_ID___addressable_init_module: unsafe extern \"C\" fn() -> i32 = init_module;
+
                     #[cfg(MODULE)]
                     #[doc(hidden)]
                     #[no_mangle]
@@ -269,6 +275,12 @@ mod __module_init {{
                         unsafe {{ __exit() }}
                     }}
 
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[used]
+                    #[link_section = \".exit.data\"]
+                    static __UNIQUE_ID___addressable_cleanup_module: extern \"C\" fn() = cleanup_module;
+
                     // Built-in modules are initialized through an initcall pointer
                     // and the identifiers need to be unique.
                     #[cfg(not(MODULE))]
-- 
2.45.2

