Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5D2329C42;
	Mon, 27 Oct 2025 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593087; cv=none; b=OHEHGQrG3Lixt0tva1UYiMQ32HSZSt/xx/vP3vxAlR/xP9n+t1fI7nV0eI3jUUrnOP78aHTNHLocDyYbRHIzym7NgYufymyo9UF2JCduJ4xzI/ayVXBmOcuJNZSb1WzTVZj4pYpQCdOzzLK8L0Qcl5cJX0eNzaXdqORD7fKsacE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593087; c=relaxed/simple;
	bh=2yuQJv/3oOXGTQHQriOfXh3ijHOwidr2jSMuVAwAZLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8+ooLQ5mq2zI0zwcQSR0azkmKEIknJwP4dNN/HXEMsek0xuDFKbM31DmKaZ6hMamgDZX92Sdxm7pGFwzlKgiRfF28PaleDmzIfd+4UGxzHGVcd0V5fimobEXqCxBfBlQDW6qLamINPdTUO6521YxDItkxbKpELuZoKGYH//MAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUYiK8HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUYiK8HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E660AC4CEFD;
	Mon, 27 Oct 2025 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593087;
	bh=2yuQJv/3oOXGTQHQriOfXh3ijHOwidr2jSMuVAwAZLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUYiK8HJalT441IvgrUxgs2INby1g7Mj2KeLdt/DOoUWcpMLNNdgBoU0TOZOqtLoO
	 fzkiEtHuVTVwOq+RxMTQQOdCOw1P4gJO6oZuvxCckZvTSBtvsLgcTA6GtxWsYa6Cux
	 Ft48odi9/8YMfVfGhI3v6PakikreVNVQQIq1lQ0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 105/117] objtool/rust: add one more `noreturn` Rust function
Date: Mon, 27 Oct 2025 19:37:11 +0100
Message-ID: <20251027183456.863829816@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
@@ -209,6 +209,7 @@ static bool is_rust_noreturn(const struc
 	 * these come from the Rust standard library).
 	 */
 	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
+	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||


