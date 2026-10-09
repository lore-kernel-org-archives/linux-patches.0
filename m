Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB60357A4A;
	Fri,  9 Oct 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557542; cv=none; b=OqPzdZZP+biwQfSCUnHgpp8K3FtfKQDL0ofSrgiOFbHCsZn0meFhW6RqTZBvScqlfcra1eVjiuuLY7FvPGhAorhuo7YHgsbc4xVvC1QU79YVCnepDyxsHd0paLj7YO/p+2ycWqYvThtr6YVPLFU8xLYVL5BYdfviCN8kRVx/DKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557542; c=relaxed/simple;
	bh=D0w/Ov4wEDbdJhNNRVPQXUyoDU2V12CwzQX8fo3tbr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk7NkXtxjAB8p/5mZ30haFx9XGuC7miat4sF1rYlDb3FUzPeP1RJWNLuahkw602mJLNdwhvu8+Iv3Q5AhsOkUhVHoLAlam9WqQDNC1TSjsbYlg6tk697wT6c/5IcA2/Av2VkrcAQIEUF8KwxeukdvVTwAq7jhznxQNFgGDHEcQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns1vlKBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns1vlKBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721CF1F000FF;
	Fri,  9 Oct 2026 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557541;
	bh=utZcYYWRbOXuMQ5lui62v3pctdV9MjngijB6vAGbfrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ns1vlKBN1Wn/3xZ5IAonHMeeMgGNCubb7hXe8k5LpiVFY6AcQXA+R5Q1yTMrN8f+h
	 H3OipZLHPKxkzsnYSqgsJrmlPA7tq9D8HUzi2IrKF1TFFeWekgBYhVYGDKhx7UTZNi
	 iKelaNtOY6X80erajzGEuKw+D6YzvGj/eTGAg0OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.2 355/428] thunderbolt: Fix domain reference leak when DPRX read is canceled
Date: Fri,  9 Oct 2026 16:11:32 +0200
Message-ID: <20261009140953.966440436@linuxfoundation.org>
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
@@ -1966,8 +1966,6 @@ static void tb_dp_tunnel_active(struct t
 		tb_dp_resource_unavailable(tb, in, "DPRX negotiation failed");
 	}
 	mutex_unlock(&tb->lock);
-
-	tb_domain_put(tb);
 }
 
 static void tb_tunnel_one_dp(struct tb *tb, struct tb_port *in,
@@ -2028,8 +2026,7 @@ static void tb_tunnel_one_dp(struct tb *
 	       available_up, available_down);
 
 	tunnel = tb_tunnel_alloc_dp(tb, in, out, link_nr, available_up,
-				    available_down, tb_dp_tunnel_active,
-				    tb_domain_get(tb));
+				    available_down, tb_dp_tunnel_active, tb);
 	if (!tunnel) {
 		tb_port_dbg(out, "could not allocate DP tunnel\n");
 		goto err_reclaim_usb;
@@ -2050,7 +2047,6 @@ err_free:
 	tb_tunnel_put(tunnel);
 err_reclaim_usb:
 	tb_reclaim_usb3_bandwidth(tb, in, out);
-	tb_domain_put(tb);
 err_detach_group:
 	tb_detach_bandwidth_group(in);
 err_dealloc_dp:
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1109,15 +1109,17 @@ static void tb_dp_dprx_work(struct work_
 
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
 	tunnel->dprx_timeout = dprx_timeout_to_ktime(dprx_timeout);
@@ -1128,11 +1130,15 @@ static int tb_dp_dprx_start(struct tb_tu
 
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
 


