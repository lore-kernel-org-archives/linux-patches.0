Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB1A223DF6;
	Tue, 26 Aug 2025 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214657; cv=none; b=ueB+NFKJL9k6qBmzJ15U8yc9qhNCyLCB08QQiWgiQcZdEdtxe3EldIOE8TvXJAm6pI4dN67zvobUdl1oHjJOROT5KqdXqbYC8EmMUXfqlmXbccL4yVBxFb1ZvUKhGTT3/bD5K9YmKdu9Sra7RIAkL/MAmu82q5EYaxrUtrkGaGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214657; c=relaxed/simple;
	bh=0h6zTmlUM218uF25sfPUUm2m5uhRQ02H+OrKYduI6IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUn6kJn3Tl2qOH6nJllblaDdyoQ3dAkMrC7JnMoXdF5RREGdkbh5Af9YHKOa9VXNOqOijEUCcPxd56rbwnE8UPGGXNlMAt4GLZC80LJRYC2hu2HhHZ3vuEngEpbn3u27QbjAN4fHTcrc98Ph0xlLJAiaiWBApRgytPx7Lbzch6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl5gIYgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl5gIYgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2600C4CEF1;
	Tue, 26 Aug 2025 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214657;
	bh=0h6zTmlUM218uF25sfPUUm2m5uhRQ02H+OrKYduI6IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl5gIYgHraoKHkJkt+44N3IhhuEl7TG9Lomj5cUlYXRgQOPKZ1ggxmD2N307vCslm
	 5U/IvbBO75+kVIUht4savgV9qucq+5DDUp7cyFYbyGkMP3LPal6B1LOc1xaS26+/Xf
	 FLGBXQlf/KcLPfkiXJ/t2qE4d+5eDHK5WsLls1LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/482] MIPS: Dont crash in stack_top() for tasks without ABI or vDSO
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826110935.474923039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17d80e2f2e4c..86deab01c578 100644
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



