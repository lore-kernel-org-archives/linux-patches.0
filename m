Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862DB15E5DC;
	Wed, 24 Jul 2024 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837741; cv=none; b=qM+GyMwtg2PaeWchs7hS2XVtkkIkzUl+NVe8EH1g2902Q61EXS7HojhAAKRrKaRhTTuxDAU3SoEawb9xuYzCFtrc5x50UQkPjy2Oz9Qr9yEbGUIwZVQhGFqEGdEiWYTc7IH2c6O/j2OPhSCQ+d2sSMH30bdNGDbbkaD8c/Xj/wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837741; c=relaxed/simple;
	bh=JjJsN/FzkXwzpwKYvwcVO1h/1p2V89dpbFM+/qYYWcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH6Tp5EMnw8wxXbPVfkqAwmJt8js5JCA2T/E0LPUX4M9P7Yyny6JKCOuKsMNmnPEAZwTD2YhefTdSZRPz+PJXBuHoiIZHhQoSyCDv6z3JoJ0G9WE930CAfZHCFYqk0Ug6HpSnShOeWDy+7LSQdhWGgTUKVswvy8BkS6oVFp+b2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hv85D+bL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv85D+bL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9894BC32781;
	Wed, 24 Jul 2024 16:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721837741;
	bh=JjJsN/FzkXwzpwKYvwcVO1h/1p2V89dpbFM+/qYYWcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hv85D+bLQllw7E5DXLnMY4obG06zABtO7uJ8l3IHxK4SBLsDJ75+nCGlbopXXVMnQ
	 lq6sQDJZ01jomOese3bNGUEJGOUH/Ui0z4xjSUbb5Asfp/et0MFmCjYvreEOtMlGYa
	 7aIk0jWTEuVQCaIkDY+wqr+Y2/Eg8DveNNQhHfyGxnilcqsqOawq4x2yQAUWF6E/4l
	 Axi6TI6s0BdOCX+1FPMGI0rdGfkvzQpAnmIcqroIGlAhBsU59loPD1jfoiuOp7h3XO
	 g7XFaDfn6ei8Efzvtn8APvfUiozB0L/4DfKMlezM6Dl2B/ioJFnP5NHlv+dHV7h+0J
	 Tl5WrqHiYQ1rg==
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
Subject: [PATCH v2 4/6] x86/rust: support MITIGATION_SLS
Date: Wed, 24 Jul 2024 18:14:57 +0200
Message-ID: <20240724161501.1319115-5-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
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
