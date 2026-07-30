Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A839DBFD;
	Thu, 30 Jul 2026 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422817; cv=none; b=lwGYfR+rShHzByHyiB3i+Ze7ZYi97OWwngDcW0O/qzlaeykZdhOlIhiFrVMIGnCJUy67/l34nFNRDKqbIVT0+N0z9RPZwIq//0oyIJmjv2z/BiBdrN2kPngaUHn/gA05eCPRImCKphpA9mhWbzEnNKygOblx86O671LmQ0ryuyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422817; c=relaxed/simple;
	bh=HJDJgfvSL2pVS5BcB/CEEtBOkBcrBiWJBFoGsiQkv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kmwx7ZWlm8foI34GCDrGa3n5UkAvv3BwUkCcf4Bf6Skw3Tz5oRhSga4vkINVMNgx0igMiFtUT9swBlLMx2mVkwpF0ZM08MCVcwDBuHgACl5auhjynXtigpQbKFCHqbXiwqRzLFq0gv7laz4D+/9pJ5eddI9YZNEDcC9Tr+ckjyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqDEqqUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqDEqqUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF2C1F000E9;
	Thu, 30 Jul 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422816;
	bh=IIqZz0XggTbbiKg2Jn6mpDDfqdYIwoihRPiYRTqeH1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqDEqqUkqPCEjSqVdxoocG57QDuhu4jz8nQJ/tPmu3QpH+qK/YIo2Ju1TitAi/Emb
	 /ooIefuvh86FLiJzcgvjhYCXVasLX2WXbfih3v9ANSLEl9uM1l35s9xAjJVJtNq+U3
	 EX8+BlxYNQ2K9RwO6/j6ZQV+tLTBtBLn0AMaTp1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 7.1 567/744] rust: allow `clippy::unwrap_or_default` globally
Date: Thu, 30 Jul 2026 16:14:00 +0200
Message-ID: <20260730141456.338416355@linuxfoundation.org>
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
@@ -473,6 +473,10 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 
 # These flags apply to all Rust code in the tree, including the kernel and
 # host programs.
+#
+# `-Aclippy::unwrap_or_default`: the lint is buggy [1] and ignores our
+# MSRV. It can trigger depending on the optimization level.
+# [1] https://github.com/rust-lang/rust-clippy/issues/17379
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
@@ -501,6 +505,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::uninlined_format_args \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
+			    -Aclippy::unwrap_or_default \
 			    -Wrustdoc::missing_crate_level_docs \
 			    -Wrustdoc::unescaped_backticks
 


