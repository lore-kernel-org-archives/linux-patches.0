Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A173D34A2;
	Fri,  9 Oct 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556774; cv=none; b=FoHcKJERzhw/hBe/tM3r0WL2Ijy9manx29KXmd9BRnK/6um0Iu3JE1SCeaInd3xyjOYEfO5G3dXjv0EwxKamCCmbG37YAmVQ833HTMSyjjHDz+ynzsrhR+XXOfZGeBQIAcfKVLetilBaSSwjaNn0nWlf/IADeBuTAz71yWqCb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556774; c=relaxed/simple;
	bh=CesU72RswFsjDk/oKiQ9hbt6kfvyyxiSTGQm5pscAns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCSu1jk6ECVfaoDBduEdPL/YLo3a8dKfK/HvPR3xx3oRjo3UL2wT/THQLCO+BDcrN8tzOIGxjKJ88n+rxKom98mk3cEI8qToredCQT408udSAa2PxjwyPK6WXhcK4SLkx8+IHykHGd903lx6CF97Aq7FZ4Vfz+6bc3moC8QDa4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeGUaEio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeGUaEio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34D1F00893;
	Fri,  9 Oct 2026 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556772;
	bh=2n+OBrh2q4gMq3qFns5oG1dHBhIU/3Ao5RBUdqmKcQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeGUaEioVJa7EaXa9Lip/j0RYHgN0SbghRHswDHSloVMyEuseTPetiqQXQnNqpYJy
	 ZUvBJFVWyHINLqgXq64PwFxjya02f6TdGj++YvbMe7KPKdR8nmE0e0G027Ywr2wk1w
	 R0SYdllK3DL0H8uiJ8IfbnPjZ0OpgnF6rSdBrf4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 291/403] thunderbolt: Fix domain reference leak when DPRX read is canceled
Date: Fri,  9 Oct 2026 16:10:52 +0200
Message-ID: <20261009140959.007835021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit 1fd1f67c94d30889377bba774f032ec15e8b9299 upstream.

tb_tunnel_one_dp() takes a domain reference which is only dropped once
tb_dp_tunnel_active() has run on the work queue. If that work is
cancelled that reference is leaked. Since
commit f5cc545f5969 ("thunderbolt: Wait for tb_domain_release() to
complete when driver is removed") instead of just leaking memory this
now also blocks in the completion wait forever when unbinding the
driver.

This can be triggered whenever a DP tunnel is torn down before the DPRX
read has completed, e.g. by unplugging within the timeout, and then
unbinding the driver.

That reference only exists to keep the domain around while the DPRX work
is scheduled so let the work itself own it: take it in tb_dp_dprx_start()
and drop it in both places that end the work. Get/put are then paired
inside the same file and it doesn't matter anymore if the callback ever
runs.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c     |    6 +-----
 drivers/thunderbolt/tunnel.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1964,8 +1964,6 @@ static void tb_dp_tunnel_active(struct t
 		tb_dp_resource_unavailable(tb, in, "DPRX negotiation failed");
 	}
 	mutex_unlock(&tb->lock);
-
-	tb_domain_put(tb);
 }
 
 static void tb_tunnel_one_dp(struct tb *tb, struct tb_port *in,
@@ -2026,8 +2024,7 @@ static void tb_tunnel_one_dp(struct tb *
 	       available_up, available_down);
 
 	tunnel = tb_tunnel_alloc_dp(tb, in, out, link_nr, available_up,
-				    available_down, tb_dp_tunnel_active,
-				    tb_domain_get(tb));
+				    available_down, tb_dp_tunnel_active, tb);
 	if (!tunnel) {
 		tb_port_dbg(out, "could not allocate DP tunnel\n");
 		goto err_reclaim_usb;
@@ -2048,7 +2045,6 @@ err_free:
 	tb_tunnel_put(tunnel);
 err_reclaim_usb:
 	tb_reclaim_usb3_bandwidth(tb, in, out);
-	tb_domain_put(tb);
 err_detach_group:
 	tb_detach_bandwidth_group(in);
 err_dealloc_dp:
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1116,15 +1116,17 @@ static void tb_dp_dprx_work(struct work_
 	if (tunnel->callback)
 		tunnel->callback(tunnel, tunnel->callback_data);
 	tb_tunnel_put(tunnel);
+	tb_domain_put(tb);
 }
 
 static int tb_dp_dprx_start(struct tb_tunnel *tunnel)
 {
 	/*
-	 * Bump up the reference to keep the tunnel around. It will be
-	 * dropped in tb_dp_dprx_stop() once the tunnel is deactivated.
+	 * Bump up the references to keep the tunnel and the domain around
+	 * until the work has run or has been canceled.
 	 */
 	tb_tunnel_get(tunnel);
+	tb_domain_get(tunnel->tb);
 
 	tunnel->dprx_started = true;
 
@@ -1140,11 +1142,15 @@ static int tb_dp_dprx_start(struct tb_tu
 
 static void tb_dp_dprx_stop(struct tb_tunnel *tunnel)
 {
+	struct tb *tb = tunnel->tb;
+
 	if (tunnel->dprx_started) {
 		tunnel->dprx_started = false;
 		tunnel->dprx_canceled = true;
-		if (cancel_delayed_work(&tunnel->dprx_work))
+		if (cancel_delayed_work(&tunnel->dprx_work)) {
 			tb_tunnel_put(tunnel);
+			tb_domain_put(tb);
+		}
 	}
 }
 


