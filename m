Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1678C67;
	Wed,  7 Aug 2024 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043434; cv=none; b=LLXe85p61stEToCCDrjC0iscXLhyQyqaadAsXXrBzBLtgDYlj8RNoGh6h/TBLZ+aS8FQSdyUNlrj8msOfly8Xgo+x0y0WxlD8n65VVf0A3AtvKtu7qY3fQ3RZjfNXKZeGNM8cIpYJo8+rtjH0nq4p4Zz8cZEaHHFCLjOUg6iukg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043434; c=relaxed/simple;
	bh=I7v91elygarNu2YDFFsFySXnOwGKwzTNVu39cxU6tZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXNiQU6VvpCoWTWK1xMqu4W/F8J2z20Ti8IzIR/X3mSj/rLV0ZaCvxpjDNDRRHSh7vETaLRaPsvx6DdhsHQ6rIePOAR6he8p8MPKaMi+U9gS8c6qmSXOY855cGwWaWlQTr0TxUbKgh37yL2atv/JoMnWo7bD9sOCFqKVXqXFSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNn5XKEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNn5XKEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA1DC32781;
	Wed,  7 Aug 2024 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043434;
	bh=I7v91elygarNu2YDFFsFySXnOwGKwzTNVu39cxU6tZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNn5XKEEMZdSrP/n1enjXD3Q4afmS+CqU/YjlnOkVi+RJrWFIXNw0plGOj4ixXdEp
	 db+7tFSFxFaw+VsRqfnoOffsROtxpFyngdcFJZaw6rHOYDoFl7diEJfO6S5Jp67Rit
	 iVxL+HAR8RXgDptChBdd5L3hy5qrjuGHPi6q/188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shifrin Dmitry <dmitry.shifrin@syntacore.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/121] perf: riscv: Fix selecting counters in legacy mode
Date: Wed,  7 Aug 2024 17:00:22 +0200
Message-ID: <20240807150022.353532607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index ae16ecb15f2d9..901da688ea3f8 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -355,7 +355,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
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



