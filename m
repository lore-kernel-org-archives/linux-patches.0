Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898017D3F6;
	Mon,  8 Apr 2024 13:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582258; cv=none; b=CoWksU73x6E6jFkRic+0VHj/v5ThKVGFtPVRF9bX9dZ1TtGRLcSr94VyUb4qwwSQxQ/67xYL3zLQl/sTvrwkTLsMKLrKucFrf9Kgl6tdMWFR4ehCPOFReK0gP6Btsk8tVRq6MFZkDAAacQWSr9WnOEn4dcQVDuER4ygYo7e1am4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582258; c=relaxed/simple;
	bh=Q5/iQSa7DTFEzKZ0Fu0Hc8FFbnSMi5IwYNeWAVdZqkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3JTwVOqsBJlidelVZpQjlaJNm2g5WiWrR54kUxY7XhBbmEFBS2HgszrW3D+pTDJKzkIuyQgFfVXy+LswGzyr96mlwClhhlpSRhcuGNuFrY4Tlv+BoAF+DmtChAKkYI+XQ7LayfQiAwb6G5uCiifUpSEA0kyvl8VfFhRD8GIxiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkiHctWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkiHctWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CABC433C7;
	Mon,  8 Apr 2024 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582258;
	bh=Q5/iQSa7DTFEzKZ0Fu0Hc8FFbnSMi5IwYNeWAVdZqkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkiHctWzA4+g8cwFHBws4c4y6zLFw/kMCuICa3DEku1NBYaOrVxOAK3ovrG/V6XLr
	 g4yqZYgTb6AdAYlDxZ3Iu2Ko3k6mlcn+geOb4j/X461xMII6Xa5ySdQwuHJ6HARJFo
	 IBelvPkinpuYJPH4eOdBLl3TgqoP3RgB2bd4HHgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/138] drivers/perf: riscv: Disable PERF_SAMPLE_BRANCH_* while not supported
Date: Mon,  8 Apr 2024 14:58:25 +0200
Message-ID: <20240408125259.055660230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index 56897d4d4fd3e..2d5cf135e8a1d 100644
--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -246,6 +246,10 @@ static int riscv_pmu_event_init(struct perf_event *event)
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



