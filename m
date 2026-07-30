Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E583E0091;
	Thu, 30 Jul 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426273; cv=none; b=eWaxfnkokCZ5mb/GBO/1/G+XFgZMQPAEcSbCd6btXhN5taPM9mVXLuBEDLHq8WeiREUpM+vtlKqfgTR8mfpAof5iq1o0lCN1BkCM3lUPXm8CyJeYpNAgGz6tlKAZsVTb/Oj0hPKKleZ8HFSyt8Yl8c5aOfKqkTFwxxcLqjdjbs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426273; c=relaxed/simple;
	bh=Sa/4GFh3SFzAaQ0djm3JTlA4Sp2JTKdnzBBD58YbK6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlO+MzRsxV8ugEXZ2WXixlFUhOt+37vn3+9A8qibYagrJol742YIMjKsfaDgJAfAIEoUwF8DJf/5uRPnxCAwjA9e62lsGloDlKkunFmYLIgSleTxEljGlGUFdN/gtg9+VIe7IWDJQFT66uJQwOPinyC5zXjk5cFdIwYijsfdRbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXqezeCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXqezeCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70391F000E9;
	Thu, 30 Jul 2026 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426272;
	bh=zOishNM+V8LtS8D4JuiIKdk3OlYS1fF6BiW+hMWlH7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXqezeCI3sTypqWlXden7O4DMZWG3jl+86XVXlF8Om2CSxvQyoJqhrxrq42bGuquA
	 F5N5QDseyx96IqCv3djl7FOnTi3VvyknaAxELYKa1iHACq34MF96QmPkxYFZKv4PH9
	 UxPlfPsoJFQ3zBl0vDMdL6Kr6idwiM7sCrdrAIMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 6.12 360/602] rust: allow `clippy::unwrap_or_default` globally
Date: Thu, 30 Jul 2026 16:12:32 +0200
Message-ID: <20260730141443.525331235@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

commit 4688cf884b3abcd12498e03b625d1916bf49a1e4 upstream.

Starting with rustc 1.88, the `clippy::unwrap_or_default` lint triggers
on `rust/kernel/soc.rs` if `CONFIG_CC_OPTIMIZE_FOR_SIZE=y`:

    warning: use of `unwrap_or` to construct default value
      --> ../rust/kernel/soc.rs:66:10
      |
   66 |         .unwrap_or(core::ptr::null())
      |          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: try: `unwrap_or_default()`

This is a clippy bug [1]: the lint decides whether an expression is
equivalent to `Default::default()` by inspecting the optimized MIR of
`<*const T as Default>::default` exported by `core`, so its outcome
depends on the optimization level `core` was built with. Moreover, its
suggestion ignores our MSRV of 1.85 (`Default` for `*const T` is only
stable since Rust 1.88), so we could not apply it anyway.

Disable the lint globally rather than working around this single
occurrence; it can be re-enabled conditionally using `rustc-min-version`
once clippy is fixed.

Link: https://github.com/rust-lang/rust-clippy/issues/17379 [1]
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://patch.msgid.link/20260708-soc_unwrap_or-v2-1-007ed724cc7b@nvidia.com
[ Moved to non-versioned group. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -443,6 +443,10 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 
 # These flags apply to all Rust code in the tree, including the kernel and
 # host programs.
+#
+# `-Aclippy::unwrap_or_default`: the lint is buggy [1] and ignores our
+# MSRV. It can trigger depending on the optimization level.
+# [1] https://github.com/rust-lang/rust-clippy/issues/17379
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
@@ -464,6 +468,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::uninlined_format_args \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
+			    -Aclippy::unwrap_or_default \
 			    -Wrustdoc::missing_crate_level_docs \
 			    -Wrustdoc::unescaped_backticks
 


