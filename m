Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D327158A3F;
	Tue, 23 Jul 2024 18:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759727; cv=none; b=NWT1Q/uvoa4dGyJkpY+pBQ4iVj1uGAyMql1uwxHtiQNQcPFI9ZlJ9wHMlpmN8ThGtuhC/L6RK4kBj6BWNmnjoiqIH0XygbyLD7LuYOJxxikZ/SDc6kYcFNl1QYyTJa7J1+uXD26Tr8QV3G+lXFPJRoKhvhc6SQpyIpgemwiikc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759727; c=relaxed/simple;
	bh=dYJG8hlj1Lk1mq4u4OgOZ7fZdCzmoEZaF4pckbBpj9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb5n113cdOi8DDh2I/zvmDaHApFdl3AF9B6MKcsoy6ZxJDNKrpD1cWpLE/jKRiqgBCtc9vl/sOIx9W6GFr+PUto6yZWX4Lb0jkcLP51owaPPRzWCbbUXzblHzPwqDJLq3Epl81Jshwor/wfwbr6eScsXaKYBMAVokZsB7dhp+q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwwTrFCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwwTrFCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3804C4AF0B;
	Tue, 23 Jul 2024 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759727;
	bh=dYJG8hlj1Lk1mq4u4OgOZ7fZdCzmoEZaF4pckbBpj9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwwTrFCp8zJ7JPC0SCMnu2QcHHoMgMy76WkGAbu2jkWw+GqvyywwAKyMCc3G7l7YR
	 CyoBcyBea7csD7vxfYNt4T8bPsnBYj1O0e4oRQjeUG3DFFBgiulmq7iufLWhZZrCUS
	 Bhh2AL1BhuEMgCeM3mgCoBvLxSYZ2x+ifvmHYq7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/129] drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus
Date: Tue, 23 Jul 2024 20:24:16 +0200
Message-ID: <20240723180408.963698306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index d80b4b09152df..ae16ecb15f2d9 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -611,7 +611,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 	 * which may include counters that are not enabled yet.
 	 */
 	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-		  0, pmu->cmask, 0, 0, 0, 0);
+		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
 static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
-- 
2.43.0



