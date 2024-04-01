Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB543AD6;
	Mon,  1 Apr 2024 16:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988486; cv=none; b=RrSpo5NaJmlrizx2jT/PeU16Eq2U8Xl5R4UM3d17ZWW+V7YXTotIREtHYzW0bG+eApByY53bjjSHuunTjqOBE/V+MIDs3t2UCUMsCAscyoUDAdeKD79TmuHz87y7DwhHFkJaSsvHL4MnaE1BOhSNRajr2CYPtyBCsRx2vJYrIoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988486; c=relaxed/simple;
	bh=o3mz9TJ8eVGFABPUrshBN/IY+Rw6lGqrlUSjzE0UnrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnQwlgnBg3yNbyBknzTVrbJbKxDhkY/3ypwzc1EZcWIJiVTptg/tyoOOP9v5OITLQa0s+hevotIVjClOvWW2ESXEfrHL2h8LqoGMB2y+giYTj0XiJCwc9gyBCJcBIWbtTL0TpSmnOLVBTB8RaKlgIAAmAk2xfTORRvLqxuFwgbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVyzrueL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVyzrueL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE85BC433C7;
	Mon,  1 Apr 2024 16:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988486;
	bh=o3mz9TJ8eVGFABPUrshBN/IY+Rw6lGqrlUSjzE0UnrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVyzrueLljU+SOmKjpl+GzKsiAt9LGdJGD15ZVQ+eAAbmSTxtMRDLegG0v2v/u2SZ
	 7NSruOL0a2rDuKxiBYXBYPbcL6gJaECM+KXSG3ivp+SwiOURTGSwW+h63Uj6gn1LT4
	 QzzZk28yRWILt8sohvL7qO6mBKfGlhCUeqfda2pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Atish Patra <atishp@rivosinc.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 170/432] clocksource/drivers/timer-riscv: Clear timer interrupt on timer initialization
Date: Mon,  1 Apr 2024 17:42:37 +0200
Message-ID: <20240401152558.219641470@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ley Foon Tan <leyfoon.tan@starfivetech.com>

[ Upstream commit 8248ca30ef89f9cc74ace62ae1b9a22b5f16736c ]

In the RISC-V specification, the stimecmp register doesn't have a default
value. To prevent the timer interrupt from being triggered during timer
initialization, clear the timer interrupt by writing stimecmp with a
maximum value.

Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ley Foon Tan <leyfoon.tan@starfivetech.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240306172330.255844-1-leyfoon.tan@starfivetech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 57857c0dfba97..1c732479a2c8d 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -101,6 +101,9 @@ static int riscv_timer_starting_cpu(unsigned int cpu)
 {
 	struct clock_event_device *ce = per_cpu_ptr(&riscv_clock_event, cpu);
 
+	/* Clear timer interrupt */
+	riscv_clock_event_stop();
+
 	ce->cpumask = cpumask_of(cpu);
 	ce->irq = riscv_clock_event_irq;
 	if (riscv_timer_cannot_wake_cpu)
-- 
2.43.0



