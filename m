Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02541DC046;
	Tue,  8 Oct 2024 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391662; cv=none; b=dztVm3ebc2Lk9QkIOjBXCwIYQ3hkwTjL+fIQNr2HbeIdgOHnC68Un3EJU0SXn8/sXUrdEMaoq1zNySbZnNOtkvJbhKF6AAjqHDhmZxjs/DXALvOrS8LMyElJ4VnIUs1LnRHp9RoaGXb3NaLVR0pvdge2/VNRqYvN/FydPIZOruE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391662; c=relaxed/simple;
	bh=CPMacX/Nx6GIC17zX5QpiIuFEsCI6/XdcQ8xQf4jvKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPq4joBhapP3OFg1qK3ZyO+bg5YRKcIMUcO0VzlhMqOHVBDUF5lHjDEixW7jcszQfXtfn6O6jKjtHG0jFLj8vXZzTizdTLnoLcY52AsKO7PuuC9gA9X1bqTtjs5+LpF/cot09OmPVSm1lxj+i3Aj46CuIX8mc6m8QptOWfO3ic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zl1yH7/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zl1yH7/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF76C4CECD;
	Tue,  8 Oct 2024 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391662;
	bh=CPMacX/Nx6GIC17zX5QpiIuFEsCI6/XdcQ8xQf4jvKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zl1yH7/TYG2ZX9XJ5mnIDnOI8M6d/YknPlvlb90r76t/WWnKJgyA41R9ZFcK7yG7I
	 4ksQ7wQbmtM8NEke2507DiLHjVXG6nvifCjn6xkL2t+CBaE5in9ftjCNcGGzEu2RlV
	 BENqf1DC8+wl3KFGs2NP0Pw1q64CLT85tGAxXVKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 186/558] x86/syscall: Avoid memcpy() for ia32 syscall_get_arguments()
Date: Tue,  8 Oct 2024 14:03:36 +0200
Message-ID: <20241008115709.670743850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2fc7bc3863ff6..7c488ff0c7641 100644
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



