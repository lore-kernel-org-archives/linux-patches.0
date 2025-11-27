Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2AA28135D;
	Thu, 27 Nov 2025 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255863; cv=none; b=eikwizXRgUTLCeT9EFMZcLNwAdKkNKrwSTeEbbIBtGmmLkp5ymqf36aV8MeOsqq546XT8t4hdX/REwaZOkBBrYDXME5mLZ669HcmGR52idgLwRu7fNeq7l0h29+eZ8uiiB6NVngBZ+kA6vLeRQIjkZwqhQyhKi7gO7lRgdQZ7Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255863; c=relaxed/simple;
	bh=pLf7rwIyCXjCPmkehp5tK+vm78DPmgAUea281SicIdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIumU+9LP9R9tz7VfHmTkaJfqeaZlSn4K2Wls4iSV7jvOzkn65hUcTISOdmp8NvSb/WK7Ai0WTc94IW1HHvOuImlfOVs5ZR3JXQ8PglTTOQ1gWJg2gkw+rNuoxjy2kbMNOiYLD0qgysBk2HWm0sDjzlQHvlK0Hi8cLu+kVkWf0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08LbbNRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08LbbNRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36C3C4CEF8;
	Thu, 27 Nov 2025 15:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255863;
	bh=pLf7rwIyCXjCPmkehp5tK+vm78DPmgAUea281SicIdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08LbbNRQjnNNHz7u5bew8Fwc6dLQhSOqsEnx4f1Cg1uU+03yXQkuT9oAHk4UxPg8S
	 66AD2u75uc1T3qPsUKgvU3Meddr7+V+rfkAuxn1EdIAktqDRwRGUmWqtoJwqho7ehE
	 p2zaLEzv/rS9MqBTmHVZMnn2rG4p6/QxC9moR0lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/175] MIPS: kernel: Fix random segmentation faults
Date: Thu, 27 Nov 2025 15:46:26 +0100
Message-ID: <20251127144047.816234013@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 14b46ba92bf547508b4a49370c99aba76cb53b53 ]

Commit 69896119dc9d ("MIPS: vdso: Switch to generic storage
implementation") switches to a generic vdso storage, which increases
the number of data pages from 1 to 4. But there is only one page
reserved, which causes segementation faults depending where the VDSO
area is randomized to. To fix this use the same size of reservation
and allocation of the VDSO data pages.

Fixes: 69896119dc9d ("MIPS: vdso: Switch to generic storage implementation")
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 29191fa1801e2..a3101f2268c6c 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -692,7 +692,7 @@ unsigned long mips_stack_top(void)
 	/* Space for the VDSO, data page & GIC user page */
 	if (current->thread.abi) {
 		top -= PAGE_ALIGN(current->thread.abi->vdso->size);
-		top -= PAGE_SIZE;
+		top -= VDSO_NR_PAGES * PAGE_SIZE;
 		top -= mips_gic_present() ? PAGE_SIZE : 0;
 
 		/* Space to randomize the VDSO base */
-- 
2.51.0



