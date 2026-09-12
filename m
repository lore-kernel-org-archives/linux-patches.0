Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A36337FF60;
	Sat, 12 Sep 2026 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208245; cv=none; b=i9S7MTLt3d5cAUaCWXmRUzugIT+IEKCbzpj1Bj7FZIy89Mabpz+hKVzZkxYZUN86oT21oSH9E8vVUKQmINyOLN7vnmfydjGEOI+k8/RYznng+WqUNVjttAV2pkaPOzPoJAS3dH4Z6fwP1UAdatyu2oKxJp1id8H5r1q/A5pCwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208245; c=relaxed/simple;
	bh=0Vk56qoaBfwzw9mzob3QpSsbklS5IRaNkkhmjQCS0g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXNjctYfz5mcx+t58HxI4vCJOFDwIpEkcsa3T8Bxgpk1wzeR2tn846zmb0/zIn6dWLseeqYz/hoMqQAw4vjNwB4y+oi97NNvha0ZT57TnDZdG7FG63RXV+O7g1GmMErQoZYkD+Tm+OjGLNdgrGmmZUDYyCrSEKRA3m8/7pTuwRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKnEONcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKnEONcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D748B1F000FF;
	Sat, 12 Sep 2026 10:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208242;
	bh=ljGew+eVU5m3AoeHxxtlYGgKd5Y12ynAVC++b6NDVBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKnEONcX9LXCuEtYw5j/SFL1MNEHqMnnO8qDXjy1BqUX/jrpFV2yATkGsFVn/VyPT
	 /RjWQlcyBR1SHcpZeaacZYnZ7kW1bO/CoTf6Yw4jzmS7MNyecaOaK3wnzKC6w+Rrtz
	 TrW9YaByi8eaSUbDrrzjblXiBsApdUm7MP2mkD8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0578/1518] arm64: RSI: fix field-spanning write warning in attestation token init
Date: Sat, 12 Sep 2026 08:45:47 +0200
Message-ID: <20260912065636.504478820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kohei Enju <enju.kohei@fujitsu.com>

[ Upstream commit 221049874b6a78c7d87bc826581b0695cd338e2b ]

The challenge is passed in registers a1 through a8. However, copying to
&regs.a1 makes FORTIFY treat the destination as the single a1 field,
resulting in a field-spanning write warning. [1]

Overlay the SMCCC register structure with an RSI-specific argument
layout and copy the challenge into an explicit 64-byte array. This keeps
the existing a1-a8 argument encoding while giving the copy a correctly
sized destination object.

[1]
memcpy: detected field-spanning write (size 64) of single field "&regs.a1" at ./arch/arm64/include/asm/rsi_cmds.h:119 (size 8)
WARNING: ./arch/arm64/include/asm/rsi_cmds.h:119 at rsi_attestation_token_init+0xdc/0xf8 [arm_cca_guest], CPU#0: cat/3314

Fixes: b880a80011f5 ("arm64: rsi: Add RSI definitions")
Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/rsi_cmds.h | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 2c8763876dfb7..c1fab41f671ec 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -88,6 +88,14 @@ static inline long rsi_set_addr_range_state(phys_addr_t start,
 	return res.a0;
 }
 
+#define RSI_ATTEST_CHALLENGE_MIN_SIZE	32
+#define RSI_ATTEST_CHALLENGE_MAX_SIZE	64
+
+struct rsi_attestation_token_init_args {
+	unsigned long fid;
+	u8 challenge[RSI_ATTEST_CHALLENGE_MAX_SIZE];
+};
+
 /**
  * rsi_attestation_token_init - Initialise the operation to retrieve an
  * attestation token.
@@ -109,18 +117,21 @@ static inline long rsi_set_addr_range_state(phys_addr_t start,
 static inline long
 rsi_attestation_token_init(const u8 *challenge, unsigned long size)
 {
-	struct arm_smccc_1_2_regs regs = { 0 };
+	union {
+		struct arm_smccc_1_2_regs regs;
+		struct rsi_attestation_token_init_args init;
+	} args = { 0 };
 
-	/* The challenge must be at least 32bytes and at most 64bytes */
-	if (!challenge || size < 32 || size > 64)
+	if (!challenge || size < RSI_ATTEST_CHALLENGE_MIN_SIZE ||
+	    size > RSI_ATTEST_CHALLENGE_MAX_SIZE)
 		return -EINVAL;
 
-	regs.a0 = SMC_RSI_ATTESTATION_TOKEN_INIT;
-	memcpy(&regs.a1, challenge, size);
-	arm_smccc_1_2_smc(&regs, &regs);
+	args.init.fid = SMC_RSI_ATTESTATION_TOKEN_INIT;
+	memcpy(args.init.challenge, challenge, size);
+	arm_smccc_1_2_smc(&args.regs, &args.regs);
 
-	if (regs.a0 == RSI_SUCCESS)
-		return regs.a1;
+	if (args.regs.a0 == RSI_SUCCESS)
+		return args.regs.a1;
 
 	return -EINVAL;
 }
-- 
2.53.0



