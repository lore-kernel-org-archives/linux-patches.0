Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6B519DF99;
	Wed, 19 Mar 2025 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394836; cv=none; b=h47FY42IvrCN5zsxUqEQq+xZlURrWf4p21Itpsl0+L6XclgVNLiOaTLGJrXQcNnLknoT1UeBuoGVNk11215ZtIQKBUP9vUboItaB+RU2Deu9YC1+xTIEJrseRVHB01Itl1DKSb/BJ2+u5EnEW20ohwGkB7sZbmX1f1bUqgI7WTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394836; c=relaxed/simple;
	bh=EOK1Cwr55eXyOwko7mT7pLTQ5zVssn1yer7LDu/gOD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT6nSUGXQeGUxnxZj2QmIOhrwd8iNhf22UmphbraK6TjBf3bN3gUj0EyloXrRqnlDTpguyzWLUv3I+yOd7NpkOpGhVkhI15sIOML2nDTIx/g1oGHOUk0hKi6CZJubAlJ/0xmpyzRMgjjhjC5ELoGh9V0TfrMZZQ+lBIBgw1OnHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UaHFFBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UaHFFBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EF6C4CEE8;
	Wed, 19 Mar 2025 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394835;
	bh=EOK1Cwr55eXyOwko7mT7pLTQ5zVssn1yer7LDu/gOD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UaHFFBaY6+OlkNOqlWFAzDfEzRo3hWHTA6mMoh7S1Zw8zEdbjD9x0HEpSF8n9Zad
	 CqLF1U7007b0yAKDOh6sfYQoq98DsMGy7qwSxLTA2TRAaeN5cbwdWOHytoMunBCemz
	 8mUcaFPGS57H4oqg93SvWEROSvsgexlOg2HuqYGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 016/241] wifi: mac80211: dont queue sdata::work for a non-running sdata
Date: Wed, 19 Mar 2025 07:28:06 -0700
Message-ID: <20250319143028.110714481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index dc0b74443c8d1..5ee7fc81ff8cf 100644
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
@@ -2190,8 +2190,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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



