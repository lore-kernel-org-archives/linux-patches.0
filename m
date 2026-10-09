Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED2439FCCD;
	Fri,  9 Oct 2026 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556450; cv=none; b=TH5f5aB1iGHiBtazvaTvUiarxiaP3iZc8DJzOHtYbEwMnpcogLPZkjJV/E3tL/vliIzJ8pvebg41qDA7E0dl9JWQdcEmRgjmeeNP3Zc7YihfnqBiccPp+abYOLDKbu5PAh9Kd3wa8fw/oY2w/4LjE7GfIMQTl/eHbOAZaUi8/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556450; c=relaxed/simple;
	bh=JsOblCoK7u+tMtF7jqaHm6D5nEtawtG43NvCjGplFuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDqavdeE0qD2kvd8unk7dUVfBilM+ytCZsTvZR6fROv0r3sT6qofo+ITijJJwXupiVZDesHkbrd1KQYa3bgWdJWAJ+afVaU0s7ZsPlOG4HTL4MC3RQcWfq3lk71SUa5d01ZSzMQouKpmnsT9HwDh9wbM3YUPDkm/+jVTDuIZpQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAsPZs0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAsPZs0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE081F000FF;
	Fri,  9 Oct 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556448;
	bh=84Y4MhCoIUmJNRvIJV/irIUWy4BExuMtSPh29GTofN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAsPZs0II7brVurrL/8p5gE0yUvUvLnKE2RnciBjl+EjKe1/PbBXcOUqraxLZXpU2
	 ZmT95kU5U39k2xXaiNm9VaP/ep4VR8zugUnQMAHsVz0RS2NRBtM4yt23uyQtu/FEQA
	 aF1K6JJJxft2/8XcpBoSh98DARlzC1c2BXJRTE2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 235/403] Bluetooth: btintel_pcie: reject oversized TX packets in send_frame()
Date: Fri,  9 Oct 2026 16:09:56 +0200
Message-ID: <20261009140957.657751679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit f771f96557a4d953a7e4d045870547271e36e819 upstream.

btintel_pcie_send_frame() eventually copies skb->data into a fixed
BTINTEL_PCIE_BUFFER_SIZE (4096) DMA buffer via memcpy() in
btintel_pcie_prepare_tx(), with a 4-byte PCIe type header prepended.
A user-space process with HCI_CHANNEL_USER access can inject an
oversized packet and overflow the buffer.

Reject packets larger than
BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN on entry.

Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1968,6 +1968,16 @@ static int btintel_pcie_send_frame(struc
 	if (test_bit(BTINTEL_PCIE_CORE_HALTED, &data->flags))
 		return -ENODEV;
 
+	/* Account for the 4-byte PCIe type header prepended before the
+	 * DMA copy.  Written as a subtraction to avoid wrap-around on
+	 * attacker-controlled skb->len.
+	 */
+	if (skb->len > BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN) {
+		bt_dev_err(hdev, "Packet too large: %u > %u", skb->len,
+			   BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN);
+		return -EMSGSIZE;
+	}
+
 	/* Due to the fw limitation, the type header of the packet should be
 	 * 4 bytes unlike 1 byte for UART. In UART, the firmware can read
 	 * the first byte to get the packet type and redirect the rest of data


