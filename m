Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C66627732;
	Thu, 16 Jul 2026 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211570; cv=none; b=n+xT+r0ddCFnY5smamFVFIc64ZzXR5TSv41I+oG3BLLUI/UtVlo5cevRq46/QoOuaw2GWsmS33oQIvSv7Jzm0Lhesrd/0AZcujwoZyGM+nQOxuQjPDKJ7zLF15bzpsSBUJjCbhtL8bELvqdfNpMIfjXoPFVL1UApIq/9veXzzAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211570; c=relaxed/simple;
	bh=1zF+WVi3TDPcXdfnLWo8fL4YRcNVfZL2lL8BIdA0O8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L03mnOwSaQQWQwC3vvbDAvIx1Dh/giE4wgbqE4OjyOR34Y9AMxXR+BEKNAeHQZAl/cEhYj4nwhN6ngqdJUOYZ081P3jZNSwNWsMSkYDweF6+tBH0Ums11rvPepSOqQr/AWd6WDOG5VvY7Xd4o37rxzhQjG2HW/il8uKC83o6p30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiLJZhmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiLJZhmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06871F000E9;
	Thu, 16 Jul 2026 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211569;
	bh=WqZOGn0mBZO1n+20O4fF9SIervqACrwDVwPvmZIVhMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiLJZhmhRsa4FcSvsyAreAju2II5BrkG2BrPJYXsKUI6MS520ism3MkT9banFInbR
	 NuTgPyg7nIcPSJuWW+duufX2BYf7Wi0lm+PnldjrRWE+KMUJ+wx4RQyUNijZb7SUWO
	 yy/Ugy4QVEIkcR6OLUAY302hbkWzcciLSwcgzdug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 479/480] Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev
Date: Thu, 16 Jul 2026 15:33:46 +0200
Message-ID: <20260716133055.186222833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


