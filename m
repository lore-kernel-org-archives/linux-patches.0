Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415983101BF;
	Thu, 16 Jul 2026 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210312; cv=none; b=WEkxO6RIoAcRH4HHE26V/MjCO4VFCF6KqVhiYWDKRT697CsVR2e9VtxbVDeidwmjZmd0OpqCko1Cv8iDw9V+esIDp6HpvgcKjotMxkWPolEiDV5akMPJi6gtjAa5HF/GHXryMt58Scyj54awUyian+Q1MUSEw4pS6UTyeB2mOjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210312; c=relaxed/simple;
	bh=d4JNdcBbc0qNNKkdXpOfM5IXEWPvE402KUJxRJFvddE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee9y6nf2Kw7qv38gK/GsyBon4mmMSS2p74Ab+5+bRAuEaUZgn44qB0QS1mOBg2dOoEcKuTqgPDLgZLfcjHKWAVWTZorJELeb+T3XCq/0nsaRQqrzBB5Jd9wbMfO+DZLFlSyyPF+aAUazUVJCr1rmj42YlWzuGJ9Lry/ryo18RDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zf0KDcZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf0KDcZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B001F000E9;
	Thu, 16 Jul 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210311;
	bh=XQ9vjiBmvnRcHbjW6Q628CMZY7DdSgcKMQQifRviJEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zf0KDcZms0wQStOy9UtqCorjlEj93jfNZaxrR1r3ur5Z6UD9G243aIOYsITxwAUuv
	 +9340XSq7NoT9gahzJwSCv+QGA+Ji7h6YVBz1ukKNpfjikopHcnNR14QUA392l5Vqn
	 Zt3E/EO3AnHN989x4LOqV+UEX6Qju4bneZVSD/w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 518/518] Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev
Date: Thu, 16 Jul 2026 15:33:06 +0200
Message-ID: <20260716133059.172919766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit d38eaf611839b85ade3dd3db309dbc8aaaaf0095 upstream.

b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding
conn ref") don't reset the chan->conn to NULL anymore making the bt#
netdev not be remove once the last l2cap_chan_del is removed.

Instead of restoring the original behavior this remove the logic of
keeping the interface after the last channel is removed because it
never worked as intended and the l2cap_chan_del always detach its
l2cap_conn which results in always removing the channel anyway.

Fixes: b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/6lowpan.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -777,20 +777,10 @@ static void chan_close_cb(struct l2cap_c
 	struct lowpan_btle_dev *dev = NULL;
 	struct lowpan_peer *peer;
 	int err = -ENOENT;
-	bool last = false, remove = true;
+	bool last = false;
 
 	BT_DBG("chan %p conn %p", chan, chan->conn);
 
-	if (chan->conn && chan->conn->hcon) {
-		if (!is_bt_6lowpan(chan->conn->hcon))
-			return;
-
-		/* If conn is set, then the netdev is also there and we should
-		 * not remove it.
-		 */
-		remove = false;
-	}
-
 	spin_lock(&devices_lock);
 
 	list_for_each_entry_rcu(entry, &bt_6lowpan_devices, list) {
@@ -817,10 +807,8 @@ static void chan_close_cb(struct l2cap_c
 
 		ifdown(dev->netdev);
 
-		if (remove) {
-			INIT_WORK(&entry->delete_netdev, delete_netdev);
-			schedule_work(&entry->delete_netdev);
-		}
+		INIT_WORK(&entry->delete_netdev, delete_netdev);
+		schedule_work(&entry->delete_netdev);
 	} else {
 		spin_unlock(&devices_lock);
 	}


