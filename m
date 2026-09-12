Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F4519E7F7;
	Sat, 12 Sep 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201280; cv=none; b=mHgFYh2R9Ic7RDe5nTiIRSYXL2GsHqdICi8xDJuBY0CB+JzxcjrLrdjm0Og5SS2oiYmrARh5eQxdtymd8RYCwtn5zFlnOhjAy//mg9wKLlwICsuMcTJvqj5rtaDTJCZ9CgdqUm4dRUDejUVgZRPuHoqtRneebxYbpCVezewdFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201280; c=relaxed/simple;
	bh=dS0NDQgbRdGv6Is29+rbim373ffsjrcPdvqyLna/KN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsMFehBzgna7IRv7+by0pvLIqlsqSBx81WZefrioURbsxbDAJ2pNzmxVIu1qKx0PjCpgLM6WmT1LXCSeWCHCczBFdV3sFBLIL2Mj3CZN3vGSTp3g3BVj7scI6p3hZl/7XUUgTRvZbLHUWP7t9kDbmpMcG60CRJjZAAAcNjRt4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZErjNO5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZErjNO5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C601F000FF;
	Sat, 12 Sep 2026 08:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201279;
	bh=lBxbhvdgfr+zfuL4l3F7NzrWMiIP2/29SrMbrDUgNmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZErjNO5VqAO62w6GW7zvPlQcLkZOpLr40avDwzVBZswigsC8IZiDHaUJ6SjpCp2U6
	 DC2AKM4kPCWKdVHNOefb8uIvzBnWVZl04djhdulygwn9WxDLfyElh9Z+f08N1IuxF5
	 MnRPbiWGTMXNjetXZpymvrxXAEWnDNmsQFLT1DGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0911/1815] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 08:44:21 +0200
Message-ID: <20260912065710.308226864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dbd0da1116390..b64cf2313a20c 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -577,7 +577,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



