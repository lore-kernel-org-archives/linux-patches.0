Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8931CA59;
	Mon, 18 Aug 2025 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522376; cv=none; b=PA9KMmFU0I36nwFlPop9dkKXSiiRF56Kexvq/XtuA7wHvacmug9v3lvrILK9ZkplpD4uwZK2YSY3oghqgdv3JbLweO4rb14EY4iSTYiuMsEe/XYkUepD7GcquNYTIeij0j9GmsDmuSbFN6l0C4O6mkZXYviYOxhIdtsUWV1Rnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522376; c=relaxed/simple;
	bh=JL0Ghvykjh6YAyWt/ZWSDaYwNZNSeAZwqDcsySjfTZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCs7YLbu9RIo67U6eHkitBJu41yoUq81D4OayQeC+WZTdnJVACXRhRWg4cEJakjH6gAFQYJjMVXiexzTzXNERwr0HhYdH+91iYfuGUglPjfEnCCr8GHWSi7IM/vgNw6a3Jl+kzo98mb0JCj9K/XMDEX1fR0RE4gGo2gufllolgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKTsMzxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKTsMzxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC65DC4CEEB;
	Mon, 18 Aug 2025 13:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522375;
	bh=JL0Ghvykjh6YAyWt/ZWSDaYwNZNSeAZwqDcsySjfTZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKTsMzxYUbVSLakwb4ZdLF0CouwN2wxZAMFtsW1poCkaEReooI0buLQuCcKO6xK4Q
	 hr3nWSGy9z76k1K7dO6X1anABsxKRyGdWbTm5i3jUZbjI8QZPJaN3ilPL5CtFuYmSO
	 IcpxIs+HLe7g2Yy18dyEweaS0v1yR5IIaPwuFQQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/444] MIPS: Dont crash in stack_top() for tasks without ABI or vDSO
Date: Mon, 18 Aug 2025 14:45:24 +0200
Message-ID: <20250818124500.127773624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e9f4a6b3421e936c3ee9d74710243897d74dbaa2 ]

Not all tasks have an ABI associated or vDSO mapped,
for example kthreads never do.
If such a task ever ends up calling stack_top(), it will derefence the
NULL ABI pointer and crash.

This can for example happen when using kunit:

    mips_stack_top+0x28/0xc0
    arch_pick_mmap_layout+0x190/0x220
    kunit_vm_mmap_init+0xf8/0x138
    __kunit_add_resource+0x40/0xa8
    kunit_vm_mmap+0x88/0xd8
    usercopy_test_init+0xb8/0x240
    kunit_try_run_case+0x5c/0x1a8
    kunit_generic_run_threadfn_adapter+0x28/0x50
    kthread+0x118/0x240
    ret_from_kernel_thread+0x14/0x1c

Only dereference the ABI point if it is set.

The GIC page is also included as it is specific to the vDSO.
Also move the randomization adjustment into the same conditional.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/process.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index b630604c577f..02aa6a04a21d 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -690,18 +690,20 @@ unsigned long mips_stack_top(void)
 	}
 
 	/* Space for the VDSO, data page & GIC user page */
-	top -= PAGE_ALIGN(current->thread.abi->vdso->size);
-	top -= PAGE_SIZE;
-	top -= mips_gic_present() ? PAGE_SIZE : 0;
+	if (current->thread.abi) {
+		top -= PAGE_ALIGN(current->thread.abi->vdso->size);
+		top -= PAGE_SIZE;
+		top -= mips_gic_present() ? PAGE_SIZE : 0;
+
+		/* Space to randomize the VDSO base */
+		if (current->flags & PF_RANDOMIZE)
+			top -= VDSO_RANDOMIZE_SIZE;
+	}
 
 	/* Space for cache colour alignment */
 	if (cpu_has_dc_aliases)
 		top -= shm_align_mask + 1;
 
-	/* Space to randomize the VDSO base */
-	if (current->flags & PF_RANDOMIZE)
-		top -= VDSO_RANDOMIZE_SIZE;
-
 	return top;
 }
 
-- 
2.39.5



