Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9629A0;
	Wed,  7 May 2025 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644543; cv=none; b=sZAY6Y5u7oRQR6eV5gPdrywy57DdPgdKMJv1SU50jWKeLhqUG++Ht2HEsnsSq/S7ysHvy5xpJd3Icj7Fxsr+kWY12HviJOB6HTcoz5X1vviRF89R996xRsCIrWK6UTA0Kx+qqPvYPEYbNR7MkSgWgqOO1pIenyDzUgepeZvM4MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644543; c=relaxed/simple;
	bh=fism3zIP+Rw8HSM5uU5O2/VhTtFTVNGYVNhdPp5WxMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcZYGy5Z4u4vY5yRlA/O4ZzggYpcGsvg7bcIVpJnyvnCj4EKvQLFeAs9JFWqssjJP2JxXJu0bx0UFNybQg068x1W0/L6BiQ6qdBc4t2KJdJ0KbXAFVqsStdjlCfcdXs7RYX/2i3onAvzqcToyvZgmsObOqRusDYKxIYM+8fzGx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHMEm8jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHMEm8jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B920CC4CEE2;
	Wed,  7 May 2025 19:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644543;
	bh=fism3zIP+Rw8HSM5uU5O2/VhTtFTVNGYVNhdPp5WxMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHMEm8jgFB/JvRFFVXR94Bp0oNKM1HhiXW88eXrdyDaTOGpe2GrlFMN68cjN/sjv2
	 0VD0zR+RP7yiaxf/PNYWx+WRq4iBfO7gBiQQdm838yEs7JWwXK7nlj7laQ/U7nWmhV
	 U9JRZPq02RGH32O+fdC7B90qVwS4SOZo09v0xm/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/164] Bluetooth: btintel_pcie: Avoid redundant buffer allocation
Date: Wed,  7 May 2025 20:39:22 +0200
Message-ID: <20250507183824.080516662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit d1af1f02ef8653dea4573e444136c8331189cd59 ]

Reuse the skb buffer provided by the PCIe driver to pass it onto the
stack, instead of copying it to a new skb.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 33 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index ab465e13c1f60..3d6067927f7ea 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -581,8 +581,10 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 		/* This is a debug event that comes from IML and OP image when it
 		 * starts execution. There is no need pass this event to stack.
 		 */
-		if (skb->data[2] == 0x97)
+		if (skb->data[2] == 0x97) {
+			hci_recv_diag(hdev, skb);
 			return 0;
+		}
 	}
 
 	return hci_recv_frame(hdev, skb);
@@ -598,7 +600,6 @@ static int btintel_pcie_recv_frame(struct btintel_pcie_data *data,
 	u8 pkt_type;
 	u16 plen;
 	u32 pcie_pkt_type;
-	struct sk_buff *new_skb;
 	void *pdata;
 	struct hci_dev *hdev = data->hdev;
 
@@ -675,24 +676,20 @@ static int btintel_pcie_recv_frame(struct btintel_pcie_data *data,
 
 	bt_dev_dbg(hdev, "pkt_type: 0x%2.2x len: %u", pkt_type, plen);
 
-	new_skb = bt_skb_alloc(plen, GFP_ATOMIC);
-	if (!new_skb) {
-		bt_dev_err(hdev, "Failed to allocate memory for skb of len: %u",
-			   skb->len);
-		ret = -ENOMEM;
-		goto exit_error;
-	}
-
-	hci_skb_pkt_type(new_skb) = pkt_type;
-	skb_put_data(new_skb, skb->data, plen);
+	hci_skb_pkt_type(skb) = pkt_type;
 	hdev->stat.byte_rx += plen;
+	skb_trim(skb, plen);
 
 	if (pcie_pkt_type == BTINTEL_PCIE_HCI_EVT_PKT)
-		ret = btintel_pcie_recv_event(hdev, new_skb);
+		ret = btintel_pcie_recv_event(hdev, skb);
 	else
-		ret = hci_recv_frame(hdev, new_skb);
+		ret = hci_recv_frame(hdev, skb);
+	skb = NULL; /* skb is freed in the callee  */
 
 exit_error:
+	if (skb)
+		kfree_skb(skb);
+
 	if (ret)
 		hdev->stat.err_rx++;
 
@@ -706,16 +703,10 @@ static void btintel_pcie_rx_work(struct work_struct *work)
 	struct btintel_pcie_data *data = container_of(work,
 					struct btintel_pcie_data, rx_work);
 	struct sk_buff *skb;
-	int err;
-	struct hci_dev *hdev = data->hdev;
 
 	/* Process the sk_buf in queue and send to the HCI layer */
 	while ((skb = skb_dequeue(&data->rx_skb_q))) {
-		err = btintel_pcie_recv_frame(data, skb);
-		if (err)
-			bt_dev_err(hdev, "Failed to send received frame: %d",
-				   err);
-		kfree_skb(skb);
+		btintel_pcie_recv_frame(data, skb);
 	}
 }
 
-- 
2.39.5



