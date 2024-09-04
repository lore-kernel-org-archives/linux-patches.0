Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0618D64D;
	Wed,  4 Sep 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482749; cv=none; b=Mh/4uaNEzBs3XSvnEFDr82puo0P0CwnPRpQBsTUUdrtd96QrvibRKHN0DxoJi5Kvt7BMvDAfP0+rOda/Mbwp2aDTfw6BZd3PF6zrKyE5YxvvAlDjB9Hd48xmum68q0HDeyi7ULev3msMnEjRJrFx1/9ghrvufq9CCLbogKSx3ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482749; c=relaxed/simple;
	bh=U6hGx73rC3AYOaz/2v00ONvDNaSLR3ygbElu0yUb9Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfBIgk4kLdjPJpA5L6vecM6C3uaWJV9304PXQ6GTHkJrOmPeHU2ghmhgZxBvTcgDXNQUP+W6q6C3qFO/oa7zZnJjbD3Je6zemI8vlJ7aC4ae3dkz6bL04+s4u7hLAQWMGtyJiJqgmby5vNobKJQQJEA/lJzO04eqXGFaP4bUtBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JprDo5FW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JprDo5FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846B8C4CEC5;
	Wed,  4 Sep 2024 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482748;
	bh=U6hGx73rC3AYOaz/2v00ONvDNaSLR3ygbElu0yUb9Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JprDo5FWn/tiTsXP1EeXBfFqsW00Qa7PjpdmAEvcSSfIx/UZoqqpCBI0sTTvqcyTe
	 gVQDwQeZV21Q94kuatc56B1WJ8m6/LEMVEAFjU5pYLWEV8O4S5CkTG/F/wXTDW7VVl
	 6jGtr/gMXbndR679UxxmLxcWqzId/YT0KDXKQBcYsp13UWNaDZjxVJBkhPNPvyIq9q
	 TK1K53ufQtbOpA2BcG4IIL3XKzPGMO5TskkDTAKnX1/54IMl0F8mjP+3vzVzVPhDl4
	 DBxn2cNID1qKb8o1JRRSIB7H4+GEfRMoyWu6zB+qqDa0hPMJ0GSQ48XcsSFDM/2S/Z
	 PKoUeCVSTLNMg==
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
Subject: [PATCH 18/19] Documentation: rust: discuss `#[expect(...)]` in the guidelines
Date: Wed,  4 Sep 2024 22:43:46 +0200
Message-ID: <20240904204347.168520-19-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Discuss `#[expect(...)]` in the Lints sections of the coding guidelines
document, which is an upcoming feature in Rust 1.81.0, and explain that
it is generally to be preferred over `allow` unless there is a reason
not to use it (e.g. conditional compilation being involved).

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 110 +++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 185d3b51117d..5d64bc69acae 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -256,3 +256,113 @@ By that virtue, it makes it possible to comfortably enable more diagnostics by
 default (i.e. outside ``W=`` levels). In particular, those that may have some
 false positives but that are otherwise quite useful to keep enabled to catch
 potential mistakes.
+
+On top of that, Rust provides the ``expect`` attribute which takes this further.
+It makes the compiler warn if the warning was not produced. For instance, the
+following will ensure that, when ``f()`` is called somewhere, we will have to
+remove the attribute:
+
+.. code-block:: rust
+
+	#[expect(dead_code)]
+	fn f() {}
+
+If we do not, we get a warning from the compiler::
+
+	warning: this lint expectation is unfulfilled
+	 --> x.rs:3:10
+	  |
+	3 | #[expect(dead_code)]
+	  |          ^^^^^^^^^
+	  |
+	  = note: `#[warn(unfulfilled_lint_expectations)]` on by default
+
+This means that ``expect``\ s do not get forgotten when they are not needed, which
+may happen in several situations, e.g.:
+
+- Temporary attributes added while developing.
+
+- Improvements in lints in the compiler, Clippy or custom tools which may
+  remove a false positive.
+
+- When the lint is not needed anymore because it was expected that it would be
+  removed at some point, such as the ``dead_code`` example above.
+
+It also increases the visibility of the remaining ``allow``\ s and reduces the
+chance of misapplying one.
+
+Thus prefer ``except`` over ``allow`` unless:
+
+- The lint attribute is intended to be temporary, e.g. while developing.
+
+- Conditional compilation triggers the warning in some cases but not others.
+
+  If there are only a few cases where the warning triggers (or does not
+  trigger) compared to the total number of cases, then one may consider using
+  a conditional ``expect`` (i.e. ``cfg_attr(..., expect(...))``). Otherwise,
+  it is likely simpler to just use ``allow``.
+
+- Inside macros, when the different invocations may create expanded code that
+  triggers the warning in some cases but not in others.
+
+- When code may trigger a warning for some architectures but not others, such
+  as an ``as`` cast to a C FFI type.
+
+As a more developed example, consider for instance this program:
+
+.. code-block:: rust
+
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+Here, function ``g()`` is dead code if ``CONFIG_X`` is not set. Can we use
+``expect`` here?
+
+.. code-block:: rust
+
+	#[expect(dead_code)]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+This would emit a lint if ``CONFIG_X`` is set, since it is not dead code in that
+configuration. Therefore, in cases like this, we cannot use ``expect`` as-is.
+
+A simple possibility is using ``allow``:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+An alternative would be using a conditional ``expect``:
+
+.. code-block:: rust
+
+	#[cfg_attr(not(CONFIG_X), expect(dead_code))]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+This would ensure that, if someone introduces another call to ``g()`` somewhere
+(e.g. unconditionally), then it would be spotted that it is not dead code
+anymore. However, the ``cfg_attr`` is more complex than a simple ``allow``.
+
+Therefore, it is likely that it is not worth using conditional ``expect``\ s when
+more than one or two configurations are involved or when the lint may be
+triggered due to non-local changes (such as ``dead_code``).
-- 
2.46.0

