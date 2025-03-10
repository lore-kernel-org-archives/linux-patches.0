Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2A2309B0;
	Mon, 10 Mar 2025 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627145; cv=none; b=FFcrjRL8icTNHCJZloypPuCQUkl6DIFmgqlUz0aJ5z8ZFzgXfvF/KmxjCzmZZf3gMXpmPappqKVqqgufTy2E+uCief5bXnZb8Mb+NPhK9kJXsBhLNsN6K0WkuAI3igKcLPLMVjhoVZbqsZp4gAx9r9dJV8TZcY7x8oL5EqE7Qfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627145; c=relaxed/simple;
	bh=TcPFJQ+VszTwiw3lLDgFtgubYcZbfZV9g0X7zSQgR4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2bVPDMT742eGPAbcJ0UJnkT9qztm1OFgWMENj5+S6QHw1+bP0orJoRTAGe96oBQynB2oRtFbvKUeaIs40kf8RljiT36e59+uzfRJ0I76lquU8HNW4mlBId6FGLDiSmONOJsPEnQ06yXtLuEJP31qfLI7rtDg+8/M0g+5VsAXB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beUkbYpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beUkbYpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73830C4CEE5;
	Mon, 10 Mar 2025 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627144;
	bh=TcPFJQ+VszTwiw3lLDgFtgubYcZbfZV9g0X7zSQgR4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beUkbYpLoc8tfSqIVM21q1Yo7vD75n8YvF7CggjqZPb6suoSD4hn+6Bx0QDT7gd2F
	 XZW6hzMiT0RcHpcbO1Uk5L1JIdctFKRdfQgHqj+smamHOJgLwD+gKbFo6SmWDq3TGP
	 2WOtALR0VfnP5g41601TFu2XC2f++CJw1CBnBzGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 028/269] Documentation: rust: discuss `#[expect(...)]` in the guidelines
Date: Mon, 10 Mar 2025 18:03:01 +0100
Message-ID: <20250310170458.834986172@linuxfoundation.org>
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

commit 04866494e936d041fd196d3a36aecd979e4ef078 upstream.

Discuss `#[expect(...)]` in the Lints sections of the coding guidelines
document, which is an upcoming feature in Rust 1.81.0, and explain that
it is generally to be preferred over `allow` unless there is a reason
not to use it (e.g. conditional compilation being involved).

Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-19-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/coding-guidelines.rst |  110 +++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -262,6 +262,116 @@ default (i.e. outside ``W=`` levels). In
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


