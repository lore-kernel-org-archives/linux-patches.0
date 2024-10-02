Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0327F1D04B4;
	Wed,  2 Oct 2024 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877344; cv=none; b=rIlMpnHeKiCgHkvnkmoUrvXcQegIeXvPmTErrT18tBBWA7vMyIkBeoaCtodFu5fA08UsB5aQuAcHc1GFBy1VDvY8uIj7EyFI/6gCGlm5jI/dylLg5DJRmumoBw+vC21IeAodNxNnZuC6i+gxlcwZ74/pNC0/Yaft961iq++y7O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877344; c=relaxed/simple;
	bh=jJgJ+acFpYNNA1lnWn0272ZVBiwB0aRivle3VEQcT1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAnEeFYeZ/RRchn1HIpQ7omucjXA3NhnwqwPGdTge+nX9phRVKvnDksoVmkRc2iJ8TbCdO+ueQ3Qopmsn2hOYDPoTn2PxLIyLh0gIn2z9D7b86LbVndlcV+Vp3eb4c6PI7GDqqqhgLMQ0egTKe4Cu3MtkB8CWAAUZ3Toq7+K9wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtXBTyGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtXBTyGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C72AC4CECE;
	Wed,  2 Oct 2024 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877343;
	bh=jJgJ+acFpYNNA1lnWn0272ZVBiwB0aRivle3VEQcT1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtXBTyGcEVYi3dNHdJ43XsnZhY9EAvDLvl+XFAZR71y8PRUCHpQh1IR/34yVcATLp
	 wJNR+4R/Y1+e/ZAf4q4p6Y9iHukTqzXbIq5jC6ywoCwwWq5XcFso3o2k6EhyeYblVk
	 vE58sZ8l5oEqtBi9tdSJlA4Qa7cE+iKt39NgkMgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 049/634] drivers/perf: hisi_pcie: Fix TLP headers bandwidth counting
Date: Wed,  2 Oct 2024 14:52:29 +0200
Message-ID: <20241002125813.039626748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fba569a8640cf..f7d6c59d99301 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -208,7 +208,7 @@ static void hisi_pcie_pmu_writeq(struct hisi_pcie_pmu *pcie_pmu, u32 reg_offset,
 static u64 hisi_pcie_pmu_get_event_ctrl_val(struct perf_event *event)
 {
 	u64 port, trig_len, thr_len, len_mode;
-	u64 reg = HISI_PCIE_INIT_SET;
+	u64 reg = 0;
 
 	/* Config HISI_PCIE_EVENT_CTRL according to event. */
 	reg |= FIELD_PREP(HISI_PCIE_EVENT_M, hisi_pcie_get_real_event(event));
-- 
2.43.0



