Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606921340;
	Mon, 23 Oct 2023 17:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5sZlBXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754EBC433C8;
	Mon, 23 Oct 2023 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698083125;
	bh=X2EiXljEqLgjkMvgVksP7BUN5cbAO2JI6oZUqCn5eWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5sZlBXBs5Iog9qQoDZ2/bLkWFr3eeiiWVLVSZ+sI7fj7xIIRbHUoWbq2iHyPy76w
	 wc88r56+X9avGXu+OMTWHjzXYfpfBL610QgzkF899uZdDPH7s7n1846Siq42LNgHNH
	 vJ+SgFDeIwPuHFNF4crhAnR5vLxKHOehoGgUTLp6Ja1E7VJiFSt9/iLj5WBEFWolsw
	 OUnXCYwblWnSwgnFRinkG5ce/hAaLYppdnsCtd+OQDe06609TMIIaLOC7MhP13nMhH
	 dQFc2UqAd5c8HVXPZNRrL2nzk4IS30mWZuAOICUKr9QnFaCkWw4YU+IQ30qXUph4r9
	 t5Sa6AK8jlnMQ==
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
Subject: [PATCH 3/4] x86/rust: depend on !RETHUNK
Date: Mon, 23 Oct 2023 19:44:47 +0200
Message-ID: <20231023174449.251550-3-ojeda@kernel.org>
In-Reply-To: <20231023174449.251550-1-ojeda@kernel.org>
References: <20231023174449.251550-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Rust compiler does not support the equivalent of
`-mfunction-return=thunk-extern` yet [1]. Thus, currently, `objtool`
warns about it, e.g.:

    samples/rust/rust_print.o: warning: objtool: _R...init+0xa5c:
    'naked' return found in RETHUNK build

The support in `rustc` for `-Zfunction-return` has been submitted and
is being reviewed [2]. It adds the needed LLVM function attributes and,
with it, I got a RETHUNK kernel build with Rust enabled that does not
print the `objtool` related warnings, boots in QEMU and can load a kernel
loadable module.

In any case, until proper/complete support is added to `rustc`, make it
a hard restriction until the mitigation is in place.

This may have an impact for developers that may not need/care about the
mitigation in the Rust side (e.g. Ubuntu offers Rust as a "technology
preview" [3]), but given we are getting closer to having the first actual
in-tree Rust kernel users, it seems like the right time to disallow
it. This should also avoid confusion [4].

Link: https://github.com/rust-lang/rust/issues/116853 [1]
Link: https://github.com/rust-lang/rust/pull/116892 [2]
Link: https://lore.kernel.org/rust-for-linux/ZSQXqX2%2Flhf5ICZP@gpd/ [3]
Link: https://lore.kernel.org/rust-for-linux/CANiq72n6DMeXQrgOzS_+3VdgNYAmpcnneAHJnZERUQhMExg+0A@mail.gmail.com/ [4]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 6d35728b94b2..9452b4102b99 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1889,6 +1889,7 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
+	depends on !RETHUNK
 	select CONSTRUCTORS
 	help
 	  Enables Rust support in the kernel.
-- 
2.42.0

