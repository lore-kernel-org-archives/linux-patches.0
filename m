Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32897156F29;
	Tue, 23 Jul 2024 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759365; cv=none; b=adKgmGFx1v9boExWGX5t6gpCQJZE044TrUrvqJmBCNC2WSG8iqfjzTyhrYyAfLsHGrBcX9q8vFq/9QHgLbILqFNYceWKsoCAqfLAmfNptlMvPih0Gz+TMp3ViAEOBy5NtKmsVZ18X1/J+QmVBwZNX9eh23uQSxY6S/Q3zTcdYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759365; c=relaxed/simple;
	bh=PjJMY0fQ8BFhTMRpsQD2lhNC3Xi2b4Sl+qKWkP0vLq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiMndijS+TTTGOkkJYLeOcGkTxTNdwPnuE+lMa8yusRNxoej1yRcLcdMsi3hlMgiGTczd0mwetcCPSpWCUBug24iKzLNtxOnYZ/skhnlh+CBJt8OZSeJ0NTWAbXXRSfcNnB1TA6Ll+Me4O5n2fkScbUe7K5acmeuFT2VGsxzerw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvkg2EJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvkg2EJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6A1C4AF0B;
	Tue, 23 Jul 2024 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759365;
	bh=PjJMY0fQ8BFhTMRpsQD2lhNC3Xi2b4Sl+qKWkP0vLq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nvkg2EJBSRedvMdr+XToel0UCv6x+b/9ZQ9D+/7G4LxDd/s8L2f5AzAb5h3rKWhnV
	 bJgd8gJVDLipiviqF7llYnYC1/ccAma7OOvaUwLXFuLPHkbOx8Y1YexCLuNRFSk5tq
	 brceQydWTPpHno+BS44QVP0cuYzyvHCtxe1hzAlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/105] drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus
Date: Tue, 23 Jul 2024 20:24:07 +0200
Message-ID: <20240723180406.712237667@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 382fe5ee6100b..5aab43a3ffb92 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -502,7 +502,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 	 * which may include counters that are not enabled yet.
 	 */
 	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-		  0, pmu->cmask, 0, 0, 0, 0);
+		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
 static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
-- 
2.43.0



