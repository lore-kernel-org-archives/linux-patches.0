Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AED4F55DC;
	Tue, 13 Oct 2026 12:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894438; cv=none; b=FRUnR5zEYh3YTL4/F5siQgQTeh2fO+7x0OvTLuIQsNz85RLl028ve5FaxC2PvpP7316gO+nqp2WOWYhYz3u3NpWij9M/4J3cYFCQ2VPGNdCzo88JV7ddUwJCUjEM1dJs7OgceEujilZsvVZYLD1szze/w+1x2MjSAMtesb4ARu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894438; c=relaxed/simple;
	bh=mzCBUdUfOltXPRngLgNA8JXNon2PLuH8ulkNg2l1GaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrp65H2j9EGCdEL2blM5j1JtSyRMUta/KTNB9Y4jheSa5Wgk0fQRW4ePMXLV6of1Az845d/4MwYlWqDPhIC1wpMc9Qi+zNZjiqtEppws5ZIZ0gTtPW+fb1UGrwKalxVAC1EmQPB8mWIM5wdh4WYoH5vKQRtoaaOlX3A9vq/7jV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZfUutIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZfUutIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E121F000FF;
	Tue, 13 Oct 2026 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894436;
	bh=7PTsm0yGWfaJyY2MwTEg5oTjWrJeeajsxE6FBp2B5QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZfUutIz4GobChTkl2s2sAFxdPFnglzzikf1LC9Zw9Q+H5ysr6tQBQKYPO+HBCH62
	 rw19eTNAyYFA0wRtV1zYV6jIjem43CE73ffDfAuqT5kqL4txYAb7a/vS9C05H1H5F9
	 rcQRP19wgsEfMFDseo2YmQk9n80exqdiDia6A0VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/621] riscv: vector: Fix output operands in context save
Date: Tue, 13 Oct 2026 13:39:14 +0200
Message-ID: <20261013112934.075951737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 55b1276ef9c1c27e8a2b2c5e8ef0515b5ad0332c ]

The __vstate_csr_save() inline assembly declares vcsr as an output
operand while the assembly only writes vstart, vtype, and vl. Remove it
as it is later saved by the C code.

Fixes: d863910eabaf ("riscv: vector: Support xtheadvector save/restore")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Link: https://patch.msgid.link/20260911194218.3379486-1-aurelien@aurel32.net
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index c612d54846b8d..c5c7bc455cb27 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -131,8 +131,8 @@ static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state *dest)
 		"csrr	%0, " __stringify(CSR_VSTART) "\n\t"
 		"csrr	%1, " __stringify(CSR_VTYPE) "\n\t"
 		"csrr	%2, " __stringify(CSR_VL) "\n\t"
-		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl),
-		"=r" (dest->vcsr) : :);
+		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl)
+		: :);
 
 	if (has_xtheadvector()) {
 		unsigned long status;
-- 
2.53.0



