Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E39318144;
	Mon, 18 Aug 2025 13:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522066; cv=none; b=pnQDK6bWR/5uc1ktv40xE26avkl+C6evrawSOxhjBDloSvEEI9NVIAtprHwp31gKfnu0cZ/C7eBGXHuQfW9oBosBjGPCSGPWFKC21m2q7mogu1BtZnqMXqWLfsSwXMWyT5yAlXMRpd5d65xTd8u20DZS0vnsVm7w/3W9XoMj6dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522066; c=relaxed/simple;
	bh=5XgPUZVJmJQqg+oOu32LPIWqDUOLkm5E3TuJ/V2vpVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTVGoRCxTRxboEE0DXIdO98/a5vtuGzGcBA/7CrE16CyDJHQvogSBtEP2pm/MpWNzVXG+Zus+R0RLzQf0kVS45ZRwWoBX6EWjkY4IA2FD23YPsZIq2ddrriIDsqSUrWuY1+kU5Ek8ztUx3JEgAm5+9NmyivX5j/5fOgHhnnIh7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No4Y7kX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No4Y7kX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0668EC4CEEB;
	Mon, 18 Aug 2025 13:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522066;
	bh=5XgPUZVJmJQqg+oOu32LPIWqDUOLkm5E3TuJ/V2vpVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No4Y7kX99vDkyx48JQETcewr/owGiLsZXn8zcGqOSyZFRcUrm4lXgKoJQYv4gWOBX
	 JC3EXOT77UJVQXGL6CmTDh81HNV9YaPVKFucESpyerM6roVDF+q/7bgtnjy43iBYKu
	 R2sS17ARwVN5Rum0ibVBnb26OoDxkaXzfiNGf8ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/444] wifi: mac80211: avoid weird state in error path
Date: Mon, 18 Aug 2025 14:43:50 +0200
Message-ID: <20250818124456.510017866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

[ Upstream commit be1ba9ed221ffb95a8bb15f4c83d0694225ba808 ]

If we get to the error path of ieee80211_prep_connection, for example
because of a FW issue, then ieee80211_vif_set_links is called
with 0.
But the call to drv_change_vif_links from ieee80211_vif_update_links
will probably fail as well, for the same reason.
In this case, the valid_links and active_links bitmaps will be reverted
to the value of the failing connection.
Then, in the next connection, due to the logic of
ieee80211_set_vif_links_bitmaps, valid_links will be set to the ID of
the new connection assoc link, but the active_links will remain with the
ID of the old connection's assoc link.
If those IDs are different, we get into a weird state of valid_links and
active_links being different. One of the consequences of this state is
to call drv_change_vif_links with new_links as 0, since the & operation
between the bitmaps will be 0.

Since a removal of a link should always succeed, ignore the return value
of drv_change_vif_links if it was called to only remove links, which is
the case for the ieee80211_prep_connection's error path.
That way, the bitmaps will not be reverted to have the value from the
failing connection and will have 0, so the next connection will have a
good state.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250609213231.ba2011fb435f.Id87ff6dab5e1cf757b54094ac2d714c656165059@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/link.c    | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 155421671fff..80259a37e724 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4435,6 +4435,8 @@ struct ieee80211_prep_tx_info {
  *	new links bitmaps may be 0 if going from/to a non-MLO situation.
  *	The @old array contains pointers to the old bss_conf structures
  *	that were already removed, in case they're needed.
+ *	Note that removal of link should always succeed, so the return value
+ *	will be ignored in a removal only case.
  *	This callback can sleep.
  * @change_sta_links: Change the valid links of a station, similar to
  *	@change_vif_links. This callback can sleep.
diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 9484449d6a34..cafedc5ecd44 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -2,7 +2,7 @@
 /*
  * MLO link handling
  *
- * Copyright (C) 2022-2024 Intel Corporation
+ * Copyright (C) 2022-2025 Intel Corporation
  */
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -365,6 +365,13 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 			ieee80211_update_apvlan_links(sdata);
 	}
 
+	/*
+	 * Ignore errors if we are only removing links as removal should
+	 * always succeed
+	 */
+	if (!new_links)
+		ret = 0;
+
 	if (ret) {
 		/* restore config */
 		memcpy(sdata->link, old_data, sizeof(old_data));
-- 
2.39.5



