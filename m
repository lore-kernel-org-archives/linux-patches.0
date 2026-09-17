Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F2251AEE0;
	Thu, 17 Sep 2026 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665315; cv=none; b=Cbu525mTl7lcp7IyOs4cfV/dNhe8vqe2h9XctVmhwJigrri8s16rjxkvnV4C/pi2/9WRhV/7fDGl9bkuXg/Lle7TF5aJJDVFykNO6qwQHruQunM9qbiWHo+6dMsgW/O4l9Fw7WeCi3dUACFE5667xTNjA4QtdfUC7sfo/1JeBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665315; c=relaxed/simple;
	bh=n1BM23drKrRSw+1B6HwEAwxrwz94l9euyMgqqMadK4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4fgdd1pXKZ3SgtOtsPrXFtGaPWJzf97bDLs2sKvQeyZqUKvm+Ou+rz3Oi+dR4eqpIFUggqazVYCqZLSDL+riPQ2J2giSlO9h9HVfd8+rGynQfrJyUBFYFHcoMKLBpZRbvF8rZFD52x8ARAe0oTcA7ZBPNDN+LGNCUaDrD5xEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJOVKp+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJOVKp+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E635A1F000FF;
	Thu, 17 Sep 2026 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665314;
	bh=u6ThPHl+tAIMZWb1VB7XXf8IBq/CLqXF9fXsvaoSh9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJOVKp+13eqHJ8c89elu1U/mMz6iG0z0fnxuM1LHZ2CMh9r87lloiWzWaL92TAl2E
	 T1T+m2lFhMlrpBrIOYId/O7mekR+iEKMQ3rK5GIWW67qudgevfbpGTmbImKTqeOb60
	 4P/8T5n3xyADRDOIoiA6CGQU0Q1F2gRgwEUtt20s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0665/1250] Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect
Date: Thu, 17 Sep 2026 16:07:40 +0100
Message-ID: <20260917151609.915428919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 56c2b5831d39dc84aad2573dc3e197af1a872a05 ]

l2cap_chan_connect() tries to ensure there are no more than
L2CAP_ECRED_CONN_SCID_MAX pending ECRED channels, so they fit in the
same L2CAP_ECRED_CONN_REQ that l2cap_ecred_connect() constructs.

However, the check only counts deferred channels.  If 6 L2CAP sockets
are connected at the same time in order DDDDND (D=deferred,
N=non-deferred), the last can bump the total to max+1.  It results to
one __le16 written out of bounds of the scid array, and an invalid
ECRED_CONN_REQ being sent.

Fix by leaving room for the non-deferred pending ECRED channels in the
counting in l2cap_chan_connect(), so the limit can't be exceeded.

Move counting under same critical section where the channel is added.
Although race conditions involving this appear unreachable, it's easier
to see.

Also add WARN_ON_ONCE check in l2cap_ecred_defer_connect() to make this
less brittle.

Fixes: da49b602f7f7 ("Bluetooth: L2CAP: Use DEFER_SETUP to group ECRED connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index daf51a57cfa61..fc74e9fad08f7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1340,7 +1340,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 struct l2cap_ecred_conn_data {
 	struct {
 		struct l2cap_ecred_conn_req_hdr req;
-		__le16 scid[5];
+		__le16 scid[L2CAP_ECRED_CONN_SCID_MAX];
 	} __packed pdu;
 	struct l2cap_chan *chan;
 	struct pid *pid;
@@ -1368,6 +1368,10 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
+	/* Unreachable, checked in l2cap_connect (+timer drops it if reached) */
+	if (WARN_ON_ONCE(conn->count >= ARRAY_SIZE(conn->pdu.scid)))
+		return;
+
 	l2cap_ecred_init(chan, 0);
 
 	/* Set the same ident so we can match on the rsp */
@@ -7371,6 +7375,9 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		goto done;
 	}
 
+	mutex_lock(&conn->lock);
+	l2cap_chan_lock(chan);
+
 	if (chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
 		struct l2cap_chan_data data;
 
@@ -7378,19 +7385,20 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		data.pid = chan->ops->get_peer_pid(chan);
 		data.count = 1;
 
-		l2cap_chan_list(conn, l2cap_chan_by_pid, &data);
+		__l2cap_chan_list(conn, l2cap_chan_by_pid, &data);
+
+		/* Leave room for non-deferred channel that ends the group. */
+		if (test_bit(FLAG_DEFER_SETUP, &chan->flags))
+			data.count += 1;
 
 		/* Check if there isn't too many channels being connected */
 		if (data.count > L2CAP_ECRED_CONN_SCID_MAX) {
 			hci_conn_drop(hcon);
 			err = -EPROTO;
-			goto done;
+			goto chan_unlock;
 		}
 	}
 
-	mutex_lock(&conn->lock);
-	l2cap_chan_lock(chan);
-
 	if (cid && __l2cap_get_chan_by_dcid(conn, cid)) {
 		hci_conn_drop(hcon);
 		err = -EBUSY;
-- 
2.53.0



