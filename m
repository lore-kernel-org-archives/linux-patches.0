Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D7A448D18;
	Fri,  7 Aug 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116887; cv=none; b=Iq2IpYz/mpLuKb262lvd+p8p64TKE+8f85lAUKk0r68s91MNGtbFooKZkBLu3hqbqXSMKz11kHOQYzqkYbgqhlvd+myXtpb07IR+kIzDzQeQ0cq8xby6iL4nKUhv8+xoGKtBMBesbJ6bf4k2oshnltUrA00cOfz0Nc+d7oAiUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116887; c=relaxed/simple;
	bh=DMoRPMdlK5LEIyIjvlGr8jkX7TMA3k+/tjkWFEQ9StM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEhiSJsFtWAfFDZmAOA4a70+55i3rTIrVGURi8sydu9mYzCuKBmPdyZHs0lPv5OM4iFyZTW2fhdAryj4Bv+teG/f3Wv5JBi1svpUlAugUvLV+w9zIaX+qiu5NrjFIdztwhKD6scpnZXLAh1unbQEOJZjGzczilMgt4hL2K7SwEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soCC+4yP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soCC+4yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841C31F00A3A;
	Fri,  7 Aug 2026 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116886;
	bh=o5LpfES6EILHIzzsMl8Co9djCJMqIsZZut8Yw+xPRcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soCC+4yP0M7ijTV3PJ56tKPHPMeZ5t6eXXdYo7g+rw71P+zIcklvejAidqLVRnK1g
	 dlpz6L2YL+qhXUq1cZIKE3fDNnB+b+/r3ucxOA8WL7HMDhrtT+QjFh0fPFOgq9/WVr
	 fP7yaega6QvjtGGrWm85fYcyiCQicXUyZfHE37Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 126/438] idpf: Fix mailbox IRQ name leak on request failure
Date: Fri,  7 Aug 2026 16:35:22 +0200
Message-ID: <20260807143430.682054486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf966fe6c759c..bb81e620c5c87 100644
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



