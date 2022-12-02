Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46304C71
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 16:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E44DC433D6;
	Fri,  2 Dec 2022 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669997740;
	bh=4UfoqML4L3IukWfvADvLkrtuQak85Ze14tDrzQ5hdwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBYta338nXNnuzZG7GDNq9PFxhM/cX92DH2AzsBGFI4iTieKuu1DUqzMRXV+nPWx5
	 7R/fiPYF8cjZQY36+UqacdBwgSgQQg8aQPTpxZ81tcSCjr4EUnhk3eo4ZZH9zDCkK+
	 2o9va6KpTYjHgLKtiqZX8PwfW8wL5dc6ZsRkqTeyqU0fEC6mNzgZrod0nhUCv3WHrJ
	 keudAiAD7Yx7UHhrOkYIUuYwdwQV+NaM+BFydjaZSSLC4hm0c/dQ0x97GqrkVCjo+K
	 4ZdmEA4t2NyS9PXASMMZYYPSd/cAu1gKw747T1i81cuvJX3084NFbeAAD2SyY0jlCC
	 GFTdyIQCe2oqQ==
From: ojeda@kernel.org
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Wei Liu <wei.liu@kernel.org>,
	=?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= <sergio.collado@gmail.com>
Subject: [PATCH v2 04/28] rust: samples: add `rust_print` example
Date: Fri,  2 Dec 2022 17:14:35 +0100
Message-Id: <20221202161502.385525-5-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miguel Ojeda <ojeda@kernel.org>

Add example to exercise the printing macros (`pr_*!`) introduced
in the previous patches.

Reviewed-by: Finn Behrens <me@kloenk.dev>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Tested-by: Sergio González Collado <sergio.collado@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 samples/rust/Kconfig       | 10 +++++++
 samples/rust/Makefile      |  1 +
 samples/rust/rust_print.rs | 54 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)
 create mode 100644 samples/rust/rust_print.rs

diff --git a/samples/rust/Kconfig b/samples/rust/Kconfig
index 841e0906e943..b0f74a81c8f9 100644
--- a/samples/rust/Kconfig
+++ b/samples/rust/Kconfig
@@ -20,6 +20,16 @@ config SAMPLE_RUST_MINIMAL
 
 	  If unsure, say N.
 
+config SAMPLE_RUST_PRINT
+	tristate "Printing macros"
+	help
+	  This option builds the Rust printing macros sample.
+
+	  To compile this as a module, choose M here:
+	  the module will be called rust_print.
+
+	  If unsure, say N.
+
 config SAMPLE_RUST_HOSTPROGS
 	bool "Host programs"
 	help
diff --git a/samples/rust/Makefile b/samples/rust/Makefile
index 1daba5f8658a..03086dabbea4 100644
--- a/samples/rust/Makefile
+++ b/samples/rust/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_SAMPLE_RUST_MINIMAL)		+= rust_minimal.o
+obj-$(CONFIG_SAMPLE_RUST_PRINT)			+= rust_print.o
 
 subdir-$(CONFIG_SAMPLE_RUST_HOSTPROGS)		+= hostprogs
diff --git a/samples/rust/rust_print.rs b/samples/rust/rust_print.rs
new file mode 100644
index 000000000000..09f737790f3f
--- /dev/null
+++ b/samples/rust/rust_print.rs
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Rust printing macros sample.
+
+use kernel::pr_cont;
+use kernel::prelude::*;
+
+module! {
+    type: RustPrint,
+    name: b"rust_print",
+    author: b"Rust for Linux Contributors",
+    description: b"Rust printing macros sample",
+    license: b"GPL",
+}
+
+struct RustPrint;
+
+impl kernel::Module for RustPrint {
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        pr_info!("Rust printing macros sample (init)\n");
+
+        pr_emerg!("Emergency message (level 0) without args\n");
+        pr_alert!("Alert message (level 1) without args\n");
+        pr_crit!("Critical message (level 2) without args\n");
+        pr_err!("Error message (level 3) without args\n");
+        pr_warn!("Warning message (level 4) without args\n");
+        pr_notice!("Notice message (level 5) without args\n");
+        pr_info!("Info message (level 6) without args\n");
+
+        pr_info!("A line that");
+        pr_cont!(" is continued");
+        pr_cont!(" without args\n");
+
+        pr_emerg!("{} message (level {}) with args\n", "Emergency", 0);
+        pr_alert!("{} message (level {}) with args\n", "Alert", 1);
+        pr_crit!("{} message (level {}) with args\n", "Critical", 2);
+        pr_err!("{} message (level {}) with args\n", "Error", 3);
+        pr_warn!("{} message (level {}) with args\n", "Warning", 4);
+        pr_notice!("{} message (level {}) with args\n", "Notice", 5);
+        pr_info!("{} message (level {}) with args\n", "Info", 6);
+
+        pr_info!("A {} that", "line");
+        pr_cont!(" is {}", "continued");
+        pr_cont!(" with {}\n", "args");
+
+        Ok(RustPrint)
+    }
+}
+
+impl Drop for RustPrint {
+    fn drop(&mut self) {
+        pr_info!("Rust printing macros sample (exit)\n");
+    }
+}
-- 
2.38.1

