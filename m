Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDF11DFE36;
	Wed, 19 Feb 2025 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955124; cv=none; b=Mx/Eegjk7sHEUPa/jBRMJcwztL8f9JLtRRxJ6IhcbvoMD9ONofrlT2F9SEgteGPOl97GCQSN4bdI/sUUiDBsJESjLvQsicCJBX4VBDeJNkoGJ0xwg/ycfni9CZd0j78NhnS5+5DtTi1kUwKUjwJjsCAOqN4RXL2v20S/M+WRc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955124; c=relaxed/simple;
	bh=dGKO9lmtUK+t3OBap3R0ZsmUcIsM+EOabMkIZhHLzcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn3fShe31GbCz2LbeHjjLWBiSdccJ0JkJwdBtnTyoLBsXNt6aUrOAa9Chsl+TKjs+LF7sJObSo1wLYmY/JjNCjlGpsGDORjbXYgIUHYFRYzJWB5GT2ywTeurIGMuNQFymGATq3sD3c0QlmOomELMwERMrU1G7fnlCsuV+ss95ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFleBANy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFleBANy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FBAC4CEE6;
	Wed, 19 Feb 2025 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955123;
	bh=dGKO9lmtUK+t3OBap3R0ZsmUcIsM+EOabMkIZhHLzcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFleBANyJz5h0+Se8eUm5GmnoMhZJk47sCua4xwwZ+quQfHv905BXbwpgLOKpluzj
	 qlKLdMh5a08CAetbdmwthQuviP679GybkGnfxp1kXCdVWKWNWM3DXeJQmdlnWC7rGe
	 LymPBk4BsGbTFWpZw2XUU2TIHJWWhQV1WMZ9fcio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 140/230] objtool/rust: add one more `noreturn` Rust function
Date: Wed, 19 Feb 2025 09:27:37 +0100
Message-ID: <20250219082607.163091287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

commit cee6f9a9c87b6ecfb51845950c28216b231c3610 upstream.

Starting with Rust 1.85.0 (currently in beta, to be released 2025-02-20),
under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
one may trigger a new `objtool` warning:

    rust/kernel.o: warning: objtool: _R...securityNtB2_11SecurityCtx8as_bytes()
    falls through to next function _R...core3ops4drop4Drop4drop()

due to a call to the `noreturn` symbol:

    core::panicking::assert_failed::<usize, usize>

Thus add it to the list so that `objtool` knows it is actually `noreturn`.
Do so matching with `strstr` since it is a generic.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20250112143951.751139-1-ojeda@kernel.org
[ Updated Cc: stable@ to include 6.13.y. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -218,6 +218,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
+	       strstr(func->name, "_4core9panicking13assert_failed")					||
 	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
 	       (strstr(func->name, "_4core5slice5index24slice_") &&
 		str_ends_with(func->name, "_fail"));


