Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476F380C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B7CC433D7;
	Tue, 27 Sep 2022 13:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284649;
	bh=FVapCLCMBFHoRGadwccT/R6zj9iqxDxY8mFOufu6k/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prAHLc750vnY4t9ZCgdqGMIYpFyZoa6GPpixK7E3xUYjkRjrASv6dEqpdvilkRk3G
	 wzY/QPzGQsaMWYftQ8vMJi5kXYpaWk2vrbZ4PBm7YBtEjs1krVTUQiRe7oqkOVyW92
	 HpmgEDKYS4I6KfLr4MEn3atGzQyDVgNF40V2UEpnxRuZPOcLJcH9J5k17VOOUELiw7
	 cYZZUCt7y7Pj8Tp2FWRmqiJ2DARJ0dr40TQi4NJnP0245O+KGnobon0IV0xrCVtxOg
	 4gdVHGDjTDZfbzFnt2HPHMzwjOD/32NX1cvI2tLztdccThdxnWrRTi45wduTsCUMAm
	 Lpimkv84GPNIw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Subject: [PATCH v10 21/27] scripts: add `is_rust_module.sh`
Date: Tue, 27 Sep 2022 15:14:52 +0200
Message-Id: <20220927131518.30000-22-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Xu <dxu@dxuuu.xyz>

This script is used to detect whether a kernel module is written
in Rust.

It will later be used to disable BTF generation on Rust modules as
BTF does not yet support Rust.

Reviewed-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/is_rust_module.sh | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100755 scripts/is_rust_module.sh

diff --git a/scripts/is_rust_module.sh b/scripts/is_rust_module.sh
new file mode 100755
index 000000000000..28b3831a7593
--- /dev/null
+++ b/scripts/is_rust_module.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# is_rust_module.sh module.ko
+#
+# Returns `0` if `module.ko` is a Rust module, `1` otherwise.
+
+set -e
+
+# Using the `16_` prefix ensures other symbols with the same substring
+# are not picked up (even if it would be unlikely). The last part is
+# used just in case LLVM decides to use the `.` suffix.
+#
+# In the future, checking for the `.comment` section may be another
+# option, see https://github.com/rust-lang/rust/pull/97550.
+${NM} "$*" | grep -qE '^[0-9a-fA-F]+ r _R[^[:space:]]+16___IS_RUST_MODULE[^[:space:]]*$'
-- 
2.37.3

