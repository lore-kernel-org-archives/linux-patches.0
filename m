Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C010308F3A;
	Mon, 27 Oct 2025 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593614; cv=none; b=SiW6uv53VvHN7DZLhTdMrAr8yi35FU6WD9l/ccLLTV+goBjzt5NDLOgeP04dIPcee07L5kmtwftHeIyOf6fxMM99xI2s0eZ1dEacj7uw1ZfQ7KB0Ct+u/A3EeGi+xagwytrK+58f44Uwv1cv6LsFlfj0os4Mxao2CqUdwlMJl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593614; c=relaxed/simple;
	bh=VDeRh82q6MwXQGb+yvRYIXGfZoHofi1aMAvydxC4rjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tz8lZVM/P2JACy0O1JBxuloBqrFBp8UhWJaiwAEcrXPyJQI/72clXrZgo9sfk2KyqkUKcuAtgZ31NWQLSa4WlWSJokzCPruR3l5FVt/eMMZkq6r2JBxl6flRLdbUs5CXVfVuoDiA5I55uiPqEjlP9/zoG/1m0ZxWehRLtitfHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8K/Tb3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8K/Tb3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CDDC4CEF1;
	Mon, 27 Oct 2025 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593614;
	bh=VDeRh82q6MwXQGb+yvRYIXGfZoHofi1aMAvydxC4rjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8K/Tb3CHUTrF7xPvrcYGOR2kR9lNejfy6MLFcDzxOO4F+oZXNPhBHO/w/mDKiITV
	 lT/dIAj+scckGIdJIeUb4shod3uVfrukZHbu8Jeilo9rmGcR3ZTVr6I/7m3PpWRfqu
	 v8GEH8VAxVmQv8/GKKzOJOnUY8X0DtQx4fZdow0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.17 160/184] objtool/rust: add one more `noreturn` Rust function
Date: Mon, 27 Oct 2025 19:37:22 +0100
Message-ID: <20251027183519.232661535@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit dbdf2a7feb422f9bacfd12774e624cf26f503eb0 upstream.

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

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
Link: https://patch.msgid.link/20251020020714.2511718-1-ojeda@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -217,6 +217,7 @@ static bool is_rust_noreturn(const struc
 	 * these come from the Rust standard library).
 	 */
 	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
+	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||


