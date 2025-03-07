Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF34C20D503;
	Fri,  7 Mar 2025 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387882; cv=none; b=CrovqSobptvRDOleXAOb6YfesSgYX3XgzGldQpWxQrazWi7tAND3cSDgKq1Vp4iJRJW8vhBO0NlKCIYNkDvaQtfd8nsv02/8HMEk0M6gPJJDlVxBD0jyN+LK5PmP4tIR5Q1zIl7CUZa5ay/FC3eoMXgBaYeH9xwifeRHf8uSFpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387882; c=relaxed/simple;
	bh=B7URHTkgribsSq9UqZu7acujgL0QAKceIL8OQsE52i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enp9LHS9x68haLkCQPsnrI5INfNEECPyDydehYeWWdpKi3Nv3GAqoWGn8TWl/+Ioetcxr1yJyFaqdk8B1TEtxZODmWLjL262KZ4J91DklxhxcrVOb37jECuOI/w2VGHT2uQ9IXlV55HG1XdBjOOcyVfx/ktGkkV6LBOMni56A2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1DvL7qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1DvL7qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC93C4CEE3;
	Fri,  7 Mar 2025 22:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387882;
	bh=B7URHTkgribsSq9UqZu7acujgL0QAKceIL8OQsE52i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1DvL7qEmH4UZszsFWOVNyCvIXCz4/Kqw6/bvJHwhm7rl77+UeJUCiuhkGUMmfT+u
	 VfE/vus06teSnySTKV9QMofH1AfGAWhdyi/WRf0nS8ynI37xT5U4r2b0X/TITMd/vT
	 f8SkCX/jWN0yDA6/y+sEfqRkcNg9JQSwpiPY4d1GoYt9fKQf033GIY6tvAVqznafLV
	 9r3tYlRaZSuU853tGgqptTz5POwtysKRXemzX9YGi3dq0oZYfEr/Z1OwtdSMeblBLq
	 JfzR/wQ3Fb5ViQVufwhEhZDk9yXWvFipcweK1slRlGwkpulLTDEFCNCng7UiGvUG0S
	 ZnTgirYd5NfAw==
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
Subject: [PATCH 6.12.y 17/60] Documentation: rust: discuss `#[expect(...)]` in the guidelines
Date: Fri,  7 Mar 2025 23:49:24 +0100
Message-ID: <20250307225008.779961-18-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 04866494e936d041fd196d3a36aecd979e4ef078 upstream.

Discuss `#[expect(...)]` in the Lints sections of the coding guidelines
document, which is an upcoming feature in Rust 1.81.0, and explain that
it is generally to be preferred over `allow` unless there is a reason
not to use it (e.g. conditional compilation being involved).

Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-19-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 110 +++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 6db0420f0cea..f7194f7124b0 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -262,6 +262,116 @@ default (i.e. outside ``W=`` levels). In particular, those that may have some
 false positives but that are otherwise quite useful to keep enabled to catch
 potential mistakes.
 
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
+
 For more information about diagnostics in Rust, please see:
 
 	https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html
-- 
2.48.1

