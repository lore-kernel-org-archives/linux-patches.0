Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C321EE00B;
	Tue,  3 Dec 2024 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242750; cv=none; b=oRW8b5MVDT6pjNSjBvoZBGra/k3nClsepa1kntDXrTHaFs01MVPZheNUMMPeT36vWT/SXWo7uAic8rHZkd7WF3BZCz6TnLY4GpSEr4Vad+z1NUbF858aF9saOTRScCq1TgRauKOOFaNcaufVo4Js1dk9PXJmzgbNYSWV8AOuqDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242750; c=relaxed/simple;
	bh=RETFulDGBgSvDrvdJnt+Bhmc+FRylmQEhQaacXAIP3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ8w6+CTIbJRbzuDGlUyQBCfVg/Efd2bD/i6rPa/BKpaZGx/HLFCciwwjzJ/w8a4W9J4T9cwgPcHa98fZ92hkO8txnigoh6KTWifAVlS2ZVLMXxg0SCRIlZAmnq6+rHn2rymBsenMraO/pCuwi+kHvehnR3z7FK/Fjk3HWxWBeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIPJhnu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIPJhnu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72094C4CECF;
	Tue,  3 Dec 2024 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242749;
	bh=RETFulDGBgSvDrvdJnt+Bhmc+FRylmQEhQaacXAIP3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIPJhnu1j8yEsJ2JfswNcUmgg8bpW0ODxO8puP1aaad5n06+SoBTyFNVo2207oVUx
	 DFDZnvTbk3YFfU6oR8piHvqYe94tZU/jjqzfFteWIQWs7X4Z4FO+mzmuShisz2cNs3
	 xQlwg6NkrUc9zM6BkH8xe19XlYx1tHlYQRAo8Qu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tuan Phan <tuanphan@os.amperecomputing.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 799/826] perf/arm-smmuv3: Fix lockdep assert in ->event_init()
Date: Tue,  3 Dec 2024 15:48:46 +0100
Message-ID: <20241203144814.926332472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Tse Shao <ctshao@google.com>

[ Upstream commit 02a55f2743012a8089f09f6867220c3d57f16564 ]

Same as
https://lore.kernel.org/all/20240514180050.182454-1-namhyung@kernel.org/,
we should skip `for_each_sibling_event()` for group leader since it
doesn't have the ctx yet.

Fixes: f3c0eba28704 ("perf: Add a few assertions")
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Chun-Tse Shao <ctshao@google.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241108050806.3730811-1-ctshao@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index d5fa92ba83739..dabdb9f7bb82c 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -431,6 +431,17 @@ static int smmu_pmu_event_init(struct perf_event *event)
 			return -EINVAL;
 	}
 
+	/*
+	 * Ensure all events are on the same cpu so all events are in the
+	 * same cpu context, to avoid races on pmu_enable etc.
+	 */
+	event->cpu = smmu_pmu->on_cpu;
+
+	hwc->idx = -1;
+
+	if (event->group_leader == event)
+		return 0;
+
 	for_each_sibling_event(sibling, event->group_leader) {
 		if (is_software_event(sibling))
 			continue;
@@ -442,14 +453,6 @@ static int smmu_pmu_event_init(struct perf_event *event)
 			return -EINVAL;
 	}
 
-	hwc->idx = -1;
-
-	/*
-	 * Ensure all events are on the same cpu so all events are in the
-	 * same cpu context, to avoid races on pmu_enable etc.
-	 */
-	event->cpu = smmu_pmu->on_cpu;
-
 	return 0;
 }
 
-- 
2.43.0



