Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226B11D13A;
	Mon, 18 Dec 2023 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/qBI27v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC6CC433C8;
	Mon, 18 Dec 2023 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908232;
	bh=0gJXVNIPKaVhnQf0xEIynHeSKslS74770FWH9BfZWD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/qBI27v6cToOGqStL/rNslajrNEkuTYJq99VC9nZ4bwIIOUf0dgtFkBbTmJ/uuSN
	 0n0lE2P3iAhyBBg5COAL01C5P3i23kyOsvw2vSSJWSIi84Z9I/qnvbjJTJLhpDSZ8B
	 6cgkoE2p9HMtMFB8jRx09zpGMqOFB785ST/IxYoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/166] LoongArch: Record pc instead of offset in la_abs relocation
Date: Mon, 18 Dec 2023 14:51:08 +0100
Message-ID: <20231218135109.568316073@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: WANG Rui <wangrui@loongson.cn>

[ Upstream commit aa0cbc1b506b090c3a775b547c693ada108cc0d7 ]

To clarify, the previous version functioned flawlessly. However, it's
worth noting that the LLVM's LoongArch backend currently lacks support
for cross-section label calculations. With this patch, we enable the use
of clang to compile relocatable kernels.

Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/asmmacro.h | 3 +--
 arch/loongarch/include/asm/setup.h    | 2 +-
 arch/loongarch/kernel/relocate.c      | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/asmmacro.h b/arch/loongarch/include/asm/asmmacro.h
index c9544f358c339..655db7d7a4279 100644
--- a/arch/loongarch/include/asm/asmmacro.h
+++ b/arch/loongarch/include/asm/asmmacro.h
@@ -609,8 +609,7 @@
 	lu32i.d	\reg, 0
 	lu52i.d	\reg, \reg, 0
 	.pushsection ".la_abs", "aw", %progbits
-	768:
-	.dword	768b-766b
+	.dword	766b
 	.dword	\sym
 	.popsection
 #endif
diff --git a/arch/loongarch/include/asm/setup.h b/arch/loongarch/include/asm/setup.h
index a0bc159ce8bdc..ee52fb1e99631 100644
--- a/arch/loongarch/include/asm/setup.h
+++ b/arch/loongarch/include/asm/setup.h
@@ -25,7 +25,7 @@ extern void set_merr_handler(unsigned long offset, void *addr, unsigned long len
 #ifdef CONFIG_RELOCATABLE
 
 struct rela_la_abs {
-	long offset;
+	long pc;
 	long symvalue;
 };
 
diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index 6c3eff9af9fb1..288b739ca88dd 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -52,7 +52,7 @@ static inline void __init relocate_absolute(long random_offset)
 	for (p = begin; (void *)p < end; p++) {
 		long v = p->symvalue;
 		uint32_t lu12iw, ori, lu32id, lu52id;
-		union loongarch_instruction *insn = (void *)p - p->offset;
+		union loongarch_instruction *insn = (void *)p->pc;
 
 		lu12iw = (v >> 12) & 0xfffff;
 		ori    = v & 0xfff;
-- 
2.43.0



