Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ABE471267;
	Tue, 21 Jul 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657871; cv=none; b=pE6AqzKsMe1WA1KaMgWSR+IKslSG3V73h4LTIm71QPBPR/V4nEzp+7WdO7G/1u00n/ZQ/y4vsBNbX4CpCfBerDP2N/a9j3fRjjBsIvB6WY0zsDIwAyu6LArrdqx7hQSS/JSJLra4jI5vCmrGSjwFy3bIJKE/XMAERdebzBHTpqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657871; c=relaxed/simple;
	bh=VM7106FQFsvwRg65TlU2Z4O9zmRz9mvtYVyknHiheRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjHy8a6+tYfBInxkAurgAQxNPsOH/8oVzljCSQNDI1DbSV2kZiFh76M3l4Oyd1kgJLiv/1z3jW+Gu4ozG8aAzsH6SpHr0g3ljgyE/rJTRO4pWdxmKpR3aMv99bGhKjYwEDErfRpK4Gc31c6DnuK9CF2BrzgbQ4+TPZMGqC2rlEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJtjDVNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJtjDVNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B41F000E9;
	Tue, 21 Jul 2026 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657868;
	bh=yAqMTnPF4EGrSxxPjDbJux5ZZRav5XqAfeR6UwEJy7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJtjDVNCCIcgSW5O72wWs9go1zI25d77AiwpQhOI0fLt4xejP8SqBo6HoaHfrtiyf
	 7WptpTxGz4T0Wc1ABeRMHNETTV2L68ZXbEaCokcqj8Ow9eafGK1R+YrS7FZGXgNe8+
	 Lt6bJCCHDaY5O2b4u8DRege2k3e7HOKPKNRgOn+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0926/1611] ACPI: processor_idle: Mark LPI enter functions as __cpuidle
Date: Tue, 21 Jul 2026 17:17:22 +0200
Message-ID: <20260721152536.215363160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 956ca5d72c76504824c8eb601879da9476973e15 ]

When function tracing or Kprobes is enabled, entering an ACPI Low
Power Idle (LPI) state triggers the following RCU splat:

  RCU not on for: acpi_idle_lpi_enter+0x4/0xd8
  WARNING: CPU: 8 PID: 0 at include/linux/trace_recursion.h:162 function_trace_call+0x1e8/0x228

The acpi_idle_lpi_enter() function is invoked within the cpuidle
path after RCU has already been disabled for the current local CPU.
Consequently, ftrace's function_trace_call() expects RCU to be
actively watching before recording trace data, emitting a warning
if it is not.

Fix this by annotating acpi_idle_lpi_enter(), the generic __weak
stub, and the RISC-V implementation of acpi_processor_ffh_lpi_enter()
with __cpuidle. This moves these functions into the '.cpuidle.text'
section, implicitly disabling ftrace instrumentation (notrace) along
this sensitive path and preventing trace-induced RCU warnings during
idle entry.

Fixes: a36a7fecfe60 ("ACPI / processor_idle: Add support for Low Power Idle(LPI) states")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: lihuisong@huawei.com
Link: https://patch.msgid.link/20260616072617.2272-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/acpi/riscv/cpuidle.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4166090db64207..2468c1d971e740 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1159,7 +1159,7 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __weak __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;
 }
@@ -1172,7 +1172,7 @@ int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
  *
  * Return: 0 for success or negative value for error
  */
-static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_lpi_enter(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
diff --git a/drivers/acpi/riscv/cpuidle.c b/drivers/acpi/riscv/cpuidle.c
index 624f9bbdb58c47..c76dbabff702e6 100644
--- a/drivers/acpi/riscv/cpuidle.c
+++ b/drivers/acpi/riscv/cpuidle.c
@@ -66,7 +66,7 @@ int acpi_processor_ffh_lpi_probe(unsigned int cpu)
 	return acpi_cpu_init_idle(cpu);
 }
 
-int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	u32 state = lpi->address;
 
-- 
2.53.0



