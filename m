Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024732FDC5E;
	Sat, 30 May 2026 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162146; cv=none; b=Qyl6dZAIta3A9f/gXkt1a8CfEvN7yBOP3knK5qWajtwin+gw5drrnIGl90K/cpMpgmGzOwhG0BpNeM8E3+cR4qRnJqnJDvhr1+bQ9KkGe5GSDnGVRIzKR1yuyhoK1PX6xraOMKdhP1P8alK5z6Zq7rlZ7ipMezS0aUi5Ck74T3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162146; c=relaxed/simple;
	bh=bhTVasjP9OZ5aAlsHxbfHMnjGHEzwglFX0KI4Zirdi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtBodohxF/G0oMe3mLIC56+zQQg9vbYWTmbjxgGk8A4RywnPGxLnX289RdxP31eTzOv75t5bFD3c0DpODwkJDm/vxDXjpp/BfSTDpeL/WciJUYw6s72mdiVWlqdzsW+ZOs23vimfzpmgSipu3ezZ4rxi9PLet3OFpbvaASlHgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+kpCr9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+kpCr9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D34B1F00893;
	Sat, 30 May 2026 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162145;
	bh=hokq08pwkrQFuBL1XeXh9A8m0xU4O7hd9Gn4L9EOt2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+kpCr9ZJONt7VzqK8Zlmi7Ek+07m6Y/66zkN+8rOtqlYyHbHNuwAzXsEccgfbdxR
	 wrRRdy8rCNOuKeUUzM2ZuI41tT292/TOXA9dBJ5jqAjFzTuTSVItbBeDVipDrlRGqn
	 fPnB/bSR6jBaugZ2lcEJ08ulvyCVrF5yKVY6OZZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 835/969] Revert "x86/vdso: Fix output operand size of RDPID"
Date: Sat, 30 May 2026 18:05:59 +0200
Message-ID: <20260530160323.707175408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 757a9e78a1c5b824d0a2b7de14c3cd8d841dfbee.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/segment.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 7865f180eb087..2e7890dd58a47 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -243,7 +243,7 @@ static inline unsigned long vdso_encode_cpunode(int cpu, unsigned long node)
 
 static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 {
-	unsigned long p;
+	unsigned int p;
 
 	/*
 	 * Load CPU and node number from the GDT.  LSL is faster than RDTSCP
@@ -253,10 +253,10 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
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



