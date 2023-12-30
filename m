Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E608563D5;
	Sat, 30 Dec 2023 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrAGu1VL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DCEC433C8;
	Sat, 30 Dec 2023 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937689;
	bh=LWu8UvjL7h4MEzCC7Ie9AuXpkdyzy54N7VD+iwBQOoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrAGu1VLXSiFJZKnyKvICBKbWwPVefppilcDNcPAMIyZ34ipIiT8UFdWWfV5CE/9E
	 CHUtZgupx+YQg0k8Hog7puyGeXMdcjYksCTXXCMUKKWXZIHaYvuQ79lT8U5bE1+Cb2
	 V37Ydt42PP4W6zVJHri2dHmMcYHyfkiVbK//wc6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/156] wifi: mac80211: dont re-add debugfs during reconfig
Date: Sat, 30 Dec 2023 11:57:58 +0000
Message-ID: <20231230115813.167582714@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 63bafd9d5421959b2124dd940ed8d7462d99f449 ]

If we're doing reconfig, then we cannot add the debugfs
files that are already there from before the reconfig.
Skip that in drv_change_sta_links() during reconfig.

Fixes: d2caad527c19 ("wifi: mac80211: add API to show the link STAs in debugfs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231211085121.88a950f43e16.Id71181780994649219685887c0fcad33d387cc78@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index aa37a1410f377..f8af0c3d405ae 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright 2015 Intel Deutschland GmbH
- * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2022-2023 Intel Corporation
  */
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -564,6 +564,10 @@ int drv_change_sta_links(struct ieee80211_local *local,
 	if (ret)
 		return ret;
 
+	/* during reconfig don't add it to debugfs again */
+	if (local->in_reconfig)
+		return 0;
+
 	for_each_set_bit(link_id, &links_to_add, IEEE80211_MLD_MAX_NUM_LINKS) {
 		link_sta = rcu_dereference_protected(info->link[link_id],
 						     lockdep_is_held(&local->sta_mtx));
-- 
2.43.0



