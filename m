Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3274432A3C9;
	Sun,  7 Jun 2026 10:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828109; cv=none; b=fz/aXiOaekilCU5Fi+uWwzqY1+4QEfpoFWvZ+354xfy5/tEqTN0KN2gRCBMF7CwmuQDpkN6IusvPFdsYiL27O6RAOxuDFSPx5UGEHotz7GlQPkZywSpIJv+9swQuqpyDZfXm16x8DcL9HP5h17V9Rdw3yXBPSCB6QfM2T+8r4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828109; c=relaxed/simple;
	bh=X/LJ4ghTWOi2qVDxJCGe9Cv/XhyuAOFN3Zlgx0gON+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGsChNXJ0SXB0d3TrvfjiVhDCUoW4umsFiuTIQjQM/I9SJm9dJjbz0dfFGPY+8FQ6X2zzCKyEbkscqLJnUtc965KmvMCtLJjntIvxQvqrbAXlV2XsS9tZuN+QJ4jm3P85WEjFPiwJP6p+ibk8ON1MYqwZSd1Ss39pGmQu+zRxr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgt7OWO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgt7OWO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261A31F00898;
	Sun,  7 Jun 2026 10:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828105;
	bh=vdkRaFC8Uxh+nfzVJaFmNhnFuUiEhfreC5e8GuI86As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgt7OWO5W/SbZvivdjBsZ7LIcxaaU+yOcbds0BWoXySLioKb2yYgjE52DjYlM+c9w
	 HRR2UXGFg98gwOo9szM7jIVkrKwJyhAyq05WpnZ12uApV6kKySRN5WAzLu9X3FuZ+Z
	 oIxnq9R6H6VV/IuV4D88bGBJUpG166xc6FqLvdVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 128/315] Bluetooth: L2CAP: use chan timer to close channels in cleanup_listen()
Date: Sun,  7 Jun 2026 11:58:35 +0200
Message-ID: <20260607095732.326093089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 8c8e620467a7b51562dbcefbd1f09f288d7d710d upstream.

l2cap_chan_close() removes the channel from conn->chan_l, which
must be done under conn->lock.  cleanup_listen() runs under the
parent sk_lock, so acquiring conn->lock would invert the
established conn->lock -> chan->lock -> sk_lock order.

Instead of calling l2cap_chan_close() directly, schedule
l2cap_chan_timeout with delay 0 to close the channel
asynchronously.  The timeout handler already acquires conn->lock
and chan->lock in the correct order.

The timer is only armed when chan->conn is still set: if it is
already NULL, l2cap_conn_del() has already processed this channel
(l2cap_chan_del + l2cap_sock_teardown_cb + l2cap_sock_close_cb),
so there is nothing left to do.  If l2cap_conn_del() races in
after the timer is armed, __clear_chan_timer() inside
l2cap_chan_del() cancels it; if the timer has already fired, the
handler returns harmlessly because chan->conn was cleared.

Fixes: 3df91ea20e74 ("Bluetooth: Revert to mutexes from RCU list")
Cc: <stable@vger.kernel.org> # 0b58004: Bluetooth: fix UAF in l2cap_sock_cleanup_listen() vs l2cap_conn_del()
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1481,6 +1481,10 @@ static void l2cap_sock_cleanup_listen(st
 	 * pin it (hold_unless_zero() additionally skips a chan already past
 	 * its last reference).  We then drop the sk lock before taking
 	 * chan->lock, so sk and chan locks are never held together.
+	 *
+	 * Since we cannot call l2cap_chan_close() without conn->lock,
+	 * schedule l2cap_chan_timeout to close the channel; it already
+	 * acquires conn->lock -> chan->lock in the correct order.
 	 */
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		struct l2cap_chan *chan;
@@ -1498,14 +1502,12 @@ static void l2cap_sock_cleanup_listen(st
 		       state_to_string(chan->state));
 
 		l2cap_chan_lock(chan);
-		__clear_chan_timer(chan);
-		l2cap_chan_close(chan, ECONNRESET);
-		/* l2cap_conn_del() may already have killed this socket
-		 * (it sets SOCK_DEAD); skip the duplicate to avoid a
-		 * double sock_put()/l2cap_chan_put().
+		/* Since we cannot call l2cap_chan_close() without
+		 * conn->lock, schedule its timer to trigger the close
+		 * and cleanup of this channel.
 		 */
-		if (!sock_flag(sk, SOCK_DEAD))
-			l2cap_sock_kill(sk);
+		if (chan->conn)
+			__set_chan_timer(chan, 0);
 		l2cap_chan_unlock(chan);
 
 		l2cap_chan_put(chan);


