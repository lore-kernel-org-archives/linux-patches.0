Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E1133C530;
	Fri,  9 Jan 2026 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960885; cv=none; b=RSZkOoJiz+XbUcEz5E1xQsJCj9sk/F/KEFF27h2iw0X00WGFEWGWd1MarYf84GyI75yT7B3KhUCNlDqauipIty2DJDcWbHJCRhTBtQcs0f4NoJM8LB04+6wKFdZHGZggaVDFDjf6zq7/Q9s1EtQ4MezOAnOjWbautAXV0GQ7pm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960885; c=relaxed/simple;
	bh=DFqH3SKrkLCdqVcsQqt0RQTzcg3r21IQiiWn+WVAGZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9pqoIzMVE5/uFqWJWCRDqDQ+hB7LundDmIZJHpchRRzu7i6PgptTcgHDQWjv9I3pVwjmZsc9WvWx7ZQ9olMflMC/40Z9CvLmvWka6B6oFHR4rmn08Ein+Y4KeUtq7H3eKhYol2SycXpHSa6Gx7Jp54l3W82DS7ptd6tuypaxmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eivqLPim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eivqLPim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535F4C4CEF1;
	Fri,  9 Jan 2026 12:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960885;
	bh=DFqH3SKrkLCdqVcsQqt0RQTzcg3r21IQiiWn+WVAGZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eivqLPim+BpxepNpbwMukFCXB6NMV5JBv/7PxHX/CM/aRQfDONiMHy5bLiNNjFNfk
	 pNcubj9JdT/0kGOVtyuKLdks7WFRf0oru/pqRxMCKhkmlO4zLz92pXU53hSCE2rOwD
	 dWvFZ6fTpR7ntWKE9c8KNk9eq3kOQK9BdY3lcB7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 532/737] RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()
Date: Fri,  9 Jan 2026 12:41:11 +0100
Message-ID: <20260109112154.009252351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 145a417a39d7efbc881f52e829817376972b278c ]

RCFW_COMM_CONS_PCI_BAR_REGION is defined as BAR 2, so checking
!creq_db->reg.bar_id is incorrect and always false.

pci_resource_start() returns the BAR base address, and a value of 0
indicates that the BAR is unassigned. Update the condition to test
bar_base == 0 instead.

This ensures the driver detects and logs an error for an unassigned
RCFW communication BAR.

Fixes: cee0c7bba486 ("RDMA/bnxt_re: Refactor command queue management code")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251217100158.752504-1-alok.a.tiwari@oracle.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index e82bd37158ad..2accda5a04a1 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -1116,7 +1116,7 @@ static int bnxt_qplib_map_creq_db(struct bnxt_qplib_rcfw *rcfw, u32 reg_offt)
 	creq_db->dbinfo.flags = 0;
 	creq_db->reg.bar_id = RCFW_COMM_CONS_PCI_BAR_REGION;
 	creq_db->reg.bar_base = pci_resource_start(pdev, creq_db->reg.bar_id);
-	if (!creq_db->reg.bar_id)
+	if (!creq_db->reg.bar_base)
 		dev_err(&pdev->dev,
 			"QPLIB: CREQ BAR region %d resc start is 0!",
 			creq_db->reg.bar_id);
-- 
2.51.0



