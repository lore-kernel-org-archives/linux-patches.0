Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8843146A61C;
	Tue, 21 Jul 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657850; cv=none; b=QCdBKsaidddUMeU1jpDFJkB2ALMLtO3AleeCPyfepXLtVOezbDooc+BxuU/57fRvSISN6PqhseOIl7GytOncO1ltKr5dFnGab929iDLk3L30hPWN5iyfopuCXqUkLUmhzl7pXGhAAX/JRUlck62dNz5uZobde08AKopfUNbwHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657850; c=relaxed/simple;
	bh=Ei1ubza/W4k4W7RTMCelmA/dl1IE8MZxYFpf95gKeKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAqQ4fK296Y4Hk2tmS4AVSmv23USj+ObN6OAdx7pKd46oXuUbXjpoeuLSwHN3Q+AAzdOZvJu75yBnwcqrv7OCRFvfROAl6MGXzfFtAXZNIjIfQ9vi9zQNAjh6SZLzTksC3/KPV/5+rPhrA/XYl57IMMPQY4JLKzsZS9MzYXsflE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKlvDI+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKlvDI+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7B41F000E9;
	Tue, 21 Jul 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657849;
	bh=7dC1gOI+HIkYMoCO5WsetU7p2XWLH64V4M2/iq+1T0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKlvDI+siGXiH4qC+ciTSriGnGMeT7d4DumS981oLtq8AiCz9zyLamZAV4S67kysq
	 rIxmjJlUA5vraERBdQfDEOFNVZDVl1P5vyAiwYyM20d+2AC0uAJBQy2zorGoXm7uIw
	 apt/D97HkMvNCXkd2bdKq41/lEJm6nuHn5ID+LqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0884/1611] PCI: endpoint: pci-epf-ntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:16:40 +0200
Message-ID: <20260721152535.273407931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit d1db6d7c2485ee475a04d8354fbb5b26ea10d978 ]

epf_ntb->db_count value should be within 1 to MAX_DB_COUNT. Current code
only checks for the upper bound, while the lower bound is unchecked. This
can cause a lot of issues in the driver if the user passes 'db_count' as 0.

Add a check for 0 also. While at it, remove the redundant 'db_count'
variable from epf_ntb_configure_interrupt().

Fixes: 8b821cf76150 ("PCI: endpoint: Add EP function driver to provide NTB functionality")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260407124421.282766-3-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-ntb.c | 21 ++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-ntb.c b/drivers/pci/endpoint/functions/pci-epf-ntb.c
index 7702ebb81d9964..d12cf226f32825 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -559,12 +559,15 @@ static int epf_ntb_configure_db(struct epf_ntb *ntb,
 	struct pci_epc *epc;
 	int ret;
 
-	if (db_count > MAX_DB_COUNT)
-		return -EINVAL;
-
 	ntb_epc = ntb->epc[type];
 	epc = ntb_epc->epc;
 
+	if (!db_count || db_count > MAX_DB_COUNT) {
+		dev_err(&epc->dev, "DB count %d out of range (1 - %d)\n",
+			db_count, MAX_DB_COUNT);
+		return -EINVAL;
+	}
+
 	if (msix)
 		ret = epf_ntb_configure_msix(ntb, type, db_count);
 	else
@@ -1278,7 +1281,6 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	u8 func_no, vfunc_no;
 	struct pci_epc *epc;
 	struct device *dev;
-	u32 db_count;
 	int ret;
 
 	ntb_epc = ntb->epc[type];
@@ -1296,17 +1298,16 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	func_no = ntb_epc->func_no;
 	vfunc_no = ntb_epc->vfunc_no;
 
-	db_count = ntb->db_count;
-	if (db_count > MAX_DB_COUNT) {
-		dev_err(dev, "DB count cannot be more than %d\n", MAX_DB_COUNT);
+	if (!ntb->db_count || ntb->db_count > MAX_DB_COUNT) {
+		dev_err(dev, "DB count %d out of range (1 - %d)\n",
+			ntb->db_count, MAX_DB_COUNT);
 		return -EINVAL;
 	}
 
-	ntb->db_count = db_count;
 	epc = ntb_epc->epc;
 
 	if (msi_capable) {
-		ret = pci_epc_set_msi(epc, func_no, vfunc_no, db_count);
+		ret = pci_epc_set_msi(epc, func_no, vfunc_no, ntb->db_count);
 		if (ret) {
 			dev_err(dev, "%s intf: MSI configuration failed\n",
 				pci_epc_interface_string(type));
@@ -1315,7 +1316,7 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	}
 
 	if (msix_capable) {
-		ret = pci_epc_set_msix(epc, func_no, vfunc_no, db_count,
+		ret = pci_epc_set_msix(epc, func_no, vfunc_no, ntb->db_count,
 				       ntb_epc->msix_bar,
 				       ntb_epc->msix_table_offset);
 		if (ret) {
-- 
2.53.0



