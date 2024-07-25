Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651B13D51B;
	Thu, 25 Jul 2024 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721932532; cv=none; b=AHDqozLcp/PqwCpb4aVLH3p7X58thJpVFobdubZzj8eAnadpzLp82BHvUMWr6jaJObMF1ptC9MTPYhNKoLRDQAg+QCyhU2FDN/zzF2B8NHa1KC4LRB9D9xomnMUbSe8ToEvTJ33DFC727Y/QMCuOqAxhAGoBom2y7SYzsN+gN44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721932532; c=relaxed/simple;
	bh=GLtC3wYk2GEvmZ/aRZo96oaKNYBG3w8k9VJ+Yew0iPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+uzw55ECZGB3/JxxkDQIMimCeB6YYZfbh3jBtTUyCPnqDmYV9VsQxUXgDJkOuPfDnSFehgz7nIYuEJsh8xTMqQObBfgMlBXEslBncwjvWZX8FcM9u8w15y7WDqJMYCFJlaHYIcdfhFcmjdgTAQB9k3dciuTSqX0u7XWQSq1mNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0XM/mBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0XM/mBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4E8C4AF0E;
	Thu, 25 Jul 2024 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721932531;
	bh=GLtC3wYk2GEvmZ/aRZo96oaKNYBG3w8k9VJ+Yew0iPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0XM/mBc6pGWaY3brJpPfsLGz8qkt8h2fr9B6QyAaDPjGTQkyzTNY7JNyqXpkZVzG
	 ujzfoey6Rs9iZrKwOTI5uG0NVI2f2dg+qItXULkVxWun6MO6WRgDizEEnKvhdwPczI
	 4NntDCZp92CrsZATy/G7JiiTt1l+6oiHXFL7ga12yhCTAhPB5FvSFSTmagEf5QCmvq
	 R3QM8qwPnzkr6rL9MV2byBzlPU2R3kcsCGTL/kpkb6FxBVrzM4LAkjN49tfKrH+cgt
	 DX7O2QrFQ2PJLkKy6hKHlg5mJoy4iw1UDpTVDeNX0bKhfDMuWH3+xX56TREdVI99kg
	 E1O5SmhnQbaDQ==
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
Subject: [PATCH v3 5/6] objtool/rust: list `noreturn` Rust functions
Date: Thu, 25 Jul 2024 20:33:22 +0200
Message-ID: <20240725183325.122827-6-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-1-ojeda@kernel.org>
References: <20240725183325.122827-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust functions may be `noreturn` (i.e. diverging) by returning the
"never" type, `!`, e.g.

    fn f() -> ! {
        loop {}
    }

Thus list the known `noreturn` functions to avoid such warnings.

Without this, `objtool` would complain if enabled for Rust, e.g.:

    rust/core.o: warning: objtool:
    _R...9panic_fmt() falls through to next function _R...18panic_nounwind_fmt()

    rust/alloc.o: warning: objtool:
    .text: unexpected end of section

In order to do so, we cannot match symbols' names exactly, for two
reasons:

  - Rust mangling scheme [1] contains disambiguators [2] which we
    cannot predict (e.g. they may vary depending on the compiler version).

    One possibility to solve this would be to parse v0 and ignore/zero
    those before comparison.

  - Some of the diverging functions come from `core`, i.e. the Rust
    standard library, which may change with each compiler version
    since they are implementation details (e.g. `panic_internals`).

Thus, to workaround both issues, only part of the symbols are matched,
instead of using the `NORETURN` macro in `noreturns.h`.

Ideally, just like for the C side, we should have a better solution. For
instance, the compiler could give us the list via something like:

    $ rustc --emit=noreturns ...

Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html [1]
Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguator [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 tools/objtool/check.c     | 48 ++++++++++++++++++++++++++++++++++++++-
 tools/objtool/noreturns.h |  2 ++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0a33d9195b7a..deace6fca2ed 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -177,6 +177,48 @@ static bool is_sibling_call(struct instruction *insn)
 	return (is_static_jump(insn) && insn_call_dest(insn));
 }
 
+/*
+ * Checks if a string ends with another.
+ */
+static bool str_ends_with(const char *s, const char *sub)
+{
+	const int slen = strlen(s);
+	const int sublen = strlen(sub);
+
+	if (sublen > slen)
+		return 0;
+
+	return !memcmp(s + slen - sublen, sub, sublen);
+}
+
+/*
+ * Checks if a function is a Rust "noreturn" one.
+ */
+static bool is_rust_noreturn(const struct symbol *func)
+{
+	/*
+	 * If it does not start with "_R", then it is not a Rust symbol.
+	 */
+	if (strncmp(func->name, "_R", 2))
+		return false;
+
+	/*
+	 * These are just heuristics -- we do not control the precise symbol
+	 * name, due to the crate disambiguators (which depend on the compiler)
+	 * as well as changes to the source code itself between versions (since
+	 * these come from the Rust standard library).
+	 */
+	return str_ends_with(func->name, "_4core6option13unwrap_failed")			||
+	       str_ends_with(func->name, "_4core6result13unwrap_failed")			||
+	       str_ends_with(func->name, "_4core9panicking5panic")				||
+	       str_ends_with(func->name, "_4core9panicking9panic_fmt")				||
+	       str_ends_with(func->name, "_4core9panicking14panic_explicit")			||
+	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
+	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
+	       (strstr(func->name, "_4core5slice5index24slice_") &&
+		str_ends_with(func->name, "_fail"));
+}
+
 /*
  * This checks to see if the given function is a "noreturn" function.
  *
@@ -202,10 +244,14 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 	if (!func)
 		return false;
 
-	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
+	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
+		if (is_rust_noreturn(func))
+			return true;
+
 		for (i = 0; i < ARRAY_SIZE(global_noreturns); i++)
 			if (!strcmp(func->name, global_noreturns[i]))
 				return true;
+	}
 
 	if (func->bind == STB_WEAK)
 		return false;
diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index 7ebf29c91184..82a001ac433b 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -35,6 +35,8 @@ NORETURN(panic)
 NORETURN(panic_smp_self_stop)
 NORETURN(rest_init)
 NORETURN(rewind_stack_and_make_dead)
+NORETURN(rust_begin_unwind)
+NORETURN(rust_helper_BUG)
 NORETURN(sev_es_terminate)
 NORETURN(snp_abort)
 NORETURN(start_kernel)
-- 
2.45.2

