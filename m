Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A098374A0E;
	Thu, 30 Jul 2026 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424657; cv=none; b=IJIiiLfgzlhuykxHqG+/WWg6Tx2gPxLnefINBdgpKKXhGpISRBvFp8/N/e0Ubsil+ZjLoo39wS4LGqxemugXgQzrQMIAQzq/iJN63GwB5CAQ1KdHDPpGDtq3UrlZz+F12rbnXBglySXQBo47j/4e81Gpw1sxH9n1u5oykZB7Llk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424657; c=relaxed/simple;
	bh=70ayXsg4TO6Qab00+mHQvB15bK8R+hLqZzRotn7hBSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afntFg2gL9vO1vApVAclvn6MbWoMk8JBTeo9PO/k7sAUycNavjKnKxK4wEZ1p0miuRtFy0QyLWP+e0tkhFQLDyKhEWOgNiTrub4JS7F2+JPB6T+FhrbOUKGMDfJHyUMm4U0Al907ZdDUJ45VuyL34Zy4umxrssi7Ig9Gxugfkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtVpVb7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtVpVb7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6596B1F00A3F;
	Thu, 30 Jul 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424654;
	bh=hN4EqnJMBWirv19DS8mP7/gsRCdMmAuQqDKlj3Efm7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtVpVb7SSX8TGLV9kIoxTulBO3QngPdjAfjYm7lfgMHSwLBonmOZusjeDtmNJ1LGj
	 qnjZhou1ZXo5Y35Bx0Z5kEgxajHj3ftOkhvXVPPa2KTSz5ETOZTaI3azrTQXYntHcA
	 WFFr+MfwnSrhOlsG6dEkXAn0vb7XyPUf4+37no7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 6.18 471/675] rust: allow `clippy::unwrap_or_default` globally
Date: Thu, 30 Jul 2026 16:13:21 +0200
Message-ID: <20260730141455.139143887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,6 +470,10 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 
 # These flags apply to all Rust code in the tree, including the kernel and
 # host programs.
+#
+# `-Aclippy::unwrap_or_default`: the lint is buggy [1] and ignores our
+# MSRV. It can trigger depending on the optimization level.
+# [1] https://github.com/rust-lang/rust-clippy/issues/17379
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
@@ -497,6 +501,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::uninlined_format_args \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
+			    -Aclippy::unwrap_or_default \
 			    -Wrustdoc::missing_crate_level_docs \
 			    -Wrustdoc::unescaped_backticks
 


