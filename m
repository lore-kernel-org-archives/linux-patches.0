Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01A73659E4;
	Tue, 16 Dec 2025 12:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887031; cv=none; b=bcwK7Dw3a5LoF/xHf4p2Iyvg7U8FTSMU55dvEQ4McTrWJBNxn3SzuuOU1Xi/aobviwhxONaMIW7wGB1N0rAehTEcvCVGBBM93H9la3uH8I3mjRnLkCsj0GILOW5Hyj4ERvRfWG+kUEaL6Ob00j3RHNX0OVKvjvVZsFUNjn2Im1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887031; c=relaxed/simple;
	bh=yaoPFBE+uP0yjnUDdOU2tHOkXFes4T9R8WWgtTQT4Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjG1zitMylv3Hh6U+YbYL103n+PvOmcHw4D25UolrMSLa0k2yb58Sj5b3f3K4sd7BpeIp6puKJYBf5YuXpSVfvFuYSu/plasmzr3jn7WYEEC37r7b5PuRB8uMBecjePSQ8pRy73Fge8knGuhhkcS9jpDZa0MOL4pxmtGovfXoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stv5gKt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stv5gKt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF99C4CEF5;
	Tue, 16 Dec 2025 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887031;
	bh=yaoPFBE+uP0yjnUDdOU2tHOkXFes4T9R8WWgtTQT4Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stv5gKt/6NSZA6JJ1vS30b2ZoIgl+KyjWTCTheN+SCZ6AZAm5WDZOD6qHwDkKBRlS
	 OqcG74NQYjuqeUW0wrZkTZPT9hR6VKshU84mpOd0fqtSBb70CkaHLZ70/00RaoslMP
	 SRQo1Iq1w+mXHBGW28ygI18GSX163C1xbjIGwZ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/614] PCI: endpoint: pci-epf-test: Fix sleeping function being called from atomic context
Date: Tue, 16 Dec 2025 12:07:54 +0100
Message-ID: <20251216111405.213657242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>

[ Upstream commit 25423cda145f9ed6ee4a72d9f2603ac2a4685e74 ]

When Root Complex (RC) triggers a Doorbell interrupt to Endpoint (EP), it
triggers the below warning in the EP:

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:271
 Call trace:
  __might_resched+0x130/0x158
  __might_sleep+0x70/0x88
  mutex_lock+0x2c/0x80
  pci_epc_get_msi+0x78/0xd8
  pci_epf_test_raise_irq.isra.0+0x74/0x138
  pci_epf_test_doorbell_handler+0x34/0x50

The BUG arises because the EP's pci_epf_test_doorbell_handler() which is
running in the hard IRQ context is making an indirect call to
pci_epc_get_msi(), which uses mutex inside.

To fix the issue, convert the hard IRQ handler to a threaded IRQ handler to
allow it to call functions that can sleep during bottom half execution.
Also, register the threaded IRQ handler with IRQF_ONESHOT to keep the
interrupt line disabled until the threaded IRQ handler completes execution.

Fixes: eff0c286aa91 ("PCI: endpoint: pci-epf-test: Add doorbell test support")
Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
[mani: reworded description a bit]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251014024109.42287-1-bhanuseshukumar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 31617772ad516..b05e8db575c35 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -730,8 +730,9 @@ static void pci_epf_test_enable_doorbell(struct pci_epf_test *epf_test,
 	if (bar < BAR_0)
 		goto err_doorbell_cleanup;
 
-	ret = request_irq(epf->db_msg[0].virq, pci_epf_test_doorbell_handler, 0,
-			  "pci-ep-test-doorbell", epf_test);
+	ret = request_threaded_irq(epf->db_msg[0].virq, NULL,
+				   pci_epf_test_doorbell_handler, IRQF_ONESHOT,
+				   "pci-ep-test-doorbell", epf_test);
 	if (ret) {
 		dev_err(&epf->dev,
 			"Failed to request doorbell IRQ: %d\n",
-- 
2.51.0



