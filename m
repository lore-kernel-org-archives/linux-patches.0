Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911A3EA86;
	Thu, 25 Jul 2024 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721932521; cv=none; b=ZCP5Dwlli8joPIUjOKlMZLWC4KAywXiVfkbHiDUS8xyl+coFIJpk/Y9SJpDZM/lNpPBfN427PE4wTp9gJjkOZk0x9oS2/e4uAKoURBeIFL8tO/x7nh6TelxcmaUcsnyzkwvko0HNaRExC/6ZjvE3/K4pOK7K9Kw9+ollNsJPox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721932521; c=relaxed/simple;
	bh=qduhv8XVc+iOI/qx1A9RUIlPuceRdUvIFdUbsHoZ2V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmwNvZykSWQJNXkTBa3ACp2SS62BWcA2OJwin8qywnXXvMCKK0ITWgW4ZdPPoCdtloq4IS2RBN3TRlRlCqjT1v0BNHdCrOvzL4U3rnu0DiWle6TXT2GJkIf4Kx2O54Xb7mMmtM3KTv+gIFhb06gLAUDi0KvvhZmMF33U+NlM5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9mcplrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9mcplrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5B2C116B1;
	Thu, 25 Jul 2024 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721932519;
	bh=qduhv8XVc+iOI/qx1A9RUIlPuceRdUvIFdUbsHoZ2V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9mcplrU8i0A1hkMa1gjCzkyRLckzwtt6GLMeel8ZYmuSeTfCbZBsgdsGUicYRsW4
	 kqIcSY1htPEEtFB6WrospNvjX8SQzMJG0wCiqMIHxFKH6LgKpcmuDOt3SQogsLaUdV
	 App9MqCA1O7ZkuPQjK9F+tzmTyoS+9AnZ55sTDuXhn0GoTtMd236RMSgIrePiLG8zd
	 Z/MuhEQpynSDKs/n45YQGL0/8omBgl9+ZiZ020hf93OVGnj0hXL2DIfzcdrsVa+1OL
	 e+XY5aC6yA+HLvP7751NylxB22hQqmPQTqJFPMTpgOnghy7y4Fb7Ea/rNBhkv/sMLE
	 YVhawqa/c++BA==
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
Subject: [PATCH v3 3/6] x86/rust: support MITIGATION_RETHUNK
Date: Thu, 25 Jul 2024 20:33:20 +0200
Message-ID: <20240725183325.122827-4-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-1-ojeda@kernel.org>
References: <20240725183325.122827-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Rust compiler added support for `-Zfunction-return=thunk-extern` [1]
in 1.76.0 [2], i.e. the equivalent of `-mfunction-return=thunk-extern`.
Thus add support for `MITIGATION_RETHUNK`.

Without this, `objtool` would warn if enabled for Rust and already warns
under IBT builds, e.g.:

    samples/rust/rust_print.o: warning: objtool:
    _R...init+0xa5c: 'naked' return found in RETHUNK build

Link: https://github.com/rust-lang/rust/issues/116853 [1]
Link: https://github.com/rust-lang/rust/pull/116892 [2]
Reviewed-by: Gary Guo <gary@garyguo.net>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 arch/x86/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e8214bff1aeb..a1883a30a5d8 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -24,11 +24,15 @@ RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 
 ifdef CONFIG_MITIGATION_RETHUNK
 RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
+RETHUNK_RUSTFLAGS	:= -Zfunction-return=thunk-extern
 RETPOLINE_CFLAGS	+= $(RETHUNK_CFLAGS)
+RETPOLINE_RUSTFLAGS	+= $(RETHUNK_RUSTFLAGS)
 endif
 
 export RETHUNK_CFLAGS
+export RETHUNK_RUSTFLAGS
 export RETPOLINE_CFLAGS
+export RETPOLINE_RUSTFLAGS
 export RETPOLINE_VDSO_CFLAGS
 
 # For gcc stack alignment is specified with -mpreferred-stack-boundary,
@@ -218,6 +222,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # Avoid indirect branches in kernel to deal with Spectre
 ifdef CONFIG_MITIGATION_RETPOLINE
   KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
+  KBUILD_RUSTFLAGS += $(RETPOLINE_RUSTFLAGS)
   # Additionally, avoid generating expensive indirect jumps which
   # are subject to retpolines for small number of switch cases.
   # LLVM turns off jump table generation by default when under
-- 
2.45.2

