Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA64B0481;
	Mon, 17 Aug 2026 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977703; cv=none; b=n64EFmZviyeiSnVcBgQ/8Nt1O9CKYXobhtmBHjs2NULD48fZlid8HR9a9Jt1TglDR8xHOmV91STOOeBSKzK5X4L1zx7uoJHWKZXFx0DrK3FWkn7cjRlSnvtHDc2zSZkVP5rXiCAvT6gXkZDrjbfZWOcjlKlP6hYyG07XA2C+VdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977703; c=relaxed/simple;
	bh=IZIPfqDBbceVPDi5f6y2SQ/406HJ+ukWAXh3EpARm6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEy48zLLDKK7YE5u6DdRjdfMfiDYE2RaptKTQcA+q3utWr1cP76otsUpjSHSpA36c8/hQnNijz6SYhpCEq9c/nfEJyZUuhXSaJof8+4wRsHqsUoeeyLEFqgADqR3GRbK6r1RaQ0vrpSvnd3X7xMv+BpdGbRuBIkNbGouiUJ+GzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT9p6zWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT9p6zWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8991F000E9;
	Mon, 17 Aug 2026 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977701;
	bh=1FPpiR+8pgkNgvOm+RlwuUlvLpi48D4A5J+oUMiW3+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT9p6zWt2gu3mc+DnjVotkCylvhOsC4Y1/ECqlQ0qy5Xo6ZE3c32kMPNW7iHVxTVu
	 Vy3Nkh8uCu+OwiWsnJocqqJKV1agur30Zr+hPAxnf4twqPjh+K3WdKJzuWYC8zrA2J
	 7oKh20akhBRIm99tfXAvXLGHJqXGqGt5kwF6PkCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/456] Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev
Date: Mon, 17 Aug 2026 15:33:30 +0200
Message-ID: <20260817132555.630812479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d38eaf611839b85ade3dd3db309dbc8aaaaf0095 ]

b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding
conn ref") don't reset the chan->conn to NULL anymore making the bt#
netdev not be remove once the last l2cap_chan_del is removed.

Instead of restoring the original behavior this remove the logic of
keeping the interface after the last channel is removed because it
never worked as intended and the l2cap_chan_del always detach its
l2cap_conn which results in always removing the channel anyway.

Fixes: b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 9424d153f323f..d0b1882f5b4b7 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -775,20 +775,10 @@ static void chan_close_cb(struct l2cap_chan *chan)
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
@@ -815,10 +805,8 @@ static void chan_close_cb(struct l2cap_chan *chan)
 
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
-- 
2.53.0



