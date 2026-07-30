Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765343B52EE;
	Thu, 30 Jul 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426954; cv=none; b=Mf9vCkI7TqZNHu5xdpdE/ZCfqbSI7o1Assm9ED0hxyLoftA1iRE3gWsVqvzVBgcsgO78uvHh5804o/bxvH81GqfEKGkpgMszoJHdSabl7bMad3MU3iZTMfr3eC1Dl7gJvdgYBj/S51OmdOxeUeSns4CNZ2iuSFhG+2YT8QGWb2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426954; c=relaxed/simple;
	bh=Vf9k8xqSGZflO4W0UjjliumOKcRi9hv6phGJKDC8yFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt7t4sqCDlKtsMXXFbmz7zIl0oUUe1pmUeCnK3rhTQJRWOmUlE1W1Ma65yJPtuTlZeeSEGR/zBdjdJi+cPYfOP4k7V2Yg/8mwaSOBQO3dMDbelhbf6Jm7ulEVKaFRtWPQiydwgDxRuKynky96Gmv/chJonPn5cy4269+AwdzrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtBZ07sV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtBZ07sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C953A1F000E9;
	Thu, 30 Jul 2026 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426953;
	bh=q1CkcPcIX1XaWaBk1KCChXX48pFX7GHSwSAejGJTzK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtBZ07sVXu8s1B3FS8pTPYd3/cZTWYqn89Q4dZEf9HMUjZd59gQviVqD1MshKFEGI
	 sMTn6qkXRZGIx40OTebrTvWMzwkvGkMRLdeH3nve1uPDmW31PrTDBIc4hRncOdiN/R
	 gG2SRxf1iW7n+WO8SpbpTVlnUSOcXE2bt8i4+9GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 599/602] Bluetooth: hci_conn: Fix not cleaning up PA_LINK connections
Date: Thu, 30 Jul 2026 16:16:31 +0200
Message-ID: <20260730141448.643100268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 41bf23338a501e745c398e0faee948dd05d0be98 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c  |   33 +++++++++++++++++++--------------
 net/bluetooth/hci_event.c |    7 +------
 net/bluetooth/hci_sync.c  |    2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -770,21 +770,23 @@ static void find_bis(struct hci_conn *co
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
 
@@ -802,6 +804,9 @@ static int hci_le_big_terminate(struct h
 			d->big_sync_term = true;
 	}
 
+	if (!d->pa_sync_term && !d->big_sync_term)
+		return 0;
+
 	ret = hci_cmd_sync_queue(hdev, big_terminate_sync, d,
 				 terminate_big_destroy);
 	if (ret)
@@ -844,8 +849,7 @@ static void bis_cleanup(struct hci_conn
 
 		hci_le_terminate_big(hdev, conn);
 	} else {
-		hci_le_big_terminate(hdev, conn->iso_qos.bcast.big,
-				     conn);
+		hci_le_big_terminate(hdev, conn);
 	}
 }
 
@@ -988,19 +992,20 @@ static struct hci_conn *__hci_conn_add(s
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
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7026,14 +7026,9 @@ static void hci_le_big_sync_established_
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
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7150,7 +7150,7 @@ static void create_pa_complete(struct hc
 
 	hci_dev_lock(hdev);
 
-	if (!hci_conn_valid(hdev, conn))
+	if (hci_conn_valid(hdev, conn))
 		clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
 
 	if (!err)


