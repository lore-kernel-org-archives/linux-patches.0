Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A251F4E9C11;
	Fri,  9 Oct 2026 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557076; cv=none; b=rBkUu48yL261fniInMEZ9NGW3cV9ycJM39IeWpcsZt7gvD3jXIGLAN5gt4uSEvC0FT/r50J1jtDXMUwtEVN7ruOm05kVjtL7W3f3J25l8UafNceDD0VIxv0Jjb/gmp7SGCoV5Xx9RLD/omMYi8zzGgii9DOIWXJprUvqpEwAAAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557076; c=relaxed/simple;
	bh=RlxwQ863fsWqw9ZyjeDlI+SndT76PpTZlFz/nPBkJ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAg0mxBrJa+UA+lk90gIa/QbiZC9iYgpT5hULk8QseS5ns+PQ8CtwdY2LJ+icC8Hz9U7D9XOccUsJ8YXnB+Rcm3/RQEASyc6znx4S0XBw+y+MFWaxEKeg792cjFtG50hXIXl0znXPBS+PKpVUXZ483TAhqvf8IRkmGVNER06D8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiiwvNtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiiwvNtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056ED1F000FF;
	Fri,  9 Oct 2026 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557075;
	bh=EcpTy0gwHGizQGeDI4PPriNa9DDegY317xI8lVdTOAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiiwvNtKaN0WbFBcY3H4RbzNY9ohL/gag9zw00T0e1P7QH9KjLKSiN2/Bfbb9K22h
	 hXxaT5TpkuICJet6jCPKxANRivUtZ7HpmSLehrdM3/WN0uCYT+HY9LXpjBDV3xi+hG
	 Def20Q3l3gsZdlMT6n4MjhpblXrk36AM8krCcPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 292/428] Bluetooth: btintel_pcie: reject oversized TX packets in send_frame()
Date: Fri,  9 Oct 2026 16:10:29 +0200
Message-ID: <20261009140952.521007621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -2157,6 +2157,16 @@ static int btintel_pcie_send_frame(struc
 	if (test_bit(BTINTEL_PCIE_RECOVERY_IN_PROGRESS, &data->flags))
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


