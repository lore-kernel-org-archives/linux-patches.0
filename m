Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3F238F658;
	Thu, 17 Sep 2026 18:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671382; cv=none; b=XU24u0k40rKDU4mQ/tSe1oIl4RqN2ah8XUrmw2vizGB0e+SQCUhSfjnDp2kx8oxFadZPStOHu2t27wiuq+DES69HSeI/zfa/LtEDXbO8ieHkesZvOw1W+72xh1jRD26p7JcscLUBguOvcy6eyHat4rsPDecIxbYSPoNU0aO/QzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671382; c=relaxed/simple;
	bh=82vaJdWvuDVPfxlA02WGyul+DEP5t07AwZT7EBZtsqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daHO1f16dNAJ/EehmCW5AsYh5WHRM0akOYfRGdey3o+G88h1+JkUGsIVQklUwoQgmjGV+K1u3u29UFQvfM9Fxk6uvJVJTItzLfJrI1nhp1TdFICg8mZdXdOuIzVf+2rMtNHqHAGOmd46mRQYI1oRB6VEUbfmG5FBjBSW1pIEhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzgdahr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzgdahr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B896B1F000FF;
	Thu, 17 Sep 2026 18:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671381;
	bh=yw0gFmppRhOF6ts0g84OroEqNj2Sj12LY19wprqx8Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kzgdahr7yUuviZpbcmgCU40yJXohSCD3hDYzj2K1sVe0QWi19CW9xzGG74QxqMWVI
	 usk20VsHLynXcV8IxvwmWRYusxbmbs9JA/4pX2tyi4P13XmiBeB/nDfWoenhIogjBE
	 Hmxj/A/WFuwBOmZkDOUTi782wcOJ7SDr+Wr9z4xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0956/1102] usb: xhci: add USB Port Register Set struct
Date: Thu, 17 Sep 2026 16:14:59 +0100
Message-ID: <20260917151604.660872578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 377a91594e008848363641d07f51d2e48f4bdde5 ]

Introduce a new struct for the Host Controller USB Port Register Set to
enhance readability and maintainability.

The Host Controller Operational Registers (struct 'xhci_op_regs') span from
offset 0x0 to 0x3FF and consist of fixed fields. Following these fixed
fields are the Host Controller USB Port Register Sets, which are dynamic
and repeat from 1 to MaxPorts, as defined by HCSPARAMS1.

Currently, the struct 'xhci_op_regs' includes:
 __le32 port_status_base;		The first PORTSC
 __le32 port_power_base;		The first PORTPMSC
 __le32 port_link_base;			The first PORTLI
 __le32 reserved5;			The first PORTHLPMC, not reserved
 __le32 reserved6[NUM_PORT_REGS*254];	Port registers 2 to MaxPorts

Replace this with the simpler:
 struct xhci_port_regs port_regs[];	Port registers 1 to MaxPorts

Host Controller USB Port Register Set:
| Offset	| Mnemonic	| Register Name
--------------------------------------------------------------------------
| 0x0		| PORTSC	| Port Status and Control
| 0x4		| PORTPMSC	| Port Power Management Status and Control
| 0x8		| PORTLI	| Port Link Info
| 0xC		| PORTHLPMC	| Port Hardware LPM Control

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 78203d5b54a4 ("usb: xhci: bail out of setup if the controller is inaccessible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |    3 +--
 drivers/usb/host/xhci.h     |   36 ++++++++++++++++--------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2161,8 +2161,7 @@ static int xhci_setup_port_arrays(struct
 		return -ENOMEM;
 
 	for (i = 0; i < num_ports; i++) {
-		xhci->hw_ports[i].addr = &xhci->op_regs->port_status_base +
-			NUM_PORT_REGS * i;
+		xhci->hw_ports[i].addr = &xhci->op_regs->port_regs[i].portsc;
 		xhci->hw_ports[i].hw_portnum = i;
 
 		init_completion(&xhci->hw_ports[i].rexit_done);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -66,14 +66,25 @@ struct xhci_cap_regs {
 	/* Reserved up to (CAPLENGTH - 0x1C) */
 };
 
-/* Number of registers per port */
-#define	NUM_PORT_REGS	4
-
 #define PORTSC		0
 #define PORTPMSC	1
 #define PORTLI		2
 #define PORTHLPMC	3
 
+/*
+ * struct xhci_port_regs - Host Controller USB Port Register Set. xHCI spec 5.4.8
+ * @portsc:	Port Status and Control
+ * @portpmsc:	Port Power Management Status and Control
+ * @portli:	Port Link Info
+ * @porthlmpc:	Port Hardware LPM Control
+ */
+struct xhci_port_regs {
+	__le32	portsc;
+	__le32	portpmsc;
+	__le32	portli;
+	__le32	porthlmpc;
+};
+
 /**
  * struct xhci_op_regs - xHCI Host Controller Operational Registers.
  * @command:		USBCMD - xHC command register
@@ -85,16 +96,7 @@ struct xhci_cap_regs {
  * @cmd_ring:		CRP - 64-bit Command Ring Pointer
  * @dcbaa_ptr:		DCBAAP - 64-bit Device Context Base Address Array Pointer
  * @config_reg:		CONFIG - Configure Register
- * @port_status_base:	PORTSCn - base address for Port Status and Control
- * 			Each port has a Port Status and Control register,
- * 			followed by a Port Power Management Status and Control
- * 			register, a Port Link Info register, and a reserved
- * 			register.
- * @port_power_base:	PORTPMSCn - base address for
- * 			Port Power Management Status and Control
- * @port_link_base:	PORTLIn - base address for Port Link Info (current
- * 			Link PM state and control) for USB 2.1 and USB 3.0
- * 			devices.
+ * @port_regs:		Port Register Sets, from 1 to MaxPorts (defined by HCSPARAMS1).
  */
 struct xhci_op_regs {
 	__le32	command;
@@ -110,13 +112,7 @@ struct xhci_op_regs {
 	__le32	config_reg;
 	/* rsvd: offset 0x3C-3FF */
 	__le32	reserved4[241];
-	/* port 1 registers, which serve as a base address for other ports */
-	__le32	port_status_base;
-	__le32	port_power_base;
-	__le32	port_link_base;
-	__le32	reserved5;
-	/* registers for ports 2-255 */
-	__le32	reserved6[NUM_PORT_REGS*254];
+	struct xhci_port_regs port_regs[];
 };
 
 /* USBCMD - USB command - command bitmasks */


