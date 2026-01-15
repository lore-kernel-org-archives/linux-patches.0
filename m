Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9E93C1997;
	Thu, 15 Jan 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499628; cv=none; b=qjpoREykPREeBjJTyNKMw5C66KAuN4JNS8cPIYzL8fqXMYEuyzxJzllYxB5EGPtJrR9wZCshyBjE3Vs8UC/tYTDFw5grJ4zL5FU5J6HQiTwHesvFWJ75aT2mQymkS7JpSFR0oyDM2gQUOrOZg/AAyqqjhLPT6Ynmz/bD71ucla8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499628; c=relaxed/simple;
	bh=ZrhaFcwwBhm0WAwnuk89n/UioktsgBA0QfxqEGID1NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFnlsb5o9RDUyZ4V24JEpeL5RcKvSMBlEI6u33H2B79R6RQO5r1lBNt2xDzgSW8mU72uRIs+llAtc7YoiHVmdFzCXv9Dhkh9INkRy45kN40hg9v4s4Xhi+Yvkxgfb4azRHdOkv8ic0AnW4BTPhEtcp4QhmJ8S5HO/CcTKrAJvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaFYOswy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaFYOswy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD10C116D0;
	Thu, 15 Jan 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499627;
	bh=ZrhaFcwwBhm0WAwnuk89n/UioktsgBA0QfxqEGID1NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaFYOswyNwu47dLuA6lTf+O4mIWhDza365D75CMmRBDWuL7l0jHyjpaLqjiFlL/g6
	 G0zp9KZWVsr3IJYAYNwOLlrScKabkzxwCUPPm2JBBy2EdgMyPJp7S5e1jWJDbVeVSk
	 pbdspUdtA4/oQJB5yY5sv73pRpCHs5Pfb9o7mXtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/451] RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()
Date: Thu, 15 Jan 2026 17:48:14 +0100
Message-ID: <20260115164241.490177442@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d61a1563f48..f9b56744d674 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -775,7 +775,7 @@ static int bnxt_qplib_map_creq_db(struct bnxt_qplib_rcfw *rcfw, u32 reg_offt)
 
 	creq_db->reg.bar_id = RCFW_COMM_CONS_PCI_BAR_REGION;
 	creq_db->reg.bar_base = pci_resource_start(pdev, creq_db->reg.bar_id);
-	if (!creq_db->reg.bar_id)
+	if (!creq_db->reg.bar_base)
 		dev_err(&pdev->dev,
 			"QPLIB: CREQ BAR region %d resc start is 0!",
 			creq_db->reg.bar_id);
-- 
2.51.0



