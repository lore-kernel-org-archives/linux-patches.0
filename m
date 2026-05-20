Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C416B371056;
	Wed, 20 May 2026 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294950; cv=none; b=R2IVWZCDs1G2qnTdCI+TEL/f/H+W7ONJmPFulrWQKcxDrI/HZNrPVBU2RmxkFc5UlZGHOVS1ep81nx9B12gu+mYql6JVh1nPce0IOI4maJeuOsucBrst+rQOrgN8vpAh+4OQ9LWGCdzdvXeYfbfjcgXg2/G+HRM5XxEHaGHHGh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294950; c=relaxed/simple;
	bh=bWDcgmYb9qD6eZ/5aSCmUIqQT0inRaXQ1KWaUuU4lO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9Mh0xEjhpXf9TeR2H2Wpaw/oQAE6/heJ+6Xe82Z2kSsYLxSid727rUK07evVNy8b1c90FGtO7uYyEN2WC6Y/i2zngYtElPn9xbWZ+8Bbbufi0CDMar+6d690CH/r2iACcK6ha0TNsj0UfDCx3dyQDe/gxQwIJeiQmzccF9gjGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKg33129; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKg33129"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739221F000E9;
	Wed, 20 May 2026 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294948;
	bh=bZ0RwZY4RJ+IjcKBnWPCcuThh1hwkhbhYJjA/4PSrOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKg33129jwWGZvPKLJtsIheQCX/KnJHYul2SsuFfjuP6Xq3QMc0CuBuG2E2citkTf
	 jkVT2h+EEL1qtBVmsQ4jPrN2Ju6LmEMNi4+CU/hh7mIhVJ9GJPB1w6uiE0qSWoiUlg
	 QZbJ0wdPPetv1ZS1oEg4avVJ0F4uoEN3x9LMzmOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0233/1146] PCI: endpoint: pci-epf-vntb: Fix MSI doorbell IRQ unwind
Date: Wed, 20 May 2026 18:08:03 +0200
Message-ID: <20260520162153.522307420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit cc04f2bfb9dae60b6e34d6bff75c26d4ec3237ce ]

epf_ntb_db_bar_init_msi_doorbell() requests ntb->db_count doorbell IRQs
and then performs additional MSI doorbell setup that may still fail.
The error path unwinds the requested IRQs, but it uses a loop variable
that is reused later in the function. When a later step fails, the
unwind can run with an unexpected index value and leave some IRQs
requested.

Track the number of successfully requested IRQs separately and use that
counter for the unwind so all previously requested IRQs are freed on
failure.

Fixes: dc693d606644 ("PCI: endpoint: pci-epf-vntb: Add MSI doorbell support")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260217063856.3759713-2-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 65f5bbf28480d..c9c7b50587dd2 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -527,20 +527,20 @@ static int epf_ntb_db_bar_init_msi_doorbell(struct epf_ntb *ntb,
 	struct msi_msg *msg;
 	size_t sz;
 	int ret;
-	int i;
+	int i, req;
 
 	ret = pci_epf_alloc_doorbell(epf,  ntb->db_count);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ntb->db_count; i++) {
-		ret = request_irq(epf->db_msg[i].virq, epf_ntb_doorbell_handler,
+	for (req = 0; req < ntb->db_count; req++) {
+		ret = request_irq(epf->db_msg[req].virq, epf_ntb_doorbell_handler,
 				  0, "pci_epf_vntb_db", ntb);
 
 		if (ret) {
 			dev_err(&epf->dev,
 				"Failed to request doorbell IRQ: %d\n",
-				epf->db_msg[i].virq);
+				epf->db_msg[req].virq);
 			goto err_free_irq;
 		}
 	}
@@ -598,8 +598,8 @@ static int epf_ntb_db_bar_init_msi_doorbell(struct epf_ntb *ntb,
 	return 0;
 
 err_free_irq:
-	for (i--; i >= 0; i--)
-		free_irq(epf->db_msg[i].virq, ntb);
+	for (req--; req >= 0; req--)
+		free_irq(epf->db_msg[req].virq, ntb);
 
 	pci_epf_free_doorbell(ntb->epf);
 	return ret;
-- 
2.53.0



