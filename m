Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215620;
	b=2TPa1mRWtVjZCGuq6M0yElrD9qLlW2pu6w5YHpDKaB1vdWdnIxyJG1uhyX/+sEQhE5gB
	 w5ZXzvG7tn2j9kjUjpUwodFvE/NrMbukLwfoNZqcOiew9IOX0tVQF/splV7g534qF2NVK
	 GLiW82W8L5B7RpCwvuRVQWoAYjCYjbQjX0v165k6SqWKm1UO8QlNochcMJuVvBBLmqZxK
	 3cPIiIuemYR1JS6ajprIU0ovaXPiDpu59EeHHmUhPknC3P0dl7jYvnFR+xT1QEa1CN98H
	 PqaYfnWo0VIIi66Ns41Bz//L91mu4Q7xpWHwJLZWOXlx318REDF003CHcd8o/pdEnSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m05P3Jb3OnwY2NSpwxWiq3hv939eeZMPyc8thlE5YCQ=;
	b=Vr1APnoY31dMZnsbVBqRzL9LSlwt3O9xp3ZYJ2m13lCSviP+lLkesudeUyKBMt3wo4UG
	 Ll3UIQ0amFlnzIbTnAgPSH3X0hCZA8UuZOMay+hbq6AtzkTHRJrt1K8i4bcZqOnX4rbby
	 6/Z5tF9SIDvxmyVbYCmWSTt5MXMyOIUTb3FCibMCumho4HArrkwlgiBdCweOCJBvdg3tm
	 5vOxVgBQr7CHmPp3Aabo0XnMr4+DkPedCTu67ehPsPdiM9n/UvFxNuWaEPjRtdmzjJawU
	 gS/szXm31uvPUMvBuM1W8AjIGRIU8+PuEOdl9S0sZ04Nup9ZrkL8xWXy6Vh0MpEyByg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoPuvOmZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FC1606A322;
	Wed, 28 Oct 2026 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoPuvOmZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06FC1F031E0;
	Wed, 28 Oct 2026 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215620;
	bh=m05P3Jb3OnwY2NSpwxWiq3hv939eeZMPyc8thlE5YCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoPuvOmZ9Od/FK4PJQnaJTKQbMnH1L5+DJy77HYBsjfV55EP+a8ColJJufpd69n4U
	 qo48534Y8CWvRLRBEKwJMaOe+uHd47hsyj0s21brVfKNy+1prCd9fzIehvemLNr4uf
	 n3FRD0Lf0oAVH7zV7YSojyfPfjq/mYDya+3lr+Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1231/1887] xen/pvcalls: bound backend response req_id before indexing rsp[]
Date: Wed, 28 Oct 2026 17:55:27 +0100
Message-ID: <20261028170527.435958787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d5d589bda243d..5e1701ca8f1a6 100644
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
@@ -322,8 +357,11 @@ int pvcalls_front_socket(struct socket *sock)
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
@@ -469,8 +507,11 @@ int pvcalls_front_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -700,8 +741,11 @@ int pvcalls_front_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
@@ -749,8 +793,11 @@ int pvcalls_front_listen(struct socket *sock, int backlog)
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
@@ -806,6 +853,14 @@ int pvcalls_front_accept(struct socket *sock, struct socket *newsock, int flags)
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
@@ -867,10 +922,18 @@ int pvcalls_front_accept(struct socket *sock, struct socket *newsock, int flags)
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
 
@@ -1039,7 +1102,8 @@ int pvcalls_front_release(struct socket *sock)
 		notify_remote_via_irq(bedata->irq);
 
 	wait_event(bedata->inflight_req,
-		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id);
+		   READ_ONCE(bedata->rsp[req_id].req_id) == req_id ||
+		   READ_ONCE(bedata->disabled));
 
 	if (map->active_socket) {
 		/*
-- 
2.53.0



