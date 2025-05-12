Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B72296FCE;
	Mon, 12 May 2025 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071977; cv=none; b=mVUMNzqBjyZLdHBrbigYKsZz/GeDvc6IkQThiMKKEsxLqb7fqNWNhxrA3Fv/yFRsiT/El3MF/3ppru2POl4+JTb95xRFANw6umtvYfIucI29YbkhcR43aHv3n1wuGCFvM2Kp3jCyCPSEWChHgPcRLXdD558U3U2nllieXeWzI7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071977; c=relaxed/simple;
	bh=GwjLfZISHdnOlmFgc6Po0Ea/HOmunbDY/auRauWaJvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+ZRMG0BwvSwNZ7zkHcy7Sn/mzWYSydrd0WQl3SrRZRQ+ZQXC5AY0gLuY73vV9z84G/FeqPFFRpMkmVtuWvklD8siNWOI3Ycz86DeY3QLCn95u68GEQG+6kjkZ0uTBCDAVWrilsPAaAIDxPlGDW9vIemQN7Gi8N8/TLvV46Es68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq4sC7lK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq4sC7lK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E00C4CEE9;
	Mon, 12 May 2025 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071975;
	bh=GwjLfZISHdnOlmFgc6Po0Ea/HOmunbDY/auRauWaJvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq4sC7lKn9htVsRhbGqsZOCPvWZTCEXoCWn3HfzKu4wjXd6I4hx827Jvy+hkHV/a8
	 xvVTBkzwtcK2ZIbsf5nduCaFoepgpUHl+rtznGe4xSedsQ9ddjoV0Fi/J35ZUQX1jF
	 Ft1zlF0tAOrrwvbDMt/ktdKT4Y5FMVnzKy52pRqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 066/197] objtool/rust: add one more `noreturn` Rust function for Rust 1.87.0
Date: Mon, 12 May 2025 19:38:36 +0200
Message-ID: <20250512172047.069281129@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 19f5ca461d5fc09bdf93a9f8e4bd78ed3a49dc71 upstream.

Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:

    rust/core.o: warning: objtool: _R..._4core9panicking9panic_fmt() falls
    through to next function _R..._4core9panicking18panic_nounwind_fmt()

    rust/core.o: warning: objtool: _R..._4core9panicking18panic_nounwind_fmt()
    falls through to next function _R..._4core9panicking5panic()

The reason is that `rust_begin_unwind` is now mangled:

    _R..._7___rustc17rust_begin_unwind

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Alternatively, we could remove the fixed one in `noreturn.h` and relax
this test to cover both, but it seems best to be strict as long as we can.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250502140237.1659624-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -228,6 +228,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
+	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
 	       (strstr(func->name, "_4core5slice5index24slice_") &&


