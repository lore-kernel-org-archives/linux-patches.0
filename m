Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FF23C4B8D;
	Sat, 17 Oct 2026 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260753; cv=none; b=cEeMiUuyfg6HoZhnYEu1j+WUN1aQs6N36UJs64cTcSkPl0z0sFe+91MBiJORGaUgKB6wHWZ8eeMVnq7SVMw4DVfoUdnc5KAzA9tN/o/o41VtdYSo4Nd+pVQM0cfqQw7VINcvlVtYKB/QJqP6AFEwQ58N1DIhDIZZXcrOLogaFYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260753; c=relaxed/simple;
	bh=s/5C/HOcYaDzj1DD99024WNbinNip6jqiYbHyuOC6H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUTsNBxwv/IV2vSSOMPkaLx03iCroMm3+WeJjGKnAVmZvdIrTqf6xF1tl7VESuLmP0SZwnSkrvplLsQHYvv8BNjLhaz0s/OTXUg0hh1aJ4LmwM/CKNHIC5SdyOSQ0SmxKIAqq6zP5xncxI59f2zf0sgfmsNeZTlNp6taNWbIEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps4kt3QO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps4kt3QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0FB1F000C4;
	Sat, 17 Oct 2026 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260752;
	bh=2TkwcYDSVX1NyCbpALW9KlZYcvxNVaQcIbxmro7zo0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ps4kt3QOjmilPkExNMOGF1mWF4W+RES8PuCKvM7bF7NyDT55HsNr4FJjCFCsin3HE
	 9XfwxYCV3mgI6ZoAA/l3UykNj2nI8hR/xwfNkKr7l9BVsaOVgsOF9L5jBIHE6S9Hg8
	 7GDjsvEoJajwBSf+ovcoi3k/tc+KCY8CjCxsyDv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1649/1674] Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect
Date: Sat, 17 Oct 2026 18:05:21 +0200
Message-ID: <20261017160513.396983197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 260031e59d646..c2bd2b25a809c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1325,7 +1325,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 struct l2cap_ecred_conn_data {
 	struct {
 		struct l2cap_ecred_conn_req req;
-		__le16 scid[5];
+		__le16 scid[L2CAP_ECRED_CONN_SCID_MAX];
 	} __packed pdu;
 	struct l2cap_chan *chan;
 	struct pid *pid;
@@ -1356,6 +1356,10 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
+	/* Unreachable, checked in l2cap_connect (+timer drops it if reached) */
+	if (WARN_ON_ONCE(conn->count >= ARRAY_SIZE(conn->pdu.scid)))
+		return;
+
 	l2cap_ecred_init(chan, 0);
 
 	/* Set the same ident so we can match on the rsp */
@@ -7304,6 +7308,9 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		goto done;
 	}
 
+	mutex_lock(&conn->lock);
+	l2cap_chan_lock(chan);
+
 	if (chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
 		struct l2cap_chan_data data;
 
@@ -7311,19 +7318,20 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
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



