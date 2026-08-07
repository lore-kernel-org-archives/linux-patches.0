Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF7342DA3F;
	Fri,  7 Aug 2026 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114946; cv=none; b=ix5Te6IrBOXWOIwLDJ3oJCsT5n/WctWygmHiOOMYTbET68lX0rDiL2MjrVQbUYk+grvKTCAcbKb+N9Qfjj5qpz+h1ARuO5HQgunScTNLmZ/Z2Hj8/CTx0oLSkvFv2/MDknfBH8+dHigshcznLsazuSE5X2WsxY9pEIAvC9IGnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114946; c=relaxed/simple;
	bh=Y1s6pivy4pM/6DTvgHsZGUYoFkzqOzeo8l6hnL1OqeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skPcKdSHdPWe8ATZxi+3xeVTq1y16a4HrXhX8NFerINkrW+l7CSHTtqB6bkaFe6FosdDaoBWLyvDUeYvHOnS2iRwqV1ol9hld02lHDQJmEoeW9R8QxBuRrk8lUXFiF20iEXWghoCTycEUnhZY9G5fEtQspq1WeVU+8Sr8qnCE4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yz2UXFTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yz2UXFTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C461F000E9;
	Fri,  7 Aug 2026 15:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114945;
	bh=hybxOFNlX+HkJlkQ0cFL4A0TAj0oo8pE9WA1Lkm8l3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yz2UXFTtpddf27mY2uOZPzHBtzIj9wCQnF2edpmtvEDNZchoBKOrfEqC6xXycNa4v
	 NUCuJmLYoU1Yb63Z0KvPt5ATQn3XVte5nVFYPBOLOmd0o/BeNYqSFmtb1Lk3p4M9FJ
	 YvfNKVORm+oiL/qpDGqw9/IxfOntBSRBP39nECKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/396] idpf: Fix mailbox IRQ name leak on request failure
Date: Fri,  7 Aug 2026 16:34:24 +0200
Message-ID: <20260807143426.536243475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 9bff30482c10f70d9e56c0633a6616e07140e217 ]

idpf_mb_intr_req_irq() allocates the mailbox IRQ name before calling
request_irq(). On success, the name is released later through
kfree(free_irq()), but request_irq() failure returns without freeing it.

Free the allocated name on the request_irq() failure path.

Fixes: 4930fbf419a7 ("idpf: add core init and interrupt request")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 131a8121839bd..590119f4097d0 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -139,7 +139,7 @@ static int idpf_mb_intr_req_irq(struct idpf_adapter *adapter)
 	if (err) {
 		dev_err(&adapter->pdev->dev,
 			"IRQ request for mailbox failed, error: %d\n", err);
-
+		kfree(name);
 		return err;
 	}
 
-- 
2.53.0



