Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF4D388E43;
	Fri,  7 Aug 2026 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115327; cv=none; b=cv4n6YkeRCoctwNBw5qsMEN1JumyzNjV4GecA8w42SIZA7Fe6LdEYulfABIE5GbjavPUhCBUxrz/jtNyyZV2OBhni1h8+FGT2nwh5RAnHIyB5HtXS6TJRIA719y/E7uSeJX/E/JrQAakWR8nbAz7tMtx6Y2gbGaMsXfrMsvWsIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115327; c=relaxed/simple;
	bh=3G0Hi/P8MyFB+fzZ+nRLk3cSm/RJ/3QJ8Kjkwi/ghWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTElQTK9R9nUmDKTB3cp8Q/X2xoVzSjiZ1CkATdHvPbO1yZtPXAegoApqMua5fF3JLAzosqhN/GDYCIl8oaVAu0+irCnfFfWoOxiLWsqCkwVVTqIRSZeqmcM3PGEp/DGOXLV+hFu5BpOac6KHyNotrnLghJzW+D6w4p6RmXiuTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzsuJzBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzsuJzBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874C71F000E9;
	Fri,  7 Aug 2026 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115326;
	bh=/P6K/ReDtoixtTY4ohCtS3tTmoFPAbt+fbNJMGPTxqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzsuJzBn/S6KPqfftY8uD9aBPfCrhcRkq9MHABVSJwOTgyfliB7Io3aJKU/N0+DCZ
	 relF5r2EJB5daIZRBUTOnYLHBbe/eZzod6R447yzLBqgUfDTDX57b5dfpSZxstYmM0
	 mbY2d/npu58iEYZjq9CUUMdUOl5M5vDImKfpB6eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 192/396] Bluetooth: SCO: give the socket its own sco_conn reference
Date: Fri,  7 Aug 2026 16:35:52 +0200
Message-ID: <20260807143428.425980783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit abd93c85c8667add738ee82aeab95dd9fc8265a2 upstream.

sco_conn_del() drops a reference it does not own. It takes one transient
reference via sco_conn_hold_unless_zero() and releases it with the
sco_conn_put() that follows sco_sock_hold(); the additional put in the
!sk branch releases a second one:

    conn = sco_conn_hold_unless_zero(conn);
    ...
    sk = sco_sock_hold(conn);
    sco_conn_unlock(conn);
    sco_conn_put(conn);

    if (!sk) {
            sco_conn_put(conn);
            return;
    }

When close() races the controller's Disconnection Complete, sco_chan_del()
clears conn->sk and drops the socket's reference while sco_conn_del() is
running. sco_conn_del() then sees sk == NULL, its own put drops the count
to zero and frees the conn, and the second put writes to the freed kref:

    BUG: KASAN: slab-use-after-free in sco_conn_put.part.0+0x1a/0x190
    Write of size 4 at addr ffff8881099dec74 by task kworker/u17:3/413
    Workqueue: hci1 hci_rx_work
    Call Trace:
     sco_conn_put.part.0+0x1a/0x190
     hci_disconn_complete_evt+0x1ee/0x3e0
     hci_event_packet+0x54a/0x650
     hci_rx_work+0x321/0x3d0
    Allocated by task 413:
     sco_conn_add+0x72/0x1a0
     sco_connect_cfm+0x88/0x670
    Freed by task 413:
     sco_conn_del.isra.0+0x3f/0xf0
     hci_disconn_complete_evt+0x1ee/0x3e0
    refcount_t: underflow; use-after-free.

The root cause is that the socket stores the connection without holding a
reference of its own. __sco_chan_add() does:

    sco_pi(sk)->conn = conn;

so the socket borrows whatever reference its caller happened to hold, and
the callers paper over that with ad-hoc holds and puts. Give the socket a
counted reference instead: __sco_chan_add() takes one and it is released
together with the channel (sco_chan_del()) and in sco_sock_destruct().
With the socket holding its own reference, sco_conn_del() no longer needs
the extra put and the redundant hold in sco_conn_ready() goes away.

Making the socket own its reference means the connection is now actually
freed on the error paths of sco_connect() where it used to leak, which in
turn runs sco_conn_free() and its hci_conn_drop(conn->hcon). To keep the
hci_conn accounting balanced, make that ownership explicit as well:
sco_conn_add() consumes one hci_conn reference and the sco_conn owns it for
its lifetime. sco_connect() hands over the reference returned by
hci_connect_sco() and no longer drops it on the error paths;
sco_connect_cfm(), which is not given a reference, takes one with
hci_conn_hold() before handing it to sco_conn_add() (and drops it again if
the allocation fails); and the explicit hci_conn_hold() in sco_conn_ready()
is removed. Every reference then has a single, clear owner.

Fixes: e6720779ae61 ("Bluetooth: SCO: Use kref to track lifetime of sco_conn")
Cc: stable@vger.kernel.org
Suggested-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -190,6 +190,9 @@ static void sco_sock_clear_timer(struct
 }
 
 /* ---- SCO connections ---- */
+/* Consumes a reference on @hcon, which the returned sco_conn owns until it is
+ * freed. On failure (NULL return) the reference is left for the caller to drop.
+ */
 static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
 {
 	struct sco_conn *conn = hcon->sco_data;
@@ -200,6 +203,9 @@ static struct sco_conn *sco_conn_add(str
 			sco_conn_lock(conn);
 			conn->hcon = hcon;
 			sco_conn_unlock(conn);
+		} else {
+			/* conn already owns a reference on hcon */
+			hci_conn_drop(hcon);
 		}
 		return conn;
 	}
@@ -267,10 +273,8 @@ static void sco_conn_del(struct hci_conn
 	sco_conn_unlock(conn);
 	sco_conn_put(conn);
 
-	if (!sk) {
-		sco_conn_put(conn);
+	if (!sk)
 		return;
-	}
 
 	/* Kill socket */
 	lock_sock(sk);
@@ -285,7 +289,7 @@ static void __sco_chan_add(struct sco_co
 {
 	BT_DBG("conn %p", conn);
 
-	sco_pi(sk)->conn = conn;
+	sco_pi(sk)->conn = sco_conn_hold(conn);
 	conn->sk = sk;
 
 	if (parent)
@@ -368,15 +372,15 @@ static int sco_connect(struct sock *sk)
 	 */
 	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
 		release_sock(sk);
-		hci_conn_drop(hcon);
+		sco_conn_put(conn);
 		err = -EBADFD;
 		goto unlock;
 	}
 
 	err = sco_chan_add(conn, sk, NULL);
+	sco_conn_put(conn);
 	if (err) {
 		release_sock(sk);
-		hci_conn_drop(hcon);
 		goto unlock;
 	}
 
@@ -1452,8 +1456,6 @@ static void sco_conn_ready(struct sco_co
 		bacpy(&sco_pi(sk)->src, &conn->hcon->src);
 		bacpy(&sco_pi(sk)->dst, &conn->hcon->dst);
 
-		sco_conn_hold(conn);
-		hci_conn_hold(conn->hcon);
 		__sco_chan_add(conn, sk, parent);
 
 		if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
@@ -1509,10 +1511,12 @@ static void sco_connect_cfm(struct hci_c
 	if (!status) {
 		struct sco_conn *conn;
 
-		conn = sco_conn_add(hcon);
+		conn = sco_conn_add(hci_conn_hold(hcon));
 		if (conn) {
 			sco_conn_ready(conn);
 			sco_conn_put(conn);
+		} else {
+			hci_conn_drop(hcon);
 		}
 	} else
 		sco_conn_del(hcon, bt_to_errno(status));


