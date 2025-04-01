Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C30720E328;
	Tue,  1 Apr 2025 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545603; cv=none; b=Q5TKxFb1jf89QVhvPGZvmS2GzGpdT+GoRK26fpOg2aeh7pM4mPm2RyqP4og6J/1dD9teH9inRVu1PuDxUr1ECx6BRj6KEGXN/4WGM/rHjHxxcQBM2jAma2O34EVcRi0N/fIFZWMdepO3Cff3Znlyc9nkr78awyUALc3wIHdlcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545603; c=relaxed/simple;
	bh=9jE1gZkrGazs+uylql/bYZ95xk/tZkYQUTL0zvL0V8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kiwtpayXwSo2TT7eSMBYlVyjp5qOq0ejR0SGEMMmPagPWiXYqkvzlPsGQ21mZk53o07txVmZ+0108btU9U2s5iqz3h7yTm9NHmDWdyo6HLZlt9puC9qQ1fu0nmE5RmwerLnWOxx0tzXwW2/3kbUVXKA8/eeWifqUvnmtvxBLz4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leUZHVK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leUZHVK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2E9C4CEE4;
	Tue,  1 Apr 2025 22:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743545602;
	bh=9jE1gZkrGazs+uylql/bYZ95xk/tZkYQUTL0zvL0V8k=;
	h=From:To:Cc:Subject:Date:From;
	b=leUZHVK+hdku+0WKtRUNHQauwPY226oQTp+WyKbZvVkA/4a/3Wfsj/NreuHBwvI8J
	 PSU2Sppp+EOGv53YrcFcXxuiT6+8FibF8m/Npl9R88Xs7i0WmWdQNGz/tRFH+bI3Y5
	 zx+gKAna4VXuA7HtJRxQAN5QaYnl6cfd5pd5RLg5KL08hHqfRnl4rQvA3kbCzM3oXm
	 99nEAopoRIY6+iHzd4Jw5ftEolEPyDmDLUGLsZ5BTuFwFvyq/UwAxbiU+qgYcubf3D
	 7H1Q9hidAE8Z9tS5UzBE6BovyJWieaGWw7TOVoKwxgQ37PAPP4K6YzKzc8pRaIt3bu
	 w0edxU4KiIbuA==
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
	patches@lists.linux.dev
Subject: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
Date: Wed,  2 Apr 2025 00:12:05 +0200
Message-ID: <20250401221205.52381-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with the upcoming Rust 1.86.0, Clippy's `needless_continue` lint
complains about the last statement of a loop [1], including cases like:

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

Thus clean them up.

Link: https://github.com/rust-lang/rust-clippy/pull/13891 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
To be honest, I am not sure we want this.

The lint can find cases that should be simplified, and it has been a nice lint
so far, but somehow I feel that using `continue` shows the intent better when
it is alone in an arm like that, and I am not sure we want to force people to
try to find other ways to write the code either, in cases when that applies.

If others feel this reads worse, then I would be happy to disable the lint and
open an issue upstream to keep the cases that are more clear cut.

 rust/macros/helpers.rs | 2 +-
 rust/macros/kunit.rs   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/macros/helpers.rs b/rust/macros/helpers.rs
index a3ee27e29a6f..bfa3aa7441d2 100644
--- a/rust/macros/helpers.rs
+++ b/rust/macros/helpers.rs
@@ -81,7 +81,7 @@ pub(crate) fn function_name(input: TokenStream) -> Option<Ident> {
                 }
                 return None;
             }
-            _ => continue,
+            _ => (),
         }
     }
     None
diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
index 4f553ecf40c0..63f79e5ac290 100644
--- a/rust/macros/kunit.rs
+++ b/rust/macros/kunit.rs
@@ -54,7 +54,7 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
                     };
                     tests.push(test_name);
                 }
-                _ => continue,
+                _ => (),
             },
             _ => (),
         }

base-commit: 08733088b566b58283f0f12fb73f5db6a9a9de30
--
2.49.0
