Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208727;
	b=wHo1X9w0vqciDPOFP4hszS7D86f873SiL/VP8alakNJ5cZFp9EiOLSBZtNBaaTBiYdwc
	 agy+gDTswJxHcah5PD83NUt1hC96PJ5KM8i0U4r9uDGYpmMr5/FmKbeApeqGsJ26mJAb2
	 tmrmBAqNF+RlWui3EMwe3WsDAaWDpYRgIxvAroH2cttbcvP2pre2QtS4QbtmlLueSyNc8
	 9sihiWRJMN16yDifxtkJpi2cqtUKGyGwnABYoYbvzJWJSz8kDznW+EEMDIP48XlMVZlZX
	 NmEqjwT5L0XOqzJ1MQH9Iq+7UcwnD5zCunU4Z3LrvuCsdLGz781iCf+V/LuggjtD3ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDS/8hZh+ls0QOE5yYrubif0inCXjDyfeuGgtOicS6w=;
	b=saKReyc5xLDH1QVNxUv0wfwHuB6qCrC9eKYhcVgwsC08npQl6GNwOn77usvW+nfGQtEQ
	 xYUIrNhaljOMxtYRv1sdk49if6GEEsJbRY2c0iR/WIYk/njG+2+N4iuJAf7+Zl+rfm6GI
	 GhYQSjJ5kk5KvuoJehhIxNlzilH83b5xl7yr0YsgYpxqOBSYHgvZ2zwyBfRfvs5Qlz1Cw
	 SBNaTwc4Ap7zH4y9FFsCKQhvaHy9I4p571BpiFl0oa51Qvf3CmdsaPuJ7a4xlMInLrfeH
	 z/7N3XPf3jTc2YyzZeq0yr6oto2gt+pcOxwDzZd3kWSG3/jraNzhjdD7uasmYJF4tdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKbVMlb2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636A606A31E;
	Wed, 28 Oct 2026 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKbVMlb2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63DF1F01825;
	Wed, 28 Oct 2026 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208727;
	bh=sDS/8hZh+ls0QOE5yYrubif0inCXjDyfeuGgtOicS6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKbVMlb27KOLGHw+MMHDJYK+C4/runoI7AfthLVs122jKGqxaHfP9vdJ/q6Q5/rHj
	 EwSt/rDX4Rv/kS7Im1hpC8+8R2uu9qHxCKt4/qw8nUngJKeotROTwjpzqcgswj1VAV
	 KqzkYf8yawnzzlX2+q3kz87xOhrB+ABF5HXK9iog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 220/516] wifi: mac80211: drain PS delivery work during station teardown
Date: Wed, 28 Oct 2026 17:56:12 +0100
Message-ID: <20261028170008.713008925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1094,6 +1094,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


