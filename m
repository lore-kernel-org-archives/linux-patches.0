Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1339E1F1534;
	Sat, 12 Sep 2026 08:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201488; cv=none; b=WqMRHf8A2svgFd0U7F5Ms/e0AZNDb0X5Lsv8e6rGPbGSLdiGRiEQglrQ13qmN8KBugUCiM8Hd1IBIILMqkyt7WuLNOgAL3+c1woDh7lFpoeLYUDfozfMM3d+oSoixDq6KkYmfnaXhtMyrRCqKinXtPYHaH9ZMlqP0JqqlilKiwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201488; c=relaxed/simple;
	bh=nL6eK0NwNpjRMLVpBaFoJ1g66eo2ir96NjghgX8ovds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8BZqC3h5tLTSpC3fPuaanr999vetSEk2QXUMuDoc/Kx4Brc4mAp5CfdPPQHTjgCRCizCH9TDx27YHWbFNO+O/Fj+Zy0zzeezCTkNPH8EYHzHs6GJNb90hr7aIMj1qBSexblUII93w7ngP0NqLKR9gBp8J6wNGHPM8N0y5yFLJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnUWiaqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnUWiaqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69831F000FF;
	Sat, 12 Sep 2026 08:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201486;
	bh=BrpgumuG9RTphwsFDfTmCj20sFO0q9vORpmeaQD1UH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnUWiaquuAyO0oLynAnvuT9i08HsR906xte7q2oHZ5zd/MmWWtRlRZzzAvhbwkVyC
	 POr6eFP7BCfAkgXolj0ZixtVSstxEa9trEGpTQL6kOoClqWSEq6XQhFOrZDYmbMOMi
	 rz1S0Bgp21I9qnn98/lX/wdvC6LqMABYsJSS0XrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0963/1815] perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register
Date: Sat, 12 Sep 2026 08:45:13 +0200
Message-ID: <20260912065711.579881158@linuxfoundation.org>
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
index 68a54d97d2a8a..39b46550a5109 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -635,7 +635,7 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 			cfg = cxl_pmu_config2_get_hdm_decoder(event);
 		else
 			cfg = GENMASK(31, 0); /* No filtering if 0xFFFF_FFFF */
-		writeq(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
+		writel(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
 	}
 
 	cfg = readq(base + CXL_PMU_COUNTER_CFG_REG(hwc->idx));
-- 
2.53.0



