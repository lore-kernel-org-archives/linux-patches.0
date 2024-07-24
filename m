Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CB4158DA7;
	Wed, 24 Jul 2024 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837722; cv=none; b=GjDkTj/GR+D6UKKmzCvxwIBoPTsLekkENTIUw73ktjnGDTwzAE+sGPYOv7j1YlY3HXQUiSXdw8aK6VvA+qpqfURei93fNG21VuqY9PfI9RhoZy6IcSfw/8a4OTGvxulDgi2Cvs6ZpFnEH4JT42hB9PJqpTQUd8GvPTYRKKFwSE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837722; c=relaxed/simple;
	bh=XWZEvVncWNQU08txXncXxWG+iRfEAo91RZkkjZxh1zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9J9OoC9GSCseTw8xLdF5RKEX1nj7KznV3qAXfEVCW2ecPET8AU432Y1ib4dNvQ3xpBaAQSvkpPDX4IWGAy442UZYMcqDXC/y5O7MfajDyupvH1cmSkxU0TMMCwFtDRJ05VH6WlCAQeOK283LmLs/yv4C1v2Qo3FG3j/BVEN+zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFSyptWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFSyptWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E89C4AF0B;
	Wed, 24 Jul 2024 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721837722;
	bh=XWZEvVncWNQU08txXncXxWG+iRfEAo91RZkkjZxh1zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFSyptWK4b57Lmyk1a2bXr/2Orsb7SSZLahbADTChWKxZYKi7xI6dinh6rCuw+NY2
	 dCzP/mgDxXCq6dwGQbpCW1Ul5pkkcqKas0VqarXD2Clc+z8TBeUKsPPNwTjU+Bk4Hx
	 nqToGf05CxswLyuHn5QQKnsARKvt2b3cHScyrAKKxD8gRhLiopzZhW/b63bi6329L+
	 PgGZcLrsV2hVMyE8uUkSIlqFl8Dxww7k09YpGqmKAXDk+C9XVeTQ/71YSGzl+pvck5
	 uUVJQfb0IbUlFgWl3mTl9D0P/2FblRIc3ntKxR8eC3d2k2yPqdiSKpxW3xhAeF6x/n
	 VbnSdrdSZhEJA==
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
Subject: [PATCH v2 1/6] rust: module: add static pointer to `{init,cleanup}_module()`
Date: Wed, 24 Jul 2024 18:14:54 +0200
Message-ID: <20240724161501.1319115-2-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the equivalent of the `___ADDRESSABLE()` annotation in the
`module_{init,exit}` macros to the Rust `module!` macro.

Without this, `objtool` would complain if enabled for Rust, e.g.:

    samples/rust/rust_print.o: warning: objtool: cleanup_module(): not an indirect call target
    samples/rust/rust_print.o: warning: objtool: init_module(): not an indirect call target

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/macros/module.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index 411dc103d82e..571ffa2e189c 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -256,6 +256,12 @@ mod __module_init {{
                         unsafe {{ __init() }}
                     }}
 
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[used]
+                    #[link_section = \".init.data\"]
+                    static __UNIQUE_ID___addressable_init_module: unsafe extern \"C\" fn() -> i32 = init_module;
+
                     #[cfg(MODULE)]
                     #[doc(hidden)]
                     #[no_mangle]
@@ -269,6 +275,12 @@ mod __module_init {{
                         unsafe {{ __exit() }}
                     }}
 
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[used]
+                    #[link_section = \".exit.data\"]
+                    static __UNIQUE_ID___addressable_cleanup_module: extern \"C\" fn() = cleanup_module;
+
                     // Built-in modules are initialized through an initcall pointer
                     // and the identifiers need to be unique.
                     #[cfg(not(MODULE))]
-- 
2.45.2

