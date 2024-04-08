Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302806CDA9;
	Mon,  8 Apr 2024 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583142; cv=none; b=t0udmxFXgnAaDyd32vertuzuEh5/4SM8mZ4BCb8fyO8Tmnt+0XxLfFLxEiutDvaRmgx08EKVLsgSJrZ4zTXQJ6ImdpppQ1MWl06oEB+RHl1qY8cQSdwzvLdIn1GsJigJkl2+IGirYQWymhfp7MNpehAnZG/Cq4WwGtNEw+xYtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583142; c=relaxed/simple;
	bh=1CEYr7lQZGVo/v0T7YB6l53pBurORd7wqWUya0l2+yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqn0JCSkQUGOziWzyVGW+nLKW2I4ms/ipPGQQuZwqK18/p1MooRoyiEQ/tBywwgY8gxanrZlXSYhWBdjZ92VlfZS2RcG3dFkSsAXO9D5G7aJ1LD6DdGNp/bGXjj9tzjR0QPgy0K52BbeYxooz7FcSUtZ12EgqruatbVV2myRN5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSaTFmBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSaTFmBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FF6C43394;
	Mon,  8 Apr 2024 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583142;
	bh=1CEYr7lQZGVo/v0T7YB6l53pBurORd7wqWUya0l2+yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSaTFmBxhUfQ5WYjDxxMmcx9KbwLmzmctiUqOYVNUs7ilo5yYCv+cdZvA1YOySnyH
	 vLwsGpfYA1iKJddV8FKLAGWCvCI9emd0diR/W819ZCuHfLn9keqga751HvKhx+1LA5
	 kZzddfOM50Nf+Zl2eRU6Fh3HVrip0swomI/f1zk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/252] drivers/perf: riscv: Disable PERF_SAMPLE_BRANCH_* while not supported
Date: Mon,  8 Apr 2024 14:57:40 +0200
Message-ID: <20240408125311.650448087@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit ea6873118493019474abbf57d5a800da365734df ]

RISC-V perf driver does not yet support branch sampling. Although the
specification is in the works [0], it is best to disable such events
until support is available, otherwise we will get unexpected results.
Due to this reason, two riscv bpf testcases get_branch_snapshot and
perf_branches/perf_branches_hw fail.

Link: https://github.com/riscv/riscv-control-transfer-records [0]
Fixes: f5bfa23f576f ("RISC-V: Add a perf core library for pmu drivers")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240312012053.1178140-1-pulehui@huaweicloud.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
index c78a6fd6c57f6..b4efdddb2ad91 100644
--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -313,6 +313,10 @@ static int riscv_pmu_event_init(struct perf_event *event)
 	u64 event_config = 0;
 	uint64_t cmask;
 
+	/* driver does not support branch stack sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	hwc->flags = 0;
 	mapped_event = rvpmu->event_map(event, &event_config);
 	if (mapped_event < 0) {
-- 
2.43.0



