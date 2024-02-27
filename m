Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5057413A26F;
	Tue, 27 Feb 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043003; cv=none; b=W4px4aICFnpxwkw4jG9W1VdAhIZTDisEikpqw2SMYse+ZM0gD64Qwe+dddLLeWMiQRP6K3H9ZiKqXacyDtWYgN5mLjlQpdHZJe9JjRwNljbLdE20TeDK4ePOobXRJvJpe2P+jskI1TdqkE1RvUzzeachcaZsmkSF0JSMfvdDI/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043003; c=relaxed/simple;
	bh=HJaxnbzZzD3/gOTdtOmjxvTXPiQJrB/x3h4yw4ULkh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imdNKUs097d6y8+wzoRblJ4D/Rdw99WT5M8WiBMjArh64F/Tmr3Q3uMXpReoyTFeRaAUJeWDCTIqhqYkVl/k4YOzEeLQTwUby8L+7TIxkMd9xxJ52uzsaE04Fn1AUwKJwX+cmHAYb3aP+9h8DxEdu0+oLFE6Vx5hSHwI01CqarM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOdCov3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOdCov3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8682DC433C7;
	Tue, 27 Feb 2024 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043002;
	bh=HJaxnbzZzD3/gOTdtOmjxvTXPiQJrB/x3h4yw4ULkh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOdCov3TxQdqOz31En5xavQDO2OtasWvnmkhywmEx/fBNVSQnNxjsY0RyEc7ZptzQ
	 r1jWgbKm7Y77mr0raqtyyJUeTqY/JqjxpsGpRcBMd9ItrrPRoqzJAcepGkLSehCJ6n
	 doarV9hs0pPzVyepij5pN/ih13s7KJixV6QQXU80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/245] xhci: track port suspend state correctly in unsuccessful resume cases
Date: Tue, 27 Feb 2024 14:26:27 +0100
Message-ID: <20240227131621.658330773@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit d7cdfc319b2bcf6899ab0a05eec0958bc802a9a1 ]

xhci-hub.c tracks suspended ports in a suspended_port bitfield.
This is checked when responding to a Get_Status(PORT) request to see if a
port in running U0 state was recently resumed, and adds the required
USB_PORT_STAT_C_SUSPEND change bit in those cases.

The suspended_port bit was left uncleared if a device is disconnected
during suspend. The bit remained set even when a new device was connected
and enumerated. The set bit resulted in a incorrect Get_Status(PORT)
response with a bogus USB_PORT_STAT_C_SUSPEND change
bit set once the new device reached U0 link state.

USB_PORT_STAT_C_SUSPEND change bit is only used for USB2 ports, but
xhci-hub keeps track of both USB2 and USB3 suspended ports.

Cc: stable@vger.kernel.org
Reported-by: Wesley Cheng <quic_wcheng@quicinc.com>
Closes: https://lore.kernel.org/linux-usb/d68aa806-b26a-0e43-42fb-b8067325e967@quicinc.com/
Fixes: 1d5810b6923c ("xhci: Rework port suspend structures for limited ports.")
Tested-by: Wesley Cheng <quic_wcheng@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230915143108.1532163-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 56c600be272a6..723201394eaa8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1043,19 +1043,19 @@ static void xhci_get_usb3_port_status(struct xhci_port *port, u32 *status,
 		*status |= USB_PORT_STAT_C_CONFIG_ERROR << 16;
 
 	/* USB3 specific wPortStatus bits */
-	if (portsc & PORT_POWER) {
+	if (portsc & PORT_POWER)
 		*status |= USB_SS_PORT_STAT_POWER;
-		/* link state handling */
-		if (link_state == XDEV_U0)
-			bus_state->suspended_ports &= ~(1 << portnum);
-	}
 
-	/* remote wake resume signaling complete */
-	if (bus_state->port_remote_wakeup & (1 << portnum) &&
+	/* no longer suspended or resuming */
+	if (link_state != XDEV_U3 &&
 	    link_state != XDEV_RESUME &&
 	    link_state != XDEV_RECOVERY) {
-		bus_state->port_remote_wakeup &= ~(1 << portnum);
-		usb_hcd_end_port_resume(&hcd->self, portnum);
+		/* remote wake resume signaling complete */
+		if (bus_state->port_remote_wakeup & (1 << portnum)) {
+			bus_state->port_remote_wakeup &= ~(1 << portnum);
+			usb_hcd_end_port_resume(&hcd->self, portnum);
+		}
+		bus_state->suspended_ports &= ~(1 << portnum);
 	}
 
 	xhci_hub_report_usb3_link_state(xhci, status, portsc);
@@ -1112,6 +1112,7 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 			usb_hcd_end_port_resume(&port->rhub->hcd->self, portnum);
 		}
 		port->rexit_active = 0;
+		bus_state->suspended_ports &= ~(1 << portnum);
 	}
 }
 
-- 
2.43.0



