Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF32561D6;
	Fri,  2 May 2025 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194599; cv=none; b=uoHwv3Y5InZLgfUNWW/l5b3DIL4B6g1Q1zHIG/wsWGwL/6uTCtiX+Avjso7ZeTtRFNMojt89aD0qxPQLXwDoI9ebgIIxMUWkJ4Rc49fH9nN7ETsGLXxAVCg2MPau5TT282aIFwcfiBgCGf7FE4o7p9RYUxSzx0NtK3kTiX4BkRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194599; c=relaxed/simple;
	bh=JcmBhEUrvfaH96FSKF0m0KRLP7jLR6gEc4dpoEbdEt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQvV7N6qk1gRrOez3zP3QgQRPLGaQoJMDy9yomuRpxOuPal1W5BoTQaTntd8tt5wU3BT3X2LhXdjaL8gaO15dEKoYNR6QhIkr5lo8lH7Z62/rpLN10GkXv0ZoAsiI3bMZoqORNTGQhrWO/Z4tdDuIXS6DmHgpSLHv4H+p9c8pjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inN3AMId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inN3AMId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA56C4CEEB;
	Fri,  2 May 2025 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194596;
	bh=JcmBhEUrvfaH96FSKF0m0KRLP7jLR6gEc4dpoEbdEt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inN3AMIdb/IvUq7c5JYjEEcJjZ4YJZtQZNjXxcAYlOxOM9xu2aeLGlpsD5nSDenGF
	 4AMtdAweIx6EMTDD2Ii4WaP8m/pC7hqExaara4Yvh9+/tOGwvcSXHhgVwGn/1LQdOn
	 Iz/b8LINQOCO+9YGWO+/4kaLuSqL/2hRLu7rvhPtjRMb8KoEzgO7ZD22BUWnCt7UHh
	 V/PRX9oU1uVdvT8Kxy8F+l3JOokHLiLIjyxMkTczVmOGck6i/nL2x5KN9QdG1SdeH9
	 2M+JoHM5+Cfs91jk1mDWZ0z6/Ys9DpRBJJHHsSUlGsrbMu51LDo7qf6nwqFqW6LN0v
	 DC4bpSveSTl0w==
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
	stable@vger.kernel.org
Subject: [PATCH 4/5] rust: clean Rust 1.88.0's warning about `clippy::disallowed_macros` configuration
Date: Fri,  2 May 2025 16:02:36 +0200
Message-ID: <20250502140237.1659624-5-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
References: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.88.0 (expected 2025-06-26) [1], Clippy may start
warning about paths that do not resolve in the `disallowed_macros`
configuration:

    warning: `kernel::dbg` does not refer to an existing macro
      --> .clippy.toml:10:5
       |
    10 |     { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
       |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is a lint we requested at [2], due to the trouble debugging
the lint due to false negatives (e.g. [3]), which we use to emulate
`clippy::dbg_macro` [4]. See commit 8577c9dca799 ("rust: replace
`clippy::dbg_macro` with `disallowed_macros`") for more details.

Given the false negatives are not resolved yet, it is expected that
Clippy complains about not finding this macro.

Thus, until the false negatives are fixed (and, even then, probably we
will need to wait for the MSRV to raise enough), use the escape hatch
to allow an invalid path.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-clippy/pull/14397 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/11432 [2]
Link: https://github.com/rust-lang/rust-clippy/issues/11431 [3]
Link: https://github.com/rust-lang/rust-clippy/issues/11303 [4]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .clippy.toml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.clippy.toml b/.clippy.toml
index 815c94732ed7..137f41d203de 100644
--- a/.clippy.toml
+++ b/.clippy.toml
@@ -7,5 +7,5 @@ check-private-items = true
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
-    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
+    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool", allow-invalid = true },
 ]
-- 
2.49.0

