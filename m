Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C497E118;
	Mon,  8 Apr 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583461; cv=none; b=Wwnmy9nRuOIvlPcblqOLNb6o6KlaBdrXr2IqI+YUpKIuYpeul3hCz4XzyRfgr0M8U57U9e4jNZMPgMtZH2L0I9hhx+y4yKOX2XTc6abSOUMyuDkZEHu9EJWvX9WdNg5b3YejtCrcBqfTgPNyCCAg0okb2QTdejNgYwM4F6amyGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583461; c=relaxed/simple;
	bh=yAImMykiGDTPsiGej3zl6X0KPFLI7JyDw14SRu6jPLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fugBs6niguMuDLlW6tXrMm1zbcua/CTacnPuyy8tObMjjKr2FD90oBpjrkmOEKTJREUAi+R0ilP9OBBHgBzkokq2k54Eer4x6DJZ4lVsWE7KAiVc2ZUooR5rSb8e7VLp6bjFNvlPCxfH4HoovPvDMPngYfrY7/7LF4lsnzb4sh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feJDF0wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feJDF0wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D7FC433C7;
	Mon,  8 Apr 2024 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583460;
	bh=yAImMykiGDTPsiGej3zl6X0KPFLI7JyDw14SRu6jPLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feJDF0wnBg04i4CYo/9/o5BMQJW9NkVxIKU9pTRtQia4lVzkYCrusL+IpF8fF+PAq
	 CjvkInh5dtV+Al4Pu6pn8AalBEByw5ysG9lplpHvFKM77EjVDevcp0LroG+CnUhW3J
	 I6g5dG7Jwc7/eG0s0TlPLd+AS91p3g7Aej2qDrkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <andrea@rivosinc.com>,
	Andy Chiu <andy.chiu@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/252] riscv: Disable preemption when using patch_map()
Date: Mon,  8 Apr 2024 14:58:17 +0200
Message-ID: <20240408125312.797908310@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit a370c2419e4680a27382d9231edcf739d5d74efc ]

patch_map() uses fixmap mappings to circumvent the non-writability of
the kernel text mapping.

The __set_fixmap() function only flushes the current cpu tlb, it does
not emit an IPI so we must make sure that while we use a fixmap mapping,
the current task is not migrated on another cpu which could miss the
newly introduced fixmap mapping.

So in order to avoid any task migration, disable the preemption.

Reported-by: Andrea Parri <andrea@rivosinc.com>
Closes: https://lore.kernel.org/all/ZcS+GAaM25LXsBOl@andrea/
Reported-by: Andy Chiu <andy.chiu@sifive.com>
Closes: https://lore.kernel.org/linux-riscv/CABgGipUMz3Sffu-CkmeUB1dKVwVQ73+7=sgC45-m0AE9RCjOZg@mail.gmail.com/
Fixes: cad539baa48f ("riscv: implement a memset like function for text")
Fixes: 0ff7c3b33127 ("riscv: Use text_mutex instead of patch_lock")
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: Puranjay Mohan <puranjay12@gmail.com>
Link: https://lore.kernel.org/r/20240326203017.310422-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/patch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 37e87fdcf6a00..30e12b310cab7 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -80,6 +80,8 @@ static int __patch_insn_set(void *addr, u8 c, size_t len)
 	 */
 	lockdep_assert_held(&text_mutex);
 
+	preempt_disable();
+
 	if (across_pages)
 		patch_map(addr + PAGE_SIZE, FIX_TEXT_POKE1);
 
@@ -92,6 +94,8 @@ static int __patch_insn_set(void *addr, u8 c, size_t len)
 	if (across_pages)
 		patch_unmap(FIX_TEXT_POKE1);
 
+	preempt_enable();
+
 	return 0;
 }
 NOKPROBE_SYMBOL(__patch_insn_set);
@@ -122,6 +126,8 @@ static int __patch_insn_write(void *addr, const void *insn, size_t len)
 	if (!riscv_patch_in_stop_machine)
 		lockdep_assert_held(&text_mutex);
 
+	preempt_disable();
+
 	if (across_pages)
 		patch_map(addr + PAGE_SIZE, FIX_TEXT_POKE1);
 
@@ -134,6 +140,8 @@ static int __patch_insn_write(void *addr, const void *insn, size_t len)
 	if (across_pages)
 		patch_unmap(FIX_TEXT_POKE1);
 
+	preempt_enable();
+
 	return ret;
 }
 NOKPROBE_SYMBOL(__patch_insn_write);
-- 
2.43.0



