Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1131F8679;
	Tue, 17 Dec 2024 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455691; cv=none; b=jk3peLyXaIzxORpatTrGfOuex13qCNZ3uLzw+fk6l8nLxXbmETYARof+mqzKaD5wFkoAVpIU3UWC7JOYIgDokWIBBr4jwSOI+rzhxKb3hronkLEU+WV5jfDarTI2/9bnnmbtZiGCZhSmxuWu1JaICUyoglslhxhzDxYNKQPke9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455691; c=relaxed/simple;
	bh=FexHeb5H4548fh+HkHDZ7YGJUqD7UfgpDepinA63GAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlbGEolgy86zxTXZyjVHacSlrvt/DyichS4Yjzmk4xPPWAdbsaWjrbddUKxOusl+W9009VQegk/KwxvjkKqSupIfrGlzRvxHmssRw86n442ou5yS23LCfHPKGhXkaeY2EbPrB/hWnJC2XBio6lV1ta3/KJpysEHuwqVAxXfxuVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0m/TAXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0m/TAXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2CAC4CED3;
	Tue, 17 Dec 2024 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455691;
	bh=FexHeb5H4548fh+HkHDZ7YGJUqD7UfgpDepinA63GAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0m/TAXe+pq5af2QuyfAG/6df6bOz0ew89ZxIeBoam3STOmn9nfE5Q2cXbPZBUopw
	 T5XGFtphI7KEv0wlkkjWM9RBHlYOmnIoUdK3xj7VVdku21TWp7dJyYSowH9q3INL1B
	 WQje6wg6D5rmf3V+0IdSIxihSyOEMVd7d7m3+jNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Antonio Quartulli <Antonio@mandelbit.com>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/51] batman-adv: Do not let TT changes list grows indefinitely
Date: Tue, 17 Dec 2024 18:07:14 +0100
Message-ID: <20241217170521.163567305@linuxfoundation.org>
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

[ Upstream commit fff8f17c1a6fc802ca23bbd3a276abfde8cc58e6 ]

When TT changes list is too big to fit in packet due to MTU size, an
empty OGM is sent expected other node to send TT request to get the
changes. The issue is that tt.last_changeset was not built thus the
originator was responding with previous changes to those TT requests
(see batadv_send_my_tt_response). Also the changes list was never
cleaned up effectively never ending growing from this point onwards,
repeatedly sending the same TT response changes over and over, and
creating a new empty OGM every OGM interval expecting for the local
changes to be purged.

When there is more TT changes that can fit in packet, drop all changes,
send empty OGM and wait for TT request so we can respond with a full
table instead.

Fixes: e1bf0c14096f ("batman-adv: tvlv - convert tt data sent within OGMs")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Acked-by: Antonio Quartulli <Antonio@mandelbit.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 5700a9eaa49a..6be14f9e071a 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -990,6 +990,7 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	int tt_diff_len, tt_change_len = 0;
 	int tt_diff_entries_num = 0;
 	int tt_diff_entries_count = 0;
+	bool drop_changes = false;
 	size_t tt_extra_len = 0;
 	u16 tvlv_len;
 
@@ -997,10 +998,17 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 	tt_diff_len = batadv_tt_len(tt_diff_entries_num);
 
 	/* if we have too many changes for one packet don't send any
-	 * and wait for the tt table request which will be fragmented
+	 * and wait for the tt table request so we can reply with the full
+	 * (fragmented) table.
+	 *
+	 * The local change history should still be cleaned up so the next
+	 * TT round can start again with a clean state.
 	 */
-	if (tt_diff_len > bat_priv->soft_iface->mtu)
+	if (tt_diff_len > bat_priv->soft_iface->mtu) {
 		tt_diff_len = 0;
+		tt_diff_entries_num = 0;
+		drop_changes = true;
+	}
 
 	tvlv_len = batadv_tt_prepare_tvlv_local_data(bat_priv, &tt_data,
 						     &tt_change, &tt_diff_len);
@@ -1009,7 +1017,7 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 
 	tt_data->flags = BATADV_TT_OGM_DIFF;
 
-	if (tt_diff_len == 0)
+	if (!drop_changes && tt_diff_len == 0)
 		goto container_register;
 
 	spin_lock_bh(&bat_priv->tt.changes_list_lock);
-- 
2.39.5



