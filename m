Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B275210EA;
	Mon, 23 Oct 2023 17:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyGAgSue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FD6C433CC;
	Mon, 23 Oct 2023 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698083120;
	bh=Re17bBZBn8W2qRuHQlXyTmtDIB19+AtXrQhAAfpI4DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyGAgSueaNzo2buyhjpYs8BFDkw71EAY3dDuDfWlQX1WW1T/eDwWfl647Hy8XX9ak
	 25Ax5Z6fooNE0HiqEPYmVUZMt6pSxj7rZPUBN276iPeE0e9A6HMExAW0TMSdlW/392
	 P1uQFi50B1uK/j6g25zYKpc3uS2/1NmtL3OtxxFaBnd3oZPm16yaa0Hoc7o5/BVMoW
	 Gy9tMgL9+93O9oT7blV7sXNeAHq/nTGoOWqnN3hOSoNSSYxfsuTA8hMwxHg5rhcxt0
	 vqChJcINqPTg5Faw23BFxEU5MHMnViVOF4haSMVEqGLQVNT31ObDkKL/VIBA6hveuQ
	 2RAGIvKTuvz0Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	x86@kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/4] x86/rust: support SLS
Date: Mon, 23 Oct 2023 19:44:46 +0200
Message-ID: <20231023174449.251550-2-ojeda@kernel.org>
In-Reply-To: <20231023174449.251550-1-ojeda@kernel.org>
References: <20231023174449.251550-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support the `SLS` speculation mitigation by enabling the target features
that Clang does.

Without this, `objtool` would complain if enabled for individual object
files (like it is planned in the future), e.g.

    rust/core.o: warning: objtool:
    _R...next_up+0x44: missing int3 after ret

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/generate_rust_target.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 163089ae13ba..7e374369afca 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -165,6 +165,14 @@ fn main() {
             features += ",+retpoline-indirect-branches";
             features += ",+retpoline-indirect-calls";
         }
+        if cfg.has("SLS") {
+            // The kernel uses `-mharden-sls=all`, which Clang maps to both these target features in
+            // `clang/lib/Driver/ToolChains/Arch/X86.cpp`. These should be eventually enabled via
+            // `-Ctarget-feature` when `rustc` starts recognizing them (or via a new dedicated
+            // flag); see https://github.com/rust-lang/rust/issues/116851.
+            features += ",+harden-sls-ijmp";
+            features += ",+harden-sls-ret";
+        }
         ts.push("features", features);
         ts.push("llvm-target", "x86_64-linux-gnu");
         ts.push("target-pointer-width", "64");
-- 
2.42.0

