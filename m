Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028937E2E7;
	Sat, 12 Sep 2026 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216984; cv=none; b=NnMQYpH5xCCh8IFKvCj9Jm3hbst/GltS8fh2xh7SFW/PJlnnNon+nGeuzrl8bQHqm1t82B+b26k4FYTN1H31qWvHeOjisLbyaRD3jZg7x/qm9HHOCqOc5rcGnjW0lasIaTdCqcOoD59jnV+fIHdMhDMjJE+3aP6u5vwf4cQcgLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216984; c=relaxed/simple;
	bh=JbIemNqeAO/aI+MEfPHnlnov4GWCNAlwAUfIs0rJQDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ5rG/pkB2SWj4xtpSHAe41C5KwFfvN2QYDKNdDnZ3/PslseBWx++irysftU/ofPwJQ7W0H2iWwiafnubzXc4haQbhvUZwZ4s/Yoc3myjqpi7MWZS9bAmxGa+AfnB5DK/UZ9mXDtIQVC2dGWyVOhHvHmZslw6DbCNsndM2hao78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWoOp9T6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWoOp9T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B591F000FF;
	Sat, 12 Sep 2026 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216983;
	bh=HPQYVwx50ddIupDO70MaqwQbrB4+ixlF19d317Ut7PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWoOp9T6R1E7cF4Fh90ZxudWqQ30L+kbgeQY5fJFtizhwmggHSniFA4ehDapCq1i6
	 z2YOp3ajio14GugNB2mTuxNN58YJpKsholE902Hrv0K9pBibdZY6vJ4uGlErd5diF8
	 0RzuBgFj5XpTBJv1+VHS7weJrfPkuQJhqhUTOfY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0849/1376] perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register
Date: Sat, 12 Sep 2026 08:54:35 +0200
Message-ID: <20260912065626.476893367@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit ea434e8fd3a539e9c53285b10d3c7e539e228591 ]

The HDM decoder filter configuration register is 32 bits wide, but the
driver programs it with a 64-bit writeq(). The filter value never
exceeds 32 bits, so the upper half of the write is always zero and
lands in the adjacent Filter ID 1 (Channel/Rank/Bank) configuration
register at offset+4.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 24244096f5141..ce97062a66190 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -632,7 +632,7 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 			cfg = cxl_pmu_config2_get_hdm_decoder(event);
 		else
 			cfg = GENMASK(31, 0); /* No filtering if 0xFFFF_FFFF */
-		writeq(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
+		writel(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
 	}
 
 	cfg = readq(base + CXL_PMU_COUNTER_CFG_REG(hwc->idx));
-- 
2.53.0



