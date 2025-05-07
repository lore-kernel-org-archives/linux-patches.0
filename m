Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DCA214813;
	Wed,  7 May 2025 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644076; cv=none; b=tddYnj1y2ZRbjRSur69kmAo0bHvTUc9nYWyoAz53XBf12u9rlBRBz+34Qkc9Om2Z6lkqSlO0GfYV7QmOIZJ8G+n72ZmPTMUUo+B5N76k/+MPcZJ501rfkPPuVVIouNhNccs9UHKsMdVbUSoXGyvbKX2zTR2Y4bi6pTruK/VNQig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644076; c=relaxed/simple;
	bh=EL3w0A2qk+hxgp6R9/SBDaxStiF3RNQozcOG1BAO/Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu0XnYlAq9lkJwjCehRfRzkDlW6ee3n3GTmorAdkXGdguD/pUplAUKdNFpn0ryaQHqygSHcsX5iZpnvQvRscVCtaA/fy0o8xX18Lw88TPbF3rjL44o2Ks/Lqe5S5teZMB+NyIYWcSr/cRabCNLs79Z6aZbb4FLZA8kJft0M8+Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVNQfoEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVNQfoEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C276AC4CEE2;
	Wed,  7 May 2025 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644076;
	bh=EL3w0A2qk+hxgp6R9/SBDaxStiF3RNQozcOG1BAO/Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVNQfoEfvDDhfUpTy3g42oh1fqJtasraxKc45vUWgIwWTlt0accPzB1glU+erhVo/
	 ixd78P/j69fB2BM3BPnIgOa+BLmZQGeF8pQEXRUVooITQJDX0c0VYmax7RDparje7K
	 pb5of2v2++lY+Xi8/a4KNGBQv5ZxevglFN3R0cqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 082/183] Bluetooth: btintel_pcie: Avoid redundant buffer allocation
Date: Wed,  7 May 2025 20:38:47 +0200
Message-ID: <20250507183828.156278688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 6130854b6658a..ea9b137b1491c 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -595,8 +595,10 @@ static int btintel_pcie_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -612,7 +614,6 @@ static int btintel_pcie_recv_frame(struct btintel_pcie_data *data,
 	u8 pkt_type;
 	u16 plen;
 	u32 pcie_pkt_type;
-	struct sk_buff *new_skb;
 	void *pdata;
 	struct hci_dev *hdev = data->hdev;
 
@@ -689,24 +690,20 @@ static int btintel_pcie_recv_frame(struct btintel_pcie_data *data,
 
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
 
@@ -720,16 +717,10 @@ static void btintel_pcie_rx_work(struct work_struct *work)
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



