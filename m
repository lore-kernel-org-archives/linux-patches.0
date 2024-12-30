Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFE15E8B;
	Mon, 30 Dec 2024 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573855; cv=none; b=S8hujzihpehvahWiSHaPJjJ/lWWG6QQ1c1aESY3f4QSzNaEMlVFrncvbiGkSgOf1gUr0ZUBxSGvETJYqIlyHqledBfK5JkAIzSzi+6JY3YvuPsEXpgxcONy+FV5C8iDRf4dQKJStCvR+lOtStJxQCckQYiwfIlrWSTkip3yBmeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573855; c=relaxed/simple;
	bh=B1wwM255L0/cqVuLAlM1PmeFrczOkUuTERI7id7xUfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbdTubscqjoBCQck6mUPOyBpdCs4nKrcqJmscsKlrt7P1kSI0y8RwNhJ2nZhJfbVgjtp4VmANxxfbir/wgJWTHVcf3biD8ahZVEAyHP8jzpWrJva0xVBbel5MVBYUfSLbrzfUY2ePJXa6V7WVlmEu/XVdkVJycLbyX535oumA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIUEClOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIUEClOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BBAC4CED0;
	Mon, 30 Dec 2024 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573855;
	bh=B1wwM255L0/cqVuLAlM1PmeFrczOkUuTERI7id7xUfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIUEClOENdXzs/xHrTqN8bs5NBD/WvNX3++qIdcmaJu+bn/3FNNw/7uU0/stlnJB8
	 l/7c5yIHdAAj8FMn2is2XNpukJ7yr0nkdshJeOZY/MQIDWXlZuTbjxAhkCAlTCIrEX
	 vFMM0EL7oc/zYa5ECbHd31Tp2yE5GhmwkSxir1/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/86] MIPS: mipsregs: Set proper ISA level for virt extensions
Date: Mon, 30 Dec 2024 16:43:01 +0100
Message-ID: <20241230154213.738111507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d53704d9f24..e959a6b1a325 100644
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



