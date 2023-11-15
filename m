Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4797E3DB97
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD5+BB5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C14C433C7;
	Wed, 15 Nov 2023 19:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078387;
	bh=4jmhzfXqjGu58RmnsHDpNqQOD2xRD0NpI1CJTY3XCHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD5+BB5f4G4FzH80fqPFmiUEoHBtGKpdqOT+QpzHlh1d6Wmt+SH5b3i2NFnJo1bl/
	 /LU2Jx11MIMlRA0DYdfsmV99YlgZUfj5hEpVQOCf6WyLOmo830fcDeChthgqkImDMR
	 fk7FLGXqCqNHIdm8XaMr59grJpvu1eHMHlbX3KL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/379] powerpc: Only define __parse_fpscr() when required
Date: Wed, 15 Nov 2023 14:26:07 -0500
Message-ID: <20231115192702.416097274@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9bdd79aa51cfc..3956f32682c62 100644
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



