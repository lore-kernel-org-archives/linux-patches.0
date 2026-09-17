Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ADE522F11;
	Thu, 17 Sep 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664239; cv=none; b=Yv/JlhIdk0fK6gCA/TqjSG7UxzbAeQtEPdDVpdIeBgmYZLX8rziRf7TW2aWptSBcVpJxGA6TKyGDiobIuaiMIJ8bb/qOk8kv5WaO9zyx6mpY8cONxuxlc6agqfsPZ5GxuWTGP0O8yYrDQWaqoUG+bWB64c7sCQIY3WbllZIB8uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664239; c=relaxed/simple;
	bh=QVtOT8wA7DMx9dVw7Nbn79z6jLRYLxt7f/5+qu0xQW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxPmyfLmj1YcxD/OaaRyrRVWj8gGVZTpSG8Usj2HsImE6iUjCmgF/0p+flIYyfmND6zGnj/cZdCbgxHe2VtqFoEoY2llz1ugiIUmdBpHK9UNKIjsDWzM3Q0UsfSNRUrZBQL0Bu3mWQWwSIA/CMAR/xJUKFUUVl1UBYX0X4SKS94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1kw2avW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1kw2avW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6EE1F000FF;
	Thu, 17 Sep 2026 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664238;
	bh=fNDj0Mb43xfB4f29q3/ORjVtk45pt7XaUhTjFn7gMZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1kw2avWpZyqkD2bW+UbbxKGKh6JJNHMAtivkloBCKVsDG+AJUHhTH7qySddEVlG+
	 htkGc3t0j2hCSVJY9BAG8q9q1Z6IMn//A3rSwzbsOl8BK+ZOMW5IZh0m7BNeg8muJq
	 jZRVsKN1qE1m6zqK1HmxcIbwx1X5FdYmFa8jvnFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0306/1250] wifi: cfg80211: harden cfg80211_defragment_element()
Date: Thu, 17 Sep 2026 16:01:41 +0100
Message-ID: <20260917151600.405163606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e48223525a54d3a3182d2d9a497dca022b942b4d ]

A previous commit changed mac80211 to no longer make wrong
calls to cfg80211_defragment_element() with the element
pointing outside of the buffer. Additionally, harden this
function itself against that and always return -EINVAL in
case the element isn't inside the source buffer.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260529102644.198945754054.I5ae8fdebf9008abc6e15d0b0f10c3a7b73d02eab@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 11f7a27bb7046..9648e24181fb0 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -5,7 +5,7 @@
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2016	Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -2626,7 +2626,9 @@ ssize_t cfg80211_defragment_element(const struct element *elem, const u8 *ies,
 	ssize_t copied;
 	u8 elem_datalen;
 
-	if (!elem)
+	if (!elem || (const u8 *)elem < ies ||
+	    (const u8 *)elem + sizeof(*elem) > ies + ieslen ||
+	    (const u8 *)elem + sizeof(*elem) + elem->datalen > ies + ieslen)
 		return -EINVAL;
 
 	/* elem might be invalid after the memmove */
-- 
2.53.0



