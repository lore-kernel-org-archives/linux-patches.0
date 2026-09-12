Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658BB23BD06;
	Sat, 12 Sep 2026 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224702; cv=none; b=mS33XIB+Rrea+m1Biqc7M1YnzvmwBfmWLK/pveJCQXDGDD/kNWKDCaRsTSeMtYIfn1GL8dYVYip4gkbO4K40an2rs6gT99MaNAUTBDII52F60oHlu3Plhu1kWlwvMCIgbDY4Ezd9guuTMEYxc9FqjTizTUExvoZl1dCle47YScY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224702; c=relaxed/simple;
	bh=lzdTui0uzjBRyMaUFLi4Jgs6Dz/7Pr3X47yN4ib+N9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YT2Jx/UypycJa7S/JIgZK3WaD8eDKX4Uc5yRiFYp6yH1MxcXLjUfmJKB519qJUXmSVkhNGmLuYkkyOIN+CjC4bvDTpjRE/xOYTBCoq4m5SFTT2NaszvRPC1DB9COGOUcoU/MKNUuwAVqjys5kZ2UVuOh+EOPP6AW5RbH676pdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+kY2SEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+kY2SEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C12D1F000FF;
	Sat, 12 Sep 2026 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224701;
	bh=8kYMBqqocwe++tslPGWJu1QdvANkIIn+btU1gI0rx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+kY2SErZGScKNgvgB5RTh0TJDjPZ2qEPU1AONByZdryVBPWT0tgpWijOwGG7uaKz
	 G9f+1ViNo09PCRTYfSMA6+w82zbRYcuVEO9x4ADD5x3VCP8rtdYhTlASBe5x0eUY7g
	 E4ObyoWRdu/+d+YRM8zynM1Of7pIRetDsSpMyhUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1004/1424] perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065629.796068458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3e1a4f9006119..2455af65ae271 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -643,7 +643,7 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 			cfg = cxl_pmu_config2_get_hdm_decoder(event);
 		else
 			cfg = GENMASK(31, 0); /* No filtering if 0xFFFF_FFFF */
-		writeq(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
+		writel(cfg, base + CXL_PMU_FILTER_CFG_REG(hwc->idx, 0));
 	}
 
 	cfg = readq(base + CXL_PMU_COUNTER_CFG_REG(hwc->idx));
-- 
2.53.0



