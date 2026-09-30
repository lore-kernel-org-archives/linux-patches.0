Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430A84C33D1;
	Wed, 30 Sep 2026 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786354; cv=none; b=NoQAZ1N4LTVHVgybDuSPdtUYR/ZU1PVssf/+PF94Pz+0iJcGwsgVGHro3RI5XQVsbrUdlNCcgy0MyvEa3vVUa+FXNYy7sqpsB2Xdt8N2F+7d0y+FoltKpLj57g5tu0T41LCqE6KnSUHnzojsAaLRUzg28gKK+kj3ajC9sCUhZvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786354; c=relaxed/simple;
	bh=hEbTjkURPSQD4w0STJRppZBz1EibCH/e5Z/Cmk3UtBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbWygTGDQ7M7WG9W8MVUo/n7/ghTxeJwTpG7EU/3uEAxXtnp6YmM9qhV2ttawacY+K1DTlv1+s0XrPJxHHLuJQLdSuhxtO15rpymVIIjBDGv3QmHlCwO4IFsZWkj20yOES7jRdycoosVD3cUuHcuR6yO1Vf8q1TDBnXGP2kvCr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2bf/RkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2bf/RkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF31F000FF;
	Wed, 30 Sep 2026 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786353;
	bh=CbjiUKv1iYR70VcbjzQVW13gtcZGGnktB/Z8rK86zxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2bf/RkHlzQW+WO1O4OM2aZ+c98y7o4aZDC3BgSvdBtSMPwdtDpEDIBqqBT2H59CK
	 4G8LQRBdTM1qkffkf96QK03FdwTbq1mAphLOu5Si9uN+n2kLQNq/TInsNmyuMyPvi7
	 PwAsAf02B6uGOGjMlW1xWKWVtlLEaQGfP3OVN7YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 787/982] Bluetooth: hci_sync: always check if connection is alive before deleting
Date: Wed, 30 Sep 2026 17:25:23 +0200
Message-ID: <20260930152433.659134264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a239110ee8e0b0aafa265f0d54f7a16744855e70 ]

In hci_abort_conn_sync it is possible that conn is deleted concurrently
by something else, also e.g. when waiting for hdev->lock.  This causes
double deletion of the conn, so UAF or conn_hash.list corruption.

Fix by having all code paths check that the connection is still in
conn_hash before deleting it, while holding hdev->lock which prevents
any races.

Log (when powering off while BAP streaming, occurs rarely):
=======================================================================
kernel BUG at lib/list_debug.c:56!
...
 ? __list_del_entry_valid (lib/list_debug.c:56)
 hci_conn_del (net/bluetooth/hci_conn.c:154) bluetooth
 hci_abort_conn_sync (net/bluetooth/hci_sync.c:5415) bluetooth
 ? __pfx_hci_abort_conn_sync+0x10/0x10 [bluetooth]
 ? lock_release+0x1d5/0x3c0
 ? hci_disconnect_all_sync.constprop.0+0xb2/0x230 [bluetooth]
 ? __pfx_lock_release+0x10/0x10
 ? __kmem_cache_free+0x14d/0x2e0
 hci_disconnect_all_sync.constprop.0+0xda/0x230 [bluetooth]
 ? __pfx_hci_disconnect_all_sync.constprop.0+0x10/0x10 [bluetooth]
 ? hci_clear_adv_sync+0x14f/0x170 [bluetooth]
 ? __pfx_set_powered_sync+0x10/0x10 [bluetooth]
 hci_set_powered_sync+0x293/0x450 [bluetooth]
=======================================================================

Fixes: 94d9ba9f9888 ("Bluetooth: hci_sync: Fix UAF in hci_disconnect_all_sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Backport to 6.1.y follow-up to 94d9ba9f9888: this tree lacks the later
  BT_OPEN and BT_BOUND special cases, so retain its existing state
  switch and add the common liveness check. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 84d98bc3efa3f..5825ab89eb22a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5589,6 +5589,7 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 {
 	int err = 0;
 	u16 handle = conn->handle;
+	bool disconnect = false;
 	struct hci_conn *c;
 
 	switch (conn->state) {
@@ -5603,19 +5604,13 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 		err = hci_reject_conn_sync(hdev, conn, reason);
 		break;
 	default:
-		hci_dev_lock(hdev);
-		conn->state = BT_CLOSED;
-		hci_disconn_cfm(conn, reason);
-		hci_conn_del(conn);
-		hci_dev_unlock(hdev);
-		return 0;
+		disconnect = true;
+		break;
 	}
 
 	hci_dev_lock(hdev);
 
-	/* Check if the connection hasn't been cleanup while waiting
-	 * commands to complete.
-	 */
+	/* Check if the connection has been cleaned up concurrently */
 	c = hci_conn_hash_lookup_handle(hdev, handle);
 	if (!c || c != conn) {
 		err = 0;
@@ -5627,7 +5622,13 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 	 * or in case of LE it was still scanning so it can be cleanup
 	 * safely.
 	 */
-	hci_conn_failed(conn, reason);
+	if (disconnect) {
+		conn->state = BT_CLOSED;
+		hci_disconn_cfm(conn, reason);
+		hci_conn_del(conn);
+	} else {
+		hci_conn_failed(conn, reason);
+	}
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
2.53.0



