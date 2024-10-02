Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871FF1D0954;
	Wed,  2 Oct 2024 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879288; cv=none; b=Dv4UQ+uG8nn+L6ssruZrPVHwWcot9hR+gaMflol99XxJnWWVEJiwMMC5f4o4zgrfjskJedUjq/0VIRUTrxEnnR6ooBBNMzQ8fprF6CfeMp4GLgEOkwjpI2Xxs9edbalnGRW3nQJw22Q2gvEq54PFNboWCzth60RZvniu+R3F0QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879288; c=relaxed/simple;
	bh=rnuJq9Ny8k5hNSRp4O5dAZ0m1j6E3gI+Hew6Wppzbc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwsXcUMfMxmqYFwr8darcGyAaVuKKUR7xFcWKW2r/9/oLPy2aoHL6MecBfiRQMXBOH4UeZz2G/Q7PJa8E+ghd5IgOEBrEziVhuSmU3qsusK41DOLLIJARIu9tIv8+XOU4Fu5M4ri5YrDamIcSMTWZ1bAZMxcfK7uH2svmvf4Hfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfTkjcsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfTkjcsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABA3C4CEC2;
	Wed,  2 Oct 2024 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879288;
	bh=rnuJq9Ny8k5hNSRp4O5dAZ0m1j6E3gI+Hew6Wppzbc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfTkjcsMkyCnbi5WjHvHTq9tZgOOryxuO2KUqL82p6cHba/mJEkt4nmn0Mz1lNLKl
	 nxWSQ8rIV8AB0KRfQK16oVJfXX3tLKaFRqSaWLf7F2yvy8yGFNMOIcxjmkfoI5Mp46
	 kYUYex39xP/sV6EINEAd9ROXd+pWGd5R2qUgY0vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/538] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Wed,  2 Oct 2024 14:55:07 +0200
Message-ID: <20241002125754.895385536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c495fceda20a2..0a58106207b0c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1352,7 +1352,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



