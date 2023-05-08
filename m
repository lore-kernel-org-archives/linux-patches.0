Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F03168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A308C4339B;
	Mon,  8 May 2023 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544926;
	bh=6EqJm2dJjY+78HdD8pFBr6H0+KwFIzPqPEM60dGxS/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfY8/hLp07ouq+FXe1GgS9D0bTyDfPtEMDewwk+/Fr5VmzC5u/SY9oQKV5QNXV7ok
	 JbVB4oHqJpHhf2Wp5KLB9SiCnDe0soskZwru+EnjIMYShmeRWMVRwBbv1AZb7BOe+K
	 i2/ZGZdNwMMXP7A8bUSUjY6gs8a3XeS92+QxF0fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 567/694] Revert "objtool: Support addition to set CFA base"
Date: Mon,  8 May 2023 11:46:42 +0200
Message-Id: <20230508094453.186998408@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e18398e80c73e3cc7d9c3d2e0bc06a4af8f4f1cb ]

Commit 468af56a7bba ("objtool: Support addition to set CFA base") was
added as a preparatory patch for arm64 support, but that support never
came.  It triggers a false positive warning on x86, so just revert it
for now.

Fixes the following warning:

  vmlinux.o: warning: objtool: cdce925_regmap_i2c_write+0xdb: stack state mismatch: cfa1=4+120 cfa2=5+40

Fixes: 468af56a7bba ("objtool: Support addition to set CFA base")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/oe-kbuild-all/202304080538.j5G6h1AB-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f937be1afe65c..f62b85832ae01 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2976,17 +2976,6 @@ static int update_cfi_state(struct instruction *insn,
 				break;
 			}
 
-			if (!cfi->drap && op->src.reg == CFI_SP &&
-			    op->dest.reg == CFI_BP && cfa->base == CFI_SP &&
-			    check_reg_frame_pos(&regs[CFI_BP], -cfa->offset + op->src.offset)) {
-
-				/* lea disp(%rsp), %rbp */
-				cfa->base = CFI_BP;
-				cfa->offset -= op->src.offset;
-				cfi->bp_scratch = false;
-				break;
-			}
-
 			if (op->src.reg == CFI_SP && cfa->base == CFI_SP) {
 
 				/* drap: lea disp(%rsp), %drap */
-- 
2.39.2



