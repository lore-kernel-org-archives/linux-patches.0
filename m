Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477C4A0EE9;
	Wed, 23 Sep 2026 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173218; cv=none; b=WfshP4SlWlIO3cQ/7qMFCABD5QYNb+kSPgpujgf/VZn9fXaRZbQ6vaFYmYpc6FCJnbfeNRu9B9n3GI/JLMszZOMhnU+n4f3GStMGW7DO2N1I8RZ5ZreFb+vLSjphOPyhDeVrIySzrnYva4YffnX4rLmnLqimEPBUVVL6moc8cCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173218; c=relaxed/simple;
	bh=1aKDxl6UKePUk1ZEMKpm7AWgzp3UR3MBpHlpuVuQEkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/7VkpAoLTm1WChhcxjCD7Um8ku6jb0bx5JQDQxDY4O7273VkkienYHszXTgoEFsnVY5SZVnVPEye8AUxh96HbXT6a/hXLRLgRtiaWuD3Y1nKZE/TvQ2kW+Gor3u6VdxrPYEI9qcKdy0ORcdnpzWRy1HOSy/HIp+9mmmCjIwUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeZG2mTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeZG2mTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE731F000FF;
	Wed, 23 Sep 2026 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173217;
	bh=UhNZR0Ofocakb1S5VYYvQ7+KZ+lCxJLCcX9caYSp/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeZG2mTdUY6L5c0tFLrsS1h/sy5fcjYnbiAaiqcb3yfTOGifyXmdkDWWm0VbXOFL1
	 ybhUz0R1GR/L6vWOTYh4Xx7St9fdaLKmg8Z5cBvlLXssg9ncpuGdC+QQSx80W3NyDF
	 vpeq6ZW6a9SOd9NmZDznWpZqJOhwK+0hov9JooTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 176/438] Bluetooth: btmtksdio, btmtkuart: validate WMT event length before struct access
Date: Wed, 23 Sep 2026 16:03:17 +0200
Message-ID: <20260923140649.328059959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 8879e3e0a84a86954c855caceead4867e74a9a27 ]

btmtksdio.c and btmtkuart.c cast a received WMT event straight to
struct btmtk_hci_wmt_evt and read its op/flag fields without checking
the event is long enough to contain them, unlike btmtk.c. The
FUNC_CTRL case then further casts to struct btmtk_hci_wmt_evt_funcc
and reads its 2-byte status field, again without a length check.
Firmware that sends a short or malformed WMT event makes both drivers
read past the end of the received SKB.

Mirror btmtk.c: validate the base WMT header with skb_pull_data()
before touching any of its fields, and when a FUNC_CTRL event turns
out to be the short, header-only form (a plain enable/disable ack
with no status word), decode the result from the header's own flag
byte instead (0 = success, otherwise failure).

Verified setup on MT7920, MT7921, MT7922 and MT7925: no regression.

Fixes: 9aebfd4a2200 ("Bluetooth: mediatek: add support for MediaTek MT7663S and MT7668S SDIO devices")
Fixes: e0b67035a90b ("Bluetooth: mediatek: update the common setup between MT7622 and other devices")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 20 +++++++++++++++++++-
 drivers/bluetooth/btmtkuart.c | 20 +++++++++++++++++++-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 94aa60d9cc207..7fab678925d19 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -217,7 +217,14 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 	}
 
 	/* Parse and handle the return WMT event */
-	wmt_evt = (struct btmtk_hci_wmt_evt *)bdev->evt_skb->data;
+	wmt_evt = skb_pull_data(bdev->evt_skb, sizeof(*wmt_evt));
+	if (!wmt_evt) {
+		bt_dev_err(hdev, "WMT event too short (%u bytes)",
+			   bdev->evt_skb->len);
+		err = -EINVAL;
+		goto err_free_skb;
+	}
+
 	if (wmt_evt->whdr.op != hdr->op) {
 		bt_dev_err(hdev, "Wrong op received %d expected %d",
 			   wmt_evt->whdr.op, hdr->op);
@@ -233,6 +240,17 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 			status = BTMTK_WMT_PATCH_DONE;
 		break;
 	case BTMTK_WMT_FUNC_CTRL:
+		if (!skb_pull_data(bdev->evt_skb,
+				   sizeof(wmt_evt_funcc->status))) {
+			/* A plain enable/disable request is acked with just
+			 * the WMT header and no trailing status word; the
+			 * result is carried in the header's own flag byte.
+			 */
+			status = wmt_evt->whdr.flag ? BTMTK_WMT_ON_UNDONE :
+						       BTMTK_WMT_ON_DONE;
+			break;
+		}
+
 		wmt_evt_funcc = (struct btmtk_hci_wmt_evt_funcc *)wmt_evt;
 		if (be16_to_cpu(wmt_evt_funcc->status) == 0x404)
 			status = BTMTK_WMT_ON_DONE;
diff --git a/drivers/bluetooth/btmtkuart.c b/drivers/bluetooth/btmtkuart.c
index 27aa48ff3ac2c..4af6fbbbd302a 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -151,7 +151,14 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 	}
 
 	/* Parse and handle the return WMT event */
-	wmt_evt = (struct btmtk_hci_wmt_evt *)bdev->evt_skb->data;
+	wmt_evt = skb_pull_data(bdev->evt_skb, sizeof(*wmt_evt));
+	if (!wmt_evt) {
+		bt_dev_err(hdev, "WMT event too short (%u bytes)",
+			   bdev->evt_skb->len);
+		err = -EINVAL;
+		goto err_free_wc;
+	}
+
 	if (wmt_evt->whdr.op != hdr->op) {
 		bt_dev_err(hdev, "Wrong op received %d expected %d",
 			   wmt_evt->whdr.op, hdr->op);
@@ -167,6 +174,17 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 			status = BTMTK_WMT_PATCH_DONE;
 		break;
 	case BTMTK_WMT_FUNC_CTRL:
+		if (!skb_pull_data(bdev->evt_skb,
+				   sizeof(wmt_evt_funcc->status))) {
+			/* A plain enable/disable request is acked with just
+			 * the WMT header and no trailing status word; the
+			 * result is carried in the header's own flag byte.
+			 */
+			status = wmt_evt->whdr.flag ? BTMTK_WMT_ON_UNDONE :
+						       BTMTK_WMT_ON_DONE;
+			break;
+		}
+
 		wmt_evt_funcc = (struct btmtk_hci_wmt_evt_funcc *)wmt_evt;
 		if (be16_to_cpu(wmt_evt_funcc->status) == 0x404)
 			status = BTMTK_WMT_ON_DONE;
-- 
2.53.0



