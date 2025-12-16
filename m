Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5532C34B69B;
	Tue, 16 Dec 2025 11:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885272; cv=none; b=gIsptLQoP5BGIP5+/gQwBz0BO2UHrRpviW3kw1yTYLXHUn94xbcNc8BJ9nX31mpD+T8l7cfzT88UgUP2P+0FpnNNP3PjfRNIcMsJxlzlWeb25YOLNejMTtcykyJ/tpFEydSdogyb8/RTr2VLsSKs8pCJPP3ot+dSzld1qC7sS9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885272; c=relaxed/simple;
	bh=4ir7KOqc+TqjEw+zjYwXcGBt3x1SmJSZlA+wqvJ1s8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPzUn8SAIfme1yo+WdxWL9EKIBlM5unQblUWCtwkhPS/4SuUSOb6762dw0Imks1+cuixaUU+UVSLit4M0g9oBxbKsL0pqxhp/silJyDy9Qvna1SZJEt7gPMUg7OuuxRpqNjyKyLSsN2MCCXZZAj+rC4aKZiXwts71AOUJGSHU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Khrxf5e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Khrxf5e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE864C4CEF1;
	Tue, 16 Dec 2025 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885272;
	bh=4ir7KOqc+TqjEw+zjYwXcGBt3x1SmJSZlA+wqvJ1s8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Khrxf5e+2j78+xsaqQeoRb/rgKr6RTnOVRIZfP7Bz6zEXa/GRnUwPPlJJapZrK5lg
	 JExBw58h3R4RlLp3odLJfOxvydiACfXk5ZA6AII/TjiiBb5dy4/jx58nfFfCzNSXkM
	 4FNBmwIXgHFC4Y81gQ1IE+xEAs0PRbPS7VU7dp28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 089/507] PCI: endpoint: pci-epf-test: Fix sleeping function being called from atomic context
Date: Tue, 16 Dec 2025 12:08:50 +0100
Message-ID: <20251216111348.763138680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



