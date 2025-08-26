Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34471A5BBC;
	Tue, 26 Aug 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213147; cv=none; b=Txvnpj95Zg6NAgx3ELBdlwFpOBIBDuNbHVRbkGt5xo8JXjulc/Mt2J9/G3wxucwjrXlrCPLhNBxpi5kHUEYuKzfOz2H3vo5eyV4QyzKIeHMGRg5B02abrU6y0gWhqN7IF/7u1BRMKy50dOfjPCqqlc3KJu5GRv4poeRKIePwqVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213147; c=relaxed/simple;
	bh=FtVCzTe3Nm41wzXkeg0+NbH4f9UCOuxtCaA3Uv79xqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p88EcCNQ+ssY0y/Kvzj6JgI6qHB/UOPKBV4hF5hP2wFY+bTcwBFXXP7taA4dQpgU25rWg2X/hJISQELQxf7BWUMwN9Ns9+BjG1lG149jpBYtp1aCRPQvBcojiwK/rcn+tLNVZDwkbEuC9uyY2KNNwPRlv5Lshwbe7j3jcMRI82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsFTaEiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsFTaEiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56998C4CEF1;
	Tue, 26 Aug 2025 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213146;
	bh=FtVCzTe3Nm41wzXkeg0+NbH4f9UCOuxtCaA3Uv79xqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsFTaEiYF/11nTs0+bvBBcuIcAov4hyJ2a4CCt/ZkFIsPsWpoQAAGQCdIpWfudNtk
	 0P5bQimkyb5zoqmybVg5ywsWuqXhga038V4QqJrUvm6AqpBk77AzedaScrrBSLVx4i
	 Xn9RZ0tuRTgdfFrCSpuuWnHF07+A8h5NQlZKTLhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/587] MIPS: Dont crash in stack_top() for tasks without ABI or vDSO
Date: Tue, 26 Aug 2025 13:06:28 +0200
Message-ID: <20250826110959.013459107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



