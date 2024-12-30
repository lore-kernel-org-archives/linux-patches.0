Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A71F15E8B;
	Mon, 30 Dec 2024 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573600; cv=none; b=pv3fpZ7Hdxtubpi0qrl9wvtbxR2qFqhtnES2q3ZsHX8u7naBY48wNhBuRrZNhOaofy2DwTmqMoVcJlUlWzk4xlpoLSWz67q0TX94kO0HPhoigy07HXQBQbV0Ey2WeC7U4pcN4koZFZzi7BMhpbDTbjcJs1hBl8I6mVkybbsAWRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573600; c=relaxed/simple;
	bh=bpnABYcvh86ezJXCLSEBxSEs3H8XWOAAjHudOwjP+ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwAcrpL18TEZRC62XZun4AYDy6nsc0Ncx+LSvxG0s63KpfIGSj/epQ+yt2ni/ZJubI5W0EOg4JKM9SEYmUe/F/TryGxcoSqc6xP/kHDb75CUmgGHOxuL3j9b4JZNZ1GwcYkymGsp1V3Ito0jgzbCmO1xP3kvSVTTlPqpG/u1e5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxQAUeQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxQAUeQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4759C4CED0;
	Mon, 30 Dec 2024 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573600;
	bh=bpnABYcvh86ezJXCLSEBxSEs3H8XWOAAjHudOwjP+ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxQAUeQVnMoJ67UOo4vy5fKhYzyg3cLfGzG3sa0UisF/E1WX00c4bVYn9MQTK1sby
	 1BRx00PQXpxWwU401hLewoLgxKCFpF4BMDygknojyNaQFPEPWJ5D1DRYiI7IWWxmfw
	 zUAY0ZhmoylByUcAXMO92/jg0ETzsXwg8QzqXGtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/60] MIPS: mipsregs: Set proper ISA level for virt extensions
Date: Mon, 30 Dec 2024 16:42:51 +0100
Message-ID: <20241230154208.839382011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit a640d6762a7d404644201ebf6d2a078e8dc84f97 ]

c994a3ec7ecc ("MIPS: set mips32r5 for virt extensions") setted
some instructions in virt extensions to ISA level mips32r5.

However TLB related vz instructions was leftover, also this
shouldn't be done to a R5 or R6 kernel buid.

Reorg macros to set ISA level as needed when _ASM_SET_VIRT
is called.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mipsregs.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 99eeafe6dcab..c60e72917a28 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -2078,7 +2078,14 @@ do {									\
 		_ASM_INSN_IF_MIPS(0x4200000c)				\
 		_ASM_INSN32_IF_MM(0x0000517c)
 #else	/* !TOOLCHAIN_SUPPORTS_VIRT */
-#define _ASM_SET_VIRT ".set\tvirt\n\t"
+#if MIPS_ISA_REV >= 5
+#define _ASM_SET_VIRT_ISA
+#elif defined(CONFIG_64BIT)
+#define _ASM_SET_VIRT_ISA ".set\tmips64r5\n\t"
+#else
+#define _ASM_SET_VIRT_ISA ".set\tmips32r5\n\t"
+#endif
+#define _ASM_SET_VIRT _ASM_SET_VIRT_ISA ".set\tvirt\n\t"
 #define _ASM_SET_MFGC0	_ASM_SET_VIRT
 #define _ASM_SET_DMFGC0	_ASM_SET_VIRT
 #define _ASM_SET_MTGC0	_ASM_SET_VIRT
@@ -2099,7 +2106,6 @@ do {									\
 ({ int __res;								\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips32r5\n\t"					\
 		_ASM_SET_MFGC0						\
 		"mfgc0\t%0, " #source ", %1\n\t"			\
 		_ASM_UNSET_MFGC0					\
@@ -2113,7 +2119,6 @@ do {									\
 ({ unsigned long long __res;						\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips64r5\n\t"					\
 		_ASM_SET_DMFGC0						\
 		"dmfgc0\t%0, " #source ", %1\n\t"			\
 		_ASM_UNSET_DMFGC0					\
@@ -2127,7 +2132,6 @@ do {									\
 do {									\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips32r5\n\t"					\
 		_ASM_SET_MTGC0						\
 		"mtgc0\t%z0, " #register ", %1\n\t"			\
 		_ASM_UNSET_MTGC0					\
@@ -2140,7 +2144,6 @@ do {									\
 do {									\
 	__asm__ __volatile__(						\
 		".set\tpush\n\t"					\
-		".set\tmips64r5\n\t"					\
 		_ASM_SET_DMTGC0						\
 		"dmtgc0\t%z0, " #register ", %1\n\t"			\
 		_ASM_UNSET_DMTGC0					\
-- 
2.39.5



