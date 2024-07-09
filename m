Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C61586C7;
	Tue,  9 Jul 2024 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523819; cv=none; b=rZL+750MY77z1W/SKiQdVUcRdBsr4NSRtmTA5svBvvtRuP66O5od8KkZM9KdFtAP2jJUA6H6FvbfT7zQAryVovTUEh+eLO0FHWQSzF9koUbDx7BV+OwCx9w/B2EdDSQsHQGJC2gexoNnq9IlLlQtvp6Tcd9Kp84lOc0EePdQypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523819; c=relaxed/simple;
	bh=4gu2F6Ja3ruc6OJvkDOTAxMYCOBjx8jYDGsr28f0M+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB4qK13anyitVSb+b23qnv9NEaSO5c4kz7Bu4BqfZQmtslHbqCLuiwvvQ9tkn4v3qmiag/v3Fwv6IdlwMsLkuHwXyUZ/TymbHHWjycEjzeHJo12LHbPT9e3T592rincxbW6peCFHy9bbg+7ye7WrxJPMjZvq0v5w5z7gNQyYtU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEABaKCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEABaKCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C68C3277B;
	Tue,  9 Jul 2024 11:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523819;
	bh=4gu2F6Ja3ruc6OJvkDOTAxMYCOBjx8jYDGsr28f0M+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEABaKCZQXyXxJ2POKvyH3ukoQRWYkyeWVw+sr1PX+GCZlblBxmjToutijhrNKSui
	 r9DVnpN8XHeXUsjYZ8ny1ZcClwSdawb7PoG4Bc2WQLq4iPaCdn7y2jQbHNlXk4EQFN
	 DYFJezXXeerVVDrdcH7uwmhVZVs+S57cNDx5jiZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Ryo Takakura <takakura@valinux.co.jp>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/139] riscv: kexec: Avoid deadlock in kexec crash path
Date: Tue,  9 Jul 2024 13:09:39 +0200
Message-ID: <20240709110701.230427743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Song Shuai <songshuaishuai@tinylab.org>

[ Upstream commit c562ba719df570c986caf0941fea2449150bcbc4 ]

If the kexec crash code is called in the interrupt context, the
machine_kexec_mask_interrupts() function will trigger a deadlock while
trying to acquire the irqdesc spinlock and then deactivate irqchip in
irq_set_irqchip_state() function.

Unlike arm64, riscv only requires irq_eoi handler to complete EOI and
keeping irq_set_irqchip_state() will only leave this possible deadlock
without any use. So we simply remove it.

Link: https://lore.kernel.org/linux-riscv/20231208111015.173237-1-songshuaishuai@tinylab.org/
Fixes: b17d19a5314a ("riscv: kexec: Fixup irq controller broken in kexec crash path")
Signed-off-by: Song Shuai <songshuaishuai@tinylab.org>
Reviewed-by: Ryo Takakura <takakura@valinux.co.jp>
Link: https://lore.kernel.org/r/20240626023316.539971-1-songshuaishuai@tinylab.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/machine_kexec.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index 2d139b724bc84..ccb0c5d5c63c4 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -147,20 +147,12 @@ static void machine_kexec_mask_interrupts(void)
 
 	for_each_irq_desc(i, desc) {
 		struct irq_chip *chip;
-		int ret;
 
 		chip = irq_desc_get_chip(desc);
 		if (!chip)
 			continue;
 
-		/*
-		 * First try to remove the active state. If this
-		 * fails, try to EOI the interrupt.
-		 */
-		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
-
-		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
-		    chip->irq_eoi)
+		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
 			chip->irq_eoi(&desc->irq_data);
 
 		if (chip->irq_mask)
-- 
2.43.0



