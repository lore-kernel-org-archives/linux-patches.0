Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9739061C;
	Sat, 12 Sep 2026 19:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242926; cv=none; b=hS5md+IA3qB/l5Z49wufX0eYShCa8xRJ27eafkyiYPcZj31Frh8WMC2f2uMRT4X8xZuD4YoJ9du7Je3S+MNcJKbZ2TmXFkgpZpNH3hFIR7XFFnW8pcgC/etdIowXjXI/08S0vBPi9DnKZWcAEhyf8+Keorj4eECJ6Q239U5AM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242926; c=relaxed/simple;
	bh=fPYHJaE1lBVaSG0x84UXVBpcbTFslccFnn4YxdF0vSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/e2ZnTBuRDEWrYOlgpr3gOUdBhyJNXZeqxB0sQw9HeAekKHwW/cdPNne9TYlylb8YyEN0a0siT6XaASj9ZlmNvd7pXn6Mt2RRLJOdDUZ6QxE5CXm91RYO7ui6UmZXgBIsHcAQgjW8A0//EITK3HWe3Rof1fViAilT+2dZSxEUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNZv08jU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNZv08jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D761F000FF;
	Sat, 12 Sep 2026 19:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242924;
	bh=zB3nSUs1zDOai4RfubelGbGxHX62zpNH2zCJNRQ77vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNZv08jU2vQifRNAJOVjCv7dFuG8Z0Pubx6p4JgOejJoESxwjCHdTWef2LUkEQK4H
	 8VQKwYLm3UBULDSp1lS5ACW9VgKHJB/xHPT5/zyVHLG0MRC0V3sTgW1XzY/Mxd45iR
	 QeTzC4+Obt2cUZY04aD6xi0v6wPcTt9JMfuox+EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 558/798] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 09:03:06 +0200
Message-ID: <20260912065529.918897160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit fcc5eaea2d234162dfb8258372dd897bc2a1b862 ]

The current code checks whether the wakeup point is in the current
writable range by comparing it with handle->head + handle->size.

The perf AUX head is a monotonically increasing index, so that addition
can overflow when head is close to ULONG_MAX. In that case, a wakeup
point which is still inside the free space range can be missed.

Use unsigned subtraction to compare the distance from head to wakeup
against the handle->size. This can dismiss the issue when addition
overflow.

This is unlikely to happen in practice, but the change makes the
watermark check logically correct.

Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 3280c4b488d44..0f2741752fe91 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -459,7 +459,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



