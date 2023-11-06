Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D0620316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIf91UCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F87C433C8;
	Mon,  6 Nov 2023 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276417;
	bh=R3/HaF7Zbvff6eestCHDKl981YMRvZ76owApH7Z5jHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIf91UCxvpSblr2ma8ylk31zE6IktmUxIj/PKC6g2IdopsKZj54Pj2YMSYAayARkv
	 weQkdcX9TpE6VLLmfZMZg/C4YzNH+qw32YRpG3ua6PeDv+pOCUmLw8+dqSZeWu5IGb
	 yeFgGSR3mx8FW6M2+L3VQB0T8a43TVGhhf9CfO1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/62] powerpc/85xx: Fix math emulation exception
Date: Mon,  6 Nov 2023 14:03:14 +0100
Message-ID: <20231106130302.113159553@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

[ Upstream commit 8e8a12ecbc86700b5e1a3596ce2b3c43dafad336 ]

Booting mpc85xx_defconfig kernel on QEMU leads to:

Bad trap at PC: fe9bab0, SR: 2d000, vector=800
awk[82]: unhandled trap (5) at 0 nip fe9bab0 lr fe9e01c code 5 in libc-2.27.so[fe5a000+17a000]
awk[82]: code: 3aa00000 3a800010 4bffe03c 9421fff0 7ca62b78 38a00000 93c10008 83c10008
awk[82]: code: 38210010 4bffdec8 9421ffc0 7c0802a6 <fc00048e> d8010008 4815190d 93810030
Trace/breakpoint trap
WARNING: no useful console

This is because allthough CONFIG_MATH_EMULATION is selected,
Exception 800 calls unknown_exception().

Call emulation_assist_interrupt() instead.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/066caa6d9480365da9b8ed83692d7101e10ac5f8.1695657339.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_85xx.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_85xx.S b/arch/powerpc/kernel/head_85xx.S
index 52c0ab416326a..0e16aea7853b8 100644
--- a/arch/powerpc/kernel/head_85xx.S
+++ b/arch/powerpc/kernel/head_85xx.S
@@ -394,7 +394,7 @@ interrupt_base:
 #ifdef CONFIG_PPC_FPU
 	FP_UNAVAILABLE_EXCEPTION
 #else
-	EXCEPTION(0x0800, FP_UNAVAIL, FloatingPointUnavailable, unknown_exception)
+	EXCEPTION(0x0800, FP_UNAVAIL, FloatingPointUnavailable, emulation_assist_interrupt)
 #endif
 
 	/* System Call Interrupt */
-- 
2.42.0



