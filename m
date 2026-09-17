Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F41D4ABBDB;
	Thu, 17 Sep 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665431; cv=none; b=k0b3PqzsrezTJtyVXRpOw8gtUSmaA+8US/xpBURnK1HZEMcxvl9a8x63Lq6EV7NH8l1gAFqdUfbqnk6Q6jBW1VQRf9J5b82ngyz3y4xHqm+Z+VYxijjiXHk9rNl8uo9/ndXRwrVSB+0rdUihu2PFIvqpjI0hPaBUAPsEsgzxEPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665431; c=relaxed/simple;
	bh=AL1hMeiLzcTIPS6YikRwCF2HH55v/OxKi7lbzDX8/14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG3LJ/e1U9SdsachCzc2vOMpoZOEgeoTwwrLjmR8y/xAVs8tjMfLRfQFvCfqPOq3eEdHbSgGC5ePg6VWiCuBU5tv6siPlLvfk7aRgdsN36siCl361BsQgv7XJBH5Wz2IuiKfqeGZZtiEJ8Uf5TiLwvJg2jUUhqkmsLcjx1DsFvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ6hllzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ6hllzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E577A1F000FF;
	Thu, 17 Sep 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665430;
	bh=wGBy7EO7bRus0WZIqgzIkEbzzhKGSTUs213OJ7K/wkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ6hllzzwYWy0nj1GE2PvlRtA15YIdAgy8rr9EZMP8qKKdsMGY33IDsInRMfHGd0K
	 w2xvwtftv5HeJF0Cl34q15o9bw8EUd7WLT+e2NyKkgGtTey7emTPxy4HYm8E7vv0yt
	 KCJNb4v5oihpqhMII8rLmW7Q0U2mvfKwtlQcOq40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0703/1250] perf: RISC-V: check cpu_hw_evt before dereference in overflow IRQ
Date: Thu, 17 Sep 2026 16:08:18 +0100
Message-ID: <20260917151610.950020011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7dd282da67cef..224fb7da992f8 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1051,11 +1051,13 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
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



