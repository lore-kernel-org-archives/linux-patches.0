Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB881EB1B8;
	Wed, 19 Feb 2025 08:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954300; cv=none; b=iV2VMtPYp9WrJoL1ctVtlFPEIcdjyG+tdyrmOy4figmruv/8ITECY189l/cxt5ROeUzs17plF0AioqYqEVxCF1SPc5Rb6+yl3zKxnu9JIRQ58/6/ZHswylpBKlKpc10xdFtoakHtFzREXOl+vN/a9WKXUp2n5u5Jx1IfghmhL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954300; c=relaxed/simple;
	bh=7EIZ0MIwxhMRJLxbgSKSGv4xM71CIJXEwEkozcqfeNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfR9fuJ7ym/TmzGzT8HpY8j91F2LQlLhdFJtDaCMjDlVkBF907grmWMOlHhMdKFSsVbR1OolP9OPMDvnAKeOWlaEE0yvm2KtYZLtwzp7LExKjVBDUKLpR8mgLAJivVGpKLFc4l3otQhK8KG7H8bbtxPoc+GW7ak05ayZQrOnxrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9zO2It2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9zO2It2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6024DC4CED1;
	Wed, 19 Feb 2025 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954299;
	bh=7EIZ0MIwxhMRJLxbgSKSGv4xM71CIJXEwEkozcqfeNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9zO2It2dGU+Z4Zc74tBgcXDzON+RkFsGWE2FxirzWgCtg5WAGKK3q8uTJByNWLR7
	 Oz9cg6q4bxNJrgDo26RM7fBnJYfUdXir21B2IUwCioTTLarOhSGTLNTZzUsA+3xn4b
	 CvKOiOHthjGm+5f/PXrTIwWfy+OwoJwXcZUB6Y5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Matthew Maurer <mmaurer@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Ralf Jung <post@ralfj.de>,
	Jubilee Young <workingjubilee@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Trevor Gross <tmgross@umich.edu>
Subject: [PATCH 6.13 160/274] arm64: rust: clean Rust 1.85.0 warning using softfloat target
Date: Wed, 19 Feb 2025 09:26:54 +0100
Message-ID: <20250219082615.856497421@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 446a8351f160d65a1c5df7097f31c74102ed2bb1 upstream.

Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
[1] about disabling neon in the aarch64 hardfloat target:

    warning: target feature `neon` cannot be toggled with
             `-Ctarget-feature`: unsound on hard-float targets
             because it changes float ABI
      |
      = note: this was previously accepted by the compiler but
              is being phased out; it will become a hard error
              in a future release!
      = note: for more information, see issue #116344
              <https://github.com/rust-lang/rust/issues/116344>

Thus, instead, use the softfloat target instead.

While trying it out, I found that the kernel sanitizers were not enabled
for that built-in target [2]. Upstream Rust agreed to backport
the enablement for the current beta so that it is ready for
the 1.85.0 release [3] -- thanks!

However, that still means that before Rust 1.85.0, we cannot switch
since sanitizers could be in use. Thus conditionally do so.

Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Ralf Jung <post@ralfj.de>
Cc: Jubilee Young <workingjubilee@gmail.com>
Link: https://github.com/rust-lang/rust/pull/133417 [1]
Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/topic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
Link: https://github.com/rust-lang/rust/pull/135905 [3]
Link: https://github.com/rust-lang/rust/issues/116344
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Ralf Jung <post@ralfj.de>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250210163732.281786-1-ojeda@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,7 +48,11 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU) \
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(compat_vdso)
 
+ifeq ($(call test-ge, $(CONFIG_RUSTC_VERSION), 108500),y)
+KBUILD_RUSTFLAGS += --target=aarch64-unknown-none-softfloat
+else
 KBUILD_RUSTFLAGS += --target=aarch64-unknown-none -Ctarget-feature="-neon"
+endif
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
 KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)


