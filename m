Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218331E1A25;
	Wed,  6 Nov 2024 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898382; cv=none; b=TGzWw9HNvKi8SfiI350qagFVgxoMX65TdCNjTBmVruPfUIIyfzacTh4dIo8Ko+wy6zpqCmB8I4yso/qxarTiL2+NYdYZcQ3qWynfpJdDP+w1vViCeasybsQcESss/eW8x98wr0yezg9y9mkJ3xTw/DG59XQfJAJZQX0QPCTl3Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898382; c=relaxed/simple;
	bh=vPpcV41TTNLVw0a12Vzg8kEPZhLxS0bW3Mnlv8E3XcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeIsLfAETaAJ4W16rTG4QoTJAQrj+Ay2Y6mQr0cF5jRg6MlWkbfdh1uDcDbfcGx4UT0TS1QXlsn7w0BXYimb1DiMOWuJjH0HClk6J9hmyesm3RxU2dKuwquKVhx+0mTtDgRdEwLK0JLxCfdRlQWvXlnVTMdvHXn/YTewUiSXTWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmcCfunu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmcCfunu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63652C4CECD;
	Wed,  6 Nov 2024 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898381;
	bh=vPpcV41TTNLVw0a12Vzg8kEPZhLxS0bW3Mnlv8E3XcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmcCfunu6DZdVakmWUSlSyphbDqvlqnGKoM49m6AlhWP78mDzB1mPCX/qo7OlV5S7
	 oCYih2X9zHGw4IEScxz2D6Fl97VhYp0t8xpIYjahptnkycA3Oclq8/9Griz/N1ZjAP
	 WhMe6e6aJeAQRwishJoxXjwii/XAHPhGLO4RLilY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/462] x86/syscall: Avoid memcpy() for ia32 syscall_get_arguments()
Date: Wed,  6 Nov 2024 13:01:51 +0100
Message-ID: <20241106120336.905725886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8db3fdb6102ec..2e7bffe9ae7d0 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -94,7 +94,12 @@ static inline void syscall_get_arguments(struct task_struct *task,
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
 
 static inline void syscall_set_arguments(struct task_struct *task,
-- 
2.43.0



