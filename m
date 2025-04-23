Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3E27EC73;
	Wed, 23 Apr 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420487; cv=none; b=YzlF3uhsWeHMz0NbxMU4tBZKv8aLi7X92HaocmhMfG8B6APgnSpu8SvJdVs3fdhP9EON7VN38GQ8q9InV4k2FF2aMiHmCntqMD/RdaZvBhCeTs/1VOZG11nVFX+Kl0Whj3fyp40O8gk3okUiTtzbh7uEN+XvK08QbLQ64zke8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420487; c=relaxed/simple;
	bh=BwJBH+tSds1vhSiRQ/i/jQ64sQPJPJ83i1wWSMSykhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv+dI9uCoZ+g4d/9kQg+1x2EBxbEDkuXLbd0Q1JAsiyyNK5Pp8C0eZ0eWPAlssDmnhf/UJo3MB9lflWxlPlR2sgjfsYg7CYyIqmtCQ3a8CtqC2SDGqlGsX1u/Hc0WsVtAukJL6Oh/XqJZPCcCTSUoTOIGPPME7uXcR2r/fTnimo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wz9Se6Z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wz9Se6Z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3910DC4CEE2;
	Wed, 23 Apr 2025 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420487;
	bh=BwJBH+tSds1vhSiRQ/i/jQ64sQPJPJ83i1wWSMSykhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz9Se6Z5YPuL6OQJ4IdIvXYzQ99ejZK9t4ibHp7DaBh9lHEe5JFXZsdlBphR+lI7J
	 PwoNKe2Ud7+vtUbVhldKs2Xi0nGEPfAgMlAXD7zwm/srJPxBD/og7JIJxRsp0n9ZMq
	 psGxnZVghTnqkuef1nixZsBKp5sBjiEox+1h8nM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 096/241] objtool/rust: add one more `noreturn` Rust function for Rust 1.86.0
Date: Wed, 23 Apr 2025 16:42:40 +0200
Message-ID: <20250423142624.501434674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

commit a3cd5f507b72c0532c3345b6913557efab34f405 upstream.

Starting with Rust 1.86.0 (see upstream commit b151b513ba2b ("Insert null
checks for pointer dereferences when debug assertions are enabled") [1]),
under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
one may trigger a new `objtool` warning:

    rust/kernel.o: warning: objtool: _R..._6kernel9workqueue6system()
    falls through to next function _R...9workqueue14system_highpri()

due to a call to the `noreturn` symbol:

    core::panicking::panic_null_pointer_dereference

Thus add it to the list so that `objtool` knows it is actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
Link: https://github.com/rust-lang/rust/commit/b151b513ba2b65c7506ec1a80f2712bbd09154d1 [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250413002338.1741593-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -226,6 +226,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking14panic_nounwind")				||
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
+	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
 	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||


