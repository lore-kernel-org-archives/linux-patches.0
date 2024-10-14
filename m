Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA31CCEE4;
	Mon, 14 Oct 2024 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919044; cv=none; b=VIZbKJP+87BO/yi8FyCsc4TQBhR+/kPk63UWpCNZFMx9Wai5gnljL8PCTyJd169ac4eEFw4+hA8R6bM7FIjCnVVBFq01lbZTAsHGprILYaIPlxtYDT180nvZtDcby8zySfv4RHKLMkkztPcNV0cTFeGlbxF9bhrH9iUz0Q3GRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919044; c=relaxed/simple;
	bh=x54nBBr87G1BPUai39FoD0/C3SpvzhYxAWuB5+vkSIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tX3tEAiy3FeUGafKF3PwerrwCl3IUFJjrwfNfEoz0SYUTO/KBJyJS/SiHD1BkZloAH2JIW1uF2jK+hsp0wlxQ0IvEO5hH2irQ/qr1fuGSWr+8nvujSN0zhLRGwbuTqoiUEXGj7PzzU72tQoyNtluAKDRuUS0LfB6GLczCljZhqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Puj+9ogR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Puj+9ogR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9450DC4CEC3;
	Mon, 14 Oct 2024 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919044;
	bh=x54nBBr87G1BPUai39FoD0/C3SpvzhYxAWuB5+vkSIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Puj+9ogRPswuaVyI0yekFstCVEHGduCz3WLAvMdZ8cLGSWdVEbJtBKohI18Ndd6Z/
	 kWzZPTMeJp/qdHyKHXnIXaPRnt+al7Zf2grD9SxxeN1hA38HgA7bD2kf9ol/uaZc3F
	 yL/Pf6rqanTdVHYofWkqGSkS34f7APUosq70Widk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/798] x86/syscall: Avoid memcpy() for ia32 syscall_get_arguments()
Date: Mon, 14 Oct 2024 16:16:59 +0200
Message-ID: <20241014141236.244064988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit d19d638b1e6cf746263ef60b7d0dee0204d8216a ]

Modern (fortified) memcpy() prefers to avoid writing (or reading) beyond
the end of the addressed destination (or source) struct member:

In function ‘fortify_memcpy_chk’,
    inlined from ‘syscall_get_arguments’ at ./arch/x86/include/asm/syscall.h:85:2,
    inlined from ‘populate_seccomp_data’ at kernel/seccomp.c:258:2,
    inlined from ‘__seccomp_filter’ at kernel/seccomp.c:1231:3:
./include/linux/fortify-string.h:580:25: error: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
  580 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As already done for x86_64 and compat mode, do not use memcpy() to
extract syscall arguments from struct pt_regs but rather just perform
direct assignments. Binary output differences are negligible, and actually
ends up using less stack space:

-       sub    $0x84,%esp
+       sub    $0x6c,%esp

and less text size:

   text    data     bss     dec     hex filename
  10794     252       0   11046    2b26 gcc-32b/kernel/seccomp.o.stock
  10714     252       0   10966    2ad6 gcc-32b/kernel/seccomp.o.after

Closes: https://lore.kernel.org/lkml/9b69fb14-df89-4677-9c82-056ea9e706f5@gmail.com/
Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Link: https://lore.kernel.org/all/20240708202202.work.477-kees%40kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/syscall.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 2725a4502321b..bad79b82dfa04 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -82,7 +82,12 @@ static inline void syscall_get_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned long *args)
 {
-	memcpy(args, &regs->bx, 6 * sizeof(args[0]));
+	args[0] = regs->bx;
+	args[1] = regs->cx;
+	args[2] = regs->dx;
+	args[3] = regs->si;
+	args[4] = regs->di;
+	args[5] = regs->bp;
 }
 
 static inline int syscall_get_arch(struct task_struct *task)
-- 
2.43.0



