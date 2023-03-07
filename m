Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0610BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7391C433D2;
	Tue,  7 Mar 2023 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212568;
	bh=CVtAXUjfOWyXtdCD7IOhtwx1KkDlNylxNmr3yMck988=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIeNvofHpjgYbGjdlzEsIQZ4O0mta65tqGIhxhOod0NmjMgDynX4WipyRgaUGTHvQ
	 OV8ja+8VkPSyos9gOED0aitOwQTayLeujZ92RQ9jmpXFnpKLXbdVHa9vLagmclZjcm
	 hskRaOIoDev7GFL7NQ/MuLKI/ydkcXgWuzJztE+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Evans <mev@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/885] clocksource/drivers/riscv: Patch riscv_clock_next_event() jump before first use
Date: Tue,  7 Mar 2023 17:52:40 +0100
Message-Id: <20230307170011.853401728@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Evans <mev@rivosinc.com>

[ Upstream commit 225b9596cb0227c1c1b1e4a836dad43595c3e61a ]

A static key is used to select between SBI and Sstc timer usage in
riscv_clock_next_event(), but currently the direction is resolved
after cpuhp_setup_state() is called (which sets the next event).  The
first event will therefore fall through the sbi_set_timer() path; this
breaks Sstc-only systems.  So, apply the jump patching before first
use.

Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
Signed-off-by: Matt Evans <mev@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/CDDAB2D0-264E-42F3-8E31-BA210BEB8EC1@rivosinc.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index a0d66fabf0732..a01c2bd241349 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -177,6 +177,11 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 		return error;
 	}
 
+	if (riscv_isa_extension_available(NULL, SSTC)) {
+		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
+		static_branch_enable(&riscv_sstc_available);
+	}
+
 	error = cpuhp_setup_state(CPUHP_AP_RISCV_TIMER_STARTING,
 			 "clockevents/riscv/timer:starting",
 			 riscv_timer_starting_cpu, riscv_timer_dying_cpu);
@@ -184,11 +189,6 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 		pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
 		       error);
 
-	if (riscv_isa_extension_available(NULL, SSTC)) {
-		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
-		static_branch_enable(&riscv_sstc_available);
-	}
-
 	return error;
 }
 
-- 
2.39.2



