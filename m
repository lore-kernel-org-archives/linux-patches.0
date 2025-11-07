Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FFA1DA60D;
	Fri,  7 Nov 2025 05:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762491874; cv=none; b=eUeMGwdLRHLhI9axjolw3AyAzf58i1eP+Rw3kff8oMx7zUHtADmNliPdlFspI5y25VL3kRfNVAdK50ARdlX7lKK+nh+Gi1aaw9oFczZwpcflcogUfa+NU78hC0SVquBUgpWHfRSgy3NM0nMxqjTuGkjBy7OH5MS+mIRgLiSzuAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762491874; c=relaxed/simple;
	bh=WkgmRKdKxCnzs6d1MwMyzQnG3gLzUtUwssTUT4PokGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qpev0v/aJEASVMl8SF8DHwxj1+XeNunSz9zFgn2fLUSVJCf+CwUD10mBLrUJWys5kxQWBDu5ThxXfR8SGEZlhEylLyI5opYpYxhGD4GVhBOM6pvy27NIWFFtgTNWS67vy2NfWpI2/Px1k5wCKH5fZ1MYqHbwJXcGV47NOHN7GMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiU4b06q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiU4b06q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89C0C116B1;
	Fri,  7 Nov 2025 05:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762491873;
	bh=WkgmRKdKxCnzs6d1MwMyzQnG3gLzUtUwssTUT4PokGQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZiU4b06q1u0P6OmRIk9yoMM1wLEoGeW6RaAgUjMmQC8WaTPM75XUsr5g7LPt00qGj
	 xgeOvqi5kH8EJQvGJi8xyrAjUcT5JUMypHeiGgXvRNw9oy1nVsmMVnyXRJN4I+ly9l
	 etwX3wOr0InWpuPHfNMJhKeIy7QLWkeydVkD9M7DQMksFtmb+X9+EIUxKXiRIKjD+7
	 ZsBpyL1QF0QQmHTjxSVRkR/TyKUGVuH57RryrDMo3JxuAXcBMu0Y0QYvAuOE4YnYK2
	 uX/GPYGh3xF1o/P80r6GavZLQRZU3YlWs2x8iPv66z3nE15I7/ZcNZbJMMNCGlPZqt
	 Hz70n9JCToBzw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] kallsyms: fix symbol type for "big" symbols
Date: Fri,  7 Nov 2025 06:04:14 +0100
Message-ID: <20251107050414.511648-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`kallsyms_get_symbol_type()` does not take into account the potential
extra byte for "big" symbols.

This makes `/proc/kallsyms` output the wrong symbol type for such "big"
symbols, such as a bogus `1` symbol type, which in turn confused other
tooling [1].

Thus fix it.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CANiq72ns1sRukpX-4L3FgqfJw4nXZ5AyqQKCEeQ=nhyERG7QGA@mail.gmail.com/
Fixes: 73bbb94466fd ("kallsyms: support "big" kernel symbols")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Somehow this went unnoticed so far... In Fedora 42 I compared the
System.map with `/proc/kallsyms` and that was the only symbol with a
different type -- Arnaldo, could you please confirm this makes it go
away for you? Thanks!

 kernel/kallsyms.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 1e7635864124..4f9b612d6bf2 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -101,11 +101,21 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
  */
 static char kallsyms_get_symbol_type(unsigned int off)
 {
+	const u8 len = kallsyms_names[off];
+
+	off++;
+
+	/*
+	 * If MSB is 1, it is a "big" symbol, so we need to skip two bytes.
+	 */
+	if ((len & 0x80) != 0)
+		off++;
+
 	/*
 	 * Get just the first code, look it up in the token table,
 	 * and return the first char from this token.
 	 */
-	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
+	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off]]];
 }



base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
--
2.51.2
