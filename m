Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580CB25F789;
	Thu, 17 Apr 2025 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914061; cv=none; b=N6M3P4Dm/a87ie+Yk8I72uAj2a//BPf8QYmrEOduPu1LeuDbf0lFXA2Z4l7uANbm3wsnOpQt/5PW4XhPkfmjnALs0C39JZc08RYCwD98Ks/eVaKwPWMQBSLwPbtMjo5saaviFfVX7U91JRoih4S8EIDv3eafxss2Bs+CsDdT8cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914061; c=relaxed/simple;
	bh=z65Q5eH0n1RNOXeWmJ+YDUBiSJXG3cs9+KS0RkaKumg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5TlTLNND3JKlUZ8VU/XMMOCVjUZClgGjvn+DOy+Uy90n1O5+YQjiNscb8UnZvLD3ECeq2Vb3V53TCFd5SEl9h46N3weRYl/eWCvLcUgS+ApX80W7ugi6E5z71gHIhi11yxN4oNuHatd2/ZYojxW/Ciskpzf2bMd0yGNOqO0HM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSSsSimu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSSsSimu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F91C4CEE7;
	Thu, 17 Apr 2025 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914061;
	bh=z65Q5eH0n1RNOXeWmJ+YDUBiSJXG3cs9+KS0RkaKumg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSSsSimuS/fI4eO2s7K8AdKAR1wFNWeDQTaEq7/rXIH1HVCKQJNehVXzcq97whqOX
	 KKw9QD0ScBRKzGjSW2qsUZky/eDcOwAE9CEy13CJsPzPFxVAhuav5+DiXCc5uzd5QI
	 Y8Q+VsIoErCt9kLCvkcCWJ+QmY0tYF48rAb7pKMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 093/414] wifi: mac80211: ensure sdata->work is canceled before initialized.
Date: Thu, 17 Apr 2025 19:47:31 +0200
Message-ID: <20250417175115.183121437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

[ Upstream commit 6c93fd502023dd919b5987ccbe990735410edd49 ]

This wiphy work is canceled when the iface is stopped,
and shouldn't be queued for a non-running iface.
If it happens to be queued for a non-running iface (due to a bug)
it can cause a corruption of wiphy_work_list when ieee80211_setup_sdata
is called. Make sure to cancel it in this case and warn on.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250205110958.99204c767c10.I84ce27a239059f6009cee197b252549a11426046@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 04b3626387309..208d42172f473 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -8,7 +8,7 @@
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (c) 2016        Intel Deutschland GmbH
- * Copyright (C) 2018-2024 Intel Corporation
+ * Copyright (C) 2018-2025 Intel Corporation
  */
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -813,6 +813,9 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  */
 static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
+	if (WARN_ON(!list_empty(&sdata->work.entry)))
+		wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->work);
+
 	/* free extra data */
 	ieee80211_free_keys(sdata, false);
 
-- 
2.39.5



