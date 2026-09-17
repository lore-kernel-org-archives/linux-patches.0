Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E284DDB57;
	Thu, 17 Sep 2026 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659021; cv=none; b=VPrYSezrU7vyku9DpnSw5fvl+5dILudKhuSmt3WzUVodnVehjE06mou//Gsl0BTHRjZ05RtpQJWvxgHCmir+N0VqL5VcfTWNOj+UfjKE6XO4d1YsAzaxWEtW/o5+7R1TvrbVcKAQaGqwtBMgV6JCxSPZ4CV68GxfkK2oe4lG1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659021; c=relaxed/simple;
	bh=lN1Z92EJ3fYW+JEsiXtw7dyjbb60u80f7j426WzaE+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTj+/ZLOxZRQRbVoj0TACpcRhkU38n4enzSlMsmfQIlYlcaK/BIbpctWRY6lE1/8J9TAscTOaL9d5vc6HJIaTvtR4FL5t1y1mrBw/inNoZ6W2QKwMs2v52nD1XikX9RB4VOa9g1ViIQPhYYXH/6p0Zp1yBhabRTZxfMdhjnD1sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXFf8YTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXFf8YTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050311F008A2;
	Thu, 17 Sep 2026 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659013;
	bh=EBNFGgAXycdf6AaIH3wIx8M9Cl/3Pof4k/uI6btg8yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXFf8YTY8H1ppH2ercZoEV0je6PgrL5BHWmkrCPlymEWXxoG1AOPTqWtg7YPM3Ubh
	 TxIcK+CcMY82L1v8Qevw9xvkRbR29ZTDuH4FPgq5S/sRcr3LPAX3e7m6IMIz7e/YYI
	 YeY751s7I8wxj/1G46SC+3HKf+RkMBSAdgmcqOSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 113/733] Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect
Date: Thu, 17 Sep 2026 16:07:01 +0100
Message-ID: <20260917151353.802960040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d9d72cac9269b..b31afc4d7dae2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1337,7 +1337,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 struct l2cap_ecred_conn_data {
 	struct {
 		struct l2cap_ecred_conn_req_hdr req;
-		__le16 scid[5];
+		__le16 scid[L2CAP_ECRED_CONN_SCID_MAX];
 	} __packed pdu;
 	struct l2cap_chan *chan;
 	struct pid *pid;
@@ -1365,6 +1365,10 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
+	/* Unreachable, checked in l2cap_connect (+timer drops it if reached) */
+	if (WARN_ON_ONCE(conn->count >= ARRAY_SIZE(conn->pdu.scid)))
+		return;
+
 	l2cap_ecred_init(chan, 0);
 
 	/* Set the same ident so we can match on the rsp */
@@ -7373,6 +7377,9 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		goto done;
 	}
 
+	mutex_lock(&conn->lock);
+	l2cap_chan_lock(chan);
+
 	if (chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
 		struct l2cap_chan_data data;
 
@@ -7380,19 +7387,20 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
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



