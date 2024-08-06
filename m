Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5A218D637;
	Tue,  6 Aug 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722955623; cv=none; b=rWimz83/9PXe5m354p/vdIMuBLw/dgxhK1zyFaEH4aRb25eSTPmecT4V/iTgm4B9pL1AQ2SbbO5meRddyW9PPkXmjZr4ca222ibmApkFIB4TCzSrB3/HylRKD5JccQpRfkO2WSvf92WqOgLkomfyq5mfzHM3m+bpJPViiiiIJzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722955623; c=relaxed/simple;
	bh=Y5cnqlYZvFN6cWFHE9qVDfBZuNNP2KiMh9AisNZvLTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B15SPvn2ubSksbwXXI3LbhbClcseFrkfD8hi6qTbIArQWPr3nG4+YR50QKi5n3pOuTMU3SCX1cui3jf7iPYCmNYAqqrC86yFB7rD1+D3eHUOilB+2JDKVE3kfTnVzAbZ3hHC14738B5K6poZnR57EejCDNOIJUh9bPnCFMMYQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2PtbaYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2PtbaYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BA1C32786;
	Tue,  6 Aug 2024 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722955622;
	bh=Y5cnqlYZvFN6cWFHE9qVDfBZuNNP2KiMh9AisNZvLTA=;
	h=From:To:Cc:Subject:Date:From;
	b=f2PtbaYtlpBr4dZgWrLP4DSz+0sMAoCOJaf8PlESRaHiKNueurDE9IJVMYT+ERerp
	 oBumhEUT12cbzB84fVrxmavyk80/teYOGHLwSdN1D6K9+KR4PHustrIOXInX1SElSA
	 YMZUrtH9MyQjkpzDpU42qnmAwGFj6jBxKSa1iWe9WSoIfliMJO/MyuYX/b2yzJm0Rz
	 ZFAx7D4lVZz+FQbkISq0r+nT6bmiG4r62iAU0r1OAkT9HZ35/WwyoJhWGvPaeMpNRV
	 NskOt/DARBB63AmPPmSVeAwyppfkBA+FxkZ5Jeu2v+CnLaGENA5+rj/8isxmi9idYj
	 5mh7ctuAZbUkg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nikita Popov <github@npopov.com>
Subject: [PATCH] rust: x86: remove `-3dnow{,a}` from target features
Date: Tue,  6 Aug 2024 16:45:58 +0200
Message-ID: <20240806144558.114461-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLVM 19 is dropping support for 3DNow! in commit f0eb5587ceeb ("Remove
support for 3DNow!, both intrinsics and builtins. (#96246)"):

    Remove support for 3DNow!, both intrinsics and builtins. (#96246)

    This set of instructions was only supported by AMD chips starting in
    the K6-2 (introduced 1998), and before the "Bulldozer" family
    (2011). They were never much used, as they were effectively superseded
    by the more-widely-implemented SSE (first implemented on the AMD side
    in Athlon XP in 2001).

    This is being done as a predecessor towards general removal of MMX
    register usage. Since there is almost no usage of the 3DNow!
    intrinsics, and no modern hardware even implements them, simple
    removal seems like the best option.

Thus we should avoid passing these to the backend, since otherwise we
get a diagnostic about it:

    '-3dnow' is not a recognized feature for this target (ignoring feature)
    '-3dnowa' is not a recognized feature for this target (ignoring feature)

We could try to disable them only up to LLVM 19 (not the C side one,
but the one used by `rustc`, which may be built with a range of
LLVMs). However, to avoid more complexity, we can likely just remove
them altogether. According to Nikita [2]:

> I don't think it's needed because LLVM should not generate 3dnow
instructions unless specifically asked to, using intrinsics that Rust
does not provide in the first place.

Thus do so, like Rust did for one of their builtin targets [3].

For those curious: Clang will warn only about trying to enable them
(`-m3dnow{,a}`), but not about disabling them (`-mno-3dnow{,a}`), so
there is no change needed there.

Cc: Nikita Popov <github@npopov.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: x86@kernel.org
Link: https://github.com/llvm/llvm-project/commit/f0eb5587ceeb641445b64cb264c822b4751de04a [1]
Link: https://github.com/rust-lang/rust/pull/127864#issuecomment-2235898760 [2]
Link: https://github.com/rust-lang/rust/pull/127864 [3]
Closes: https://github.com/Rust-for-Linux/linux/issues/1094
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/generate_rust_target.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 87f34925eb7b..404edf7587e0 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -162,7 +162,7 @@ fn main() {
             "data-layout",
             "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128",
         );
-        let mut features = "-3dnow,-3dnowa,-mmx,+soft-float".to_string();
+        let mut features = "-mmx,+soft-float".to_string();
         if cfg.has("MITIGATION_RETPOLINE") {
             features += ",+retpoline-external-thunk";
         }
@@ -179,7 +179,7 @@ fn main() {
             "data-layout",
             "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128",
         );
-        let mut features = "-3dnow,-3dnowa,-mmx,+soft-float".to_string();
+        let mut features = "-mmx,+soft-float".to_string();
         if cfg.has("MITIGATION_RETPOLINE") {
             features += ",+retpoline-external-thunk";
         }

base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.46.0

