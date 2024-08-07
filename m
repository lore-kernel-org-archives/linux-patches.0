Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3E78281;
	Wed,  7 Aug 2024 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043143; cv=none; b=QAv0cbr2cMZT8S4qqr11aaAIGuEYW7XSw6pID1KtKJzTzbvYKb2cNPAWsVBVrCXw1pNbUh+oDEdEQe7V13yj0aMTh+7u2QPE2XjeaiXI4QOak8DV9SMlO9MzsnD+D31q1+sd1R6U8bZgTT+z+5MH4EL3Og4ykxzWMz/fzpW8nQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043143; c=relaxed/simple;
	bh=gAvQBZ85BFTaftB4EeKiOzZM9T+g/rM2f6IY4rkumkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4AMZWvTufFVxGp72NvRYvTxCkWFXoy3B3cs9L9Erpbm0co9eIN4t/9dIE5K7qz6TBI8NvjExrlI06Qo64hkLrbnBLb7I18b3DzBctMzezLzZrdMKBlFDuAeSj3pG0fpt/MSeelJeX08Dtof3OmenGmuTZmwRk7wsY7Aac50wLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkGR/fzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkGR/fzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251F8C32781;
	Wed,  7 Aug 2024 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043143;
	bh=gAvQBZ85BFTaftB4EeKiOzZM9T+g/rM2f6IY4rkumkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkGR/fzsCbWdENtaGmWEGXBGExnqkDO4LQnxsDRcvWfo5uhmqlfYCLH3MATcRlfer
	 4VkFJeCPLu2jgpuY3PybRPdX7T1uJwL5ciTdHklMA3ha7j3iE66pXEw1PhFL4aKERT
	 WCJatM5h7RKFy9hBObFWc/9cuLU82SDXgIFXuYuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shifrin Dmitry <dmitry.shifrin@syntacore.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 070/123] perf: riscv: Fix selecting counters in legacy mode
Date: Wed,  7 Aug 2024 16:59:49 +0200
Message-ID: <20240807150023.064763033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shifrin Dmitry <dmitry.shifrin@syntacore.com>

[ Upstream commit 941a8e9b7a86763ac52d5bf6ccc9986d37fde628 ]

It is required to check event type before checking event config.
Events with the different types can have the same config.
This check is missed for legacy mode code

For such perf usage:
    sysctl -w kernel.perf_user_access=2
    perf stat -e cycles,L1-dcache-loads --
driver will try to force both events to CYCLE counter.

This commit implements event type check before forcing
events on the special counters.

Signed-off-by: Shifrin Dmitry <dmitry.shifrin@syntacore.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Fixes: cc4c07c89aad ("drivers: perf: Implement perf event mmap support in the SBI backend")
Link: https://lore.kernel.org/r/20240729125858.630653-1-dmitry.shifrin@syntacore.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 4e842dcedfbaa..11c7c85047ed4 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -412,7 +412,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	 * but not in the user access mode as we want to use the other counters
 	 * that support sampling/filtering.
 	 */
-	if (hwc->flags & PERF_EVENT_FLAG_LEGACY) {
+	if ((hwc->flags & PERF_EVENT_FLAG_LEGACY) && (event->attr.type == PERF_TYPE_HARDWARE)) {
 		if (event->attr.config == PERF_COUNT_HW_CPU_CYCLES) {
 			cflags |= SBI_PMU_CFG_FLAG_SKIP_MATCH;
 			cmask = 1;
-- 
2.43.0



