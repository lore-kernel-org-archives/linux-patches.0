Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA66FDE1;
	Mon, 29 Jan 2024 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548493; cv=none; b=GrhRNBe3EMJYvlwNY4q4r29FNZohhHDCPCW6WwbIG8PnkeRRbYHTu03+5iTY72ofUNtWk2UPqPfZN6d4FqQ/hMbpLnrH+GW66SZNsH5zi+Dywk2OntUB/4POgXOanN0L6OjZP48dEXXeTr6LVOoce4cpMhEHz5aqzhnLifFCkec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548493; c=relaxed/simple;
	bh=dQXpXEHJnmkDiowLvtxSMbAyhE+7AlOX7wWuGNQQ+1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AroxB4v/XlkpnmMF1CPMCt53Z6ZEEoPewS/3VEFPYe1mrWV8vMpYPsKkrjFMiZFviNrE5vDjjFjKvfh3V48lcoEt2J8bagGb6ae2eLmK77n5szKFF+PlxnRez0rJi2xwWWsr0OVPr7QlUvQi5Ng2WA/r39XoxDsdxbGzrBzGgYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr5dMz3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr5dMz3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BEEC43390;
	Mon, 29 Jan 2024 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548493;
	bh=dQXpXEHJnmkDiowLvtxSMbAyhE+7AlOX7wWuGNQQ+1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr5dMz3IUh95yK1IgCrCV8724j0ftfAA1ZOCSLGFx545PYJ5L2vlHsgjr+Tl4EFWK
	 AMYVIJHndEMjW/tWWYTqNnxDlt46tcIWJP5V0chPpJH89gcUD5HTmwvIgQ98cdC3hj
	 Ga6KL+0Fwg5f7GrDT1JZH/zpQuDqWj90M+q92lyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Leonardo Bras <leobras@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 110/331] riscv: mm: Fixup compat mode boot failure
Date: Mon, 29 Jan 2024 09:02:54 -0800
Message-ID: <20240129170018.140746268@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Guo Ren <guoren@linux.alibaba.com>

commit 5f449e245e5b0d9d63eef6c8968fbdc3a8594407 upstream.

In COMPAT mode, the STACK_TOP is DEFAULT_MAP_WINDOW (0x80000000), but
the TASK_SIZE is 0x7fff000. When the user stack is upon 0x7fff000, it
will cause a user segment fault. Sometimes, it would cause boot
failure when the whole rootfs is rv32.

Freeing unused kernel image (initmem) memory: 2236K
Run /sbin/init as init process
Starting init: /sbin/init exists but couldn't execute it (error -14)
Run /etc/init as init process
...

Increase the TASK_SIZE to cover STACK_TOP.

Cc: stable@vger.kernel.org
Fixes: add2cc6b6515 ("RISC-V: mm: Restrict address space for sv39,sv48,sv57")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231222115703.2404036-2-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -880,7 +880,7 @@ static inline pte_t pte_swp_clear_exclus
 #define TASK_SIZE_MIN	(PGDIR_SIZE_L3 * PTRS_PER_PGD / 2)
 
 #ifdef CONFIG_COMPAT
-#define TASK_SIZE_32	(_AC(0x80000000, UL) - PAGE_SIZE)
+#define TASK_SIZE_32	(_AC(0x80000000, UL))
 #define TASK_SIZE	(test_thread_flag(TIF_32BIT) ? \
 			 TASK_SIZE_32 : TASK_SIZE_64)
 #else


