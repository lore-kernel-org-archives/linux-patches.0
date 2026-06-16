Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DD33D091A;
	Tue, 16 Jun 2026 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634038; cv=none; b=jQAvgtYnjcUBdGWopxTkCPY/ragXtY5vMWfboPdVeJMxoLrpIVA0pyxtlpXcHCqQNp7ufvaGyGkPgL6Z/RyJbSMIdbUlUtvAqCphcNsq63Z1pO42LX8qgog9xTinKfzhZAxUQa+5MtZjcmDX/dw7yTyqjVSjeX6HBYu2Dg2DH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634038; c=relaxed/simple;
	bh=iGDtajNVL2YwHq5stSIp5x2I3L6Zn2/805p2SPFXEqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRpHYxBjixVRj3Wb2t8GoBk6gcznlwUIYgTaHfeMJt6REhfjctS4T+e6PeSd3/vBoEDgknRnDAm8KdmOc47NQqTgandn7ZoJJAr0riSwum3jbzCB17I/QFJ2KhvBr64pwmQxIB7aumIc/duDsLGjrkSyZYVNcJI8MhFBzTxU8Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i21jD+lD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i21jD+lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C1F1F000E9;
	Tue, 16 Jun 2026 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634037;
	bh=HB0aXEs+4ZLyKLRHd3P80SR6zKkmBQaGT5m2e6272eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i21jD+lDkZc95fHiTq6pQZsSvsOIiojoSQDCVsbCiwzx3wPzPuGJ2DkwEmp/stnCC
	 sXq59kQAwhN7Q1MQWTIE1s4RTeK8y1mRj9WmQs4TMG/ACN16wx8Lh+A53Bvqrf+n6b
	 1ihpIMBWBoGvfvvHQ9KxUUX0B0mBlLdzJuGrgaqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/411] Bluetooth: RFCOMM: hold listener socket in rfcomm_connect_ind()
Date: Tue, 16 Jun 2026 20:26:40 +0530
Message-ID: <20260616145109.120228884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit 43c441edacf953b39517a44f5e5e10a93618b226 ]

rfcomm_get_sock_by_channel() scans rfcomm_sk_list under the list lock,
but returns the selected listener after dropping that lock without
taking a reference. rfcomm_connect_ind() then locks the listener,
queues a child socket on it, and may notify it after unlocking it.

The buggy scenario involves two paths, with each column showing the
order within that path:

rfcomm_connect_ind():            listener close:
  1. Find parent in              1. close() enters
     rfcomm_get_sock_by_channel()   rfcomm_sock_release().
  2. Drop rfcomm_sk_list.lock    2. rfcomm_sock_shutdown()
     without pinning parent.        closes the listener.
  3. Call lock_sock(parent) and  3. rfcomm_sock_kill()
     bt_accept_enqueue(parent,      unlinks and puts parent.
     sk, true).
  4. Read parent flags and may   4. parent can be freed.
     call sk_state_change().

If close wins the race, parent can be freed before
rfcomm_connect_ind() reaches lock_sock(), bt_accept_enqueue(), or the
deferred-setup callback.

Take a reference on the listener before leaving rfcomm_sk_list.lock.
After lock_sock() succeeds, recheck that it is still in BT_LISTEN
before queueing a child, cache the deferred-setup bit while the parent
is locked, and drop the reference after the last parent use.

KASAN reported a slab-use-after-free in lock_sock_nested() from
rfcomm_connect_ind(), with the freeing stack going through
rfcomm_sock_kill() and rfcomm_sock_release().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index d1f2c936a8a811..2f091f134a606c 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -122,7 +122,7 @@ static struct sock *__rfcomm_get_listen_sock_by_addr(u8 channel, bdaddr_t *src)
 }
 
 /* Find socket with channel and source bdaddr.
- * Returns closest match.
+ * Returns closest match with an extra reference held.
  */
 static struct sock *rfcomm_get_sock_by_channel(int state, u8 channel, bdaddr_t *src)
 {
@@ -136,15 +136,25 @@ static struct sock *rfcomm_get_sock_by_channel(int state, u8 channel, bdaddr_t *
 
 		if (rfcomm_pi(sk)->channel == channel) {
 			/* Exact match. */
-			if (!bacmp(&rfcomm_pi(sk)->src, src))
+			if (!bacmp(&rfcomm_pi(sk)->src, src)) {
+				sock_hold(sk);
 				break;
+			}
 
 			/* Closest match */
-			if (!bacmp(&rfcomm_pi(sk)->src, BDADDR_ANY))
+			if (!bacmp(&rfcomm_pi(sk)->src, BDADDR_ANY)) {
+				if (sk1)
+					sock_put(sk1);
+
 				sk1 = sk;
+				sock_hold(sk1);
+			}
 		}
 	}
 
+	if (sk && sk1)
+		sock_put(sk1);
+
 	read_unlock(&rfcomm_sk_list.lock);
 
 	return sk ? sk : sk1;
@@ -941,6 +951,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 {
 	struct sock *sk, *parent;
 	bdaddr_t src, dst;
+	bool defer_setup = false;
 	int result = 0;
 
 	BT_DBG("session %p channel %d", s, channel);
@@ -954,6 +965,11 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 
 	lock_sock(parent);
 
+	if (parent->sk_state != BT_LISTEN)
+		goto done;
+
+	defer_setup = test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags);
+
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
 		BT_DBG("backlog full %d", parent->sk_ack_backlog);
@@ -981,9 +997,11 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 done:
 	release_sock(parent);
 
-	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
+	if (defer_setup)
 		parent->sk_state_change(parent);
 
+	sock_put(parent);
+
 	return result;
 }
 
-- 
2.53.0



