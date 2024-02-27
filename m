Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09213A26F;
	Tue, 27 Feb 2024 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042997; cv=none; b=Wl9nvrvCHoACH/tyZIGKk3VF9GrJBW1Vjf5/7XS3ZHU8yhOGKgN8dNAOfVfh3+1iLaVFjHnbdZQZL7BpCIgkk++tklqwFUUtol1teS+IeeX12OY6C4iKa/cZAelqohNmpzI9T0y/RDIUbpeXv/ZRS3RfTiplz42jD17c05xO0ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042997; c=relaxed/simple;
	bh=VQPodJwakFg2gCAqJKZvYxAAvrnOtrPiVbqbbOKVlm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYpLFJLtynHBzq0vqY5PNqRLxB3PrJ6LGzta0uGUeZZQwAR0FsIwLp9ELmEKN7BApS+UL6R1yRO7L0sqI4MxN3pItqMMXAk+/+4Z8HzDSEcbUpoTeeZKdI9l4TM1A3aub+buXVzkXqWQoils8kvKsjazpxmQwPoL6nilcJlVzZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4KO3t62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4KO3t62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BB8C433C7;
	Tue, 27 Feb 2024 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042997;
	bh=VQPodJwakFg2gCAqJKZvYxAAvrnOtrPiVbqbbOKVlm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4KO3t62W7M6UliC5lrqg7sNexaV/4C2c/qOpwHPHL71tEiUUFCZjMP48TqeckWQm
	 detNbQPzreN/pS/rocBQiaKu7ecjdn19jXjOklTGEocNdfD6rhkbU3PfejwgjCKb3M
	 cDc5CQLWcP3CFI2fF3nX3oTlajjwt+4unxXRw5qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/245] xhci: clear usb2 resume related variables in one place.
Date: Tue, 27 Feb 2024 14:26:25 +0100
Message-ID: <20240227131621.596898876@linuxfoundation.org>
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

[ Upstream commit 0e6275452ce26d7ff274a5c1b15ed581a26f7986 ]

Initially resume related USB2 variables were cleared once port
successfully resumed to U0. Later code was added to clean up
stale resume variables in case of port failed to resume to U0.

Clear the variables in one place after port is no longer resuming
or in suspended U3 state.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d7cdfc319b2b ("xhci: track port suspend state correctly in unsuccessful resume cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 38 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index d3d3dadaca10b..660a7d0f79a42 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1071,7 +1071,6 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 	struct xhci_bus_state *bus_state;
 	u32 link_state;
 	u32 portnum;
-	int ret;
 
 	bus_state = &port->rhub->bus_state;
 	link_state = portsc & PORT_PLS_MASK;
@@ -1087,23 +1086,30 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 		if (link_state == XDEV_U2)
 			*status |= USB_PORT_STAT_L1;
 		if (link_state == XDEV_U0) {
-			if (port->resume_timestamp)
-				usb_hcd_end_port_resume(&port->rhub->hcd->self,
-							portnum);
-			port->resume_timestamp = 0;
-			clear_bit(portnum, &bus_state->resuming_ports);
 			if (bus_state->suspended_ports & (1 << portnum)) {
 				bus_state->suspended_ports &= ~(1 << portnum);
 				bus_state->port_c_suspend |= 1 << portnum;
 			}
 		}
 		if (link_state == XDEV_RESUME) {
-			ret = xhci_handle_usb2_port_link_resume(port, status,
-								portsc, flags);
-			if (ret)
-				return;
+			xhci_handle_usb2_port_link_resume(port, status, portsc,
+							  flags);
 		}
 	}
+
+	/*
+	 * Clear usb2 resume signalling variables if port is no longer suspended
+	 * or resuming. Port either resumed to U0/U1/U2, disconnected, or in a
+	 * error state. Resume related variables should be cleared in all those cases.
+	 */
+	if ((link_state != XDEV_U3 &&
+	     link_state != XDEV_RESUME) &&
+	    (port->resume_timestamp ||
+	     test_bit(portnum, &bus_state->resuming_ports))) {
+		port->resume_timestamp = 0;
+		clear_bit(portnum, &bus_state->resuming_ports);
+		usb_hcd_end_port_resume(&port->rhub->hcd->self, portnum);
+	}
 }
 
 /*
@@ -1158,18 +1164,6 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 	else
 		xhci_get_usb2_port_status(port, &status, raw_port_status,
 					  flags);
-	/*
-	 * Clear stale usb2 resume signalling variables in case port changed
-	 * state during resume signalling. For example on error
-	 */
-	if ((port->resume_timestamp ||
-	     test_bit(wIndex, &bus_state->resuming_ports)) &&
-	    (raw_port_status & PORT_PLS_MASK) != XDEV_U3 &&
-	    (raw_port_status & PORT_PLS_MASK) != XDEV_RESUME) {
-		port->resume_timestamp = 0;
-		clear_bit(wIndex, &bus_state->resuming_ports);
-		usb_hcd_end_port_resume(&hcd->self, wIndex);
-	}
 
 	if (bus_state->port_c_suspend & (1 << wIndex))
 		status |= USB_PORT_STAT_C_SUSPEND << 16;
-- 
2.43.0



