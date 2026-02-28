Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414943191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300944; cv=none; b=YMoquL1VejiOPa2A+iwQ1MqZbO4qQuW8KN4JwbugaiYiSatX7hMb+l2A9XxWeQvtzqfUJRLUpeALVgV79Vnb4nZyy3NYbyzzgA3uwnFOr5MHBw4v5OAqx3gN76PfXdsny4kILO/e1kS/C65FjCjcNs6/M9NwpPzH6/pCJLaLPVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300944; c=relaxed/simple;
	bh=pOvG3Od1IZRVUetc72P1RuXm0cu7iWlVDHRtFCIDi3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InyodNoFdwoxtQpankQAwptg2+sjqKFJgo+H3n+1S7YSxavErhyxzpIsPBiAJqBLG/f1tSrnCvAddL24gvMjS+KD0B5BIB7HBpz55OsegzPCQ3tHMhI/d2f8bxbkFsOIfEUOQkCivR2lHE196BCADv3Y1J2ZP+rp0JAE4O+t7ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhAHY19S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhAHY19S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91349C19423;
	Sat, 28 Feb 2026 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300944;
	bh=pOvG3Od1IZRVUetc72P1RuXm0cu7iWlVDHRtFCIDi3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhAHY19S1Dn6BQzL5vYm8GVg5vtNaBg36Z1py/PreFpbZKbnfCDGOYu6fiqNzrPP8
	 foweFlNS374mHQdg7j4M/E5MM56Wt+AqXQBERfNZfPY0hNIOvQXF6zMawBwNa+zEIk
	 yrgegfj0cb1xTlGMj0tQJA/hNe2aIal7hmzS76dQUlNnazU/SPAR5NdHfGE4vdTSoq
	 mEwjCXZpNb1NAxwbEOFbmxwGRof3WsTbQIDwU7Ybp2Z884hsLVYcnSMjTTsi5ES8vi
	 QoridqVBCf5eTUFmEVn8Q+6W9fuLc4DQba9wTmLipNccQyRAkxO3DaIVAOuJT17eYM
	 pIW8CDJhFn30g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/752] perf/cxlpmu: Replace IRQF_ONESHOT with IRQF_NO_THREAD
Date: Sat, 28 Feb 2026 12:36:17 -0500
Message-ID: <20260228174750.1542406-66-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit ab26d9c85554c4ff1d95ca8341522880ed9219d6 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.
The flag also disallows force-threading of the primary handler and the
irq-core will warn about this.

The intention here was probably not allowing forced-threading.

Replace IRQF_ONESHOT with IRQF_NO_THREAD.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index d094030220bf2..68a54d97d2a8a 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -877,7 +877,7 @@ static int cxl_pmu_probe(struct device *dev)
 	if (!irq_name)
 		return -ENOMEM;
 
-	rc = devm_request_irq(dev, irq, cxl_pmu_irq, IRQF_SHARED | IRQF_ONESHOT,
+	rc = devm_request_irq(dev, irq, cxl_pmu_irq, IRQF_SHARED | IRQF_NO_THREAD,
 			      irq_name, info);
 	if (rc)
 		return rc;
-- 
2.51.0

