Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1E1DF973;
	Wed, 19 Mar 2025 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395006; cv=none; b=bz+jFMN3EOuU3LMazc9jH4bUeEjeW51tbGRPi13YHzMFitTTqG/DyzkKDibK83AvZRqc488cxGcbK8ZYKMDuTsalHWb48yVHCN7OiQvV8yrFRAgCIjshcpIijGit1jf8ecKxidArdwSnsRfRi4NG1kRL0NX+75uFFw8MZHIs8XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395006; c=relaxed/simple;
	bh=M7GICDq5F64C1x6mnvyIojVD3oDw//h9OjP1LubVNMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6dpm2L5lc3WO14c3SWK83P9rGA33h9T5YyylPJeqSZmqtvNSi1rZ1/WInRnKddgxFBph3R44jDSD+aT2v8ClsDz7WFO54arxlwsK4LPEtifWcpLRnb/CTNGaYrmIUFfqTDYk+BShduh28gnhmgi3K6O4VtW79Us2dZqOsAJ3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJC3Q8gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJC3Q8gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39092C4CEE4;
	Wed, 19 Mar 2025 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395006;
	bh=M7GICDq5F64C1x6mnvyIojVD3oDw//h9OjP1LubVNMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJC3Q8gtPpEaYmigN+G9DVI+2sAMQ9+WRG4vEfel4Ze/nEqcCIIUpKo30rj/hkmS3
	 XQcgbGVOYbxtJOYZGAtxnH5UCgqEnvgXRV7t1nPoI01x1hG2QinBFhA9Nch0WhLrxV
	 /bZ0RXL9a20499WdOfo0mF1Km0Pfp3qKHS8Y5SbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/231] wifi: mac80211: dont queue sdata::work for a non-running sdata
Date: Wed, 19 Mar 2025 07:28:28 -0700
Message-ID: <20250319143027.229287273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 20d5a0b9cd0ccb32e886cf6baecf14936325bf10 ]

The worker really shouldn't be queued for a non-running interface.
Also, if ieee80211_setup_sdata is called between queueing and executing
the wk, it will be initialized, which will corrupt wiphy_work_list.

Fixes: f8891461a277 ("mac80211: do not start any work during reconfigure flow")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250306123626.1e02caf82640.I4949e71ed56e7186ed4968fa9ddff477473fa2f4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 38c30e4ddda98..2b6e8e7307ee5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -6,7 +6,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2024 Intel Corporation
+ * Copyright (C) 2018-2025 Intel Corporation
  *
  * utilities for mac80211
  */
@@ -2184,8 +2184,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		ieee80211_reconfig_roc(local);
 
 		/* Requeue all works */
-		list_for_each_entry(sdata, &local->interfaces, list)
-			wiphy_work_queue(local->hw.wiphy, &sdata->work);
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (ieee80211_sdata_running(sdata))
+				wiphy_work_queue(local->hw.wiphy, &sdata->work);
+		}
 	}
 
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-- 
2.39.5



