Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391F62566FB;
	Thu, 17 Apr 2025 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912733; cv=none; b=ho/5WhWUgyI758GkAP+FHkR9g2jTRgD4LebbXSOUYTTVu0HqaMrowepMkBL10ajkSPnHZN/mU9EjSMJW+AzQwihtpikFROk2Em93P3cpKLS2pcARwSudGrkZ+RUjD9bw3SlkS5qk5gfln7AjqdktgOP3MBBJwvZIRCGWsHlpQIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912733; c=relaxed/simple;
	bh=IYHrVVrYMFJNwPG7rTig8SybX6OKVGxssGD6s9gERBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnZ/x2avM8jpoQI1kpThZCQh2auZgjOMqg/qHxbYrSUDOAouMaVGZ+fXmQMSG3rRyvLmUFsTzLZnGDcFkvB80h0ImU0iz5b9DMblL0HpKCPvAq5spQQX7XdNHuIXLuBHMZzRwxdH3vT5hYhUqvFaq+7Xcrfd6RBWDop2CcH/SG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgOQ4Y+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgOQ4Y+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40371C4CEE4;
	Thu, 17 Apr 2025 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912732;
	bh=IYHrVVrYMFJNwPG7rTig8SybX6OKVGxssGD6s9gERBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgOQ4Y+5qGVveDWfWZ66ju06AfyGipjUlKIPcnNO1E58GTLtNlrrRXr1zmMdM0H17
	 KQbU/86c7S65qq8rqrs99CZcFYToycwdRmn+5KmMidgNDW2H/2ynuKw9gRWPmeirfi
	 JgQMK8P1Q15NN904d7bBbWFGf3C1EJ3DZ+TGw/j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 107/449] wifi: mac80211: ensure sdata->work is canceled before initialized.
Date: Thu, 17 Apr 2025 19:46:35 +0200
Message-ID: <20250417175122.271785586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 738de269e13f0..459fc391a4d93 100644
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
@@ -807,6 +807,9 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
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



