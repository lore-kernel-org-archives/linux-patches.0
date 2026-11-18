Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040794;
	b=wH/PJtOOnL+aqPey4dUeNuEDuj1lXz9f1iNnfLHJu2A/ydaD/S9l+rdeEqJPkggKpwMX
	 wwGm6R3wrtXSOA73NcJwncvPQeGEkELr4/3dl2rnJljmyEM3FppUenmbO0RtmrkX2xVCN
	 5BjzkcATLZPxtEdfohL63G83c3lNpv5IfExlTklD128KmgTrgSsdovByGvsPUxKu5lF6b
	 tOkSAXPMHugqg1XoAanxi3/3soGuY1RtVIGubuQhfcMzym9t0N6MiWRD7X2Unt8V4Pvvl
	 tXJQOVDkOypXrhjrM5ibvr3eaBnJhnWw5/ZkHADi9Zo3f4/RUIZP8d+QBkcYQxn3MVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pUhGIRp2BkmOhwqoY7SPX7meCChLjwXq21W+jUlf78U=;
	b=HbZASnI9KUM1A/lpgQFV1fup1Ksa5buthr81tLLeJAR8vMS4KsbwFWgtdk1hFmbkjEt7
	 RROaNrSYdGvG6kiGltg+jdRcUyqby0DSs3Bnfq41PmihOwnd5ule8DPFT2EUGTFuRpZCy
	 9FUZfop3H/+Uw3a5scKNQhfZhyGuwunbj8fuzWHd08Wsb2PPpyWu317Kc/7pbyFrD3zBd
	 c2c2ypzwB3F6rmj4CwjnTO4VD+0gerxacqNka2kiuZdfbnVPNp+AmaD/YZSBbD8CSlwNS
	 vkxXLn4UrHo0tGzGc9Wd8RkgnXE98uXx399/cvSjY0q9DM/F3FquiL8SRZSBPLdIs6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFjCy6nc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E11606A320;
	Wed, 18 Nov 2026 22:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFjCy6nc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098F91F000C4;
	Wed, 18 Nov 2026 22:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040794;
	bh=pUhGIRp2BkmOhwqoY7SPX7meCChLjwXq21W+jUlf78U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFjCy6nc4jKs2hAdRjzBGWTJDHqBKajmV5ODH8fSk5sYU9g+NaiGZS2gWS7LMss6+
	 +hsuUq7m0sGz0BJjlcpPCvRjR3lgmQFK6LQ2wOBMYYpmoU67IrxlMxdNrLGQUrofzO
	 9ZRylFCc+2KbkpsJinDOl+MZhjSp323u5VcvIt9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2543/3318] perf/cxl: Clear stale event fields before reprogramming a counter
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150437.594464368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 7406d6cf76b1dad53084f3988dc65ab967209344 ]

cxl_pmu_event_start() ORs the event group id, event mask, edge and invert
selections into a configurable counter's config register without clearing
them first, and cxl_pmu_event_stop() leaves them set. Reuse the counter for
another event and the new selection lands on top of the old one, so the
counter counts the wrong events with stale edge and invert behaviour.

Use FIELD_MODIFY() so each field is replaced rather than accumulated.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index fdcbf50cc2a3e..d37d792c81f31 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -654,17 +654,17 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_INT_ON_OVRFLW, 1);
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_FREEZE_ON_OVRFLW, 1);
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_ENABLE, 1);
-	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EDGE,
-			  cxl_pmu_config1_get_edge(event) ? 1 : 0);
-	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_INVERT,
-			  cxl_pmu_config1_get_invert(event) ? 1 : 0);
+	FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EDGE, &cfg,
+		     cxl_pmu_config1_get_edge(event) ? 1 : 0);
+	FIELD_MODIFY(CXL_PMU_COUNTER_CFG_INVERT, &cfg,
+		     cxl_pmu_config1_get_invert(event) ? 1 : 0);
 
 	/* Fixed purpose counters have next two fields RO */
 	if (test_bit(hwc->idx, info->conf_counter_bm)) {
-		cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EVENT_GRP_ID_IDX_MSK,
-				  hwc->event_base);
-		cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EVENTS_MSK,
-				  cxl_pmu_config_get_mask(event));
+		FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EVENT_GRP_ID_IDX_MSK, &cfg,
+			     hwc->event_base);
+		FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EVENTS_MSK, &cfg,
+			     cxl_pmu_config_get_mask(event));
 	}
 	cfg &= ~CXL_PMU_COUNTER_CFG_THRESHOLD_MSK;
 	/*
-- 
2.53.0



