Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BED18FC65;
	Mon, 28 Oct 2024 06:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097330; cv=none; b=nUZzNGyk2s1ZEI6WD6oX3oYvxigz6S8A1kfT05E6uIQX6Sz4Gh7GfxywiDC6YS6i76ebldRni/8aTlv8BluPnv255U/zo5JPbkHGcV7xiPWbd9YbHNwVYoULjbSR5NKfmx9mYbgIufA/rC3PREbD4J2hL5btsxwQ407bO5pYA6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097330; c=relaxed/simple;
	bh=l58fGSZBVrYzpiN4IAhgiv2fOqekJTL1qAVsgxgK2/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLz2JbBG2RLq3So4PW24WoUfaXagJ6Uvh5HrjtjTQIoMTuFGtSAhTzp6TrqQuMhzU7cW1SzQbdDBfTbgBOoCW9aKLNaSnNhMKibpUslq/5d4BYuztt1V83fqe93Lz7uLfV9CVjesX2tXe2w856btVIE8tCof/Y342Ofk39cF+IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd6DetGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd6DetGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FD6C4CEC3;
	Mon, 28 Oct 2024 06:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097330;
	bh=l58fGSZBVrYzpiN4IAhgiv2fOqekJTL1qAVsgxgK2/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yd6DetGwOZY7GDDBivTsuXdwqUkwmJM2Melo0w0jopDxGT7GWMABTUovOIEDODvEm
	 y3qiRGgb05N1RcFRU9EOkMVPXEenE0x6fzn5zuL2BjjOoryPgIHx4apCnvR5OSrDjq
	 opMwqhF7nBps2ZR1hV4xuJxEnJEfxG6bZo5K4zC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/137] LoongArch: Dont crash in stack_top() for tasks without vDSO
Date: Mon, 28 Oct 2024 07:25:20 +0100
Message-ID: <20241028062301.054498754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
index 51176e5ecee59..4561bc81c0639 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -271,13 +271,15 @@ unsigned long stack_top(void)
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



