Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE40121ABD0;
	Tue, 12 Aug 2025 18:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023936; cv=none; b=UBrATD7fm++tqH7cFsMES7Fw2MD/BAbkn1fRXRAoyXhrIJKqHm/CHd0JHafOxOwd70y7lMixZpVBje4FfIFd9agNdjiwNdnB/fLiIDvTuNMUJ5qKtTnIxx3O0gXgdoSvh2lCsfpT1xHe8MeOTb4OOvXwufFzC+VdKxEfg2m8QA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023936; c=relaxed/simple;
	bh=/O6oJBelGsbXIyKuz4NbLe0Etn0iiNPGlHdD37dZXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAPHcHtl6wktmWBvWYqW+KGXZDw/x9wNH1qrGrP+03zRBNlH8ftW3sGI+CZvZyJly5fUL8vEvhcSnfmPJEaklQ+qw1oD8Op+74JIc02f0dhGKDFlSP5ls24sFeR1zqxle5cRbDkEPUg0mJH+4+KBo/AhvXuusMidbbmRy460HUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSqmpA9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSqmpA9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3E7C4CEF0;
	Tue, 12 Aug 2025 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023936;
	bh=/O6oJBelGsbXIyKuz4NbLe0Etn0iiNPGlHdD37dZXoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSqmpA9h81H5NM6rEAHLOr4KnsOjjx8u2fclig3QV9KXL+h52RvQ085WTJwdMPqg6
	 lL99pBbw+CYbirmXW/Umz+nuHXRZhK8oVU9ijNFVkmV748KWMZ0X3abV77RNfMSPRW
	 dZbvNM0ov3neCMAoIh7tWl7WNqRrjK8CtirvuLiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 225/627] wifi: mac80211: use RCU-safe iteration in ieee80211_csa_finish
Date: Tue, 12 Aug 2025 19:28:40 +0200
Message-ID: <20250812173427.845472547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>

[ Upstream commit 9975aeebe2908cdd552ee59607754755459fad52 ]

The ieee80211_csa_finish() function currently uses for_each_sdata_link()
to iterate over links of sdata. However, this macro internally uses
wiphy_dereference(), which expects the wiphy->mtx lock to be held.
When ieee80211_csa_finish() is invoked under an RCU read-side critical
section (e.g., under rcu_read_lock()), this leads to a warning from the
RCU debugging framework.

  WARNING: suspicious RCU usage
  net/mac80211/cfg.c:3830 suspicious rcu_dereference_protected() usage!

This warning is triggered because wiphy_dereference() is not safe to use
without holding the wiphy mutex, and it is being used in an RCU context
without the required locking.

Fix this by introducing and using a new macro, for_each_sdata_link_rcu(),
which performs RCU-safe iteration over sdata links using
list_for_each_entry_rcu() and rcu_dereference(). This ensures that the
link pointers are accessed safely under RCU and eliminates the warning.

Fixes: f600832794c9 ("wifi: mac80211: restructure tx profile retrieval for MLO MBSSID")
Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250711033846.40455-1-maharaja.kennadyrajan@oss.qualcomm.com
[unindent like the non-RCU macro]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/ieee80211_i.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bc64c1b83a6e..18ad7ab1bb8c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3760,7 +3760,7 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif, unsigned int link_id)
 		 */
 		struct ieee80211_link_data *iter;
 
-		for_each_sdata_link(local, iter) {
+		for_each_sdata_link_rcu(local, iter) {
 			if (iter->sdata == sdata ||
 			    rcu_access_pointer(iter->conf->tx_bss_conf) != tx_bss_conf)
 				continue;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 30809f0b35f7..f71d9eeb8abc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1226,6 +1226,21 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 	if ((_link = wiphy_dereference((_local)->hw.wiphy,		\
 				       ___sdata->link[___link_id])))
 
+/*
+ * for_each_sdata_link_rcu() must be used under RCU read lock.
+ */
+#define for_each_sdata_link_rcu(_local, _link)						\
+	/* outer loop just to define the variables ... */				\
+	for (struct ieee80211_sub_if_data *___sdata = NULL;				\
+	     !___sdata;									\
+	     ___sdata = (void *)~0 /* always stop */)					\
+	list_for_each_entry_rcu(___sdata, &(_local)->interfaces, list)			\
+	if (ieee80211_sdata_running(___sdata))						\
+	for (int ___link_id = 0;							\
+	     ___link_id < ARRAY_SIZE((___sdata)->link);					\
+	     ___link_id++)								\
+	if ((_link = rcu_dereference((___sdata)->link[___link_id])))
+
 #define for_each_link_data(sdata, __link)					\
 	struct ieee80211_sub_if_data *__sdata = sdata;				\
 	for (int __link_id = 0;							\
-- 
2.39.5



