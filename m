Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DAB223DC6;
	Sat, 30 May 2026 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164829; cv=none; b=LQ3oZKbWvhKuQPKe6Y9SFZ1qnOKBxlvD2odu9sbhVs7vtijzwNfdqzzA3vbV7MaYhC7otATLlwOpcrXyedmfCCmRDeDgCEiVdpKNAkPgTe6XMqeNQlht7v803jDVVmJ2lFdm9F2mzi7jc4fpSOhyC/3IqDDRmcqExgkk7Ijo/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164829; c=relaxed/simple;
	bh=QBsv9wtkW6bU0c0uB8ht6r8JcOVDW7U1jKP6LZrkRwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEEA04fHzg6jUIn1+iiCJBUDFLHGs2++gTl6YhWThJJ/eUjvJ84Jwm45AHZsO2R5iSC8/HWCF+GW2D+3sf7JYlvP9c0uISwbCwZmnqQu8BGbwHN0BLICy4LoXgzPJ+tQ7eeaPT+sN9ouTA3a1P++4o2KdD4ky2V62vW1ZRlQZCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVydT2Hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVydT2Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6836D1F00893;
	Sat, 30 May 2026 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164828;
	bh=YR4/qBRxGM7wwX8FXcpzRIh9Gukr7QD9ZUiHEw4j2lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVydT2Hbplqhn1v6+TPP84StSqnXDLsRI/e2CBoYX4zE8w9y6U0pRas1zD5Cp1i3/
	 bJq9Z/FtuOwMN7MDUEoZNzoaggM3rSoHXlZ5+A4gWjGAlY3LdAhVH5DHUIekxehGxA
	 FpRiYqJUmLGpdsVzULTPHEP5SkJ9QQWzyvgK1gSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 671/776] Revert "x86/vdso: Fix output operand size of RDPID"
Date: Sat, 30 May 2026 18:06:25 +0200
Message-ID: <20260530160257.218073240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 64f14b1ab6f39a704b62bf9b3fa28803cf2b3ebe.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/segment.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 879be4ffa06c7..8dd8e8ec9fa55 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -242,7 +242,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned long p;
+	unsigned int p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -252,10 +252,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 	 *
 	 * If RDPID is available, use it.
 	 */
-	alternative_io ("lsl %[seg],%k[p]",
-			"rdpid %[p]",
+	alternative_io ("lsl %[seg],%[p]",
+			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
 			X86_FEATURE_RDPID,
-			[p] "=r" (p), [seg] "r" (__CPUNODE_SEG));
+			[p] "=a" (p), [seg] "r" (__CPUNODE_SEG));
 
 	if (cpu)
 		*cpu = (p & VDSO_CPUNODE_MASK);
-- 
2.53.0



