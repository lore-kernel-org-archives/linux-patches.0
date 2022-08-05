Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F201C03
	for <patches@lists.linux.dev>; Fri,  5 Aug 2022 15:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B529C433D6;
	Fri,  5 Aug 2022 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1659714266;
	bh=5Jb5dRbpZh0rUGsjuxSpsmEeXQf/l3SF0NEHYaTvdmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDO+Dz1RO+EM400WnQiYu+aJHutW9+Yxo4ZrNySoyZNvFgpEUSqr/HotwdH2MPK0W
	 5AQl1Mh/l0NCW0bbKIHFaMff+K6dKNZ7gCwawZcbp86fZgOoMkmLYe6Ue4ywXRWIhI
	 eYC2FAg6VWV0JZ9BsutOh6pJdwPPGV0aNVAIdxoyxBCz7ocnQ5ChvYFIigTNXIdbLr
	 Fl8LFCFVeNhaQr36EZdPEgq/tZ1q4dQOvIfnd+aVSGfMhWe5j1EviSUPcRFJMPAtIk
	 WO1s042of/fjcHyuZUWoNcm4olhv8gkF5F8oWmgx92ltIasj+3zG4BGPUAbEtkog3r
	 ZKzM47n495h7Q==
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
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Subject: [PATCH v9 21/27] scripts: add `is_rust_module.sh`
Date: Fri,  5 Aug 2022 17:42:06 +0200
Message-Id: <20220805154231.31257-22-ojeda@kernel.org>
In-Reply-To: <20220805154231.31257-1-ojeda@kernel.org>
References: <20220805154231.31257-1-ojeda@kernel.org>
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
2.37.1

