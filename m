Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CBB1527B1;
	Tue, 17 Dec 2024 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455784; cv=none; b=os2SnLCKwGMDn67uzOinW5MvZyKyWSl+kxGB8hjGdI9wWaJvP40v9jXk0HAB4tlpGckp8/bUdWQKEnPEPcRJdkMJ+2x+7VgJrZXH0nRtfLT9G4491AdEbfivKdbQk34Qi3lEafmwxs0xOuAkqe8BbDTPdIr7tXWj9ukVQlDJ8f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455784; c=relaxed/simple;
	bh=GK03mYDeaoy4CWqYN17Ea5heXsmH7QX8hvVIxAXDwc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfzitbA18XFRxTZ2b41lQ178A2/JqgL3DvYCEo6oIc7NcXN8kbmvTkrMtChdUeGHVvQKuWpRnmMt4UuHZC0lbSUmD0j7sktJ/WG/1rUovL9OMqTZqzqdVdu4/Zqbqm1elboW0v6PeGLEbQQSSvNSsFjCYZLPEZpCVaX8of71BQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2yA4fSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2yA4fSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067F6C4CED3;
	Tue, 17 Dec 2024 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455784;
	bh=GK03mYDeaoy4CWqYN17Ea5heXsmH7QX8hvVIxAXDwc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2yA4fSQxyEJPQjMUuB641+ovRBn8wm1DirugExe584hnz8IZQ5FgGpIV/ZPp23Z1
	 QjT2hSx9EohZSzdLLF4J4SQuYpHZqyl3H++ELI6Mf5aSnwkZev6QQ6SOj/Ia/bTJbr
	 baXVH+PlKpbQ5hV8ECakcgbQ1J0lmz/EfXB2z13c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/76] batman-adv: Do not send uninitialized TT changes
Date: Tue, 17 Dec 2024 18:07:12 +0100
Message-ID: <20241217170527.598832499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4fc66cd95dc4..7711f87397d5 100644
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



