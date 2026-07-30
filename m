Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4760F3E0091;
	Thu, 30 Jul 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426276; cv=none; b=NsinI8d/zHyBKhzhOGL+bvwbYza9iSsI/7jA1Vlr+LDFl1aavWtXw3CWIjU6/d8p8t4N3uSksyF7F3JYpv1Nm5SuKZ91S9EmlYIO0nqRf6HrvuWeMIOM9ADIZL/EtWLsIbcLbkKdzDHbb4sRTIBGLe0+D19Fx3UkjH4Mub002Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426276; c=relaxed/simple;
	bh=ozMbhZFlzkFCA5GXCWYqssaNTRZU/vSP2W7Nozm8Hl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLbpGWOdoWdaOMz0IHMouJTtCSf8KvVGehDqvx2EOqcZzr0Av7s10nnztivtFAaoPByG3uX4v2fIXZWNHUhuFrkmPkUxGH1BsO3evYanejFJ6CZyXzVGn4Za/Mu8UUblRX/ooRtRL3TAGdtHQ2pv4qHSAuuOqyyR1V+G8oWLXAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4Tios56; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4Tios56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0F91F000E9;
	Thu, 30 Jul 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426275;
	bh=MpmrtMwkZeUlE/A+VERU1Mxsmvdz2b71ycC2FSFlZb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4Tios56FJV8zb5GcBHOT5tFJ0bLE/W2YH6ZHkw3DsPs0oHAk+YL+XcFhNJfBTV17
	 KxhzkaHvwuxHZ/7r7VO/3ygXpL4XkuiMVjeV2HYst8B3c3eA85nPsTyXVKiBQpxTC2
	 S58NQCaJAEU+StqYfcVvphYISmI97epzWa6WZM9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 361/602] objtool/rust: add one more `noreturn` Rust function for Rust 1.99.0
Date: Thu, 30 Jul 2026 16:12:33 +0200
Message-ID: <20260730141443.546105966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -220,6 +220,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking18panic_nounwind_fmt")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
+	       str_ends_with(func->name, "_4core9panicking32panic_null_reference_constructed")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
 	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||


