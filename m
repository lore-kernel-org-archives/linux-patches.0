Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D26B51C58;
	Mon, 11 Dec 2023 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VftowU5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47AEC433C7;
	Mon, 11 Dec 2023 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319731;
	bh=ttRHmP5MVxuDiO/gw5IvjRdgw36gufPePo0bxvVNRbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VftowU5K6RxAi+rulpltCY9i/7HKTm0ss239kAAR0mpanQQDTycGyk4georzqANpK
	 ncwlxzYMIeLsv25CVTvqiuaVw+MviM+PW8bJNZy9Jm52G7u9zZTJzyQX5m76Rzco3T
	 d5r1z/qGfJgBigPslVpr82OliDJO3HBlVuIQK95M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 6.6 214/244] parport: Add support for Brainboxes IX/UC/PX parallel cards
Date: Mon, 11 Dec 2023 19:21:47 +0100
Message-ID: <20231211182055.559742982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Cameron Williams <cang1@live.co.uk>

commit 1a031f6edc460e9562098bdedc3918da07c30a6e upstream.

Adds support for Intashield IX-500/IX-550, UC-146/UC-157, PX-146/PX-157,
PX-203 and PX-475 (LPT port)

Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/AS4PR02MB790389C130410BD864C8DCC9C4A6A@AS4PR02MB7903.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/parport_pc.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2658,6 +2658,8 @@ enum parport_pc_pci_cards {
 	asix_ax99100,
 	quatech_sppxp100,
 	wch_ch382l,
+	brainboxes_uc146,
+	brainboxes_px203,
 };
 
 
@@ -2737,6 +2739,8 @@ static struct parport_pc_pci {
 	/* asix_ax99100 */		{ 1, { { 0, 1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 	/* wch_ch382l */		{ 1, { { 2, -1 }, } },
+	/* brainboxes_uc146 */	{ 1, { { 3, -1 }, } },
+	/* brainboxes_px203 */	{ 1, { { 0, -1 }, } },
 };
 
 static const struct pci_device_id parport_pc_pci_tbl[] = {
@@ -2833,6 +2837,23 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
 	/* WCH CH382L PCI-E single parallel port card */
 	{ 0x1c00, 0x3050, 0x1c00, 0x3050, 0, 0, wch_ch382l },
+	/* Brainboxes IX-500/550 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x402a,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
+	/* Brainboxes UC-146/UC-157 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0be1,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc146 },
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0be2,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc146 },
+	/* Brainboxes PX-146/PX-257 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x401c,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
+	/* Brainboxes PX-203 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x4007,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_px203 },
+	/* Brainboxes PX-475 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x401f,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, parport_pc_pci_tbl);


