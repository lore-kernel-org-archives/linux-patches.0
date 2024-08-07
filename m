Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D467F7F5;
	Wed,  7 Aug 2024 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043690; cv=none; b=sP/gZy0zYC7QVpdGx63FztCZ8ntFneoeCDP7yDybLFMVu7CEc4ZtDNi9aYsOGHN5h9LNQs1ZwrwkiSJwywHOY9dyRY9ZeVKW5WSCbFOhovVozuBIOtRcq7SNUwRFg8aTi3LTiVyFj8bPlwHGdPUW/N368FCCB6TnZK5SwD5iwmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043690; c=relaxed/simple;
	bh=vVUrIZaqBSd487uUjguB+a3sjH4WF8mVs1boFlfUk78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fv/gugUTBAWrHSfL48mFKBNOJMUpAlwEg6IIvJ1lwGYOVeMeBhdVcI8qRCwpNOoDb/y8PPTs7+kWRQSJqvBCkiguC+GNQSrf0vyshqbh8eXaTxinyvoi4fXeIL9n6c87S7gx++HXhvV4lrnnodyOKbJe1+UDx64XOS+fTHcb0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF+0lUGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF+0lUGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A742AC4AF0D;
	Wed,  7 Aug 2024 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043690;
	bh=vVUrIZaqBSd487uUjguB+a3sjH4WF8mVs1boFlfUk78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dF+0lUGRaZLqUq2zocuk061FnqLl5TvO7hhrziaqGnjP1iERIF6RarY4tZpqIHjs7
	 bb+wLEK0v8fT9nSnqpy90eH3gQf0wq5A1NeLuQxwu524QhsZAQ7VjeIZJ4crfVJEEW
	 R9SzNJXRrFg+omP+gLgwB4mDw3a46BpCpUxYydiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/86] riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()
Date: Wed,  7 Aug 2024 17:00:43 +0200
Message-ID: <20240807150041.373511735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Zhe Qiao <qiaozhe@iscas.ac.cn>

[ Upstream commit 0c710050c47d45eb77b28c271cddefc5c785cb40 ]

Handle VM_FAULT_SIGSEGV in the page fault path so that we correctly
kill the process and we don't BUG() the kernel.

Fixes: 07037db5d479 ("RISC-V: Paging and MMU")
Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240731084547.85380-1-qiaozhe@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/fault.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 274bc6dd839fa..05d7d36479648 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -60,26 +60,27 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 
 static inline void mm_fault_error(struct pt_regs *regs, unsigned long addr, vm_fault_t fault)
 {
+	if (!user_mode(regs)) {
+		no_context(regs, addr);
+		return;
+	}
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return the userspace
 		 * (which will retry the fault, or kill us if we got oom-killed).
 		 */
-		if (!user_mode(regs)) {
-			no_context(regs, addr);
-			return;
-		}
 		pagefault_out_of_memory();
 		return;
 	} else if (fault & VM_FAULT_SIGBUS) {
 		/* Kernel mode? Handle exceptions or die */
-		if (!user_mode(regs)) {
-			no_context(regs, addr);
-			return;
-		}
 		do_trap(regs, SIGBUS, BUS_ADRERR, addr);
 		return;
+	} else if (fault & VM_FAULT_SIGSEGV) {
+		do_trap(regs, SIGSEGV, SEGV_MAPERR, addr);
+		return;
 	}
+
 	BUG();
 }
 
-- 
2.43.0



