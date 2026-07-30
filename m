Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFED34D385;
	Thu, 30 Jul 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422820; cv=none; b=MLjInPWVN1VVA966E7EnJgkTldIZXqnt9GbKOAMIzRR4EGgaq4Zy8GD0sOZQFRiN+PYbXddKvBo1XxMl3H4IX4K+40MzjJJO47Dh5vWj8enhqwhEvhtDbHFSXpBKMxG0wdA4I2WPY0bLV55HNkbqyU5nd35fbqEtYQxDqQ+Im9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422820; c=relaxed/simple;
	bh=lTiuK1tQkOFYX4zI74IMcqTlYs9EWI/ACWTcH4ojOUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFwKxQA/ejnrDqgcwb7vWK1YDogclPnBbK/ZB5uodr5+B0csxW/vKJtmJFxG1cU5CaeoUt/CfPVn18Rcv11rxMOc/gCmYueAOU5uDTV1jj9WfetT/DdjbZUJblWNZM7nETPrROWYT47+2Enbjca0ARJ7QnlyvjP6IDdWur2sw6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDrJRsyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDrJRsyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858931F000E9;
	Thu, 30 Jul 2026 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422819;
	bh=RbZCoAr428q5lNLrjGi189sJJDIUrNjPPVg0eTlK1Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDrJRsyZUvPwSIRUvJjAfd3kD8ncArWYCOsQfdVfxedNM1+IGPdRYWsNiw1aIecLA
	 an4c++WXD3QBaclbwX71A3hxQ7mvN7G3Y44RXRhCztW2l6oKxnZZa9oaFOkBH/3qwh
	 yzy+ZmyzF4WaArlxmSZS31h2h31H8vGKaHzaJqAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 568/744] objtool/rust: add one more `noreturn` Rust function for Rust 1.99.0
Date: Thu, 30 Jul 2026 16:14:01 +0200
Message-ID: <20260730141456.359561252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 5a81c35c3b18cd59ded56171a6a9f643b92a6759 upstream.

Starting with Rust 1.99.0 (expected 2026-10-01), under
`CONFIG_RUST_DEBUG_ASSERTIONS=y`, `objtool` may report:

    rust/kernel.o: warning: objtool: _R..._6kernel12module_param9set_paramaEB4_()
    falls through to next function _R..._6kernel12module_param9set_paramhEB4_()

(and many others) due to calls to the `noreturn` symbol [1]:

    core::panicking::panic_null_reference_constructed

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Link: https://github.com/rust-lang/rust/pull/158796 [1]
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/rust-for-linux/alEBInX9gD1M5NAr@google.com/
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260710173252.191781-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -211,6 +211,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking18panic_nounwind_fmt")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
+	       str_ends_with(func->name, "_4core9panicking32panic_null_reference_constructed")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
 	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||


