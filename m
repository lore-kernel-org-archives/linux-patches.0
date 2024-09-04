Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10501153824;
	Wed,  4 Sep 2024 20:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482708; cv=none; b=X7lK1MYECyvxS4sSDwfvQfzhhQ6FpHYBz4iIKr8mLNZr9IYfrJnIzZtvo43wiyXsV6T0uv61sYGQ7CKzqHBMTX9tLD3cJElKccZLhQ7LdH7Qqf6VcRh/tODadRWppqKCZf5t+9HdAwmUXovzZpujUMr4D6Bh4MPLwna1MGnyY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482708; c=relaxed/simple;
	bh=glvDHd6iNw4JzzL+e5mlgcx23zzqkBX2iil+RJ4+6/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGPEEETLms3X1R+i6V5Gi4/IDifKcsCuttpwaVNoCNLFf1ogmhEM6ZGl0Tc/slM+NApuDRFlzb0ZaGEV5VvlctpDLSmILsOhE7e0aNbJgf4Z+afi91tPpEMfxeUu2Ci+l6rA+l/p3YZLk3/xljZs3lMxdMWVMBhR2IKQQTFyze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BM0sidpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BM0sidpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B0C4CEC5;
	Wed,  4 Sep 2024 20:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482707;
	bh=glvDHd6iNw4JzzL+e5mlgcx23zzqkBX2iil+RJ4+6/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BM0sidprk7i3FSoeF4LZErYZbC4hUpGWVcsPRQPtpaWa53tAAclBbMIk+ZiIcS2p7
	 gtCDtwVWHxCejWNCeWaExcSHwu/6P4wZK+xxqlSnO/AqTWBouh6Vc0zrPw4urpMI31
	 LxjWfQznX7s8Qf8udk6lg/0metfmeggiFLAwKMOolbEjEjycwJIEPpekWWkWyeHPJt
	 UoeDAjFFZnRcPN/C9RnWsW+wwHpL2U6vDfNTWa9MksEmRKvz3ez0cVXo7C6bNCT1mG
	 3VfO1JmVl7P/hnPGtt8NlysRKXUEerE8CqCwX/DGc8QKiFD4t0lSRoazva+yo7uNst
	 2yYfv6Foq5itw==
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
Subject: [PATCH 07/19] rust: enable `clippy::ignored_unit_patterns` lint
Date: Wed,  4 Sep 2024 22:43:35 +0200
Message-ID: <20240904204347.168520-8-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile             | 1 +
 rust/kernel/types.rs | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f903309db91b..cc1b01590227 100644
--- a/Makefile
+++ b/Makefile
@@ -452,6 +452,7 @@ export rust_common_flags := --edition=2021 \
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
2.46.0

