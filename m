Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C741D3594A;
	Mon, 20 Oct 2025 02:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760926065; cv=none; b=Ewmy5nd2Y0jXVSKhKB18pkr+aD4Z82o7480TbYeAoY8pxgJzP0/0tw2ufAk4Oq10iXaRmzsUpljVcYiYAOf1C3DNoV5rDppJT/y96Z1xBvAJl7te/Opn3xEkBuQoackzYHFQ5YBrtRe7PQ7PPnryqCdcjinDYe+cjCkB8WnMEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760926065; c=relaxed/simple;
	bh=rheH6Ia6DijJ7OprwEpFfSq6P7ogPSfbX6TYiHJYnvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lx/ybaole9BAG67XERRfTbpp3sjtpy4TzHIyE5Lr6zXaL6VLR5HeGi7d121lEpjsHKp0+p1LbXJgCZokXnUJK00yx+ztDAX9hYhOrbJhgNceTqxfQoJro4cD2dVWre1/4qtaxGAoLwzhKrlbVCYMzye6QJdYpg094UvQ1I6tikY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl4l2Izi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl4l2Izi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA61C4CEE7;
	Mon, 20 Oct 2025 02:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760926065;
	bh=rheH6Ia6DijJ7OprwEpFfSq6P7ogPSfbX6TYiHJYnvs=;
	h=From:To:Cc:Subject:Date:From;
	b=Kl4l2IziLW8kHFxHkhddlY0BAI82TlrFICtCwi6lmXdVXcmlXLYUJRdV6Ch2NxQgR
	 jg9eFTQc32ZOmnELADfLFrd+K3Wah/AUiJz5AhEzpZbhep8QXiVxpssLDQakUxUPIJ
	 zuv747Tvrex4uzl/DoqkMhJdaXEH7QY+WG3Bo+jqDfWfwAycM/ysxbiP5YnTK+gSM9
	 A0SXW9yKhu7L0UNfHhLTYRfADgUfeERZF2JOltNyOCfxDrKOAvxFjl6mdin2kUb+9f
	 NLVCLoql1vlvOkH9ocRWQunmc7EAtX3iIPWCT5MpUv2ItlmXsH36p2G2U1HkC3/Dn0
	 2QTLSJPV8jIBw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] objtool/rust: add one more `noreturn` Rust function
Date: Mon, 20 Oct 2025 04:07:14 +0200
Message-ID: <20251020020714.2511718-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Between Rust 1.79 and 1.86, under `CONFIG_RUST_KERNEL_DOCTESTS=y`,
`objtool` may report:

    rust/doctests_kernel_generated.o: warning: objtool:
    rust_doctest_kernel_alloc_kbox_rs_13() falls through to next
    function rust_doctest_kernel_alloc_kvec_rs_0()

(as well as in rust_doctest_kernel_alloc_kvec_rs_0) due to calls to the
`noreturn` symbol:

    core::option::expect_failed

from code added in commits 779db37373a3 ("rust: alloc: kvec: implement
AsPageIter for VVec") and 671618432f46 ("rust: alloc: kbox: implement
AsPageIter for VBox").

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

This can be reproduced as well in other versions by tweaking the code,
such as the latest stable Rust (1.90.0).

Stable does not have code that triggers this, but it could have it in
the future. Downstream forks could too. Thus tag it for backport.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index a5770570b106..3c7ab910b189 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -217,6 +217,7 @@ static bool is_rust_noreturn(const struct symbol *func)
 	 * these come from the Rust standard library).
 	 */
 	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
+	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||

base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
-- 
2.51.0

