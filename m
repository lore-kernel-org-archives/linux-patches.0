Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582F49D5AB;
	Thu, 17 Sep 2026 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668613; cv=none; b=p/tDGS/sDOw393xCMB30zasrMahOBkimDhHNDjwPTCT1OqhP2fKkTanul7qpFiHoN0gtEMPuNIC3bcb7kW6Ou0l6Cg+GxvzqOTPM5+T6OcdsA3wY2DYGvNJAOJZDNW7JeqSwxkTGpV1+kclET5j5J7TxHCpDGcdYUGbEO7shw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668613; c=relaxed/simple;
	bh=pOruO3v5/LRBnJG0dWvu9VyRJac1f2taiavOw3y3pt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6Sa0TxJLqML/59vQrWJFyU4eX7NU/RBf55QbB/0zBHuKCxTGmRPzsZJMkxVbRiLGKOH3U13Ogd9l/yVRpx9DbH4tWDdeF+cdWbO6W2HJmxZU+VdowImENLSjuLFbaYfDjIlg2p4NLKZoRUwohTcQfzGGtTmF6odxfbHKguut9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHu7at4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHu7at4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04251F000FF;
	Thu, 17 Sep 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668612;
	bh=/5avORS2bRZJVXrt1wgdTDaHHNhllJv0WuA2b5MKymk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHu7at4u01URuIkUHKeS4h5ZvLZRm9QCpMbV1Yk4j/97SsEdZVphpbit6JcN0kuYi
	 QHvSySL4nsvhWpCv1ycnUsEOtm8We/+gzDzJPYloMFeD5XxtAlaOZf0NKYBAL2Dmkx
	 Lmbz4ldU8wSDfX8zEXupEy2fzlPOnkhMN9AeGFYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0483/1102] Bluetooth: ISO: fix malformed ISO_END/CONT handling
Date: Thu, 17 Sep 2026 16:07:06 +0100
Message-ID: <20260917151551.823844453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index a8b4676bc8df5..6e1fac4b1cf63 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2329,7 +2329,7 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 	switch (pb) {
 	case ISO_START:
 	case ISO_SINGLE:
-		if (conn->rx_len) {
+		if (conn->rx_skb || conn->rx_len) {
 			BT_ERR("Unexpected start frame (len %d)", skb->len);
 			kfree_skb(conn->rx_skb);
 			conn->rx_skb = NULL;
@@ -2396,12 +2396,14 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
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
 
@@ -2417,17 +2419,9 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
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
@@ -2438,6 +2432,13 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
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



