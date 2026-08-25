Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1CD448D11;
	Tue, 25 Aug 2026 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666146; cv=none; b=tEw4+DzY4yYQ4yrkigHt+V2se8dhX2+HNKl465OZJHZkDM8BywtukdjBQlZJUJGQs+Aql1zUje7n637Wu0b9AJIbQRECSULWJDb8sR4Gn/jfSJRtfSxaNc9ZElUyeQZoi4nqbQbvJqaXIfhjWJb9CFhCpFjzwpu43qNi2fmd8X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666146; c=relaxed/simple;
	bh=aQkk9/iWZcuhJTOMcA70jq+JnUAbUY1yfl2SaxUZ3oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4N9C1QeVaJKB/HkEml1TeZGrloo5VZi32E0HQTPr2MSkvq0G+w04bH8GesCnfa/BW12gwVP+YkIShShIn7j2s3s9jt2cUT0Ghmi2m2ocYiykKYL53A9+qIeZshx6SJL2rB15iWiLsEO4e6bAe30AtIO2W0wktEYWiOP5FLWjKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArLRrBsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArLRrBsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6BE1F00A3A;
	Tue, 25 Aug 2026 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666144;
	bh=BvE5/indBwWJVh2mbO+mcIJT0Ko4ekDc4ViXs7yQcQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArLRrBsGrUW7p8MYp5NzmXxTYus2Bh31FS1ViqP3KV3hxWKHVX2tsasudd5MnMONC
	 ECwdUWxhx4wao4hmu1FqPI9INQklAAWrneRKLWtDHqwaE2p1MJxLqrUZnL6vA5KBG+
	 dz7JUUzhAXP6u6FiS/D72ROXFcGI9uiK3REhtQUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 02/76] Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept
Date: Tue, 25 Aug 2026 15:25:55 +0200
Message-ID: <20260825132541.656102162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 43a556b2fd43f2df6dded59c2e26560a27874c24 upstream.

rfcomm_sock_recvmsg() completes a deferred setup by calling
rfcomm_dlc_accept() without holding any RFCOMM lock:

	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
		rfcomm_dlc_accept(d);
		return 0;
	}

and rfcomm_dlc_accept() dereferences the session on its first line:

	struct sock *sk = d->session->sock->sk;

Every other path that touches d->session runs under rfcomm_mutex:
rfcomm_dlc_open(), rfcomm_dlc_close(), rfcomm_dlc_exists(),
rfcomm_dlc_send_rpn(), and the RFCOMM thread through
rfcomm_process_sessions(). rfcomm_connect_ind() is even documented as
"called under rfcomm_lock()". This call site is the only one that skips
it.

The RFCOMM_DEFER_SETUP bit looks like it serialises the accept against
teardown, since __rfcomm_dlc_close() returns early when it wins the
test_and_clear. But rfcomm_recv_disc() forces the state first:

	d->state = BT_CLOSED;
	__rfcomm_dlc_close(d, err);

and the early return only covers BT_CONNECT, BT_CONFIG, BT_OPEN and
BT_CONNECT2. With the state already BT_CLOSED that switch does not
match, the bit is never consulted, and __rfcomm_dlc_close() falls
through to rfcomm_dlc_unlink(), which sets d->session = NULL.

So a remote DISC on a deferred dlc clears the session while leaving
RFCOMM_DEFER_SETUP set. The next recvmsg() then passes the
test_and_clear and dereferences a NULL session. No timing window is
needed: once the DISC has been processed, the dereference is
unconditional.

Give rfcomm_dlc_accept() the same shape as rfcomm_dlc_open() and
rfcomm_dlc_close(): an exported wrapper that takes rfcomm_mutex and
re-checks the session, around a __rfcomm_dlc_accept() that the two
in-core callers, which already hold the mutex, keep using.

Reproduced on a KASAN + PROVE_LOCKING kernel with a BR/EDR peer emulated
over /dev/vhci: the peer brings up an ACL link, opens L2CAP on the
RFCOMM PSM, starts a session, opens a dlc on a channel bound with
BT_DEFER_SETUP, and sends DISC after the socket is accepted. recv() on
the accepted socket then hits:

  Oops: general protection fault
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:rfcomm_dlc_accept+0x54/0x350
  Call Trace:
    rfcomm_sock_recvmsg+0x1cd/0x230
    sock_recvmsg+0x166/0x1c0
    __sys_recvfrom+0x20d/0x300

0x10 is the offset of sock in struct rfcomm_session. With this patch the
same run completes with recv() returning 0 and no report, and lockdep
stays quiet, confirming rfcomm_mutex is still taken before lock_sock on
this path as it is on the thread side.

Fixes: bb23c0ab8246 ("Bluetooth: Add support for deferring RFCOMM connection setup")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/core.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1330,7 +1330,10 @@ static struct rfcomm_session *rfcomm_rec
 	return s;
 }
 
-void rfcomm_dlc_accept(struct rfcomm_dlc *d)
+/* Must be called with rfcomm_mutex held, so that the session cannot be
+ * unlinked from under us.
+ */
+static void __rfcomm_dlc_accept(struct rfcomm_dlc *d)
 {
 	struct sock *sk = d->session->sock->sk;
 	struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
@@ -1352,6 +1355,21 @@ void rfcomm_dlc_accept(struct rfcomm_dlc
 	rfcomm_send_msc(d->session, 1, d->dlci, d->v24_sig);
 }
 
+void rfcomm_dlc_accept(struct rfcomm_dlc *d)
+{
+	rfcomm_lock();
+
+	/* rfcomm_recv_disc() sets the dlc state to BT_CLOSED before calling
+	 * __rfcomm_dlc_close(), so the RFCOMM_DEFER_SETUP handshake there is
+	 * skipped and the session can already be unlinked by the time the
+	 * deferred accept runs from rfcomm_sock_recvmsg().
+	 */
+	if (d->session)
+		__rfcomm_dlc_accept(d);
+
+	rfcomm_unlock();
+}
+
 static void rfcomm_check_accept(struct rfcomm_dlc *d)
 {
 	if (rfcomm_check_security(d)) {
@@ -1364,7 +1382,7 @@ static void rfcomm_check_accept(struct r
 			d->state_change(d, 0);
 			rfcomm_dlc_unlock(d);
 		} else
-			rfcomm_dlc_accept(d);
+			__rfcomm_dlc_accept(d);
 	} else {
 		set_bit(RFCOMM_AUTH_PENDING, &d->flags);
 		rfcomm_dlc_set_timer(d, RFCOMM_AUTH_TIMEOUT);
@@ -1949,7 +1967,7 @@ static void rfcomm_process_dlcs(struct r
 					d->state_change(d, 0);
 					rfcomm_dlc_unlock(d);
 				} else
-					rfcomm_dlc_accept(d);
+					__rfcomm_dlc_accept(d);
 			}
 			continue;
 		} else if (test_and_clear_bit(RFCOMM_AUTH_REJECT, &d->flags)) {


