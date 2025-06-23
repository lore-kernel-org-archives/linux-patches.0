Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220584C74;
	Mon, 23 Jun 2025 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716125; cv=none; b=JZtlF7X3smBjuh/ns52QyYN1cfGVDeyDwka550OB6dGlMpuI+Ly6va8h7pWplO5LaLcbWs/bFR+RTQhMBJoS9UTswGT6aLLN0YF7QnrBoZ8PQ5JVvg/AeM5CV+dLiGE/RukEO8XdEhXtYGwsUaX0VLluLvRNzdpx4vwmXX5bIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716125; c=relaxed/simple;
	bh=BmiZ93uaJky06OmjyRVCTlc6M0sx2JDCzMv5WLyFtZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmuDWpO+h7o9Jf2G6z1JkauwBKFatzZDuo4lSXJbZkv1H7xwTwRngslVoFKz7bbKCu4pA3tdPV8GmxOuT8H32ew33AFof+FbDnd1kwu+0GerDtmkschEYDdrtjlYbg+s2xM/rgZiGRz2OSiayn7H+PQOEk0a8pYGVQfnY0BNDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTV1r/oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTV1r/oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE93C4CEEA;
	Mon, 23 Jun 2025 22:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716125;
	bh=BmiZ93uaJky06OmjyRVCTlc6M0sx2JDCzMv5WLyFtZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTV1r/oz3NyrmgrlXH7B7WwUraEAZAkhK3a0D6ZLF5c5MnX4q6DsJ2t4ClmXCI29J
	 ETvdqvPFE6biJ9kqigQsR6n49e7NkU+Y+NCWnmu+vr/f4LC/IDKi138tK9QbkBbibd
	 c90LSVGn5Za+DRFCNf12YHdKNzfgadJiOuAv3vP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Thierry <jthierry@redhat.com>,
	Will Deacon <will@kernel.org>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 322/355] arm64: insn: Add barrier encodings
Date: Mon, 23 Jun 2025 15:08:43 +0200
Message-ID: <20250623130636.441828377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Thierry <jthierry@redhat.com>

[ Upstream commit d4b217330d7e0320084ff04c8491964f1f68980a ]

Create necessary functions to encode/decode aarch64 barrier
instructions.

DSB needs special case handling as it has multiple encodings.

Signed-off-by: Julien Thierry <jthierry@redhat.com>
Link: https://lore.kernel.org/r/20210303170536.1838032-7-jthierry@redhat.com
[will: Don't reject DSB #4]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -370,6 +370,14 @@ __AARCH64_INSN_FUNCS(eret_auth,	0xFFFFFB
 __AARCH64_INSN_FUNCS(mrs,	0xFFF00000, 0xD5300000)
 __AARCH64_INSN_FUNCS(msr_imm,	0xFFF8F01F, 0xD500401F)
 __AARCH64_INSN_FUNCS(msr_reg,	0xFFF00000, 0xD5100000)
+__AARCH64_INSN_FUNCS(dmb,	0xFFFFF0FF, 0xD50330BF)
+__AARCH64_INSN_FUNCS(dsb_base,	0xFFFFF0FF, 0xD503309F)
+__AARCH64_INSN_FUNCS(dsb_nxs,	0xFFFFF3FF, 0xD503323F)
+__AARCH64_INSN_FUNCS(isb,	0xFFFFF0FF, 0xD50330DF)
+__AARCH64_INSN_FUNCS(sb,	0xFFFFFFFF, 0xD50330FF)
+__AARCH64_INSN_FUNCS(clrex,	0xFFFFF0FF, 0xD503305F)
+__AARCH64_INSN_FUNCS(ssbb,	0xFFFFFFFF, 0xD503309F)
+__AARCH64_INSN_FUNCS(pssbb,	0xFFFFFFFF, 0xD503349F)
 
 #undef	__AARCH64_INSN_FUNCS
 
@@ -381,6 +389,19 @@ static inline bool aarch64_insn_is_adr_a
 	return aarch64_insn_is_adr(insn) || aarch64_insn_is_adrp(insn);
 }
 
+static inline bool aarch64_insn_is_dsb(u32 insn)
+{
+	return aarch64_insn_is_dsb_base(insn) || aarch64_insn_is_dsb_nxs(insn);
+}
+
+static inline bool aarch64_insn_is_barrier(u32 insn)
+{
+	return aarch64_insn_is_dmb(insn) || aarch64_insn_is_dsb(insn) ||
+	       aarch64_insn_is_isb(insn) || aarch64_insn_is_sb(insn) ||
+	       aarch64_insn_is_clrex(insn) || aarch64_insn_is_ssbb(insn) ||
+	       aarch64_insn_is_pssbb(insn);
+}
+
 int aarch64_insn_read(void *addr, u32 *insnp);
 int aarch64_insn_write(void *addr, u32 insn);
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);


