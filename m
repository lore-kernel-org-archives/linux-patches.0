Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533AE511E90;
	Thu, 17 Sep 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659293; cv=none; b=F+HbwsJ51vNe2G6eyl+7dxA92MpsOlBDv+MrMThz5y1/IEue3WVuX4A+xxC2b6nOHJDn7CZASBmIpxLtQY3PJfM10TdgOMYaUkTAbHDSSnfXRtboB/W8kWoZTALbKra91MvNR+YbI4a4PnxZdmHa7oxz2cSfVeB3VIxHhWdGNZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659293; c=relaxed/simple;
	bh=yPrH7UVFobcF0Nxk5aW9xNRG2Q4k+p8aTj4nyaXv+9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyl2w5g/uvNrtdID3J43Z+3ezsfEw+NP3CHcOvP5lqTl6CCL/WW4x1Azkyt4vC/hODC8g0tAk0kSPUJ1ZcXoKL/L1d3t1x29f0gB23JLJ+hUeynNU6d63p9/Rtpf+Jfp0uHlNOJkA9jVgOLG1NHqI61NwJCPGSPdHY73S+E6TjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5tehtcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5tehtcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA3E1F00893;
	Thu, 17 Sep 2026 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659285;
	bh=ojZF83aduwSavXkr5xEh5Q2YAi8omM7zmrKGC1vVLpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5tehtcAWdJxnBBEs7Q6WJupRDXhJorbkAEEQ7KYj0q+vDfYf+oJWZk7UlUaHv49w
	 YyAUD386oyJhT4tHezGHGDXLAyb/mGaxgr8R4QvDOB7AVD3IgZQtRri2PsmJ/A1XUP
	 ND/T2Z8R7Qbbv2I1qTxVdkCwkX6GMALRGfOOJaj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 167/733] perf: RISC-V: check cpu_hw_evt before dereference in overflow IRQ
Date: Thu, 17 Sep 2026 16:07:55 +0100
Message-ID: <20260917151355.256319620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit f643f520c4c6998fa27dce90dd3b3ff6414e0bae ]

The overflow IRQ handler dereferences cpu_hw_evt before the null check.
Move the check first. Defensive only; the cookie is valid on the normal
path today.

Fixes: a8625217a054 ("drivers/perf: riscv: Implement SBI PMU snapshot function")
Assisted-by: DeepSeek:deepseek-v3
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/fdd42c791752.v2.1786420235.git.liuxixin@kylinos.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index dfc886dee5ad0..f0dd9d2645b44 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1050,11 +1050,13 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 	u64 overflowed_ctrs = 0;
 	struct cpu_hw_events *cpu_hw_evt = dev;
 	u64 start_clock = sched_clock();
-	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
+	struct riscv_pmu_snapshot_data *sdata;
 
 	if (WARN_ON_ONCE(!cpu_hw_evt))
 		return IRQ_NONE;
 
+	sdata = cpu_hw_evt->snapshot_addr;
+
 	/* Firmware counter don't support overflow yet */
 	fidx = find_first_bit(cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS);
 	if (fidx == RISCV_MAX_COUNTERS) {
-- 
2.53.0



