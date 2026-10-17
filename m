Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4440938F658;
	Sat, 17 Oct 2026 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254431; cv=none; b=ptRp05pEh+LKQ09PLnK/GHtEiwqZ2rzUOVsf0Y/T2WmWYD/6PJDekZpYuaRZF81fYv9vdp44mUrCm51OJ61QnsBe5/h/HGHbDLbooj1SfE+NE5BUW2GRj0zJnklfR+/uacRSAQECW4qXvYkCTxDocddaPaXMemOknGwWEhDo6uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254431; c=relaxed/simple;
	bh=I1jcpbsf2876wd31he3EeSd8h99L6IhNkiyE4r4eJDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcuE/KzFJPWM7ldRnMK/a6Y761wBmmmgiMxP/QMRU0gNpgkaEr9R3pHyM5CDCYsZTs+Ltqape+uLHBcqbuYxCMl8aOZOfzTrWYk3Rph2pnYnOLTnYsotkON9nKEBAl+Rp2qYBgdKKc4tpbrFD83qQ/8ucuDzFmeeWeNzJR1jFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnDiiPW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnDiiPW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8691F000C4;
	Sat, 17 Oct 2026 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254430;
	bh=e02KGH7qSBS33ffXORF07ZGNqHSq/VW3/h5yIZChhm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnDiiPW6/tCrguVzrYd9t8rhiuSpj9rCFrmmuI/yPMCdxld/WSzf5Sqwln+BEPde2
	 V/wYl6yz+e9jYseMYonO0omMe/ljnZtAjdsSPchRhhKNJfmYmVboSp6PiuqHOkDS9h
	 r1Ov5j527qzp71qi4FIlYXFJBq4Tv2uC2tkKx08M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/869] xen/pvcalls: bound backend response req_id before indexing rsp[]
Date: Sat, 17 Oct 2026 17:54:45 +0200
Message-ID: <20261017160048.528059825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit d33846c8dcc06b83b7acdeac1e8bfbb5c0c26cb2 ]

pvcalls_front_event_handler() takes req_id directly from the
backend-supplied ring response and uses it to index the fixed-size
bedata->rsp[] array for a memcpy() and a store, with no range check. A
malicious or buggy backend can set req_id past PVCALLS_NR_RSP_PER_RING
and drive an out-of-bounds write past the bedata allocation.

req_id was also declared int while the wire field rsp->req_id is u32, so
a range check on the signed value alone is insufficient: a backend
req_id of 0xffffffff becomes -1, passes a >= PVCALLS_NR_RSP_PER_RING
test and indexes bedata->rsp[-1]. Declare req_id as u32 so a single
bound covers both ends.

A backend that sends an out-of-range req_id has violated the wire
protocol, so rather than silently dropping the response, log once and
stop trusting the backend: set bedata->disabled. The event handler then
ignores further responses, and the request paths that wait for a
response return -EIO instead of blocking forever. This mirrors the
fatal-error handling xen-netback uses (xenvif_fatal_tx_err()).

The pvcalls frontend currently trusts its backend, so this is not a
classic-Xen security issue, but it matters for hardening PV frontends
against malicious backends (confidential and disaggregated deployments).

Fixes: 2195046bfd69 ("xen/pvcalls: implement socket command and handle events")
Suggested-by: Juergen Gross <jgross@suse.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260617014149.2647404-1-michael.bommarito@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 88 ++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index b72ee9379d77c..d2bdd43703e88 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -32,6 +32,7 @@ struct pvcalls_bedata {
 	struct xen_pvcalls_front_ring ring;
 	grant_ref_t ref;
 	int irq;
+	bool disabled;
 
 	struct list_head socket_mappings;
 	spinlock_t socket_lock;
@@ -131,6 +132,20 @@ static inline int get_request(struct pvcalls_bedata *bedata, int *req_id)
 	return 0;
 }
 
+/*
+ * Wait for the backend's response to req_id, or for the frontend to be
+ * disabled because the backend violated the wire protocol. Returns 0 once
+ * the response has arrived, or -EIO if the frontend was disabled.
+ */
+static int pvcalls_front_wait_rsp(struct pvcalls_bedata *bedata, u32 req_id)
+{
+	wait_event(bedata->inflight_req,
+		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id ||
+		   READ_ONCE(bedata->disabled));
+
+	return READ_ONCE(bedata->disabled) ? -EIO : 0;
+}
+
 static bool pvcalls_front_write_todo(struct sock_mapping *map)
 {
 	struct pvcalls_data_intf *intf = map->active.ring;
@@ -168,7 +183,8 @@ static irqreturn_t pvcalls_front_event_handler(int irq, void *dev_id)
 	struct pvcalls_bedata *bedata;
 	struct xen_pvcalls_response *rsp;
 	uint8_t *src, *dst;
-	int req_id = 0, more = 0, done = 0;
+	u32 req_id = 0;
+	int more = 0, done = 0;
 
 	if (dev == NULL)
 		return IRQ_HANDLED;
@@ -179,12 +195,31 @@ static irqreturn_t pvcalls_front_event_handler(int irq, void *dev_id)
 		pvcalls_exit();
 		return IRQ_HANDLED;
 	}
