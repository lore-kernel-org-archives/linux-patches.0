Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA633A6F7;
	Tue, 25 Aug 2026 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665395; cv=none; b=SDD4FBpe1XBOtaj/DsHLCB+g7vU/BGdpojf4J70Wk/5iZgVNApwjTJOjGZ6lUVQws1GzydiuArq4fngkYAP0AOxU4DOd6Kqnb0+iPYeIdo6fo3F/6mX+p43pVGbsqoMdQIqdf6Ed+borPi1e5FY4u7m8SHmpL90T1uzKZsABg2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665395; c=relaxed/simple;
	bh=IqPR9VADvL1lCin6vv2/CBjqeSI+D08YeYqN2Iu5D1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD/MMP2l1hxsi6pHL6NL8j2LW+dPnSRoel9BPCDkTAENle9pUpqyl3dqFNqoLrbHvyNit/xeG3n28LYHYDAwQ5awynlyIWyYij9gOoFM+yCie3aisazcRWwNiLqBfCYBKraRVMelVccvJZ0hF6hCnQWlabcFLyeVkU9Y4LO2gx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9twxCEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9twxCEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC21F00A3A;
	Tue, 25 Aug 2026 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665393;
	bh=tVH37HtrTn1MMONNYnbGnBiuYNDbELiRm6swBG+Jo9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9twxCEjbsIWNL0Xwqjyr3jXMiDnQDpC/apr26tS9bZ4PXeDL97zPOcuMjwr1thJ6
	 ZSqhaHBY2Rkh/dw6a3AA6kVcv8rs8xFGQCKhSb09E692ExLpevg4WzaTbMtywq2nOe
	 1MZGr5fEfJ1map4sfamBchk+xTex/bqh6SEF0ce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 02/77] Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept
Date: Tue, 25 Aug 2026 15:25:24 +0200
Message-ID: <20260825132541.667797881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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
@@ -1334,7 +1334,10 @@ static struct rfcomm_session *rfcomm_rec
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
@@ -1356,6 +1359,21 @@ void rfcomm_dlc_accept(struct rfcomm_dlc
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
@@ -1368,7 +1386,7 @@ static void rfcomm_check_accept(struct r
 			d->state_change(d, 0);
 			rfcomm_dlc_unlock(d);
 		} else
-			rfcomm_dlc_accept(d);
+			__rfcomm_dlc_accept(d);
 	} else {
 		set_bit(RFCOMM_AUTH_PENDING, &d->flags);
 		rfcomm_dlc_set_timer(d, RFCOMM_AUTH_TIMEOUT);
@@ -1953,7 +1971,7 @@ static void rfcomm_process_dlcs(struct r
 					d->state_change(d, 0);
 					rfcomm_dlc_unlock(d);
 				} else
-					rfcomm_dlc_accept(d);
+					__rfcomm_dlc_accept(d);
 			}
 			continue;
 		} else if (test_and_clear_bit(RFCOMM_AUTH_REJECT, &d->flags)) {


