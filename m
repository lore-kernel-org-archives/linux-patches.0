Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF7F1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7934C433C1;
	Wed, 23 Nov 2022 09:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195943;
	bh=s+LaA2Wi8EUCX3BFfeokk0V07Q8RVJTayEln1EXQPvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ2BckttNCPs/3PaM4DtyIVuRZJqVa0GwjZIN7wAic2Ew+uRQEtpLezrxbUS3zvQ3
	 luqtvNh/waZyDplqvZmaRh/2aE1K1QFb2x5p+11DBmd4/BcZAcV3qnScQkFIxzvP5y
	 dkY2WRoifgRlol8kZHPaPKsomjlBgp1i0YrTHnWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongwei Zhang <pudh4418@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/181] MIPS: fix duplicate definitions for exported symbols
Date: Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084605.641939929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rongwei Zhang <pudh4418@gmail.com>

[ Upstream commit 612d80784fdc0c2e2ee2e2d901a55ef2f72ebf4b ]

Building with clang-14 fails with:

AS      arch/mips/kernel/relocate_kernel.o
<unknown>:0: error: symbol 'kexec_args' is already defined
<unknown>:0: error: symbol 'secondary_kexec_args' is already defined
<unknown>:0: error: symbol 'kexec_start_address' is already defined
<unknown>:0: error: symbol 'kexec_indirection_page' is already defined
<unknown>:0: error: symbol 'relocate_new_kernel_size' is already defined

It turns out EXPORT defined in asm/asm.h expands to a symbol definition,
so there is no need to define these symbols again. Remove duplicated
symbol definitions.

Fixes: 7aa1c8f47e7e ("MIPS: kdump: Add support")
Signed-off-by: Rongwei Zhang <pudh4418@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/relocate_kernel.S | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/mips/kernel/relocate_kernel.S b/arch/mips/kernel/relocate_kernel.S
index cfde14b48fd8..f5b2ef979b43 100644
--- a/arch/mips/kernel/relocate_kernel.S
+++ b/arch/mips/kernel/relocate_kernel.S
@@ -145,8 +145,7 @@ LEAF(kexec_smp_wait)
  * kexec_args[0..3] are used to prepare register values.
  */
 
-kexec_args:
-	EXPORT(kexec_args)
+EXPORT(kexec_args)
 arg0:	PTR_WD		0x0
 arg1:	PTR_WD		0x0
 arg2:	PTR_WD		0x0
@@ -159,8 +158,7 @@ arg3:	PTR_WD		0x0
  * their registers a0-a3. secondary_kexec_args[0..3] are used
  * to prepare register values.
  */
-secondary_kexec_args:
-	EXPORT(secondary_kexec_args)
+EXPORT(secondary_kexec_args)
 s_arg0: PTR_WD		0x0
 s_arg1: PTR_WD		0x0
 s_arg2: PTR_WD		0x0
@@ -171,19 +169,16 @@ kexec_flag:
 
 #endif
 
-kexec_start_address:
-	EXPORT(kexec_start_address)
+EXPORT(kexec_start_address)
 	PTR_WD		0x0
 	.size		kexec_start_address, PTRSIZE
 
-kexec_indirection_page:
-	EXPORT(kexec_indirection_page)
+EXPORT(kexec_indirection_page)
 	PTR_WD		0
 	.size		kexec_indirection_page, PTRSIZE
 
 relocate_new_kernel_end:
 
-relocate_new_kernel_size:
-	EXPORT(relocate_new_kernel_size)
+EXPORT(relocate_new_kernel_size)
 	PTR_WD		relocate_new_kernel_end - relocate_new_kernel
 	.size		relocate_new_kernel_size, PTRSIZE
-- 
2.35.1



