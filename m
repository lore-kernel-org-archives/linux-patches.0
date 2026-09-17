Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C309F51C07A;
	Thu, 17 Sep 2026 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665068; cv=none; b=Pyp6Kf+Lzp4apIsPEqqHk8gE+6fi+aq1lfHOpc19FqGSzRSjNkEju5xVl0nv+rHQkyG7uiZx0eEV5AAGhTayOxVfnrPeWUOV/eOoU+d4ukbbeZDvJ3N/o+ZztfF6N2Gclf3aIKSVerX7lBTroZsQOnFMSkOJeNkSp9aam5j/qW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665068; c=relaxed/simple;
	bh=0pMxc3TSfEw7UC7ATUsxHEYj6uUOqY1IZWtoqKy2l4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEVidR0z0ANp4DTj2p+ap8ToNs1FVykFo29QOSkunYhqu8/rrugf4xRppDxRG/XrNbiVVIO34DRuT3OiL8/PoMunQHgBHR8nZNT/0TQxTXLeA1KPuGYe25Y01q8SSXRYaht7tIx1rAZWvf7P6M0F3AB3eHU18I0Gg6pHCIF3Y1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsXkEFXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsXkEFXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB211F000FF;
	Thu, 17 Sep 2026 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665065;
	bh=hozILGj4rWQkZQZeSPgsrlZN5qFFllgljeNclD07cqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsXkEFXKlD7EFqj1VIeqBL8xKQ3VQuQPfgAKDEwsv0B9eYuApGSvEvaGYUTmZXtH8
	 l1o4mYNhI2v9EizVQxyhicxGa34A6IeXSKM3wu3OIu170gYKNt+PV4EjENBIVkarzj
	 FSxjQ2iL8hUYYe6g2hNx7XavJONqWFHxk0P89kw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0581/1250] Bluetooth: ISO: fix malformed ISO_END/CONT handling
Date: Thu, 17 Sep 2026 16:06:16 +0100
Message-ID: <20260917151607.637399152@linuxfoundation.org>
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

[ Upstream commit e054c1a6ae7310d2815778fddb87da616e11c255 ]

Core specification (Part C vol 4 sec 5.4.5) does not exclude empty
ISO_CONT, ISO_END packets.  We currently reject them if they are last.

If controller sends malformed sequence

    ISO_START -> rx_len = 4, ISO_CONT skb->len 4, ISO_START

that ends payload in ISO_CONT, we leak conn->rx_skb. If controller sends
too long ISO_END, we panic on skb_put. If controller sends too short
ISO_END we accept it.

Fix by marking unfinished ISO_START via conn->rx_skb != NULL.  Check
skb->len properly before skb_put.  Combine the ISO_CONT/END code paths
as they require the same initial checks. Reject too short ISO_END
packets.

Fixes: 84c24fb151fc ("Bluetooth: ISO: drop ISO_END frames received without prior ISO_START")
Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 03260e1e265cf..c30bf48d3858a 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2543,7 +2543,7 @@ int iso_recv(struct hci_dev *hdev, u16 handle, struct sk_buff *skb, u16 flags)
 	switch (pb) {
 	case ISO_START:
 	case ISO_SINGLE:
-		if (conn->rx_len) {
+		if (conn->rx_skb || conn->rx_len) {
 			BT_ERR("Unexpected start frame (len %d)", skb->len);
 			kfree_skb(conn->rx_skb);
 			conn->rx_skb = NULL;
@@ -2624,12 +2624,14 @@ int iso_recv(struct hci_dev *hdev, u16 handle, struct sk_buff *skb, u16 flags)
 		break;
 
 	case ISO_CONT:
-		BT_DBG("Cont: frag len %d (expecting %d)", skb->len,
+	case ISO_END:
+		BT_DBG("%s: frag len %d (expecting %d)",
+		       (pb == ISO_END) ? "End" : "Cont", skb->len,
 		       conn->rx_len);
 
-		if (!conn->rx_len) {
-			BT_ERR("Unexpected continuation frame (len %d)",
-			       skb->len);
+		if (!conn->rx_skb) {
+			BT_ERR("Unexpected ISO %s frame (len %d)",
+			       (pb == ISO_END) ? "End" : "Cont", skb->len);
 			goto drop;
 		}
 
@@ -2645,17 +2647,9 @@ int iso_recv(struct hci_dev *hdev, u16 handle, struct sk_buff *skb, u16 flags)
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;
-		break;
 
-	case ISO_END:
-		if (!conn->rx_len) {
-			BT_ERR("Unexpected end frame (len %d)", skb->len);
-			goto drop;
-		}
-
-		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
-					  skb->len);
-		conn->rx_len -= skb->len;
+		if (pb == ISO_CONT)
+			break;
 
 		if (!conn->rx_len) {
 			struct sk_buff *rx_skb = conn->rx_skb;
@@ -2666,6 +2660,13 @@ int iso_recv(struct hci_dev *hdev, u16 handle, struct sk_buff *skb, u16 flags)
 			 */
 			conn->rx_skb = NULL;
 			iso_recv_frame(conn, rx_skb);
+		} else {
+			BT_ERR("ISO fragment incomplete (len %d, expected %d)",
+			       skb->len, conn->rx_len);
+			kfree_skb(conn->rx_skb);
+			conn->rx_skb = NULL;
+			conn->rx_len = 0;
+			goto drop;
 		}
 		break;
 	}
-- 
2.53.0



