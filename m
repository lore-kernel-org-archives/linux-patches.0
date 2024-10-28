Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AFB18E04F;
	Mon, 28 Oct 2024 06:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097742; cv=none; b=DXKtnShjXlYHMD3VSh0EwMYmbRVPBnOj59ax1d5b592mnmZCcxolfuTSDbolZdiKS82+o52f1tWtABOyEMJsMMfv+SgG1/9CRvLwENZgmSNAiAaJ3R0hnl8I/B6a0nt7gFvF/cwrdhfjInO3sArSds8GokkXLQvMTYRfCjGX/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097742; c=relaxed/simple;
	bh=Hy2LOGRGU2WUAdVPDiOiSHhLK+U4f74ep2hdMtGqckg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAJ3cTYjr2Z4gMAyBn6Uf820zo+HDUwgWQ38/s+D3mcMowdu9tZwTpKIIU8I6VYrkG+kb2xlqSfcIrF/ATYq8+Ua7LKGtSlo4DnzUuukzCT/h2D3r2MytrnlLbxXYhuz40gY6R6xm1fcxpROQqkQBLZh8C2H+l9S0VlBX0Py//I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4Y+ScZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4Y+ScZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7EFC4CEC3;
	Mon, 28 Oct 2024 06:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097741;
	bh=Hy2LOGRGU2WUAdVPDiOiSHhLK+U4f74ep2hdMtGqckg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4Y+ScZzTfAvxdHJAoa8qe9BIl/UmaMUdGRyl7uArQEifxC5LQwqKR2eM3MYh5O8g
	 EOkjNOQ8tGdHsPaJo9BKK1DIGVsLx2TM3IOmRI0uGUKqhoj/jup20P1Q4lQBGeXHaA
	 XmA7NRqt9pcys850Qvyh9Y6D78ewwR8DugYZ4el0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/208] LoongArch: Dont crash in stack_top() for tasks without vDSO
Date: Mon, 28 Oct 2024 07:25:07 +0100
Message-ID: <20241028062309.770191983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 134475a9ab8487527238d270639a8cb74c10aab2 ]

Not all tasks have a vDSO mapped, for example kthreads never do. If such
a task ever ends up calling stack_top(), it will derefence the NULL vdso
pointer and crash.

This can for example happen when using kunit:

	[<9000000000203874>] stack_top+0x58/0xa8
	[<90000000002956cc>] arch_pick_mmap_layout+0x164/0x220
	[<90000000003c284c>] kunit_vm_mmap_init+0x108/0x12c
	[<90000000003c1fbc>] __kunit_add_resource+0x38/0x8c
	[<90000000003c2704>] kunit_vm_mmap+0x88/0xc8
	[<9000000000410b14>] usercopy_test_init+0xbc/0x25c
	[<90000000003c1db4>] kunit_try_run_case+0x5c/0x184
	[<90000000003c3d54>] kunit_generic_run_threadfn_adapter+0x24/0x48
	[<900000000022e4bc>] kthread+0xc8/0xd4
	[<9000000000200ce8>] ret_from_kernel_thread+0xc/0xa4

Fixes: 803b0fc5c3f2 ("LoongArch: Add process management")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/process.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index f2ff8b5d591e4..6e58f65455c7c 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -293,13 +293,15 @@ unsigned long stack_top(void)
 {
 	unsigned long top = TASK_SIZE & PAGE_MASK;
 
-	/* Space for the VDSO & data page */
-	top -= PAGE_ALIGN(current->thread.vdso->size);
-	top -= VVAR_SIZE;
-
-	/* Space to randomize the VDSO base */
-	if (current->flags & PF_RANDOMIZE)
-		top -= VDSO_RANDOMIZE_SIZE;
+	if (current->thread.vdso) {
+		/* Space for the VDSO & data page */
+		top -= PAGE_ALIGN(current->thread.vdso->size);
+		top -= VVAR_SIZE;
+
+		/* Space to randomize the VDSO base */
+		if (current->flags & PF_RANDOMIZE)
+			top -= VDSO_RANDOMIZE_SIZE;
+	}
 
 	return top;
 }
-- 
2.43.0



