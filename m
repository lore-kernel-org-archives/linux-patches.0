Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC60613B5B7;
	Thu, 25 Jul 2024 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721932526; cv=none; b=F/cc3EdRcDigPtet7cI4SOh5/R3fzX1qF23KogwmW+ruW+LPYCz3gEbUufngHjEvDNNKVb2g5yHSzqrGnC3WweQT/9EC1ufh2U//VfPf3ckOWcscmT6g0yuTKtkn1R3CiFYXrfr+JbMpzUfkAh8t5on02lKmQnpgzB3AJ/00zfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721932526; c=relaxed/simple;
	bh=X/CrvOwKkJQPjUg7k87bmhOZ9O/PNGGYuPcG1DD02wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9vqiButPrWM50K26zwJWcxneNsGWuEwIK1RreJxgNeKqSK6Tp2XMCu57mBLWax0LTTpeib+1I6r6QEQSjoxPlAdOdiGdeuccYBwIabx2FLaA5OxHffSOunQx61jqzEx13QgItOz3njcV4I1v8pBuOUWtkLVsfGv/9pxd4GStvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nr3/LVEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nr3/LVEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80487C32786;
	Thu, 25 Jul 2024 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721932525;
	bh=X/CrvOwKkJQPjUg7k87bmhOZ9O/PNGGYuPcG1DD02wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nr3/LVEby6a+yuOo/vjA/x87nIp9a8RRKG2EwFBe6w/6QYWjSQPLErwWQTtd+Tawe
	 cvQgBL04BNcQe6nH7wrnNCI27V/9tBsW7XbbkHPJzMTX7yO3NMHb29CRh503EaEp0M
	 gOvO5H2X9UJwFfqTwdKzPzaBxeWOuxF/VA9oOAIMUy5t0ah8NjWDvNHgqaCS6PRWBj
	 O0Lc9jKKiFalADuM3TAPdPnmkHzzIXNvZKGYyVz4DJZbtpGL/oMvcgoR9JtHdgeAgX
	 K4uLs8mOhFOHP+h33ERNp4n1DmQn+xPS/4Ja44XPubT6QexFkB6MEYkIXeMvTJBAb1
	 /U4QZhF2YzU+Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 4/6] x86/rust: support MITIGATION_SLS
Date: Thu, 25 Jul 2024 20:33:21 +0200
Message-ID: <20240725183325.122827-5-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-1-ojeda@kernel.org>
References: <20240725183325.122827-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support `MITIGATION_SLS` by enabling the target features that Clang does.

Without this, `objtool` would complain if enabled for Rust, e.g.:

    rust/core.o: warning: objtool:
    _R...next_up+0x44: missing int3 after ret

These should be eventually enabled via `-Ctarget-feature` when `rustc`
starts recognizing them (or via a new dedicated flag) [1].

Link: https://github.com/rust-lang/rust/issues/116851 [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/generate_rust_target.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 44952f0a3aac..ba1bd455e160 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -173,6 +173,14 @@ fn main() {
             features += ",+retpoline-indirect-branches";
             features += ",+retpoline-indirect-calls";
         }
+        if cfg.has("MITIGATION_SLS") {
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
2.45.2

