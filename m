Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4185A29827E;
	Mon, 12 May 2025 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073058; cv=none; b=ULHrsotlt7dgsi636K7Pj7tIaQudbpUq7vqxHH5hch2y8fJONrdu//z23lhmQazTjQp9r2LL/2SifUrfIYMiDP6vxX1QqZNpYZBlWUrfD1vt/uS06d46VU3zW2dqJJMZFb8/P4Hl9Hzl4z8mAMj0xYYKlCvxdo+WHcKBx8SkAuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073058; c=relaxed/simple;
	bh=ihl1kSVlIi5HspHm0RxdI7ss1jafMpv7LPgD1idjFFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANUMKYvGjbs6EhXr2B/s9K/wQrgbYSmgZMqdk+HIzSpmG/XW58IOQ0LDESvxl+gfn2whDFZtBs5eeQNAU91OAI7/n0GaWzqWd850qxNPEBROj+drUlCv2kB8EQZkJenIDu9qPJUD70zQmOIr1JN8JCUtbZmyzqVFlG1u5GEJVrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyU/rdBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyU/rdBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BEBC4CEEF;
	Mon, 12 May 2025 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073058;
	bh=ihl1kSVlIi5HspHm0RxdI7ss1jafMpv7LPgD1idjFFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyU/rdBF5nbmvwd1Um3jdR2cmUBIjpeWyo+kqCF3upz1bnLDiL0+pGbW0MeaBSCFZ
	 +ejRYDsi55n8BQCkzGJ0Fz/eBwhokmM9WHs6sV3sSwW8Dw2d1a+Vj+gFdWGOMPD4Cn
	 A8/Sn+W06TmUGIukf1IwpGo8SFcXx8GjO2azyfQYlcIFAn18uRHerAm03akFhk1rq5
	 2IXUFM4rEgcPAlZ89ODEMDwRAAxm0msmApqNPKzA7PU0hMON05i49okcXs6sjMjQJW
	 XAK47T/EPCmDdHMahBXNiAqPkDwfBlxldE+K1a+7fMtxXn8mSBltmbZ+SCM3gYdTTu
	 PfPTnPEG4/wdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pawe=C5=82=20Anikiel?= <panikiel@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	alex.gaynor@gmail.com,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 12/15] x86/Kconfig: make CFI_AUTO_DEFAULT depend on !RUST or Rust >= 1.88
Date: Mon, 12 May 2025 14:03:47 -0400
Message-Id: <20250512180352.437356-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180352.437356-1-sashal@kernel.org>
References: <20250512180352.437356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.6
Content-Transfer-Encoding: 8bit

From: Paweł Anikiel <panikiel@google.com>

[ Upstream commit 5595c31c370957aabe739ac3996aedba8267603f ]

Calling core::fmt::write() from rust code while FineIBT is enabled
results in a kernel panic:

[ 4614.199779] kernel BUG at arch/x86/kernel/cet.c:132!
[ 4614.205343] Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[ 4614.211781] CPU: 2 UID: 0 PID: 6057 Comm: dmabuf_dump Tainted: G     U     O       6.12.17-android16-0-g6ab38c534a43 #1 9da040f27673ec3945e23b998a0f8bd64c846599
[ 4614.227832] Tainted: [U]=USER, [O]=OOT_MODULE
[ 4614.241247] RIP: 0010:do_kernel_cp_fault+0xea/0xf0
...
[ 4614.398144] RIP: 0010:_RNvXs5_NtNtNtCs3o2tGsuHyou_4core3fmt3num3impyNtB9_7Display3fmt+0x0/0x20
[ 4614.407792] Code: 48 f7 df 48 0f 48 f9 48 89 f2 89 c6 5d e9 18 fd ff ff 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 41 81 ea 14 61 af 2c 74 03 0f 0b 90 <66> 0f 1f 00 55 48 89 e5 48 89 f2 48 8b 3f be 01 00 00 00 5d e9 e7
[ 4614.428775] RSP: 0018:ffffb95acfa4ba68 EFLAGS: 00010246
[ 4614.434609] RAX: 0000000000000000 RBX: 0000000000000010 RCX: 0000000000000000
[ 4614.442587] RDX: 0000000000000007 RSI: ffffb95acfa4ba70 RDI: ffffb95acfa4bc88
[ 4614.450557] RBP: ffffb95acfa4bae0 R08: ffff0a00ffffff05 R09: 0000000000000070
[ 4614.458527] R10: 0000000000000000 R11: ffffffffab67eaf0 R12: ffffb95acfa4bcc8
[ 4614.466493] R13: ffffffffac5d50f0 R14: 0000000000000000 R15: 0000000000000000
[ 4614.474473]  ? __cfi__RNvXs5_NtNtNtCs3o2tGsuHyou_4core3fmt3num3impyNtB9_7Display3fmt+0x10/0x10
[ 4614.484118]  ? _RNvNtCs3o2tGsuHyou_4core3fmt5write+0x1d2/0x250

This happens because core::fmt::write() calls
core::fmt::rt::Argument::fmt(), which currently has CFI disabled:

library/core/src/fmt/rt.rs:
171     // FIXME: Transmuting formatter in new and indirectly branching to/calling
172     // it here is an explicit CFI violation.
173     #[allow(inline_no_sanitize)]
174     #[no_sanitize(cfi, kcfi)]
175     #[inline]
176     pub(super) unsafe fn fmt(&self, f: &mut Formatter<'_>) -> Result {

This causes a Control Protection exception, because FineIBT has sealed
off the original function's endbr64.

This makes rust currently incompatible with FineIBT. Add a Kconfig
dependency that prevents FineIBT from getting turned on by default
if rust is enabled.

[ Rust 1.88.0 (scheduled for 2025-06-26) should have this fixed [1],
  and thus we relaxed the condition with Rust >= 1.88.

  When `objtool` lands checking for this with e.g. [2], the plan is
  to ideally run that in upstream Rust's CI to prevent regressions
  early [3], since we do not control `core`'s source code.

  Alice tested the Rust PR backported to an older compiler.

  Peter would like that Rust provides a stable `core` which can be
  pulled into the kernel: "Relying on that much out of tree code is
  'unfortunate'".

    - Miguel ]

Signed-off-by: Paweł Anikiel <panikiel@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://github.com/rust-lang/rust/pull/139632 [1]
Link: https://lore.kernel.org/rust-for-linux/20250410154556.GB9003@noisy.programming.kicks-ass.net/ [2]
Link: https://github.com/rust-lang/rust/pull/139632#issuecomment-2801950873 [3]
Link: https://lore.kernel.org/r/20250410115420.366349-1-panikiel@google.com
Link: https://lore.kernel.org/r/att0-CANiq72kjDM0cKALVy4POEzhfdT4nO7tqz0Pm7xM+3=_0+L1t=A@mail.gmail.com
[ Reduced splat. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aeb95b6e55369..fec9c72ad8d90 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2430,6 +2430,7 @@ config STRICT_SIGALTSTACK_SIZE
 config CFI_AUTO_DEFAULT
 	bool "Attempt to use FineIBT by default at boot time"
 	depends on FINEIBT
+	depends on !RUST || RUSTC_VERSION >= 108800
 	default y
 	help
 	  Attempt to use FineIBT by default at boot time. If enabled,
-- 
2.39.5

