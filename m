Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB9B8837;
	Mon, 28 Oct 2024 06:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098272; cv=none; b=BV1u8uH/1i7GYs8SP3JVfsnGrlsqvoFDa0zw5/ZGO+D33ntprhdTPwoubtZtdQStCedJB2CImBVQh8MzKAL7GRSQGA7AMiCDay4o6OLrDpz29OWi2OQCx4FcjUn/PJhxpLfGDoGKxXX17nrYxwzcgs+QnZ3Yl/XMQhJkRmLIigg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098272; c=relaxed/simple;
	bh=1LDit7OxT6lI63a/+PTgkbJSjdijO6eTCOzlCKIyBNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ny6kFy7mgKd+8RGGd1wIjvYEQYvQFQRxddyeEUIvlHxN4lpIDN6prdB5Hkbtz0/wW9OvwDmMqmAE2jh4o1QFpD9ajeFWr97s/mu7atSpMmKixEBusopiAmu3JXCAW2pBw2HmuOx2NqrdYKtHCMz/U2krsBsfh66eEFGGbWZMfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rd+yZnlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd+yZnlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4410C4CEC3;
	Mon, 28 Oct 2024 06:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098272;
	bh=1LDit7OxT6lI63a/+PTgkbJSjdijO6eTCOzlCKIyBNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rd+yZnlhaoKaElFJsP3gKJRK7+W34fbqNzzyngMUEb4fDc58ioKYTstireTkQFSSp
	 ZYsPd6tHS4V0f3wzUCCC0BpeDrQY2RfLXdEs40K5ZBbEfFJtQoy439c/HUMdp56rHC
	 jr/7tDa5D0sYFF0g/aG909Ulcv+v5+OxzLvJLPtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 136/261] LoongArch: Dont crash in stack_top() for tasks without vDSO
Date: Mon, 28 Oct 2024 07:24:38 +0100
Message-ID: <20241028062315.452761145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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



