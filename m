Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F47A340A57;
	Sat, 12 Sep 2026 07:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199841; cv=none; b=WUkgYUGFMGpn2uHr9OjER7mMS1gzo2IyliypFhiOJZloZYSUDw4+telmK5hJ0EklET+EB1Jo8X3T9dqqr2Pu2mXQsmT7jbxW5TYJAnbeLXtUxX9TWc4MLQmFfav4RgReqqo7Ary6QiZdfZX4HtqnZxG9J2lwLSuP47Qi9iGgPP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199841; c=relaxed/simple;
	bh=ticPJfvO/tTXQcS/jtF8ZsiVauXY6TD1GQ7qgp9xgyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU6RcqeZtYx8wTtcZ1cuFI3oOi10JvhyJb+BS0Bxg9gi3hSskwbhovEM4c+cS5blJLcLWEwdleyQzTjUobpq3hxhP8K9EeOcaJNF0KH8pVEE2Ez9zoellWVoaVdaAhYzd2hmUsGcNKbO8gbQ8HLI+S3J6+KrLGGswjht9N5RqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VWpdrTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VWpdrTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477131F000FF;
	Sat, 12 Sep 2026 07:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199839;
	bh=k47MsXHlOigKzJ6MMbG+tMm76oWQd+rg7WRK0d7ZCNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VWpdrTI/5RUkE746CebDjkcuuRdQKg+pb8+yFOalkd3QXQ5Lszdy+v/zkJFL+uZ9
	 e/ib6AZwaw8u/knEhMaBO5uqVfPmaBfiHXm+rQJCKebI9duTX0DxyerW26tbKVaf/7
	 uLOAQDbv3iAmTMzOqRVqfS1LZ/+3r4M7R+O280nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0666/1815] arm64: RSI: fix field-spanning write warning in attestation token init
Date: Sat, 12 Sep 2026 08:40:16 +0200
Message-ID: <20260912065704.519298557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



