Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D133246FD;
	Fri, 21 Nov 2025 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731011; cv=none; b=c0++63zF6G3ufWHe76N8HxgHB+GDQux+Duu6VSgSsR72eqadduF9vFXjTiycyCA5NaXsS3AvRoiMuusa1fMrgMnkbW01EdpZyu09MFakDbsiBkcBvAmcoiYiJU96pxVPh/if1LeVBzJgtizanGcM56keMf4Ox9sHRIm4SuXERkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731011; c=relaxed/simple;
	bh=U2gGaLVeK3BD/5EISOTDPnUY2TkvW7u2OPsp/IHUqTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcwvGZWCIEV1hXXla9HwsUONJhw1GqA8TdbCPQ/1OrolXQG5vhxGgjwh84RM02E/B9gkZTgIpRymWgqzXFzwLoAfA1X8nkXVzYOJlSYlTAQ9pRfQUfmEh5CE6ABB4fe5KN4Q9hzbSWIMqEfoeaaFzIwCo5C+/joO4eWZEbC1ZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwtLqdAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwtLqdAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9702C4CEF1;
	Fri, 21 Nov 2025 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731011;
	bh=U2gGaLVeK3BD/5EISOTDPnUY2TkvW7u2OPsp/IHUqTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwtLqdAFObqV5PfnkG22cQJCdv2USJkWlFTbRXCWxO9ML9Qedgag/t5w4GXP/0lqX
	 Uc2cgh+nr0HQ4Bv2UjSZ7vW71QG7N/tJO65+/FHdH8UjIvhyo8dHlvC+w3tfQUpr/H
	 0omESQQpbPRfuVDseHcsL+cZSeym0FAZH9BdyrYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/247] Bluetooth: hci_conn: Fix not cleaning up PA_LINK connections
Date: Fri, 21 Nov 2025 14:10:07 +0100
Message-ID: <20251121130156.758267034@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 41bf23338a501e745c398e0faee948dd05d0be98 ]

Contrary to what was stated on d36349ea73d8 ("Bluetooth: hci_conn:
Fix running bis_cleanup for hci_conn->type PA_LINK") the PA_LINK does
in fact needs to run bis_cleanup in order to terminate the PA Sync,
since that is bond to the listening socket which is the entity that
controls the lifetime of PA Sync, so if it is closed/released the PA
Sync shall be terminated, terminating the PA Sync shall not result in
the BIG Sync being terminated since once the later is established it
doesn't depend on the former anymore.

If the use user wants to reconnect/rebind a number of BIS(s) it shall
keep the socket open until it no longer needs the PA Sync, which means
it retains full control of the lifetime of both PA and BIG Syncs.

Fixes: d36349ea73d8 ("Bluetooth: hci_conn: Fix running bis_cleanup for hci_conn->type PA_LINK")
Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c  | 33 +++++++++++++++++++--------------
 net/bluetooth/hci_event.c |  7 +------
 net/bluetooth/hci_sync.c  |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c021c6cb3d9a5..5846b4bae77a3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -769,21 +769,23 @@ static void find_bis(struct hci_conn *conn, void *data)
 	d->count++;
 }
 
-static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, struct hci_conn *conn)
+static int hci_le_big_terminate(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	struct iso_list_data *d;
 	int ret;
 
-	bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, conn->sync_handle);
+	bt_dev_dbg(hdev, "hcon %p big 0x%2.2x sync_handle 0x%4.4x", conn,
+		   conn->iso_qos.bcast.big, conn->sync_handle);
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
-	d->big = big;
+	d->big = conn->iso_qos.bcast.big;
 	d->sync_handle = conn->sync_handle;
 
-	if (test_and_clear_bit(HCI_CONN_PA_SYNC, &conn->flags)) {
+	if (conn->type == PA_LINK &&
+	    test_and_clear_bit(HCI_CONN_PA_SYNC, &conn->flags)) {
 		hci_conn_hash_list_flag(hdev, find_bis, PA_LINK,
 					HCI_CONN_PA_SYNC, d);
 
@@ -801,6 +803,9 @@ static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, struct hci_conn *c
 			d->big_sync_term = true;
 	}
 
+	if (!d->pa_sync_term && !d->big_sync_term)
+		return 0;
+
 	ret = hci_cmd_sync_queue(hdev, big_terminate_sync, d,
 				 terminate_big_destroy);
 	if (ret)
@@ -852,8 +857,7 @@ static void bis_cleanup(struct hci_conn *conn)
 
 		hci_le_terminate_big(hdev, conn);
 	} else {
-		hci_le_big_terminate(hdev, conn->iso_qos.bcast.big,
-				     conn);
+		hci_le_big_terminate(hdev, conn);
 	}
 }
 
@@ -995,19 +999,20 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
 		conn->mtu = hdev->le_mtu ? hdev->le_mtu : hdev->acl_mtu;
 		break;
 	case CIS_LINK:
-	case BIS_LINK:
-	case PA_LINK:
 		/* conn->src should reflect the local identity address */
 		hci_copy_identity_address(hdev, &conn->src, &conn->src_type);
 
-		/* set proper cleanup function */
-		if (!bacmp(dst, BDADDR_ANY))
-			conn->cleanup = bis_cleanup;
-		else if (conn->role == HCI_ROLE_MASTER)
+		if (conn->role == HCI_ROLE_MASTER)
 			conn->cleanup = cis_cleanup;
 
-		conn->mtu = hdev->iso_mtu ? hdev->iso_mtu :
-			    hdev->le_mtu ? hdev->le_mtu : hdev->acl_mtu;
+		conn->mtu = hdev->iso_mtu;
+		break;
+	case PA_LINK:
+	case BIS_LINK:
+		/* conn->src should reflect the local identity address */
+		hci_copy_identity_address(hdev, &conn->src, &conn->src_type);
+		conn->cleanup = bis_cleanup;
+		conn->mtu = hdev->iso_mtu;
 		break;
 	case SCO_LINK:
 		if (lmp_esco_capable(hdev))
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7ee8bc7ac5a2a..0380d2f596c97 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7011,14 +7011,9 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 				continue;
 		}
 
-		if (ev->status != 0x42) {
+		if (ev->status != 0x42)
 			/* Mark PA sync as established */
 			set_bit(HCI_CONN_PA_SYNC, &bis->flags);
-			/* Reset cleanup callback of PA Sync so it doesn't
-			 * terminate the sync when deleting the connection.
-			 */
-			conn->cleanup = NULL;
-		}
 
 		bis->sync_handle = conn->sync_handle;
 		bis->iso_qos.bcast.big = ev->handle;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 73fc41b68b687..6e76798ec786b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6999,7 +6999,7 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 
 	hci_dev_lock(hdev);
 
-	if (!hci_conn_valid(hdev, conn))
+	if (hci_conn_valid(hdev, conn))
 		clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
 
 	if (!err)
-- 
2.51.0



