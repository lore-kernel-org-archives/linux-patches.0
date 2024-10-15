Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ED61EBFE0;
	Tue, 15 Oct 2024 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992464; cv=none; b=biOCQeBLXU2qg8clef5cLUuIU95GARUz8mbxHUgdAAYbbu3Yu+06fDqKBtwnaV2r1JoOYa6dFqtTZ9Zh3thkE57osnHzkwX/W8Fem3Py3fJlJoRw7upUU34FWjNAJ9gml4nSZyymJDDNJDaEuzA3T65CnYkznUVv7Xsk0dZMNTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992464; c=relaxed/simple;
	bh=3GXFusBYgV/6CpeiSSnDr3F3mtDTaqs+5o+g0bMyxiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rit+Fpr+4IvhwYagGKqkzupAHg6XR7JBDUWIdJj5kUdMQHw6dk+UtOuJMfTzxnQaGwWiFHxLUn/zEFBLaZn8w6MueU+/eoMpd0YW2QHumnMcYvZXj89LRQRbFF4xzVTUl3kcn2/+mRoBniNgr7x4Q6zejnSEAEMPAqxFl5Wl+Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+2P+LWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+2P+LWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29BCC4CEC6;
	Tue, 15 Oct 2024 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992464;
	bh=3GXFusBYgV/6CpeiSSnDr3F3mtDTaqs+5o+g0bMyxiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+2P+LWC5vbR7rgXJiUax7OUaYHu3AXBscRqc5wXys5x9e4eUvsCQmFnkmlqeyZgR
	 OylGR9zcRBn3s9Zw2dlyLuko2m4+rqLch2WnmyjoeDRvd23AR1AktUc6+3U/zF99p+
	 yioU8FVQBl4axKGG1XwDzeh4Flr2IxtqKGEyEA88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/691] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Tue, 15 Oct 2024 13:21:13 +0200
Message-ID: <20241015112445.318447953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 7b05933340f4490ef5b09e84d644d12484b05fdf ]

Requesting transfers of the exact same size of wMaxPacketSize may result
in ZPL/short-transfer since the USB stack cannot handle it as we are
limiting the buffer size to be the same as wMaxPacketSize.

Also, in terms of throughput this change has the same effect to
interrupt endpoint as 290ba200815f "Bluetooth: Improve USB driver throughput
by increasing the frame size" had for the bulk endpoint, so users of the
advertisement bearer (e.g. BT Mesh) may benefit from this change.

Fixes: 5e23b923da03 ("[Bluetooth] Add generic driver for Bluetooth USB devices")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e45bfe8463a42..fcd1910825b65 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1002,7 +1002,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
 	if (!urb)
 		return -ENOMEM;
 
-	size = le16_to_cpu(data->intr_ep->wMaxPacketSize);
+	/* Use maximum HCI Event size so the USB stack handles
+	 * ZPL/short-transfer automatically.
+	 */
+	size = HCI_MAX_EVENT_SIZE;
 
 	buf = kmalloc(size, mem_flags);
 	if (!buf) {
-- 
2.43.0



