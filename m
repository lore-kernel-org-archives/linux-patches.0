Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898F335BB8;
	Mon, 18 Aug 2025 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523676; cv=none; b=p8cO6nbvzc0lzD9l9n8rNsKbrYHIYrlSMlair5201AukHG4hjbA2FQuo+oCYcb99tTg9jNBfM6CpnFSF5Xt07XgTOcbfm0pfyEOCnxCmruBDN/KYla9UigqJDmWvT2sThOSHnDKjw2gtUoxqn/KstwSGq/scTyX+FZMIZ0siuuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523676; c=relaxed/simple;
	bh=1YKMc+O7bszezgWmwJ/ngpBvjNoCgse3TYGD4MK24NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsZBbci2owBuItGbEsONAQBUKmkBr1HVtSHeHm3var07lLTHSA9G8cyBe4J3rx4+7epYs/OvQJlWQgKFVIBFJ6H6JcAcFN5EzWvJDaScJz5TLRGwriJHz+0qvf++eje6u4Hzo5vderDUNr3/PivnrNOdG4gx9ha8WT5j3mDCOyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zu3/XgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zu3/XgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9443FC4CEEB;
	Mon, 18 Aug 2025 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523676;
	bh=1YKMc+O7bszezgWmwJ/ngpBvjNoCgse3TYGD4MK24NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zu3/XgUBPEZSR9s8HFw7NR3MxmtG2jnIYdEE2ZaQyuamfoo2YGu67/47P2v2Y1X6
	 5QPpmK6mjw7e+kHZNY1rtmbX+i/4XE2rwjoR3OWZr90YW1GlJf5lHGAS85HVPlW6VJ
	 jbOKbCFAmEYhiDydxNKoYMaF3MiQvbg80qjx2e18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 244/515] wifi: mac80211: avoid weird state in error path
Date: Mon, 18 Aug 2025 14:43:50 +0200
Message-ID: <20250818124507.780212667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 829032258978..5989cacb9d50 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4462,6 +4462,8 @@ struct ieee80211_prep_tx_info {
  *	new links bitmaps may be 0 if going from/to a non-MLO situation.
  *	The @old array contains pointers to the old bss_conf structures
  *	that were already removed, in case they're needed.
+ *	Note that removal of link should always succeed, so the return value
+ *	will be ignored in a removal only case.
  *	This callback can sleep.
  * @change_sta_links: Change the valid links of a station, similar to
  *	@change_vif_links. This callback can sleep.
diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 4f7b7d0f64f2..d71eabe5abf8 100644
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
@@ -368,6 +368,13 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
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



