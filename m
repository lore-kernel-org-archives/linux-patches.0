Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBDF4E8E15;
	Fri,  9 Oct 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557279; cv=none; b=XOpi4wAynmTNZ4iF2/VlY6f6AVB0jJuZgiclQBgMqJ8QcImBOzOXbSPpd1Sbk6gkfPi7POkrECu08LKd5acltYsFiVGokwJP1fgHDeyNg39nOdCOHbkI1Ixn+kXw4OazVRIzM6+RoCpXlO/lEITo8irzvbJ6xCm87wHSdCGDE4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557279; c=relaxed/simple;
	bh=Do3y3A0pzjME4IWA5E4xQugfic86SlUg3fEzK/1H2dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8r7vF36qMYhii1vU5YvjOboQzCxlQcrE/x12UQQ87cXfUt8JTPRFA0wldlwEViy9Yc/rOBTFwfNV6CVSyhBXaahD5icZ9qdf7TWYYVRnHeBVHiNVA81BRyWxg9HXohCVsCtGWbH/oh2arxKDApFniecZ8dqfYCIi26zQg/eyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQLSt8/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQLSt8/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7191F000FF;
	Fri,  9 Oct 2026 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557278;
	bh=hed+I4qSg61scpTNuicKyoo1xZt7NsDMhy7fZC+/2Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQLSt8/OaaVnQ589TnUm588uukgEsNwIE7FyUnEYlpxJH2HF9eSaqu++9/S76vhwS
	 FXOUEHnlyFPswYWDNT/n9KgZWLUFPjokHPZM1S76nhxvnA50B4avHbXlEYm8/8brD7
	 1tkueRmByt7WCfU4xbzcVvRLn60tik2sS1HevO+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 330/428] wifi: mac80211: drain PS delivery work during station teardown
Date: Fri,  9 Oct 2026 16:11:07 +0200
Message-ID: <20261009140953.387372789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,6 +137,8 @@ static void __cleanup_single_sta(struct
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
@@ -166,8 +168,6 @@ static void __cleanup_single_sta(struct
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
-	cancel_work_sync(&sta->drv_deliver_wk);
-
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
 	 * driver to finish aggregation stop and then clean up, but for now
@@ -1582,6 +1582,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


