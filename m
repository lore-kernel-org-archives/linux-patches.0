Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668FB230BC8;
	Mon, 10 Mar 2025 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627113; cv=none; b=Mk0OFwZFf2Uh2uG+0z1F47wIU6JDJIpILfe5Ck9qTXK91H4bHsU3WNyj7kyjUzzrISOYqW71EbeeMZrmZC2gbAwNCurEYKBG/H5AYxEHoY0g1wehhE7321a+a3o5W15PuLQjDw9A8H2RPahrMT+iy//uEQ/NJwjty6a0V+YgL7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627113; c=relaxed/simple;
	bh=JtupEimtiUMSVJBjPTYwUj4KokLpbb+E1dUIfK87syQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZvIqoKvr4EfFYQTpQxX9LDwFQa01l5wz2bLLbfXbKtZyoj6p2rwkiU208JaRnTr7ocpBz/QgSIAPoWolCCM2P+uK/bIoNqGPFTvlDu3Hmy58YjqMZydvD4g2aoWioutRX5+uDR0M8cvXaIF9qgXj+zZmYXnSWLeSkHaUvL+1B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOaH7xyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOaH7xyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ECFC4CEED;
	Mon, 10 Mar 2025 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627113;
	bh=JtupEimtiUMSVJBjPTYwUj4KokLpbb+E1dUIfK87syQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOaH7xytsuU4MNpJx35kBbhYSJeNN9HUSa24QlgIG87YbwqIDlIwYtVLCaPEjwtTt
	 hsnTe5ctstkiIZdksxivuSqZbsqi6Ynfer1atz18Ahv/ECBpSGk12bigECeX0db/fP
	 iAgGlisCyerBuOhjHGKuTt2xXqXFTKRNfjoevTpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 018/269] rust: enable `clippy::ignored_unit_patterns` lint
Date: Mon, 10 Mar 2025 18:02:51 +0100
Message-ID: <20250310170458.434685650@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile             |    1 +
 rust/kernel/types.rs |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -453,6 +453,7 @@ export rust_common_flags := --edition=20
 			    -Wunreachable_pub \
 			    -Wclippy::all \
 			    -Wclippy::dbg_macro \
+			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -225,7 +225,7 @@ impl<T, F: FnOnce(T)> ScopeGuard<T, F> {
 impl ScopeGuard<(), fn(())> {
     /// Creates a new guarded object with the given cleanup function.
     pub fn new(cleanup: impl FnOnce()) -> ScopeGuard<(), impl FnOnce(())> {
-        ScopeGuard::new_with_data((), move |_| cleanup())
+        ScopeGuard::new_with_data((), move |()| cleanup())
     }
 }
 


