Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A944471268;
	Tue, 21 Jul 2026 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664631; cv=none; b=oYRC9s/DE3CFYNN+Ak7GuVgsMRqIq0Jv53WqWzmCD7VBw7MORHxZ6j2yn4t7GhmkrHH4gXQQlKtW/nD2xQrK7jCJdRXLPpuFpR8320vd8XQ2faGAqf0iCNDA9cuS2uXxTFYapgw2Md75DEPpkTnWKjkkl32nQLA+n/zDzipOBc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664631; c=relaxed/simple;
	bh=nhYa9bm4i/VwgxFf8DXjbPOTgB90lBFKLuUC4H+GvOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9JO1/8Akmxx1H0LjSxXdlIHyqf/S01n5jBwAjQBg0UZ6Re8dJG7BMqmUf9a/FmkQ3MdsdHXRGri7HZbUn3wVo2zz3rT2lX4Mg6mLftYMCHKmlvqXrXE/YHs8jasviFBLBoqIM63hOh++O63KY22vn31XNowt2TgHIBF04hA3Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6yolg0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6yolg0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF63C1F000E9;
	Tue, 21 Jul 2026 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664630;
	bh=QPF9EUJ5NfmcBr3c0g9JsS15cPMvqA9CDvxdxMn6l8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6yolg0QFObQlwdS4nbMyXDVuBLTtVjPYz53dD88qtbZJaRnvcVK8f23L64tnnfzt
	 4qk5DZtBplOYnhp/6akLYMPpnzMncNjof8wBjLoH5NltEQa2fGVeJ26PmCBWjiuwhB
	 v6tgVtSFWN3hMG4wBN79NSHvdGOinMXjI7g816tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 1273/1276] Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev
Date: Tue, 21 Jul 2026 17:28:36 +0200
Message-ID: <20260721152514.576378575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -781,20 +781,10 @@ static void chan_close_cb(struct l2cap_c
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
@@ -821,10 +811,8 @@ static void chan_close_cb(struct l2cap_c
 
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


