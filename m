Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF5A262A1
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pp+TK/rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC768C433C7;
	Mon, 16 Oct 2023 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468075;
	bh=Bfts6BPuEzuocBFAlPre5UxCP6CKiqwqGjCZV6KjIRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pp+TK/rqeoi93Abq11zMqy4QJbMnELOXlsPLXqMY8YZjHz+M6ePn5AHfzUZ1uVFNt
	 ysg35W4ZxZJ3vYGzocoJ8VcuN7LGWI1SdbM44JNW8ixIz6cHtY5Q/TNtCE4Ci4Ka3p
	 sNNYUglGpVA5TK9x864k94nyx1V4xnaYrHEEo/cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Balcanquall <alex@alexbal.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.5 143/191] thunderbolt: Restart XDomain discovery handshake after failure
Date: Mon, 16 Oct 2023 10:42:08 +0200
Message-ID: <20231016084018.722622103@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 308092d080852f8997126e5b3507536162416f4a upstream.

Alex reported that after rebooting the other host the peer-to-peer link
does not come up anymore. The reason for this is that the host that was
not rebooted tries to send the UUID request only 10 times according to
the USB4 Inter-Domain spec and gives up if it does not get reply. Then
when the other side is actually ready it cannot get the link established
anymore. The USB4 Inter-Domain spec requires that the discovery protocol
is restarted in that case so implement this now.

Reported-by: Alex Balcanquall <alex@alexbal.com>
Fixes: 8e1de7042596 ("thunderbolt: Add support for XDomain lane bonding")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |   58 +++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -703,6 +703,27 @@ out_unlock:
 	mutex_unlock(&xdomain_lock);
 }
 
+static void start_handshake(struct tb_xdomain *xd)
+{
+	xd->state = XDOMAIN_STATE_INIT;
+	queue_delayed_work(xd->tb->wq, &xd->state_work,
+			   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
+}
+
+/* Can be called from state_work */
+static void __stop_handshake(struct tb_xdomain *xd)
+{
+	cancel_delayed_work_sync(&xd->properties_changed_work);
+	xd->properties_changed_retries = 0;
+	xd->state_retries = 0;
+}
+
+static void stop_handshake(struct tb_xdomain *xd)
+{
+	cancel_delayed_work_sync(&xd->state_work);
+	__stop_handshake(xd);
+}
+
 static void tb_xdp_handle_request(struct work_struct *work)
 {
 	struct xdomain_request_work *xw = container_of(work, typeof(*xw), work);
@@ -765,6 +786,15 @@ static void tb_xdp_handle_request(struct
 	case UUID_REQUEST:
 		tb_dbg(tb, "%llx: received XDomain UUID request\n", route);
 		ret = tb_xdp_uuid_response(ctl, route, sequence, uuid);
+		/*
+		 * If we've stopped the discovery with an error such as
+		 * timing out, we will restart the handshake now that we
+		 * received UUID request from the remote host.
+		 */
+		if (!ret && xd && xd->state == XDOMAIN_STATE_ERROR) {
+			dev_dbg(&xd->dev, "restarting handshake\n");
+			start_handshake(xd);
+		}
 		break;
 
 	case LINK_STATE_STATUS_REQUEST:
@@ -1521,6 +1551,13 @@ static void tb_xdomain_queue_properties_
 			   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
 }
 
+static void tb_xdomain_failed(struct tb_xdomain *xd)
+{
+	xd->state = XDOMAIN_STATE_ERROR;
+	queue_delayed_work(xd->tb->wq, &xd->state_work,
+			   msecs_to_jiffies(XDOMAIN_DEFAULT_TIMEOUT));
+}
+
 static void tb_xdomain_state_work(struct work_struct *work)
 {
 	struct tb_xdomain *xd = container_of(work, typeof(*xd), state_work.work);
@@ -1547,7 +1584,7 @@ static void tb_xdomain_state_work(struct
 		if (ret) {
 			if (ret == -EAGAIN)
 				goto retry_state;
-			xd->state = XDOMAIN_STATE_ERROR;
+			tb_xdomain_failed(xd);
 		} else {
 			tb_xdomain_queue_properties_changed(xd);
 			if (xd->bonding_possible)
@@ -1612,7 +1649,7 @@ static void tb_xdomain_state_work(struct
 		if (ret) {
 			if (ret == -EAGAIN)
 				goto retry_state;
-			xd->state = XDOMAIN_STATE_ERROR;
+			tb_xdomain_failed(xd);
 		} else {
 			xd->state = XDOMAIN_STATE_ENUMERATED;
 		}
@@ -1623,6 +1660,8 @@ static void tb_xdomain_state_work(struct
 		break;
 
 	case XDOMAIN_STATE_ERROR:
+		dev_dbg(&xd->dev, "discovery failed, stopping handshake\n");
+		__stop_handshake(xd);
 		break;
 
 	default:
@@ -1833,21 +1872,6 @@ static void tb_xdomain_release(struct de
 	kfree(xd);
 }
 
-static void start_handshake(struct tb_xdomain *xd)
-{
-	xd->state = XDOMAIN_STATE_INIT;
-	queue_delayed_work(xd->tb->wq, &xd->state_work,
-			   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
-}
-
-static void stop_handshake(struct tb_xdomain *xd)
-{
-	cancel_delayed_work_sync(&xd->properties_changed_work);
-	cancel_delayed_work_sync(&xd->state_work);
-	xd->properties_changed_retries = 0;
-	xd->state_retries = 0;
-}
-
 static int __maybe_unused tb_xdomain_suspend(struct device *dev)
 {
 	stop_handshake(tb_to_xdomain(dev));


