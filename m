Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C39B4E0B93;
	Fri,  9 Oct 2026 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557199; cv=none; b=vAdOfTN1+Il7yEiLuWx0N6JwwDkBHzlg0P2ccvt9raI+YrBoXhlSGQqOwCB3wf2X39eIW3RFESAHhqLG4p6fQwPg2NmuIYHqktIWb1gzY+/bYtwq+1fRLq3JzYK5gF46lSz1/BiBheQQWsWpYVZHVqK/rLSJkC4XdtDDyYL+JgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557199; c=relaxed/simple;
	bh=ZucNQV1lH3eYWoC4/56X1QKOVXKB7qnbo2wtkw4ftHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4baWEdzrPdIoRjx5d7cgEymGrj/4LTKWi+cesgpVK41r8vyuAQJCoTBvJNMVu5oEQa0lPP1obWCg3ijgGsRsjZiMZ1PdrFHKyJ4jkML8CTJvfLxX/D/pm78m6t0G4uQTXtBQPxnaCIDh+KAaK8TNLMtvX8YLss/sTsVjy1MsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYboyEIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYboyEIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4A91F000FF;
	Fri,  9 Oct 2026 14:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557198;
	bh=80ZmPLY4VQd41Hg2TD24mOot6bco2RBisWUwGmaCaXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYboyEIaul6RINYN5+vR+r8ZTEQq8QrVeGEOnJFk4QlNFy0VPAQCEGKZaOJyyFEW3
	 eVUKjJGYoPvn/c/EkA54+8aWdpatPfeRKi3+RozMdbOpWG0XzZ8ux6ZPRfKhkvRPkV
	 9jEugjDDZBrOoTn85P1t3qkt0YNjg6lAdmQg4yNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/403] thunderbolt: Dont access a DP tunnel after its DPRX read was canceled
Date: Fri,  9 Oct 2026 16:12:04 +0200
Message-ID: <20261009141000.780003152@linuxfoundation.org>
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

[ Upstream commit 419fa32fa5bc2d7fb9d0d15d5630b1c1090808b3 ]

tb_dp_dprx_work() checks ->dprx_canceled before it takes tb->lock so it
misses a tb_dp_dprx_stop() that could not cancel the already running
work. It then polls the DPRX capabilities and runs the callback for a
tunnel that has already been torn down while the domain is suspending or
going away.

This can be hit by cancelling the DPRX read from outside the ordered
tb->wq: During suspend tb_disconnect_and_release_dp() does just this and
with a later patch tb_stop() will do it as well. The latter in combination
with the Apple NHI where the DPRX read never completed is how I hit
this.

Check the flag with tb->lock held instead and check it again in
tb_dp_tunnel_active() because the callback runs after the lock has been
dropped again.

Also clear the flag in tb_dp_dprx_start() so that it only ever describes
the work that is currently in flight.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[ sashal: Adjusted tb_dp_dprx_start() context to retain optional callbacks and synchronous reads. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c     |   12 ++++++++++++
 drivers/thunderbolt/tunnel.c |   11 +++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1910,6 +1910,18 @@ static void tb_dp_tunnel_active(struct t
 	struct tb *tb = data;
 
 	mutex_lock(&tb->lock);
+
+	/*
+	 * If the DPRX read was canceled the tunnel is already being torn
+	 * down by whoever canceled it. Do not touch the adapters here
+	 * because the routers may be gone by now.
+	 */
+	if (tunnel->dprx_canceled) {
+		tb_tunnel_dbg(tunnel, "DPRX read canceled, not activating\n");
+		mutex_unlock(&tb->lock);
+		return;
+	}
+
 	if (tb_tunnel_is_active(tunnel)) {
 		int consumed_up, consumed_down, ret;
 
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1097,8 +1097,14 @@ static void tb_dp_dprx_work(struct work_
 	struct tb_tunnel *tunnel = container_of(work, typeof(*tunnel), dprx_work.work);
 	struct tb *tb = tunnel->tb;
 
+	/*
+	 * The DPRX read can be canceled while this work is waiting for
+	 * tb->lock. Check the flag only once it is held: while the lock is
+	 * held the tunnel cannot be torn down under us and the adapters are
+	 * safe to access.
+	 */
+	mutex_lock(&tb->lock);
 	if (!tunnel->dprx_canceled) {
-		mutex_lock(&tb->lock);
 		if (tb_dp_is_usb4(tunnel->src_port->sw) &&
 		    tb_dp_wait_dprx(tunnel, TB_DPRX_WAIT_TIMEOUT)) {
 			if (ktime_before(ktime_get(), tunnel->dprx_timeout)) {
@@ -1110,8 +1116,8 @@ static void tb_dp_dprx_work(struct work_
 		} else {
 			tb_tunnel_set_active(tunnel, true);
 		}
-		mutex_unlock(&tb->lock);
 	}
+	mutex_unlock(&tb->lock);
 
 	if (tunnel->callback)
 		tunnel->callback(tunnel, tunnel->callback_data);
@@ -1129,6 +1135,7 @@ static int tb_dp_dprx_start(struct tb_tu
 	tb_domain_get(tunnel->tb);
 
 	tunnel->dprx_started = true;
+	tunnel->dprx_canceled = false;
 
 	if (tunnel->callback) {
 		tunnel->dprx_timeout = dprx_timeout_to_ktime(dprx_timeout);


