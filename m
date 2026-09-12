Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BC147ACE9;
	Sat, 12 Sep 2026 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216874; cv=none; b=mHVwQwSNNDwrwiYUBO/3vxhoOGmq2jlNpPRxKLPqOk0mscK3LULOS0gIT7Q4/ZsBiXKU/tIx74KznkfGrS3mbs2zhwf41HE2IMBrLWH7NF3GIgQLLJ23m1hnFik/9yxufjGrjkeLwu+tRvCpIHxZf073b9GjQ/sKgH9eAHWwPto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216874; c=relaxed/simple;
	bh=PluYur4FB2kkFOQI4nI+bfRu/lGmsiPAhOhuba45Phk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPHWniOdrK6wXi1VS07cT48IfJa7RH11h8/fs/kfFc2nu6/yNfwqw29z0Un0szfBmFkE6/OCJh5oBakpvnJHtql+xjIe1DJcQdc3MG+2DDLU5AIqOvLdD+rogBGG2y/ESeMJyKWtP5L0KpYtMCcQQ9QN7LtaI2PrEzEOdHULgyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQKK3xQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQKK3xQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B721F000FF;
	Sat, 12 Sep 2026 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216872;
	bh=DR9EqTfYnijEySib10SK9GwXl9T9e6hLWW6TJZbpuVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQKK3xQnwdeVg33LflwP9aQjx51DyBSHgKcNcaAaTHSXyB3W4Yu1EFHcR1uRGREEs
	 GGy9chNOaIaKqjdTko5iQOTqWrWkCUHsu2ixCegLfGbtnA+xM87WTARYAZpF/yTTik
	 GlRlLpotL/Vq4RnV7pAHYqt3CDs0VhKLHsLUCvsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0824/1376] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 08:54:10 +0200
Message-ID: <20260912065625.912355833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2fce871a1882d..5902ca3f057a1 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -467,7 +467,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



