Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE24F3939;
	Tue, 13 Oct 2026 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895177; cv=none; b=TniD/mbnoDju8rATipTBK8G1mMVSrFJL5paDoG/SzlXYes+u8zqadbTbdGsCrd3ItnTETsBU7wyuQTkLggQmjIjoceYvwbrD+uwhv985EW7HEEKjY1rbnu2EYWFPUJj6KB29fn6LIaBOKBuBgE/hVkPnv8AK8w1nnpQryGNilss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895177; c=relaxed/simple;
	bh=XI1+kAK3AF5kHe//KfiiEnbB9zczTknPV2kxgRs2Hag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBW47yBQgs8teW/ogQaOl8YxmcUXAjA9pR6hrPn7nxkfpROldIVE+/IJE08AB3zVayvq2S7LbmvnohRbyH8urp49HCwhfUgrxTNgX2VZFrFgnB9vjLp9qT9R4gHHEWD2k49uetJyLzVxYbUP2PNQBpGKvVFDgwXnq3AAhpAxiMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMx3Kf6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMx3Kf6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163F71F000FF;
	Tue, 13 Oct 2026 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895176;
	bh=YVxzeniUrw1A4YVMv8loFX61oY23XIg15lE+Pzhi/z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMx3Kf6TvsAR+cBWOnLE3ApfZEFA9UrVQ8gTV/xnGCVMYg+xWd0AbpY6rF3yxr1rX
	 xZ8gRTDpt2h+nuz3BA4cV8E7x1z3UthEXfyyFXxEfM89hARdolGNxHGKQTDfWO14ge
	 k23SJJkZNBRFXDcvuc9yZ9M0OT8HKh7od79XZhco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 188/497] Bluetooth: btintel_pcie: reject oversized TX packets in send_frame()
Date: Tue, 13 Oct 2026 13:35:55 +0200
Message-ID: <20261013112912.353183511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1321,6 +1321,16 @@ static int btintel_pcie_send_frame(struc
 	u32 type;
 	u32 old_ctxt;
 
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


