Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400D18027;
	Wed, 28 Jan 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615704; cv=none; b=cANwTsYp1lvQhGoNNfjPuE/Bsb+Zr7zEWaJPHQZY20kTEYmC/8ic21ebl5bkieYD3fMlwnzLs0/+c+XFk/pcje26Ddywhr25nA6sxzS2672cgW7xcBrlqKu88drhQ7+8tsgckidoFpzyEFwS/uN4Wv45tFLO4qDMHEBP0uHZUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615704; c=relaxed/simple;
	bh=RG34Kk6jPkdhij+C2bUhgvUZmN391S/6UB77eCY4WZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpgZnoKiQ1kRtq39yHuPObd5wFCpKCgQTCDc/9Cxbs/3/WfSkbXDKes4F6sQd6G+Id8vUoF7kSvVFRawXWxYTEGseHArS2G7/qXrzvp9sJz18BitcXsgwnyJOc4JbPyDBxfQNXI6dgKl1N3vHHVW50prgUaWkjmIE3+qARyXR7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq5ouieN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq5ouieN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49249C4CEF1;
	Wed, 28 Jan 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615704;
	bh=RG34Kk6jPkdhij+C2bUhgvUZmN391S/6UB77eCY4WZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq5ouieN+Sz7WV/BEcP5WrGE9HxWqzkgw0Lm/OWD/esbJ5lN0wewYV5XjYjQkbMCy
	 dF1YVIDMN2PwhRdqIcBggA1BEhBo+UiwlKKsmMMSwuvL4CgY7cxk6QUz0GWFpwStq2
	 CBvpyL3yO8Jn3nDg1KjNuyvDJ86zmXDCgieAcKcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/227] riscv: suspend: Fix stimecmp update hazard on RV32
Date: Wed, 28 Jan 2026 16:22:14 +0100
Message-ID: <20260128145347.538954552@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiko Shimizu <naohiko.shimizu@gmail.com>

[ Upstream commit 344c5281f43851b22c7cc223fd0250c143fcbc79 ]

On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
separate 32-bit writes. A race condition exists if the timer triggers
during these two writes.

The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
recommends a specific 3-step sequence to avoid spurious interrupts
when updating 64-bit comparison registers on 32-bit systems:

1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
2. Set the high-order bits (stimecmph) to the desired value.
3. Set the low-order bits (stimecmp) to the desired value.

Current implementation writes the LSB first without ensuring a future
value, which may lead to a transient state where the 64-bit comparison
is incorrectly evaluated as "expired" by the hardware. This results in
spurious timer interrupts.

This patch adopts the spec-recommended 3-step sequence to ensure the
intermediate 64-bit state is never smaller than the current time.

Fixes: ffef54ad4110 ("riscv: Add stimecmp save and restore")
Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://patch.msgid.link/20260104135938.524-4-naohiko.shimizu@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/suspend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/suspend.c b/arch/riscv/kernel/suspend.c
index 24b3f57d467f8..aff93090c4efc 100644
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -51,10 +51,11 @@ void suspend_restore_csrs(struct suspend_context *context)
 
 #ifdef CONFIG_MMU
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SSTC)) {
-		csr_write(CSR_STIMECMP, context->stimecmp);
 #if __riscv_xlen < 64
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, context->stimecmph);
 #endif
+		csr_write(CSR_STIMECMP, context->stimecmp);
 	}
 
 	csr_write(CSR_SATP, context->satp);
-- 
2.51.0



