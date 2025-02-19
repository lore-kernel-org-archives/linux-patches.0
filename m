Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AB11DE2D8;
	Wed, 19 Feb 2025 08:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954304; cv=none; b=pnUav2eEfjJ3o1V8Mupvf8gss1Wa9ZGwQhsPT9+YOcydyq8m042vTbIc4TSRyTY6vUWeqarWtiHlGiubcHIquSL1L6OF3ny0zEjULJeEid/T63ZfTO2qpOYmNoEnBSFfep9KgL2VAsTupO9OaJfcYIRihyXkQYeGavaxRIURBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954304; c=relaxed/simple;
	bh=Bq5tmamhAFQiOssS/cruO3gYFpsgc3B4GJX0qJLzxZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQvOTnuH7A9PeNG4dkZIAeLbyCrlaURjyIdLburFMt8xtn4Ub9SWbR/0egk207vBc1JnKwBGtJdDP8f/hMry4M0z3MLFi9j/3+l7eUUyqZkSlppVW/fjuHS1pi5AlqXbgxnWUgBlgnroDKCcAPsVvc1motox51BlLwgwEW9JtYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxDFBLfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxDFBLfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76677C4CED1;
	Wed, 19 Feb 2025 08:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954302;
	bh=Bq5tmamhAFQiOssS/cruO3gYFpsgc3B4GJX0qJLzxZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxDFBLfGw7xBK63hItT+3E3Z/7TWoz3L/O20eceDHtfCjsR3HmReThavvKmO47d/u
	 0NlOQ747j4LUpAVLhbOw7zB50vcqjzzvgTnP7nny8YwJPJbtngmJj5tVaSjsHMQgA0
	 RSBuC8AlxduXjlUbCcUDt/DBdcRjszGQrh1Cjf/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 161/274] objtool/rust: add one more `noreturn` Rust function
Date: Wed, 19 Feb 2025 09:26:55 +0100
Message-ID: <20250219082615.896623240@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


