Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211036;
	b=FtEfZ+ETW1tSIzNNRk9Jy3fFK34uxHy+IXfrgOr6dQbojCIcqPa/HGUYTu+ah+cyvdAj
	 Dp4sghTS8sMqFU/jGTiaEtUhrb5r4yqnAEPa2wNIQbUQrTMhIIsoh8F2ob7QBldod9YAN
	 PikSYDGdb4BmPtY27TmBPkqoxhrcvzH1jUN3DoHVhrwhGgKD3VaSiMTGtMR68tiyxMYGm
	 vk1MQfxBGtBzYHp+biOoYuj2M0QAy/bjS2ImmEUfGSDWRuzQvgrMAN9jzD7A25PJxHnN3
	 7rD4P8RgJNX8FBBwQtR9HFXPpK87WqhrE/unXwwMVA5CCxqDf6wD1Zd9PHAAnaEsGXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PW2qJ+Ciny2oSAyUMCmKgMaw3f+WOm9ZDLnX/nxs7qU=;
	b=U5wEpWKC76ds3r8VlssymK93vpg9EYX8luW/qoqpQ3FhM6xLYr88qoB+iN+hBbimzE7z
	 vFkBtBqYKOPZAf3JTnY7FnGKZyihKaTa68JXLT56B0oozEj1IrA2pC2eZAouf+ol6hPBr
	 YAo/IgWTdts14nnCAQbYLx+KvRzHQB5hLfLCI3n3bsEURQ0/TqkrN87rdqSFWibZ7b+zv
	 hgvtaz921AcZ3ZmiTih42kz+/wpz73BagrZJtEw27lIXSm6MrT94aKWa43mClW9f7FdKX
	 P99SK4Z8NVlmZiS2btINBjjf///pXHSxlaoanhrQiKdim0io3qdLTmJ9obI4MXd71EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQ5uyQgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF5760A2609;
	Wed, 28 Oct 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQ5uyQgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3951F031E1;
	Wed, 28 Oct 2026 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211035;
	bh=PW2qJ+Ciny2oSAyUMCmKgMaw3f+WOm9ZDLnX/nxs7qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQ5uyQgqppXpfl6gouFi0TK/z5OzZDJJDGx8deKUNKo00yJmf1DL43AvSJuMy9sDM
	 m6hjhmGIWNuXhMD2GBW93c/yQTddfSHJKnFIHJT/ruQlVLndSO8ZPAixffH9vFU4iz
	 Rleje7XZ5rXz3vHu8uWnh5eDJx3ud9kWk7uIuw/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 237/571] wifi: mac80211: drain PS delivery work during station teardown
Date: Wed, 28 Oct 2026 17:56:24 +0100
Message-ID: <20261028170013.629897592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 67a9e80c3ca20c9044cd6ee72cd6278dd19b5023 upstream.

Removing an AP or mesh station can notify the driver and wake TXQs after
the station has already been removed from the driver, and can update
num_sta_ps and the power-save queues after station cleanup has purged
them.

sta_deliver_ps_frames() tests sta->dead only before it starts delivery. A
worker that passes that test can be delayed while teardown sets sta->dead
and removes the station from the driver; when it resumes it still runs the
full delivery.

The existing cancel_work_sync() sits near the end of
__cleanup_single_sta(), after the final driver state transition and after
PS accounting and queue purging, so it drains the worker only once the
state it has to protect has already changed. Before commit d34ba2168a3c
("mac80211: don't delay station destruction") cleanup was deferred
through the same ordered workqueue as the delivery work, which kept the
two ordered.

Cancel the work after setting sta->dead and before moving the driver
state, and move the existing cancellation to the start of
__cleanup_single_sta(). The first drain closes the driver-lifetime window;
driver callbacks during the remaining state transitions can still queue
drv_deliver_wk through ieee80211_sta_block_awake(), so retain the second
drain at the start of __cleanup_single_sta(). That drain also covers
insertion failures, which reach cleanup without setting sta->dead.

Fixes: d34ba2168a3c ("mac80211: don't delay station destruction")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse smatch coccinelle kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113735.31029-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/sta_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -89,6 +89,8 @@ static void __cleanup_single_sta(struct
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
@@ -129,8 +131,6 @@ static void __cleanup_single_sta(struct
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
-	cancel_work_sync(&sta->drv_deliver_wk);
-
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
 	 * driver to finish aggregation stop and then clean up, but for now
@@ -1090,6 +1090,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


