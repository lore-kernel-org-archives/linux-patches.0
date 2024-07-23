Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2413E03A;
	Tue, 23 Jul 2024 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760302; cv=none; b=Pg9jWMx+lHFiMuP1WeZduNpGMcuPfUwtnu5z5JjyTCOj0LyzEOnZsyc0adsJ8SsOPXFKt3TOyx344b5Pw7spQx0d8D7WNbH73MXEKgU/Oedo4PrskFNbxq3VGGONfjTZI1Vtf1mVP8Iyi0RNbudtQwjkd2Q40959xItmnhP784k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760302; c=relaxed/simple;
	bh=aq9aSkkIDmDEtOPyu/9qf+ftMxcoZ0LbqDffSaKbnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FExSVAX09LyQoIm4T4pZ55l+Ghi3WURg+YoKnHJ0AgJT10B5plZy8hytfxndXLu57q9JQSi28nnC1H3qxj3XhT97dpKhkMqikItzhX0M5n9VvotzNGwEkB1liM2c8InMRulObDahvgIByXA1NgElPiRIGn2sBYt2Uvd0yS75eS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABB4taC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABB4taC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6C7C4AF09;
	Tue, 23 Jul 2024 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760302;
	bh=aq9aSkkIDmDEtOPyu/9qf+ftMxcoZ0LbqDffSaKbnIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABB4taC0EGG9Ev+djBXWO5oJI8zrx57/UK7kqABoifVtGA2N8Vk39C4M53Zu/+du+
	 BsMoFUMhDBQ5v9XYkwnWJtp0tRlX5O47EQUwDoyYCquMNRpP2fyUeyuHc4o39UCclv
	 Ftq27cU0ocoWNtMyeXm+va9xnvE69wwrHJPpVM24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 142/163] drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus
Date: Tue, 23 Jul 2024 20:24:31 +0200
Message-ID: <20240723180148.959972762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 7dd646cf745c34d31e7ed2a52265e9ca8308f58f ]

Currently, we stop all the counters while a new cpu is brought online.
However, the hpmevent to counter mappings are not reset. The firmware may
have some stale encoding in their mapping structure which may lead to
undesirable results. We have not encountered such scenario though.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20240628-misc_perf_fixes-v4-2-e01cfddcf035@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 3e44d2fb8bf81..6d3fdf3a688dd 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -634,7 +634,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 	 * which may include counters that are not enabled yet.
 	 */
 	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-		  0, pmu->cmask, 0, 0, 0, 0);
+		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
 static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
-- 
2.43.0



