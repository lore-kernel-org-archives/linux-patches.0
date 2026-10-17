Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13493AF66D;
	Sat, 17 Oct 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256671; cv=none; b=Yrjkro1MtaHyS+A1vEFt9fFUt9rubhjQ7WTq7XRja+2/E39SW9C/IogTCuygaJzXVGoeKh+bEBStfoduSWJ+GbkkYgQ/DrTFnWwSPN8RvV8uSTelkwbAUiz++iWQEvl3KJh/cHKV7xOprEjs1xik2FeKx7PvZhtEY/VjYM3McHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256671; c=relaxed/simple;
	bh=iP9i1P6aTIkbJoNIbomueJkNOwzLj9H7xQKtqsCaG78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhKHrp6DTSzozPsyQp3m1gAh8EQ1PmlTk6nwi9og/4pdfJEk5lpCx7kgtlnNh5V+eZTokwetmTzsBS6T6FCPboF4yJbZu31Fw4LB/wYQY8EnbAytm8ZKuzsfR3ES3wqzJlwzzkCt8vv1sbhhY1DhWE2hgVHJ2/FW57Acm8vQrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1qXlD2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1qXlD2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA171F000C4;
	Sat, 17 Oct 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256670;
	bh=kBh3s9cR1z1csm1TkLEu3Pk+v3ykYaJJaYHgZ/n4M+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1qXlD2HOXuobyj1XJ/rCpFeWBYkTIjS+dMbHsLy3sRKFO4JUKy9QzRVBfkRgXYgz
	 sNjOelCKfWBx5d3RVtqYf1gyDvWkluozPo+zrQtR09jWPRoJdIOETvKT4j0QeuK4RN
	 m8e04TfmaGqQY4fDjYMZiK9Qnyg2wCzFvuaY4DHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0314/1674] wifi: mac80211: drain PS delivery work during station teardown
Date: Sat, 17 Oct 2026 17:43:06 +0200
Message-ID: <20261017160439.180152742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -122,6 +122,8 @@ static void __cleanup_single_sta(struct
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
@@ -160,8 +162,6 @@ static void __cleanup_single_sta(struct
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
-	cancel_work_sync(&sta->drv_deliver_wk);
-
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
 	 * driver to finish aggregation stop and then clean up, but for now
@@ -1466,6 +1466,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


