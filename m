Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CCBA49;
	Sun, 13 Apr 2025 00:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744503961; cv=none; b=FIk/XQrFtn//vQsyBwbs3Zz+9GsbIRgkQM73iT1j+s/P0cbxyIue5hZGNArRXj1sdINyErW9dF8ONAQjzYSCQ+bFD3vFamXolx91LZ4IZCJ7I+G8SExG2dP0JksFng3rKRAeR3M70h46iTd0f6sXexb4ZiJyRnWdX5M93LMJ8r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744503961; c=relaxed/simple;
	bh=ma3//bYP5NsNIhP5erbPOIXQNgt8Q5cf+5oa2YsETf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TF7ql689QvAxFt0MsR6YW2yKNRuGHzgqdtvMD+imrOCpMST8QRVzCw3JYIrBT0SEdtwutjZR1a4hbOuNhL8K0AZD6McefoVo49l7lecyAKof4FX+hSY6Z5wbEyK4IGXj1hGqRc82z2eyUmLRB5CnGicjhMM2uC3z7xWJypGREBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hyvh4CBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hyvh4CBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FB8C4CEE3;
	Sun, 13 Apr 2025 00:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744503960;
	bh=ma3//bYP5NsNIhP5erbPOIXQNgt8Q5cf+5oa2YsETf4=;
	h=From:To:Cc:Subject:Date:From;
	b=Hyvh4CBQGVpkZke9Eevo4Du530yg+SyCbC8PHMFkTNpfWs+KEkSymUUZfq0Tneg95
	 ja0EckenR/73QUrQdNi2i817jmiYoULWVol2wFxjoBlKV6DtpufczdkOg7JivlW07G
	 yHgbV/O+X7FjUdKBlPyhJP51A26hb4FMGrCag2SipRwThB9d6JYx/oU3dsQR3frJpS
	 YTN67cQ71ZduyUlmhDqtnqzp7sAq8H/37ByWbVnDmib1sYQryaDis6IiZUZ9b2imuw
	 80PQW7Ck4GaZiYiraT91m4PUkl3+xUWSQ262TYBm6OOcAnofU16x7WrEdmoE1bzXiO
	 cldJx6aLqME2Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
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
	stable@vger.kernel.org
Subject: [PATCH] objtool/rust: add one more `noreturn` Rust function
Date: Sun, 13 Apr 2025 02:23:38 +0200
Message-ID: <20250413002338.1741593-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.86.0 (see upstream commit b151b513ba2b ("Insert null
checks for pointer dereferences when debug assertions are enabled") [1]),
under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
one may trigger a new `objtool` warning:

    rust/kernel.o: warning: objtool: _R..._6kernel9workqueue6system()
    falls through to next function _R...9workqueue14system_highpri()

due to a call to the `noreturn` symbol:

    core::panicking::panic_null_pointer_dereference

Thus add it to the list so that `objtool` knows it is actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
Link: https://github.com/rust-lang/rust/commit/b151b513ba2b65c7506ec1a80f2712bbd09154d1 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4a1f6c3169b3..67006eeb30c8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -225,6 +225,7 @@ static bool is_rust_noreturn(const struct symbol *func)
 	       str_ends_with(func->name, "_4core9panicking14panic_nounwind")				||
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
+	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||

base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
-- 
2.49.0

