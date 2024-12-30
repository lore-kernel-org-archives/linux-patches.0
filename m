Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933D715E8B;
	Mon, 30 Dec 2024 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574348; cv=none; b=HtQ1jcdJdHwNKhYqVpL1a8uzJxADSMcpGrJEf7ICz6CaXHSkzwHyDGlZ5nn1iQ6f3jFnYGnSFqzWA4m6WiIyIrBtz1W2MSkTI/gJAghRrSb9ZPjhdVcxE796YOA07DSf9IVhIqyt7qL+LjBRelpnPcgkm15LhS8aQ/M9WgYEbJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574348; c=relaxed/simple;
	bh=kfsIfskmKZ27JLQmhM8kVtjKc1gN+3UsmTD7BAH+Yj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYJgSzuYadYSwi2Hmv8uWio/1rgN9n1sZ1CTX4kIzzhSDuyn4u/jdEcITE4KEwW+QEqfYv6bLQDN5nhDFvk+L3X8A0KxrMc1tZfgo9buDqDWfcJncNVCaGQdqKfljPDD82YxeOItseX45Gun5s6M02tBUByWIkYgUUdTz1GpDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOU3/nR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOU3/nR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E4AC4CED0;
	Mon, 30 Dec 2024 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574348;
	bh=kfsIfskmKZ27JLQmhM8kVtjKc1gN+3UsmTD7BAH+Yj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOU3/nR1XOWRb+Abj3ktSM2+enGitnzwCNI6JBuoTb5blWGyLNRrcnF96zUukh7t9
	 j17lNinhm7GBDFnhprsbjqp5RdVlLaoz7ACYv7kffPujW4ALVDhRVY/CeSTHvnBxLu
	 Es6YdmW8xdkJSQVj6mWhD1bTOHe8F0tfFYWMFO1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <boddah8794@gmail.com>
Subject: [PATCH 6.12 110/114] Bluetooth: btusb: mediatek: add callback function in btusb_disconnect
Date: Mon, 30 Dec 2024 16:43:47 +0100
Message-ID: <20241230154222.366829609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

commit cea1805f165cdd783dd21f26df957118cb8641b4 upstream.

Add disconnect callback function in btusb_disconnect which is reserved
for vendor specific usage before deregister hci in btusb_disconnect.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Fedor Pchelkin <boddah8794@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -870,6 +870,7 @@ struct btusb_data {
 
 	int (*suspend)(struct hci_dev *hdev);
 	int (*resume)(struct hci_dev *hdev);
+	int (*disconnect)(struct hci_dev *hdev);
 
 	int oob_wake_irq;   /* irq for out-of-band wake-on-bt */
 	unsigned cmd_timeout_cnt;
@@ -4043,6 +4044,9 @@ static void btusb_disconnect(struct usb_
 	if (data->diag)
 		usb_set_intfdata(data->diag, NULL);
 
+	if (data->disconnect)
+		data->disconnect(hdev);
+
 	hci_unregister_dev(hdev);
 
 	if (intf == data->intf) {


