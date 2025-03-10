Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1E17C225;
	Mon, 10 Mar 2025 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627136; cv=none; b=uLUKBuzHLZHn4L3xvnegiD4cp24u4fseBCqlbgit0BkC/AoHpm9WeV8DdrK3KFkdATI2fl3acsHWCduoBjT1DsgbR0CMYpXh2cIq0+3nALlV7eDWNFIIhUx4wpdYanoLIGP99aHCy2doaslg23KwIHO+lammnUrvw40LFqJ1vuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627136; c=relaxed/simple;
	bh=3iNAaUYmsVTdJEjn2UJFYBot5mSeFlU4iAzpuvK1IM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOjkX7RFRE6MAxHlSX4udfCNPq6LfDirBUwPcmbgJZnD8Evm61wNppD0arax9NyCNuW/+xHdwToADi/SUQYB7fxCs75dMPOueHJhscslxfLqestinf4MREdK+0o4TU0DTmM7O4n7yxfB5NA2j9QaQvFE2TkQqWztx+q/hulH7O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBd0p4RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBd0p4RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3802C4CEE5;
	Mon, 10 Mar 2025 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627136;
	bh=3iNAaUYmsVTdJEjn2UJFYBot5mSeFlU4iAzpuvK1IM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBd0p4RL5cyeiLtDkwVigfkVlYqbt5OCrx4uLhYRX16jpXUVxMZoBGPIcpA0u0WLH
	 a0Tr6iGWL/PSLev2GdY7Dylcj38qbk6EuiJ8Qeu+l/ryVkzuqRVuxd92bGdGVY6Osj
	 njGcPtNuIX4RgG83tnxsMUuozNwxUF5MqxIhV0NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 026/269] Documentation: rust: add coding guidelines on lints
Date: Mon, 10 Mar 2025 18:02:59 +0100
Message-ID: <20250310170458.755854861@linuxfoundation.org>
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

commit 139d396572ec4ba6e8cc5c02f5c8d5d1139be4b7 upstream.

In the C side, disabling diagnostics locally, i.e. within the source code,
is rare (at least in the kernel). Sometimes warnings are manipulated
via the flags at the translation unit level, but that is about it.

In Rust, it is easier to change locally the "level" of lints
(e.g. allowing them locally). In turn, this means it is easier to
globally enable more lints that may trigger a few false positives here
and there that need to be allowed locally, but that generally can spot
issues or bugs.

Thus document this.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-17-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/coding-guidelines.rst |   38 +++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -227,3 +227,41 @@ The equivalent in Rust may look like (ig
 That is, the equivalent of ``GPIO_LINE_DIRECTION_IN`` would be referred to as
 ``gpio::LineDirection::In``. In particular, it should not be named
 ``gpio::gpio_line_direction::GPIO_LINE_DIRECTION_IN``.
+
+
+Lints
+-----
+
+In Rust, it is possible to ``allow`` particular warnings (diagnostics, lints)
+locally, making the compiler ignore instances of a given warning within a given
+function, module, block, etc.
+
+It is similar to ``#pragma GCC diagnostic push`` + ``ignored`` + ``pop`` in C
+[#]_:
+
+.. code-block:: c
+
+	#pragma GCC diagnostic push
+	#pragma GCC diagnostic ignored "-Wunused-function"
+	static void f(void) {}
+	#pragma GCC diagnostic pop
+
+.. [#] In this particular case, the kernel's ``__{always,maybe}_unused``
+       attributes (C23's ``[[maybe_unused]]``) may be used; however, the example
+       is meant to reflect the equivalent lint in Rust discussed afterwards.
+
+But way less verbose:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn f() {}
+
+By that virtue, it makes it possible to comfortably enable more diagnostics by
+default (i.e. outside ``W=`` levels). In particular, those that may have some
+false positives but that are otherwise quite useful to keep enabled to catch
+potential mistakes.
+
+For more information about diagnostics in Rust, please see:
+
+	https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html


