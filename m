Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF7248BC1;
	Wed, 15 Jan 2025 10:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938315; cv=none; b=XF/8XUXz4dpbSdcZzJjDEQ9hnX5dcGfIZPAlil4x+jYQd2hKsAIh4fJ59c90L82B54z+IphRsO9k2wYLHOWLUmtAFTeo5pVd/a9Myj7RXSzA/BQov37RtY1LTnk93q+3WJfFmylIQ3CnuyxABdR+X4+6PJFVC8n5nmB/B7w5eqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938315; c=relaxed/simple;
	bh=JDCNIK4YzvBaCLQFbdW9wrJrMfyO3N0yUmls7p4LsWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Saf3RyOeWeoDqhc3lCk8Qb7ys/VCJP++vjxarheZVtWaJDIHHLyTWK/bseS9E0scGdqml/f+M5LE3nYCbQcFUoczQ969Ly9ee5q7bP5eMWTRB4ZqaZjrYy24IIa48XMQQ8+xCIhMcOvoq/Lt5sAVw1zGcudQWt8hZsE5p5ezE94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMxwV7oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMxwV7oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0685FC4CEDF;
	Wed, 15 Jan 2025 10:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938315;
	bh=JDCNIK4YzvBaCLQFbdW9wrJrMfyO3N0yUmls7p4LsWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMxwV7oCO+Q2ij+DA/gLjCnUrFyKPRBNebFs0A3LkJYXOrgHeZNUYYIbCzFSA29eZ
	 KDDwg/OrlBHQXZDWj4aTGVFuJEc/8fYXJdcBTkhqewG5LLu4LLgJCYRp9EN6ZOPNGp
	 HNjDrRJ7MOwCMEIwT4kXlTQWFqPfHPVlRiTLYNQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	stable <stable@kernel.org>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.12 146/189] USB: core: Disable LPM only for non-suspended ports
Date: Wed, 15 Jan 2025 11:37:22 +0100
Message-ID: <20250115103612.247437436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Kai-Heng Feng <kaihengf@nvidia.com>

commit 59bfeaf5454b7e764288d84802577f4a99bf0819 upstream.

There's USB error when tegra board is shutting down:
[  180.919315] usb 2-3: Failed to set U1 timeout to 0x0,error code -113
[  180.919995] usb 2-3: Failed to set U1 timeout to 0xa,error code -113
[  180.920512] usb 2-3: Failed to set U2 timeout to 0x4,error code -113
[  186.157172] tegra-xusb 3610000.usb: xHCI host controller not responding, assume dead
[  186.157858] tegra-xusb 3610000.usb: HC died; cleaning up
[  186.317280] tegra-xusb 3610000.usb: Timeout while waiting for evaluate context command

The issue is caused by disabling LPM on already suspended ports.

For USB2 LPM, the LPM is already disabled during port suspend. For USB3
LPM, port won't transit to U1/U2 when it's already suspended in U3,
hence disabling LPM is only needed for ports that are not suspended.

Cc: Wayne Chang <waynec@nvidia.com>
Cc: stable <stable@kernel.org>
Fixes: d920a2ed8620 ("usb: Disable USB3 LPM at shutdown")
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241206074817.89189-1-kaihengf@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -452,10 +452,11 @@ static int usb_port_runtime_suspend(stru
 static void usb_port_shutdown(struct device *dev)
 {
 	struct usb_port *port_dev = to_usb_port(dev);
+	struct usb_device *udev = port_dev->child;
 
-	if (port_dev->child) {
-		usb_disable_usb2_hardware_lpm(port_dev->child);
-		usb_unlocked_disable_lpm(port_dev->child);
+	if (udev && !udev->port_is_suspended) {
+		usb_disable_usb2_hardware_lpm(udev);
+		usb_unlocked_disable_lpm(udev);
 	}
 }
 


