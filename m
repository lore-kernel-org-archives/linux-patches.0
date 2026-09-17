Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A681E49D584;
	Thu, 17 Sep 2026 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670371; cv=none; b=RfjFvA5g3YNoj5CXvF6+UU0/TWfJPyE1u6//T0rbpbdKXff0ZYpFKyNLqZBntaSdnHlgsbw1myxPR6jSyu2dfYOgj8TFVT5VUxV2n7ml3GZMNf8r1+1RguyQxMhBf5v4GoHwaMoG79eVXiBNDo0a68Kn9xbQCjZoVi/0f4N8tz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670371; c=relaxed/simple;
	bh=yM3V/ZAYBZT8EoeIYL3xJzw1coZBSgkKMxhgYB/K27A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0be0vRjY93fkud6hYwf9K70Kdflj1dU0Lp9pWPnjIxxUeazSs6MmGNN9gGXGiO+qucTxdT7BN5kwnnlP6DlyNJRObeRmu3kRIjNRoy9CgEcGjuYaeNfyfsHvu+d++wY+yZyzOh2NklBKrj/dK39Xgv6LfPNTTnH30nFWBxN45U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjQ5b5zc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjQ5b5zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCE31F000FF;
	Thu, 17 Sep 2026 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670370;
	bh=C9Rt0c+R7ASi0Cyzj3nY3TCDmR7VetTbUybRutoKlPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjQ5b5zclhn+MH4NCFQt6gP/Yu3uQUCUcCnLEsY+Bfm/kA0pm3nTsnnB71zqslNr6
	 n3ok0VBK7CfEH4l4g1KfdPsEbxlf6DR3bDUqp9JMZ4boWoTrua9OMdOrDb5jfYxTSi
	 nhrE/PL8qcMMnavyGTRIo4WYIJQn1qZsuyfwkpkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0594/1102] perf: RISC-V: check cpu_hw_evt before dereference in overflow IRQ
Date: Thu, 17 Sep 2026 16:08:57 +0100
Message-ID: <20260917151554.892906959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6df8b260f0702..d6106f80e956e 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -958,11 +958,13 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
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



