Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155F47A5D;
	Mon,  1 Apr 2024 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987152; cv=none; b=HnNY1LwF3CZAtt/R0viL4CGJ6XnfeteNx05bz0Wlh+5XuxFKckhRiO2/IIVgLGafIY/USCweW0wqb3xqU2NCVC6fYWL7jClpGJ4/cOVLsbvHUcz9Wg3Zh1VQ6tcHDz0sbDMW8dSMWryj/+K385rA+VBQM8c/K3X06tnaiJnQCvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987152; c=relaxed/simple;
	bh=2yPgbNNSVKReb4s7D057A/wF5huuT53s+V9i6LWx/o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2hkG0z2dzsJeAwpz2Q0akuluo9VJYqVsuQspPd08T/ahfSlvhulkFVbctcnITXv8H5qIkkndtqYGZ9+wCk1MFaXPk964aLWerUXuoSG8Aj1TXPF08tYZW+/MQI4ZE4LFpFJHeg2C4Zx/aamOTWVc01eUZctdBX/np3etUGO7f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDzdqD8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDzdqD8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4225C433C7;
	Mon,  1 Apr 2024 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987152;
	bh=2yPgbNNSVKReb4s7D057A/wF5huuT53s+V9i6LWx/o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDzdqD8W1LBPGEOnVseDrJHnV2+zhxAtg3CA2T1pRC6cpC6HXGOm2gputgLjKJDun
	 stWl89/zkRFMVrP/T8Fc6BkC7AStvf4UI4PrI0W/OCwAtZsHVXX15uyBYtppBWrFV3
	 Y0D8/XFwkp+WsFLV0qichaVP2V6qkAyGqmVd8HB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Atish Patra <atishp@rivosinc.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 170/399] clocksource/drivers/timer-riscv: Clear timer interrupt on timer initialization
Date: Mon,  1 Apr 2024 17:42:16 +0200
Message-ID: <20240401152554.254010541@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e66dcbd665665..79bb9a98baa7b 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -108,6 +108,9 @@ static int riscv_timer_starting_cpu(unsigned int cpu)
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



