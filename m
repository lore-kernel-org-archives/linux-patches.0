Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B05171BB;
	Wed, 24 Jul 2024 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837747; cv=none; b=TMdMs1xagI3hyrRpuxFy5XRijJHn0+Y/Ai73eV87J1Rd+8FkG55rMHW4QpPjkjfPAdiU9DBcvlC+uL98xTXS/PA+MTpNqK7w2cBJCQ856HXfp588keTfKIBlGVlgGb7QmXXxZf4mNYeDLjAU/ezuuG4VE3D/nR/P8JM3kMiqQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837747; c=relaxed/simple;
	bh=M1N+bP3TKgNJUJQcJY99MqXZl55fVzueDXJIefZrph0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0JXGI1gOv7pl5XSVGgVqqkC5VGKB9/UJkPjFomhSpqQm7yYBttyY+XmxHnY3UPRbWMqDGmFixuZM9/Q9IiWJBfZxtJux9OqkDvXu/lKtcd041OWo3tWGwPQVl8aVqSPu+z0N8kG8+TCP/9Kwi1bOcgs0uIhAlhZsUF9zhCuoqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvCkB9+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvCkB9+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A42C32781;
	Wed, 24 Jul 2024 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721837747;
	bh=M1N+bP3TKgNJUJQcJY99MqXZl55fVzueDXJIefZrph0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvCkB9+Eck5uobL+XFawEywRWKStGU5NIgPkIH8fyikKgJwVRgtdYoXyW3KEYDly2
	 HzLYLSpIsGNrBYOKf1DisrYGUdTOcIVbrlYgGtUuwm2tHOoKud15C0cUq1bXmPDF/G
	 h5Tte860PeIiUqoWlFJYw+1iqKrYHT5PLPb6RFb3Z8M9xG9sOn8bw9sfW/IieRfU8X
	 b5GNA2xrvfiQ9Z7W8LFt6H/94sFElt0kcp4QYW6j8+pjOJIyzUel83yfFYZWViJrVv
	 ZXROAoI9kTv94Zb3zMIvW+gAJDwdE0FI34ao5UWIECZ++Wug9pNtyr1Fb8ItRlJ3QA
	 RQ/EnZtJgvquw==
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
Subject: [PATCH v2 5/6] objtool: list `noreturn` Rust functions
Date: Wed, 24 Jul 2024 18:14:58 +0200
Message-ID: <20240724161501.1319115-6-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
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

  - Some of the diverging functions come from `core` and `alloc`, i.e.
    the Rust standard library, which may change with each compiler version
    since they are implementation details (e.g. `panic_internals`).

Thus, to workaround both issues, only part of the symbols are matched,
instead of using the `NORETURN` macro in `noreturns.h`.

Ideally, just like for the C side, we should have a better solution. For
instance, the compiler could give us the list via something like:

    $ rustc --print noreturns ...

Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html [1]
Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguator [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Please let me know if there is a better solution -- what kind of solution was
being thought about for C as mentioned in `noreturns.h`? Would it help for Rust?

 tools/objtool/check.c     | 36 +++++++++++++++++++++++++++++++++++-
 tools/objtool/noreturns.h |  2 ++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0a33d9195b7a..0afdcee038fd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -177,6 +177,20 @@ static bool is_sibling_call(struct instruction *insn)
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
 /*
  * This checks to see if the given function is a "noreturn" function.
  *
@@ -202,10 +216,30 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 	if (!func)
 		return false;

-	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
+	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
+		/*
+		 * Rust standard library functions.
+		 *
+		 * These are just heuristics -- we do not control the precise symbol
+		 * name, due to the crate disambiguators (which depend on the compiler)
+		 * as well as changes to the source code itself between versions.
+		 */
+		if (!strncmp(func->name, "_R", 2) &&
+		    (str_ends_with(func->name, "_4core6option13unwrap_failed")			||
+		     str_ends_with(func->name, "_4core6result13unwrap_failed")			||
+		     str_ends_with(func->name, "_4core9panicking5panic")			||
+		     str_ends_with(func->name, "_4core9panicking9panic_fmt")			||
+		     str_ends_with(func->name, "_4core9panicking14panic_explicit")		||
+		     str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
+		     strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
+		     (strstr(func->name, "_4core5slice5index24slice_") &&
+		      str_ends_with(func->name, "_fail"))))
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
