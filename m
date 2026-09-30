Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849F751AFFB;
	Wed, 30 Sep 2026 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788406; cv=none; b=RJhe4/KrMSfoDdJhVor/5OkGVi688En1MrW6B//MNrBDEetDe6yRfXxfE6gzZ610OnsXsNqkwiB1g7w9m6HqhUa6KMofKJzdxuXYGQQnO/8H0Ampd7EHF7BCqp+w1TN8+vRMqtZHpipv5CFnmh4OcccNy1EM+GTgtu3qQbp2w3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788406; c=relaxed/simple;
	bh=DpkEIXQ6+Z8WQrOFyciXV8QYFtGLjciBc6Ch3EV/18A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGVcpZ67eFIx78FCrK+FPVGUycgaX6OCUE6ENjiTJHqZkjWx8RMG4HdolUtmSZLZCO+okryFC4NoyPkkDN9hNfgrHlYSwUsfc5pw/JnAx5nx2qmh6WGNogiIpx5YvDskdB1vVvxvokMUlqgotzyJTtxcYYxTV+RfjyJegOFvUkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEqamEyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEqamEyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6991F000FF;
	Wed, 30 Sep 2026 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788405;
	bh=voxJrtO3ohuhji+Hzhs2x5VD6aFf5IJVBg/oBBiBolM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEqamEyFgVxsXKkByn20F2LqObqoMtOwnEk+HllHJj+rzavttx5bgFBkt8Kn+0Z/s
	 QFL3OeUhlBbkFsD2LIFrxtgaAESaocLdvahz1AmVBrrmakdr3sbe6yjwcwArngayGE
	 WQ9SSmDCBCTchcPQk3ufGyqhFMr3KWyFzmPNX5Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/877] wifi: cfg80211: expose cfg80211_chandef_get_width()
Date: Wed, 30 Sep 2026 17:16:19 +0200
Message-ID: <20260930152416.207325841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b5c1622762f0937a66b69b7f15466c28fe85dcf1 ]

This can be just a trivial inline, to simplify some code.
Expose it, and also use it in util.c where it wasn't
previously available.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250311122534.c5c3b4af9a74.Ib25cf60f634dc359961182113214e5cdc3504e9c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: e14bf37bb2b3 ("wifi: mac80211: don't allow injecting frames wider than the chanctx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 11 +++++++++++
 net/wireless/chan.c    |  5 -----
 net/wireless/util.c    |  4 ++--
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3915118c15d7..ede91e4709ee5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1008,6 +1008,17 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *chandef1,
  */
 int nl80211_chan_width_to_mhz(enum nl80211_chan_width chan_width);
 
+/**
+ * cfg80211_chandef_get_width - return chandef width in MHz
+ * @c: chandef to return bandwidth for
+ * Return: channel width in MHz for the given chandef; note that it returns
+ *	80 for 80+80 configurations
+ */
+static inline int cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)
+{
+	return nl80211_chan_width_to_mhz(c->width);
+}
+
 /**
  * cfg80211_chandef_valid - check if a channel definition is valid
  * @chandef: the channel definition to check
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index b1a8d17baa62a..6f4b4770bf50b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -55,11 +55,6 @@ void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(cfg80211_chandef_create);
 
-static int cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)
-{
-	return nl80211_chan_width_to_mhz(c->width);
-}
-
 static u32 cfg80211_get_start_freq(const struct cfg80211_chan_def *chandef,
 				   u32 cf)
 {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8cc205b9f105c..66f95044adb2a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -5,7 +5,7 @@
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2023, 2025 Intel Corporation
  */
 #include <linux/export.h>
 #include <linux/bitops.h>
@@ -2954,7 +2954,7 @@ bool cfg80211_radio_chandef_valid(const struct wiphy_radio *radio,
 	u32 freq, width;
 
 	freq = ieee80211_chandef_to_khz(chandef);
-	width = nl80211_chan_width_to_mhz(chandef->width);
+	width = cfg80211_chandef_get_width(chandef);
 	if (!ieee80211_radio_freq_range_valid(radio, freq, width))
 		return false;
 
-- 
2.53.0



