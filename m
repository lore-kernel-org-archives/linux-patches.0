Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD71F8911;
	Tue, 17 Dec 2024 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455686; cv=none; b=Pq5Jd3euHpDw2Vt5pjIRylWPkJscA7iebgS9WAo+Cg6DKfz7haLNxxnGhiJDZLGbIswuv0e4Jv1hpoCwOr39vg7iksveXY4FCYoUauJBPV9rh47iTPKqKqqE5DkAFpVtNU5c6mr5tZQt/Mi/LKLGB4f6FSK3FNIcT8TLP4jxFpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455686; c=relaxed/simple;
	bh=kX3YvymP7L0gwKDmnypial//P7cf7B3/Fbud8rlSDDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0ZLsWbP69HuoXVQNyb1/xhT2eFuLWufm6jYZvgh2pzjzfwco1f7vocjBoaAolKZt4F5Lj6D7tizOTKMsDDgh4eNGG1nwKN5QmnWj9+ODxkkG7dbFjD0Zx06VnR5KGN6v6NMfgcGPT4oM9mD867ua4oY91Z47+mSCYDagD60hto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGMYIm91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGMYIm91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E26EC4CED3;
	Tue, 17 Dec 2024 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455685;
	bh=kX3YvymP7L0gwKDmnypial//P7cf7B3/Fbud8rlSDDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGMYIm91DNTBkiW2Ms5aeazY2DWEhGfH3buk9VnIThWaWw8u7zqS6djdFs8oUCN8z
	 hzgsLrgrUdO/E7fMg0TIa3plCak9/C9i+XzHQ3IS/mhrqcFsYfKglUF4XqiuHaPMIl
	 Wc+qQNht+lvgolcq71QfCu1ELvn0VFSRQMkjev/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/51] batman-adv: Do not send uninitialized TT changes
Date: Tue, 17 Dec 2024 18:07:12 +0100
Message-ID: <20241217170521.084365209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit f2f7358c3890e7366cbcb7512b4bc8b4394b2d61 ]

The number of TT changes can be less than initially expected in
batadv_tt_tvlv_container_update() (changes can be removed by
batadv_tt_local_event() in ADD+DEL sequence between reading
tt_diff_entries_num and actually iterating the change list under lock).

Thus tt_diff_len could be bigger than the actual changes size that need
to be sent. Because batadv_send_my_tt_response sends the whole
packet, uninitialized data can be interpreted as TT changes on other
nodes leading to weird TT global entries on those nodes such as:

 * 00:00:00:00:00:00   -1 [....] (  0) 88:12:4e:ad:7e:ba (179) (0x45845380)
 * 00:00:00:00:78:79 4092 [.W..] (  0) 88:12:4e:ad:7e:3c (145) (0x8ebadb8b)

All of the above also applies to OGM tvlv container buffer's tvlv_len.

Remove the extra allocated space to avoid sending uninitialized TT
changes in batadv_send_my_tt_response() and batadv_v_ogm_send_softif().

Fixes: e1bf0c14096f ("batman-adv: tvlv - convert tt data sent within OGMs")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 660a5594a647..ec30c1d36160 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -990,6 +990,7 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	int tt_diff_len, tt_change_len = 0;
 	int tt_diff_entries_num = 0;
 	int tt_diff_entries_count = 0;
+	size_t tt_extra_len = 0;
 	u16 tvlv_len;
 
 	tt_diff_entries_num = atomic_read(&bat_priv->tt.local_changes);
@@ -1027,6 +1028,9 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	}
 	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
 
+	tt_extra_len = batadv_tt_len(tt_diff_entries_num -
+				     tt_diff_entries_count);
+
 	/* Keep the buffer for possible tt_request */
 	spin_lock_bh(&bat_priv->tt.last_changeset_lock);
 	kfree(bat_priv->tt.last_changeset);
@@ -1035,6 +1039,7 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	tt_change_len = batadv_tt_len(tt_diff_entries_count);
 	/* check whether this new OGM has no changes due to size problems */
 	if (tt_diff_entries_count > 0) {
+		tt_diff_len -= tt_extra_len;
 		/* if kmalloc() fails we will reply with the full table
 		 * instead of providing the diff
 		 */
@@ -1047,6 +1052,8 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	}
 	spin_unlock_bh(&bat_priv->tt.last_changeset_lock);
 
+	/* Remove extra packet space for OGM */
+	tvlv_len -= tt_extra_len;
 container_register:
 	batadv_tvlv_container_register(bat_priv, BATADV_TVLV_TT, 1, tt_data,
 				       tvlv_len);
-- 
2.39.5



