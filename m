Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF801D040E;
	Wed,  2 Oct 2024 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875452; cv=none; b=rcsf3Aw5dYeGJwJ53Fo930D8ySnZJU3Y762p2/SE80cictt2kWzD1WNtII5pu5aSX2w8rm+Y7n9IDmQZBDRjlQgA9qxZ+lfIJC5IkP5o1cqGoXwhZDQZJ4gQ/nDbfz32nuR5/dhH6gNxZ/2/clKWCDJ6jeDkMV8cLCcKHob2oFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875452; c=relaxed/simple;
	bh=sYCDW8lAUPJMLA8UM+JJArlq8YtkaRw2t4Y6ftJmNmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rD8Gh2BQmfsC2N5uFlG7zJmNc+y2PiBuemI2oEicLwnNPRrp3OiJjkqcrkRBY/oDlyK7dw8bYplzNdbgKEWxglIC2XNU3XC3YLeFmlTwhTF93QtWm+pZFUursBvDd9pz8DG7T1AMtOPGg1SG2XH7GfCCEJz44V6GaGGXGjto3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1GkACcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1GkACcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E56C4CEC5;
	Wed,  2 Oct 2024 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875452;
	bh=sYCDW8lAUPJMLA8UM+JJArlq8YtkaRw2t4Y6ftJmNmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1GkACcK9nlV46l9eU/DpQyntC1BJZiwE+BLs8Z/5hcCW26ZEKzOTIcGlqFUvUXRL
	 DdFuQ4KpZt6KURB1RaQIKIpZgtQzUtq4C2X1SL4W4xplFSEwbRuzCxjmnXoNlbawBL
	 al69yo9+k2OdBW59TvASkJqux8ubsxg4+MXkXrok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 106/695] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Wed,  2 Oct 2024 14:51:44 +0200
Message-ID: <20241002125826.705268482@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 51d9d4532dda4..1ec71a2fb63ea 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1397,7 +1397,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



