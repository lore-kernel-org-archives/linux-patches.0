Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6780C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27313C433C1;
	Tue, 27 Sep 2022 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284614;
	bh=s/UljI70Vv0SGpL736mlm7zLImOyzf9iXSKvkaxCaWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M71Xih9AdmGtPValy28Q23Ca6NgekVQzhMigg1Aj8UAxzaoT8ukkN9ChNkGeL9vGO
	 tp/gA1EISSrr4KfuB1JNf6R1mq6a4s47uj2fcco1/C7DMwu1yAKGV/OlFsSTXlHeM7
	 R/RosiRymCLwE7eD4Vpu5EYZ3WW0VA73qFDTrFgWtkqzfWyBx2AKLXdl+GKhh49jY8
	 J/9wPWnmiqvU5Yn/Kccvb6uHXLB+IEtHNpWO97hxo4sizNrOXXRt7MGlb1YX1ry8UP
	 mbRoadQRczwVSL/A/kvt4tU+qfGqfeBbC9OmpvIvCVr+tmkWb3tyGy43jaYNJDDjDv
	 aC3XoGZ8bxFtQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH v10 13/27] rust: export generated symbols
Date: Tue, 27 Sep 2022 15:14:44 +0200
Message-Id: <20220927131518.30000-14-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

All symbols are reexported reusing the `EXPORT_SYMBOL_GPL` macro
from C. The lists of symbols are generated on the fly.

There are three main sets of symbols to distinguish:

  - The ones from the `core` and `alloc` crates (from the Rust
    standard library). The code is licensed as Apache/MIT.

  - The ones from our abstractions in the `kernel` crate.

  - The helpers (already exported since they are not generated).

We export everything as GPL. This ensures we do not mistakenly
expose GPL kernel symbols/features as non-GPL, even indirectly.

Reviewed-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Co-developed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Signed-off-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/exports.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 rust/exports.c

diff --git a/rust/exports.c b/rust/exports.c
new file mode 100644
index 000000000000..bb7cc64cecd0
--- /dev/null
+++ b/rust/exports.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A hack to export Rust symbols for loadable modules without having to redo
+ * the entire `include/linux/export.h` logic in Rust.
+ *
+ * This requires the Rust's new/future `v0` mangling scheme because the default
+ * one ("legacy") uses invalid characters for C identifiers (thus we cannot use
+ * the `EXPORT_SYMBOL_*` macros).
+ *
+ * All symbols are exported as GPL-only to guarantee no GPL-only feature is
+ * accidentally exposed.
+ */
+
+#include <linux/module.h>
+
+#define EXPORT_SYMBOL_RUST_GPL(sym) extern int sym; EXPORT_SYMBOL_GPL(sym)
+
+#include "exports_core_generated.h"
+#include "exports_alloc_generated.h"
+#include "exports_bindings_generated.h"
+#include "exports_kernel_generated.h"
-- 
2.37.3

