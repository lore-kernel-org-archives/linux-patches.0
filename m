Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA39E31721
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07B1M5sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971B2C433C9;
	Wed, 15 Nov 2023 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076791;
	bh=T/7/utmSKULTzFarOoroD50NCEyurASFL14ixeMggNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07B1M5smfdJrlB0WSH5HgH7ArmNRTfp3NgeE8r6PeQ7FTa1wcTwIB8PNCEOEQr/R2
	 Ie36otHEVF3TRw2Po6f4dkBAH8w5Pmjv05TlUq3haTzkGwBStI/ZqpBvt9U/vlgidJ
	 ok45s2uO2n5OhqGvHckhU7yjW0t5X9X9W+5xkTYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 422/550] powerpc: Only define __parse_fpscr() when required
Date: Wed, 15 Nov 2023 14:16:46 -0500
Message-ID: <20231115191630.016654029@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit c7e0d9bb9154c6e6b2ac8746faba27b53393f25e ]

Clang 17 reports:

arch/powerpc/kernel/traps.c:1167:19: error: unused function '__parse_fpscr' [-Werror,-Wunused-function]

__parse_fpscr() is called from two sites. First call is guarded
by #ifdef CONFIG_PPC_FPU_REGS

Second call is guarded by CONFIG_MATH_EMULATION which selects
CONFIG_PPC_FPU_REGS.

So only define __parse_fpscr() when CONFIG_PPC_FPU_REGS is defined.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309210327.WkqSd5Bq-lkp@intel.com/
Fixes: b6254ced4da6 ("powerpc/signal: Don't manage floating point regs when no FPU")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/5de2998c57f3983563b27b39228ea9a7229d4110.1695385984.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 109b93874df92..5455e819fb76b 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1164,6 +1164,7 @@ static void emulate_single_step(struct pt_regs *regs)
 		__single_step_exception(regs);
 }
 
+#ifdef CONFIG_PPC_FPU_REGS
 static inline int __parse_fpscr(unsigned long fpscr)
 {
 	int ret = FPE_FLTUNK;
@@ -1190,6 +1191,7 @@ static inline int __parse_fpscr(unsigned long fpscr)
 
 	return ret;
 }
+#endif
 
 static void parse_fpe(struct pt_regs *regs)
 {
-- 
2.42.0



