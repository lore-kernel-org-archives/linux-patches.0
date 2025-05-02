Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF873238D54;
	Fri,  2 May 2025 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194587; cv=none; b=E5AHPlASUU5rlfgj697W+277mdOgrclBNlwOmDT+Bhsqb8SFgT8yOsQhuFNdS5f9/YDEd6N1VIMgtyUDT739nnBTqbZNMSpX7o9nDCKW6MNHLJoP3/ELfEntTB/XorpJDwt6GzUvqDS2yHp6rKvXzv7jdTWOL/xkcn0isGnSy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194587; c=relaxed/simple;
	bh=loBVhQtxMnHPpHQWrOwMbvIHRbUcRTPATJrFoQoljRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnxk92aOUyIejF7kuCJM9Zcb121bik1MF6YdGcUh4FLFWdkj6Fa9w0HOLmN6lWvpWQy574tjhhpZ1LRc2OCtvM6OSKS4y2fJb/+44mLPQqxJBXhEzJUsmJAokw7GiGreyfh7dd8rPGi8QVUULxbpDAxmguTjTkVvHKagj3HwEOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfbHIUu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfbHIUu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80EAC4CEEE;
	Fri,  2 May 2025 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194585;
	bh=loBVhQtxMnHPpHQWrOwMbvIHRbUcRTPATJrFoQoljRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfbHIUu3MDdYXjpZMQd3JJ9F/Ni3TpciA38YgnqSmUfX9v9csHW4+XmvfYGZSubwX
	 YA3iaU6JBxlD2XLnQNy9kxYPqHSW7foCgCkfu2zzGQ5NAt1UJqTFJeeIdVQeUUi/eG
	 mTNtn2GT71xj1+I6kzHGAfTcENTPjf+Nm0hKWtCqwruCP55KxNWn4S88c1QtDeEvT7
	 XmlCPOJGt6pJK1JzYQvmVIZFvXstT3C07JBYqAZ2yNGP5c+VMWZRNb2SaygVUZlkOA
	 0Ux/WF+UG5HrlykiVnjVW3V9tJUrHSzpxEAmbgLSsg7CtsFntWbOJ1K+rv1SkwInpE
	 V1WrxLPpEZm5A==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function for Rust 1.87.0
Date: Fri,  2 May 2025 16:02:33 +0200
Message-ID: <20250502140237.1659624-2-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
References: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:

    rust/core.o: warning: objtool: _R..._4core9panicking9panic_fmt() falls
    through to next function _R..._4core9panicking18panic_nounwind_fmt()

    rust/core.o: warning: objtool: _R..._4core9panicking18panic_nounwind_fmt()
    falls through to next function _R..._4core9panicking5panic()

The reason is that `rust_begin_unwind` is now mangled:

    _R..._7___rustc17rust_begin_unwind

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Alternatively, we could remove the fixed one in `noreturn.h` and relax
this test to cover both, but it seems best to be strict as long as we can.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3a411064fa34..b21b12ec88d9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -227,6 +227,7 @@ static bool is_rust_noreturn(const struct symbol *func)
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
+	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
 	       (strstr(func->name, "_4core5slice5index24slice_") &&
--
2.49.0
