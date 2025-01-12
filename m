Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1AB1B86DC;
	Sun, 12 Jan 2025 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736692811; cv=none; b=bnkugBxC6LNoLIlqKqT81WGFlKLy2z4iqu9KsHNzV5shSMwnTU/dYGoh4mkkeAfW3UtKOlrKdmqb2fuvIRyzi3LoXx/DSkZwkNDpMpjvWblRgZcUanClmm9k5EMfC2rUDuM8gBJCFxKM0sRSAsYQ9LAJFD9cSFx9CjI/iY/DMDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736692811; c=relaxed/simple;
	bh=c/aW+36Ftt9sDgQezinuh9vh1Mz1Do0ug6ZEwJvIveQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=maoBhZcxKfqqQNFHxP2OFHX/gcfzZPJ7JwLekp2R1rtK8QIsV2gF2PDApY5BU0iyh0aF/0/EFQ0JVMb54+VKSeqXfz7kgHcVs3+O1umplgy74vYMhGKS4Yid9qSwCqiq1ji3lCCWQXgVZqjblDoeyq9C0Yh7Vi2raVItMtWRX/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msG6UESS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msG6UESS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A395BC4CEDF;
	Sun, 12 Jan 2025 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736692811;
	bh=c/aW+36Ftt9sDgQezinuh9vh1Mz1Do0ug6ZEwJvIveQ=;
	h=From:To:Cc:Subject:Date:From;
	b=msG6UESSdmhoZMfcTTWrdzxjfzWfCZZYLOQeRi2AWDpz1pUd6NigKgWFcEO26+YUg
	 XEyhg3xy6KTxz03F6HuRD9AjZ5a3OmJTB2RycuErdfoOqR4eLG32BnehvdxJVddy9U
	 FgVLfI84i5H0uepDXuf5oWncphui7sMuJucmO3hCuavqP8V5HadB7hk9/Fb9SQX7Tf
	 e4SlRCNUyI1AuFuM59KhZlGujW1IDBSWZZMyCrLzFAyAzam9Xp9YWHOFE2nPDtXshG
	 7j6yKYJrkj8Ja6S7Unn42yyrYTTpevNn/G8TedSzeCHLvZStQh5h551wNxURsSAr2+
	 nEwHXHmNYw0SA==
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
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] objtool/rust: add one more `noreturn` Rust function
Date: Sun, 12 Jan 2025 15:39:51 +0100
Message-ID: <20250112143951.751139-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.85.0 (currently in beta, to be released 2025-02-20),
under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
one may trigger a new `objtool` warning:

    rust/kernel.o: warning: objtool: _R...securityNtB2_11SecurityCtx8as_bytes()
    falls through to next function _R...core3ops4drop4Drop4drop()

due to a call to the `noreturn` symbol:

    core::panicking::assert_failed::<usize, usize>

Thus add it to the list so that `objtool` knows it is actually `noreturn`.
Do so matching with `strstr` since it is a generic.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned in older LTSs).
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 76060da755b5..e7ec29dfdff2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -218,6 +218,7 @@ static bool is_rust_noreturn(const struct symbol *func)
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
+	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
 	       (strstr(func->name, "_4core5slice5index24slice_") &&
 		str_ends_with(func->name, "_fail"));

base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20
-- 
2.48.0

