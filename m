Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F9015B134;
	Wed, 24 Jul 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837735; cv=none; b=afb9nZ7V7aS/z1ndJ2T8jTR5xXF83/1vrhn+mgBvnC1YRGbHBCVh5DbxSuS1N58BXps7YMt/xfAIsAiKJpTaKERoOPW6vC9XaXoAY1JfeL7lUxERpa8HQ139tW1XZEVUEkz2xM1d4h1JBDr9ddwFn5hUqgUJWBQndXm0WU0xfVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837735; c=relaxed/simple;
	bh=62HOawHTIw3KVJYCgacE1sz8810PmzPRoDT7e9avsRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFI5uC/9O9ss4dNc0XIUgIsF3xgvUGxNLHbdbPwXX/y3F+9wODd00PIU3favMq7HAvtX9O3a+Ex0WniASzEZQgO3XBTZU9AiWf6U7FkDCoXfn7A1YiOrCN5n6KlglPgA75NhMyQRt8RngyHzbvCgd4nv+uMdccFBm0TYoEaWI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAanHT0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAanHT0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7109BC32781;
	Wed, 24 Jul 2024 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721837735;
	bh=62HOawHTIw3KVJYCgacE1sz8810PmzPRoDT7e9avsRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAanHT0vv/S/66XOcrpIaFVo24vR6XHyfD/sNV9aZcLCGfa3uIDJ66nObaW4vPfpg
	 l2mFR5niCvHnexbJ8TMDNQBrTgUb5JHN+0Zp+7eOj5XtCGez2nTZ2DkpOEu9oXlJP4
	 6dgAbnE8xME/w/UE2iu+/dDkUVuF6+6RT162DP8yZR+OgqpG7rM0C+u4rmpsCESlfl
	 E61wgwSM3XWnLo6GaKHqioleudaBPAGvLTdMWWvixVXOeqqq7IqIUH9yCbpfKZrtln
	 hCqBAzXErinuqvePpfFghKeA9qe0wClltjlgrdVGUrPrAzNq84fPYGw7bCtKZ0euGM
	 FgTscqe1nJHWQ==
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
Subject: [PATCH v2 3/6] x86/rust: support MITIGATION_RETHUNK
Date: Wed, 24 Jul 2024 18:14:56 +0200
Message-ID: <20240724161501.1319115-4-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
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