+	if (READ_ONCE(bedata->disabled)) {
+		pvcalls_exit();
+		return IRQ_HANDLED;
+	}
 
 again:
 	while (RING_HAS_UNCONSUMED_RESPONSES(&bedata->ring)) {
 		rsp = RING_GET_RESPONSE(&bedata->ring, bedata->ring.rsp_cons);
 
 		req_id = rsp->req_id;
+		if (req_id >= PVCALLS_NR_RSP_PER_RING) {
+			/*
+			 * The backend supplied a req_id that would index
+			 * bedata->rsp[] out of bounds: a protocol violation
+			 * from a malicious or buggy backend. Log once, stop
+			 * trusting this backend and disable the frontend rather
+			 * than silently dropping the response and continuing.
+			 */
+			pr_err_once("pvcalls: backend sent out-of-range req_id %u, disabling frontend\n",
+				    req_id);
+			WRITE_ONCE(bedata->disabled, true);
+			bedata->ring.rsp_cons++;
+			done = 1;
+			break;
+		}
 		if (rsp->cmd == PVCALLS_POLL) {
 			struct sock_mapping *map = (struct sock_mapping *)(uintptr_t)
 						   rsp->u.poll.id;
@@ -217,7 +252,7 @@ static irqreturn_t pvcalls_front_event_handler(int irq, void *dev_id)
 	}
 
 	RING_FINAL_CHECK_FOR_RESPONSES(&bedata->ring, more);
-	if (more)
+	if (more && !READ_ONCE(bedata->disabled))
 		goto again;
 	if (done)
 		wake_up(&bedata->inflight_req);
@@ -330,8 +365,11 @@ int pvcalls_front_socket(struct socket *sock)
 	if (notify)
 		notify_remote_via_irq(bedata->irq);
 
-	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+	ret = pvcalls_front_wait_rsp(bedata, req_id);
+	if (ret) {
+		pvcalls_exit();
+		return ret;
+	}
 
 	/* read req_id, then the content */
 	smp_rmb();
@@ -476,8 +514,11 @@ int pvcalls_front_connect(struct socket *sock, struct sockaddr *addr,
 	if (notify)
 		notify_remote_via_irq(bedata->irq);
 
-	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+	ret = pvcalls_front_wait_rsp(bedata, req_id);
+	if (ret) {
+		pvcalls_exit_sock(sock);
+		return ret;
+	}
 
 	/* read req_id, then the content */
 	smp_rmb();
@@ -707,8 +748,11 @@ int pvcalls_front_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	if (notify)
 		notify_remote_via_irq(bedata->irq);
 
-	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+	ret = pvcalls_front_wait_rsp(bedata, req_id);
+	if (ret) {
+		pvcalls_exit_sock(sock);
+		return ret;
+	}
 
 	/* read req_id, then the content */
 	smp_rmb();
@@ -756,8 +800,11 @@ int pvcalls_front_listen(struct socket *sock, int backlog)
 	if (notify)
 		notify_remote_via_irq(bedata->irq);
 
-	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+	ret = pvcalls_front_wait_rsp(bedata, req_id);
+	if (ret) {
+		pvcalls_exit_sock(sock);
+		return ret;
+	}
 
 	/* read req_id, then the content */
 	smp_rmb();
@@ -813,6 +860,14 @@ int pvcalls_front_accept(struct socket *sock, struct socket *newsock, int flags)
 		}
 	}
 
+	if (READ_ONCE(bedata->disabled)) {
+		clear_bit(PVCALLS_FLAG_ACCEPT_INFLIGHT,
+			  (void *)&map->passive.flags);
+		wake_up(&map->passive.inflight_accept_req);
+		pvcalls_exit_sock(sock);
+		return -EIO;
+	}
+
 	map2 = kzalloc(sizeof(*map2), GFP_KERNEL);
 	if (map2 == NULL) {
 		clear_bit(PVCALLS_FLAG_ACCEPT_INFLIGHT,
@@ -873,10 +928,18 @@ int pvcalls_front_accept(struct socket *sock, struct socket *newsock, int flags)
 	}
 
 	if (wait_event_interruptible(bedata->inflight_req,
-		READ_ONCE(bedata->rsp[req_id].req_id) == req_id)) {
+		READ_ONCE(bedata->rsp[req_id].req_id) == req_id ||
+		READ_ONCE(bedata->disabled))) {
 		pvcalls_exit_sock(sock);
 		return -EINTR;
 	}
+	if (READ_ONCE(bedata->disabled)) {
+		clear_bit(PVCALLS_FLAG_ACCEPT_INFLIGHT,
+			  (void *)&map->passive.flags);
+		wake_up(&map->passive.inflight_accept_req);
+		pvcalls_exit_sock(sock);
+		return -EIO;
+	}
 	/* read req_id, then the content */
 	smp_rmb();
 
@@ -1045,7 +1108,8 @@ int pvcalls_front_release(struct socket *sock)
 		notify_remote_via_irq(bedata->irq);
 
 	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id ||
+		   READ_ONCE(bedata->disabled));
 
 	if (map->active_socket) {
 		/*
-- 
2.53.0



