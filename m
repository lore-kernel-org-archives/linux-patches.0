Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8B023EA8B;
	Tue, 13 Oct 2026 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895235; cv=none; b=TdnVClgE/ED/aL2FzvbqLaXiVsU7/GTwsXDlQ744rIoQljJAQqq4cIoo624YhKnGC4+MQVLdSHd950tt5YO4oB1WIzD0M0CXeGsE8OUT9XGvxPkpEuLMhypAomOLWbdXDibgk13cxQrfeQ4OEfSes0w/jZm2Bbb6TBSShBMnLN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895235; c=relaxed/simple;
	bh=Fi3cMvxCp4V2QgJSSNXP4zn60p334G6L7PY0qDA5t5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfROeUA6QmsZ9/rmTh7DcgMXjN8BnXNwjGumD7v7YAHDoN2DOgzp2brPsZ+bn95ymCwAzSgsVnfQjsjdIcU0gZQUnhF/zCtTchtu9zIZD6BvZHbleLDtWffj0bQ5BahPcA3pCzigdsI0kWvRNSYsj+93ROyTKfXhNe3ifyTxPLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooZEaw1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooZEaw1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DA21F000FF;
	Tue, 13 Oct 2026 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895234;
	bh=RDMcnNgxN8gE5BkFk2xIcO/pLCgsxmSB9lUMH0QGL94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooZEaw1eSwG3R98XplevTZFyuoulBC4d9uQsKUjkZKi+bOQzajTPYnOXj22WqScuj
	 pEwwqe9SGgOTaVKdl0XzQOhk8yokJ+cuqj5A6Y59g3xO+Dqvg0tVec1VIQuJoSC61X
	 XoMZUD36b3nly3XTd3dXO1eohjsAtHrAA2OWWrlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 206/497] wifi: mac80211: drain PS delivery work during station teardown
Date: Tue, 13 Oct 2026 13:36:13 +0200
Message-ID: <20261013112912.779947103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1455,6 +1455,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


