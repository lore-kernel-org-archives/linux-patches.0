Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D675E20D503;
	Fri,  7 Mar 2025 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387855; cv=none; b=UsRZYcF1BdKUrDzlc3UA5bm3ND05C1CNksPzSClwr0/BoVzf60qoPn9VmkIdjoykc4wO1EI2Xn4W+r9MF02KvBWKpy2LIEskgkAG+W9LuvRxeM9XWEqR8Yw0BjPv2O4sQrVEBFAmmITUcf+/R1w7pL0Ce9vjHATSuq8M6bj+oEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387855; c=relaxed/simple;
	bh=ltJfqT2R+WXDwEX4QosYJyqC8o8Gw8bYiXIWDKG2ito=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHU6ynvecb2lPGv5o8jSeA4AmlR2ARwtK8hRKIkKodBIKfoxXPGtq3hdHlGYbzRy8d8a+Lv23hrRlHdqXJbbxTpLRUTqk8YKFEGVQtdZCzq7bMi+sRnY6Z0W4RSzCLG46wethr5WBjX5gyqUj5E2jgDNO9kfH85Tjcu5gpZer/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R060iW+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R060iW+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202A4C4CEE3;
	Fri,  7 Mar 2025 22:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387855;
	bh=ltJfqT2R+WXDwEX4QosYJyqC8o8Gw8bYiXIWDKG2ito=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R060iW+LXFLRat5tydVZP82M+06WLcXtiLLtzkjB0Oy/7Nklb1VyHAKv2/Yus7JUE
	 w4iiIKnqKy2Iffb1Hy/szPM19o+SH6pzu1p5dE9jhkIM0eSgXowkdFXh24KeYrsRnc
	 GLrr5rjmYuKQ2l4sA6esu2uqfMgLDRZGPpSHGJqhro/X6W5Yij2rsnrSsDnvP26Vf+
	 +ygYfRPuB3wfWFq5Q2u9X3hNrLkR9tTUZwTmqHRWUSFzGXy5fHNgecivp+uI1yjbXj
	 pg6Jto2Z8CfhjbxNouaVDRp2DHL8V8l3NQLi/vsX90NmJaacUDlAjbZuIOtdBW3vXV
	 BK3T0awnjjU0A==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 07/60] rust: enable `clippy::ignored_unit_patterns` lint
Date: Fri,  7 Mar 2025 23:49:14 +0100
Message-ID: <20250307225008.779961-8-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 3fcc23397628c2357dbe66df59644e09f72ac725 upstream.

In Rust 1.73.0, Clippy introduced the `ignored_unit_patterns` lint [1]:

> Matching with `()` explicitly instead of `_` outlines the fact that
> the pattern contains no data. Also it would detect a type change
> that `_` would ignore.

There is only a single case that requires a change:

    error: matching over `()` is more explicit
       --> rust/kernel/types.rs:176:45
        |
    176 |         ScopeGuard::new_with_data((), move |_| cleanup())
        |                                             ^ help: use `()` instead of `_`: `()`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#ignored_unit_patterns
        = note: requested on the command line with `-D clippy::ignored-unit-patterns`

Thus clean it up and enable the lint -- no functional change intended.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/ignored_unit_patterns [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-8-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile             | 1 +
 rust/kernel/types.rs | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 13d8aa4a41d3..7433df4d22f9 100644
--- a/Makefile
+++ b/Makefile
@@ -453,6 +453,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wunreachable_pub \
 			    -Wclippy::all \
 			    -Wclippy::dbg_macro \
+			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 6c2d5fa9bce3..4e03df725f3f 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -225,7 +225,7 @@ pub fn dismiss(mut self) -> T {
 impl ScopeGuard<(), fn(())> {
     /// Creates a new guarded object with the given cleanup function.
     pub fn new(cleanup: impl FnOnce()) -> ScopeGuard<(), impl FnOnce(())> {
-        ScopeGuard::new_with_data((), move |_| cleanup())
+        ScopeGuard::new_with_data((), move |()| cleanup())
     }
 }
 
-- 
2.48.1

