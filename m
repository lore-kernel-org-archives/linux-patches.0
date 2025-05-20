Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5037727BF7D;
	Tue, 20 May 2025 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747767366; cv=none; b=fIGceSbYLPmBHo3yhxjydD1VV3x/wmX7Ey3jBH+mTU5SK/dTGkH8e3MTT86xB7jkxciL5noB/EeLxHRuuctwKztmQTupn3yR0N+mdUwB/GKgkTrTVPuzlpkYeuKELzX1Z/macuNtXy+drvNL/zl2BZtdfmMZqNW65kxuWl3M8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747767366; c=relaxed/simple;
	bh=RQmU7ezkBQCoyTFpXIqZ6e3GD/9vmGdYmUjBtJPu0M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IHcK9zH1sOzhWkIrd05tZ1kpzSrUFYqLaI9rGIhZ/u1kpHpzcue1Ll/BfHOHuVwGkAqdL7v2sreyzpUqYFiANVbCvhzrK6NrhS5KyQYOhnvFUvz8ggm2kTRAQukoj+4wuJL/2LDRxm6Ci+P6dIj1VXX/f7LCGK3Pk38AaR28VRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxs73m4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxs73m4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD83C4CEE9;
	Tue, 20 May 2025 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747767365;
	bh=RQmU7ezkBQCoyTFpXIqZ6e3GD/9vmGdYmUjBtJPu0M0=;
	h=From:To:Cc:Subject:Date:From;
	b=oxs73m4v1aU+7EhWgM0E0YJtBqCh0sl1uADbXbEZkcBE7l/y57qnIXhjXv3pnival
	 AbhzhEHHiIXIuRsDslzASYpPDaU98el4SmBR1+huFro8aDevjY1L4Nb8rdaAwCqCL6
	 iPnaighpWFkbIdGPmMxMo+1znNk+/yrg9jbF99AcU1jRFPGU/D3gybpApLmvKbKPKr
	 IdG6/p6EHJLu3vc7V6eZ9qoPW8T7kZ7yow9a1QzwFBldYvzZpckHSVp+5wjTBvrkqa
	 QU6/AuatC1wyWgQleSoZ6IxGuIsbS9Ccm9A6EIyixdvwPzVDBF+rpRakitHT3G4llW
	 +pcP4SVeKxR+A==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
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
	John Hubbard <jhubbard@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Kane York <kanepyork@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>
Subject: [PATCH] objtool/rust: relax slice condition to cover more `noreturn` Rust functions
Date: Tue, 20 May 2025 20:55:55 +0200
Message-ID: <20250520185555.825242-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Developers are indeed hitting other of the `noreturn` slice symbols in
Nova [1], thus relax the last check in the list so that we catch all of
them, i.e.

    *_4core5slice5index22slice_index_order_fail
    *_4core5slice5index24slice_end_index_len_fail
    *_4core5slice5index26slice_start_index_len_fail
    *_4core5slice5index29slice_end_index_overflow_fail
    *_4core5slice5index31slice_start_index_overflow_fail

These all exist since at least Rust 1.78.0, thus backport it too.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Timur Tabi <ttabi@nvidia.com>
Cc: Kane York <kanepyork@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Joel Fernandes <joelagnelf@nvidia.com>
Link: https://lore.kernel.org/rust-for-linux/20250513180757.GA1295002@joelnvbox/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I tested it with the Timur's `alex` branch, but a Tested-by is appreciated.
Thanks!

 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b21b12ec88d9..f23bdda737aa 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -230,7 +230,8 @@ static bool is_rust_noreturn(const struct symbol *func)
 	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
-	       (strstr(func->name, "_4core5slice5index24slice_") &&
+	       (strstr(func->name, "_4core5slice5index") &&
+		strstr(func->name, "slice_") &&
 		str_ends_with(func->name, "_fail"));
 }


base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
--
2.49.0
