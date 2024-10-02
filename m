Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58CD1D0E2A;
	Wed,  2 Oct 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879267; cv=none; b=S9/EXOYoErr3FFwJa72kyLE32LdUK6L0jZDbMKd1QCw6CAJXCWTsWDAHWtcS64MiPv64OoRFZuTbzRuQ9HBuUUqLALaVo58onx4EHWRNJfykuSrygAcwXOAQ2TGvb2MGZ3OoVdJxrYP4ydnZeVkK+uc2UZuKa3MGbzotnyshwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879267; c=relaxed/simple;
	bh=fcllsbrtiuNVYIPyIDAxDSAXZbzklTqJhkuCExLvdw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuQPcrYYEgsVYb2RnncP5yVulKxi8RuH857x8Le1pwMel2J9/DiW4Z7qqeRmwfCadBZy3Jo6Rralue+LH60wrQ6AmWSGnC41SzuRg/2Y6AsPpxAQEOOU1+TpgimhujIMyS+PMCrqZ5gUZZ5wOim8BiXPJdSU9pvCscVBZ/ZiDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjsg7ph4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjsg7ph4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2903DC4CEC2;
	Wed,  2 Oct 2024 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879267;
	bh=fcllsbrtiuNVYIPyIDAxDSAXZbzklTqJhkuCExLvdw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjsg7ph4J8JLyr7/JRU6MdkDL6dWGDVVMuykgt/RL8rKaJAPXBR79cSMtUy5VeeLq
	 mLn1BszDVPnweuubSFJmeO46vwyBn15VBNZW49mR5thJMyMFerzUKM/TKeYQJaS2xt
	 gcV6rOM4sgNUFXFaU3MFmOccis5VxPLEq7wCrKjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/538] drivers/perf: hisi_pcie: Fix TLP headers bandwidth counting
Date: Wed,  2 Oct 2024 14:54:28 +0200
Message-ID: <20241002125753.171631880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 17bf68aeb3642221e3e770399b5a52f370747ac1 ]

We make the initial value of event ctrl register as HISI_PCIE_INIT_SET
and modify according to the user options. This will make TLP headers
bandwidth only counting never take effect since HISI_PCIE_INIT_SET
configures to count the TLP payloads bandwidth. Fix this by making
the initial value of event ctrl register as 0.

Fixes: 17d573984d4d ("drivers/perf: hisi: Add TLP filter support")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240829090332.28756-3-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index 570ae69c38ec0..4a902da5c1d49 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -221,7 +221,7 @@ static void hisi_pcie_pmu_config_filter(struct perf_event *event)
 	struct hisi_pcie_pmu *pcie_pmu = to_pcie_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 port, trig_len, thr_len, len_mode;
-	u64 reg = HISI_PCIE_INIT_SET;
+	u64 reg = 0;
 
 	/* Config HISI_PCIE_EVENT_CTRL according to event. */
 	reg |= FIELD_PREP(HISI_PCIE_EVENT_M, hisi_pcie_get_real_event(event));
-- 
2.43.0



