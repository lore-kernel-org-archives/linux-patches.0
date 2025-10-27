Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2B31FBC92;
	Mon, 27 Oct 2025 19:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592800; cv=none; b=kswCd7DU2qHlEtoxpHJOrXUJ/ClajBlQ16N6G3UKsqM5YaKrNp4+mXjryI94SGfBlWFlznmwNCa1AOlo/ZWmZ4MmG68LmwrkfmRGRbM2MMG2+JrrRKWRJoIcMpWGgbLN0G0qE3jSq6HUNm95bfnsDIqEbOC715W9vHIFh/rIeZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592800; c=relaxed/simple;
	bh=i9vwRb1t/bl4pkKetN5U0J1+twn9j3o/8loS71zlk9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqhR8K2APEZbdDedMPf7MSfQ/hpiFaeZueN3yYVsPGrpFFKwpWy6f33w5CNZPiRdzOZD4cGl31iNZCY/9i/R2unMt9Rrin8obsAV/+l8SddkW3GDfjezQYzfKuyEdsQDQLBgFm8nWo5PIYaZMtSE42aNJry5DI+4i8JTiIakA2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMm+wNEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMm+wNEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E7C4CEF1;
	Mon, 27 Oct 2025 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592800;
	bh=i9vwRb1t/bl4pkKetN5U0J1+twn9j3o/8loS71zlk9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMm+wNEyMMOvlVniU6oK/k62pPDrFaGfWmskovls2AoInRuWYSA5y12pkwyLUeewO
	 F69St+CJKE2kMI0FfWlcPVeUBfyLI/FlSQota4TvB+DNe8hvjhuU/4o+kb+Ac46JQr
	 P42Cf4AiikdG5am7mz48gL/IJ6u+aENZbExKdM/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yushan Wang <wangyushan12@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/117] drivers/perf: hisi: Relax the event ID check in the framework
Date: Mon, 27 Oct 2025 19:35:43 +0100
Message-ID: <20251027183454.413288057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 43de0ac332b815cf56dbdce63687de9acfd35d49 ]

Event ID is only using the attr::config bit [7, 0] but we check the
event range using the whole 64bit field. It blocks the usage of the
rest field of attr::config. Relax the check by only using the
bit [7, 0].

Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Yushan Wang <wangyushan12@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_pmu.c | 2 +-
 drivers/perf/hisilicon/hisi_uncore_pmu.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_pmu.c b/drivers/perf/hisilicon/hisi_uncore_pmu.c
index 918cdc31de572..e37682b280db5 100644
--- a/drivers/perf/hisilicon/hisi_uncore_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_pmu.c
@@ -198,7 +198,7 @@ int hisi_uncore_pmu_event_init(struct perf_event *event)
 		return -EINVAL;
 
 	hisi_pmu = to_hisi_pmu(event->pmu);
-	if (event->attr.config > hisi_pmu->check_event)
+	if ((event->attr.config & HISI_EVENTID_MASK) > hisi_pmu->check_event)
 		return -EINVAL;
 
 	if (hisi_pmu->on_cpu == -1)
diff --git a/drivers/perf/hisilicon/hisi_uncore_pmu.h b/drivers/perf/hisilicon/hisi_uncore_pmu.h
index 25b2d43b72bf9..ab5d54170b416 100644
--- a/drivers/perf/hisilicon/hisi_uncore_pmu.h
+++ b/drivers/perf/hisilicon/hisi_uncore_pmu.h
@@ -43,7 +43,8 @@
 		return FIELD_GET(GENMASK_ULL(hi, lo), event->attr.config);  \
 	}
 
-#define HISI_GET_EVENTID(ev) (ev->hw.config_base & 0xff)
+#define HISI_EVENTID_MASK		GENMASK(7, 0)
+#define HISI_GET_EVENTID(ev)		((ev)->hw.config_base & HISI_EVENTID_MASK)
 
 #define HISI_PMU_EVTYPE_BITS		8
 #define HISI_PMU_EVTYPE_SHIFT(idx)	((idx) % 4 * HISI_PMU_EVTYPE_BITS)
-- 
2.51.0



