Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7D1F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D57C433C7;
	Fri, 21 Jul 2023 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956660;
	bh=Gfzn7EPGSr7OH8BVhIL4eGj63Ac+FdYDNqa5kmBZ0L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJ7fzcofX2vVO1Qfq7TmwDoQ6KWwmoK6i5R4/oj2IdOiPPcQDpZEgAypQJrjHFnRz
	 8GMIaRfcQHwlJgPiiihPtI9YNP9Rojan0Z17gHylsIMZT/VS3+tpgDknlBlsHkwVuS
	 igMs4YZwMvfplJU387xcUDUk/D3ajgfao6usWABA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Subject: [PATCH 6.4 228/292] xhci: Show ZHAOXIN xHCI root hub speed correctly
Date: Fri, 21 Jul 2023 18:05:37 +0200
Message-ID: <20230721160538.659186802@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

commit d9b0328d0b8b8298dfdc97cd8e0e2371d4bcc97b upstream.

Some ZHAOXIN xHCI controllers follow usb3.1 spec, but only support
gen1 speed 5Gbps. While in Linux kernel, if xHCI suspport usb3.1,
root hub speed will show on 10Gbps.
To fix this issue of ZHAOXIN xHCI platforms, read usb speed ID
supported by xHCI to determine root hub speed. And add a quirk
XHCI_ZHAOXIN_HOST for this issue.

[fix warning about uninitialized symbol -Mathias]

Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <20230602144009.1225632-11-mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |   31 ++++++++++++++++++++++++-------
 drivers/usb/host/xhci-pci.c |    2 ++
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 27 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1968,7 +1968,7 @@ static void xhci_add_in_port(struct xhci
 {
 	u32 temp, port_offset, port_count;
 	int i;
-	u8 major_revision, minor_revision;
+	u8 major_revision, minor_revision, tmp_minor_revision;
 	struct xhci_hub *rhub;
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	struct xhci_port_cap *port_cap;
@@ -1988,6 +1988,15 @@ static void xhci_add_in_port(struct xhci
 		 */
 		if (minor_revision > 0x00 && minor_revision < 0x10)
 			minor_revision <<= 4;
+		/*
+		 * Some zhaoxin's xHCI controller that follow usb3.1 spec
+		 * but only support Gen1.
+		 */
+		if (xhci->quirks & XHCI_ZHAOXIN_HOST) {
+			tmp_minor_revision = minor_revision;
+			minor_revision = 0;
+		}
+
 	} else if (major_revision <= 0x02) {
 		rhub = &xhci->usb2_rhub;
 	} else {
@@ -1996,10 +2005,6 @@ static void xhci_add_in_port(struct xhci
 		/* Ignoring port protocol we can't understand. FIXME */
 		return;
 	}
-	rhub->maj_rev = XHCI_EXT_PORT_MAJOR(temp);
-
-	if (rhub->min_rev < minor_revision)
-		rhub->min_rev = minor_revision;
 
 	/* Port offset and count in the third dword, see section 7.2 */
 	temp = readl(addr + 2);
@@ -2017,8 +2022,6 @@ static void xhci_add_in_port(struct xhci
 	if (xhci->num_port_caps > max_caps)
 		return;
 
-	port_cap->maj_rev = major_revision;
-	port_cap->min_rev = minor_revision;
 	port_cap->psi_count = XHCI_EXT_PORT_PSIC(temp);
 
 	if (port_cap->psi_count) {
@@ -2039,6 +2042,11 @@ static void xhci_add_in_port(struct xhci
 				  XHCI_EXT_PORT_PSIV(port_cap->psi[i - 1])))
 				port_cap->psi_uid_count++;
 
+			if (xhci->quirks & XHCI_ZHAOXIN_HOST &&
+			    major_revision == 0x03 &&
+			    XHCI_EXT_PORT_PSIV(port_cap->psi[i]) >= 5)
+				minor_revision = tmp_minor_revision;
+
 			xhci_dbg(xhci, "PSIV:%d PSIE:%d PLT:%d PFD:%d LP:%d PSIM:%d\n",
 				  XHCI_EXT_PORT_PSIV(port_cap->psi[i]),
 				  XHCI_EXT_PORT_PSIE(port_cap->psi[i]),
@@ -2048,6 +2056,15 @@ static void xhci_add_in_port(struct xhci
 				  XHCI_EXT_PORT_PSIM(port_cap->psi[i]));
 		}
 	}
+
+	rhub->maj_rev = major_revision;
+
+	if (rhub->min_rev < minor_revision)
+		rhub->min_rev = minor_revision;
+
+	port_cap->maj_rev = major_revision;
+	port_cap->min_rev = minor_revision;
+
 	/* cache usb2 port capabilities */
 	if (major_revision < 0x03 && xhci->num_ext_caps < max_caps)
 		xhci->ext_caps[xhci->num_ext_caps++] = temp;
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -529,6 +529,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ZHAOXIN) {
+		xhci->quirks |= XHCI_ZHAOXIN_HOST;
+
 		if (pdev->device == 0x9202) {
 			xhci->quirks |= XHCI_RESET_ON_RESUME;
 			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1906,6 +1906,7 @@ struct xhci_hcd {
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 #define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
+#define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


