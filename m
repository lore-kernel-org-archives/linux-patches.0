Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CF52590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D96CC433EF;
	Sun, 22 Jan 2023 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400346;
	bh=5n00pYNdhTKEaeVLHLBRQn6jFuJHjA1J/7S0ovuYaYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hftMrM4L5qmdVHIo2UJVSrAb/QEFtBvTV0r7KRrONVVxGpg6/cCr6nVSqXEm2m0CZ
	 EmpLbTGLRs2cMbFRWXY+1WPKD0FQi2LHT34oLg6v+VjZXBh/mEPsC/YVvWwU4IWt7p
	 W5zCGpxrje6CSnGGVqoAlrrypiCcN9DgKLdui9wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 39/98] xhci: Add a flag to disable USB3 lpm on a xhci root port level.
Date: Sun, 22 Jan 2023 16:03:55 +0100
Message-Id: <20230122150231.146788924@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 0522b9a1653048440da5f21747f21e498b9220d1 upstream.

One USB3 roothub port may support link power management, while another
root port on the same xHC can't due to different retimers used for
the ports.

This is the case with Intel Alder Lake, and possible future platforms
where retimers used for USB4 ports cause too long exit latecy to
enable native USB3 lpm U1 and U2 states.

Add a flag in the xhci port structure to indicate if the port is
lpm_incapable, and check it while calculating exit latency.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    8 ++++++++
 drivers/usb/host/xhci.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5009,6 +5009,7 @@ static int xhci_enable_usb3_lpm_timeout(
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -5022,6 +5023,13 @@ static int xhci_enable_usb3_lpm_timeout(
 			!xhci->devs[udev->slot_id])
 		return USB3_LPM_DISABLED;
 
+	/* If connected to root port then check port can handle lpm */
+	if (udev->parent && !udev->parent->parent) {
+		port = xhci->usb3_rhub.ports[udev->portnum - 1];
+		if (port->lpm_incapable)
+			return USB3_LPM_DISABLED;
+	}
+
 	hub_encoded_timeout = xhci_calculate_lpm_timeout(hcd, udev, state);
 	mel = calculate_max_exit_latency(udev, state, hub_encoded_timeout);
 	if (mel < 0) {
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1728,6 +1728,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {


