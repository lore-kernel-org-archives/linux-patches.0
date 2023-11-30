Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D273161FA8;
	Thu, 30 Nov 2023 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpcYcGFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B1DC433CC;
	Thu, 30 Nov 2023 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385110;
	bh=EUwWw4yzJwWBZgXmraEmC5l+oNo9pQipjHMv0LstRcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PpcYcGFMaaQneglWphdkpuTXsMLnbORcQJsa7HjtkFUXUrzipK6hN1YchK/Sw9V3W
	 ql32MMf4BjXzeoMARENcG967H2rHfloh/Dj2dCzAyDgK+dki3yBMxZZYKt/lJMDO9E
	 BjucFERe5NcXUAIWNg9D4P9GDcQ1joYfmrNrEApZz1mPrFr2Le2AwnNjbphS8iV/Bi
	 amS1X4d0xG2ehPNMYlzICEuIHwfzUM29CRNTPVPiprWpEYgWD4bDYfPqtZqkktx0Y1
	 ZoP4+zp1I8GP3hUpO389aIlmS1KQky2Dmz+8rYAjLqTmoLqu+KDxdGxz4BseVjxDfp
	 Q43/qAzoKftoA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:24 -0700
Subject: [PATCH 11/19] hexagon: signal: Switch to SYSCALL_DEFINE0 for
 sys_rt_sigreturn()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-11-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1213; i=nathan@kernel.org;
 h=from:subject:message-id; bh=EUwWw4yzJwWBZgXmraEmC5l+oNo9pQipjHMv0LstRcI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn2O649dtf0zzapDZ4LC39INDp2t/PUab6wN5x4qk
 GnOvObRUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbCfp6R4catS0lT4w/YOjof
 XdK9RLFVTVrV8crTGd+3/rd94Tuh1ZWRYYHcpPvmUX7ePEnJq7cUW/84WtWf/Gi238wS//X6Iiw
 VXAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/signal.c:223:16: warning: no previous prototype for function 'sys_rt_sigreturn' [-Wmissing-prototypes]
    223 | asmlinkage int sys_rt_sigreturn(void)
        |                ^
  arch/hexagon/kernel/signal.c:223:12: note: declare 'static' if the function is not intended to be used outside of this translation unit
    223 | asmlinkage int sys_rt_sigreturn(void)
        |            ^
        |            static
  1 warning generated.

Switch to the SYSCALL_DEFINE0() macro, which automatically declares a
prototype.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index bcba31e9e0ae..d301f4621553 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -220,7 +220,7 @@ void do_signal(struct pt_regs *regs)
  * Architecture-specific wrappers for signal-related system calls
  */
 
-asmlinkage int sys_rt_sigreturn(void)
+SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;

-- 
2.43.0

