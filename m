Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E64D24A047;
	Tue, 21 Oct 2025 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077132; cv=none; b=RMfC8owvmnb/Bt64uP7mY7joiFH68Z5ROTcQuo5J008SXdPZf0vIye0DxTG0f61ULFwbFzHDsnZjpwDdiwYvg7hLIF4XT94TbfVuxoT2grBHMUaCfu61n+WG23wAUbrPMTATbLj/VS6bg+h043K3e3IwmnsFSBf/BMjxl0hcnD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077132; c=relaxed/simple;
	bh=MfvkSTQoSAfM8NAZm3meqnM5yZ2+n4elhjWdS+Cq5jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkj+ivzI2gbbruJ6ngZ/nrWsFnQFlblwK/0tuql2E65wxvNb50FcF4chSpsQRNNKZ6/VnCyAWRFtdFo+LYN6Mb97++gHae1ZWD/Z4hDjAi18JSn2NubstYdW49NhbA0IFO4fRrjaeC1fF8mLG/1eH4+8+pFbO5b7m/s+1GcHnWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H80X/Ph+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H80X/Ph+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07E1C4CEF7;
	Tue, 21 Oct 2025 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077132;
	bh=MfvkSTQoSAfM8NAZm3meqnM5yZ2+n4elhjWdS+Cq5jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H80X/Ph++gzJ6LDM4rh8a8XL1seHQzrde+m6/x83SKUgYLBlfiFxwEXP5YbDaEwng
	 xH1gqHdvDC0N7dRDcyjgQzawhh8k68y7QjFPPkF6eUIKE5I6+N8L5kZOwOtEtnKTGY
	 eUeZfL28LIQIi3FMkAe8r33Giu+/QluW09xiwaFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.17 010/159] rust: cfi: only 64-bit arm and x86 support CFI_CLANG
Date: Tue, 21 Oct 2025 21:49:47 +0200
Message-ID: <20251021195043.432068280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 812258ff4166bcd41c7d44707e0591f9ae32ac8c upstream.

The kernel uses the standard rustc targets for non-x86 targets, and out
of those only 64-bit arm's target has kcfi support enabled. For x86, the
custom 64-bit target enables kcfi.

The HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC config option that allows
CFI_CLANG to be used in combination with RUST does not check whether the
rustc target supports kcfi. This breaks the build on riscv (and
presumably 32-bit arm) when CFI_CLANG and RUST are enabled at the same
time.

Ordinarily, a rustc-option check would be used to detect target support
but unfortunately rustc-option filters out the target for reasons given
in commit 46e24a545cdb4 ("rust: kasan/kbuild: fix missing flags on first
build"). As a result, if the host supports kcfi but the target does not,
e.g. when building for riscv on x86_64, the build would remain broken.

Instead, make HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC depend on the only
two architectures where the target used supports it to fix the build.

CC: stable@vger.kernel.org
Fixes: ca627e636551e ("rust: cfi: add support for CFI_CLANG with Rust")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250908-distill-lint-1ae78bcf777c@spud
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -917,6 +917,7 @@ config HAVE_CFI_ICALL_NORMALIZE_INTEGERS
 	def_bool y
 	depends on HAVE_CFI_ICALL_NORMALIZE_INTEGERS_CLANG
 	depends on RUSTC_VERSION >= 107900
+	depends on ARM64 || X86_64
 	# With GCOV/KASAN we need this fix: https://github.com/rust-lang/rust/pull/129373
 	depends on (RUSTC_LLVM_VERSION >= 190103 && RUSTC_VERSION >= 108200) || \
 		(!GCOV_KERNEL && !KASAN_GENERIC && !KASAN_SW_TAGS)


