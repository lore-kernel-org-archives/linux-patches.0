Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A41514F6;
	Thu,  3 Apr 2025 16:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743698300; cv=none; b=rzhDiDJM297zuqoX2zsF4C1qPQxAOBpNNm7/luJrjjVY4ytNgKSXO+Rl0rXONpG7sjodvYQug4P/+GWOozNbb79+JgE6ahrtHq3/OIUhD2ISo5nOZakxZtj5rrLNORC6MfPoAfWRy3jG28oDn43CK61qqb9sB5aEdvDYks0YkZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743698300; c=relaxed/simple;
	bh=KtUfjAG1/WEauaqQuciEUvXMo2dub6bMxhzIcaq1sR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hs/y6pGsackX6Jr4WY/0XDKVJU45l5DCK6NKGJTd0oyaoqn4FqPCoS1UJlEBeIll+olWEythBE/xsiJzIDx9YkY8pfKmAPMJkr10shyGmSd+RkusIYpgEzXx09UlzTiRQCtY56pfnVwqgq5/dv3z8p8h1mB4FV1kf60EGLZL/N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dyb1tNEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dyb1tNEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF80C4CEE3;
	Thu,  3 Apr 2025 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743698299;
	bh=KtUfjAG1/WEauaqQuciEUvXMo2dub6bMxhzIcaq1sR0=;
	h=From:To:Cc:Subject:Date:From;
	b=Dyb1tNEAiREoivi+HcddE7uM+5xkKAqaXKimQ8xAMYqnHxWd5mV/1NJhyLOBETnW4
	 M8qOqq+DxgjSF8Tnkv7VJiiMVObDS86dPsFyLv2HvIgNAo3U4p7HBqXf8QLHxL6Gox
	 neTTAZKOcayi+k9lQ47oSrcB4vNuK7VOIbqlfQ4EouNoEsmnSzAqFGDO8rigCcgFKv
	 kZ2a10HJSGlT/yrsMooCvfeKoobktNtq1YKPx0aXf5GcPfoQl5cR4wKU8ssKGsMnuZ
	 9VGUAVnqX6HpurACGpsGxjP6c22IC0j4AJ8f2AoG2GVLJH72bKkr/vToG250BSGWs5
	 /7yy43JcQYYqw==
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
	Tamir Duberstein <tamird@gmail.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: disable `clippy::needless_continue`
Date: Thu,  3 Apr 2025 18:38:05 +0200
Message-ID: <20250403163805.67770-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.86.0, Clippy's `needless_continue` lint complains
about the last statement of a loop [1], including cases like:

    while ... {
        match ... {
            ... if ... => {
                ...
                return ...;
            }
            _ => continue,
        }
    }

as well as nested `match`es in a loop.

One solution is changing `continue` for `()` [2], but arguably using
`continue` shows the intent better when it is alone in an arm like that.

Moreover, I am not sure we want to force people to try to find other
ways to write the code either, in cases when that applies.

In addition, the help text does not really apply in the new cases the
lint has introduced, e.g. here one cannot simply "drop" the expression:

    warning: this `continue` expression is redundant
      --> rust/macros/helpers.rs:85:18
       |
    85 |             _ => continue,
       |                  ^^^^^^^^
       |
       = help: consider dropping the `continue` expression
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_continue
       = note: requested on the command line with `-W clippy::needless-continue`

The examples in the documentation do not show a case like this, either,
so the second "help" line does not help.

In addition, locally disabling the lint is not possible with `expect`,
since the behavior differs across versions. Using `allow` would be
possible, but, even then, an extra line just for this is a bit too much,
especially if there are other ways to satisfy the lint.

Finally, the lint is still in the "pedantic" category and disabled by
default by Clippy.

Thus disable the lint, at least for the time being.

Feedback was submitted to upstream Clippy, in case this can be improved
or perhaps the lint split into several [3].

Link: https://github.com/rust-lang/rust-clippy/pull/13891 [1]
Link: https://lore.kernel.org/rust-for-linux/20250401221205.52381-1-ojeda@kernel.org/ [2]
Link: https://github.com/rust-lang/rust-clippy/issues/14536 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Makefile b/Makefile
index d138b17b8840..2c33d25c505c 100644
--- a/Makefile
+++ b/Makefile
@@ -480,7 +480,6 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
-			    -Wclippy::needless_continue \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \

base-commit: a2cc6ff5ec8f91bc463fd3b0c26b61166a07eb11
-- 
2.49.0

