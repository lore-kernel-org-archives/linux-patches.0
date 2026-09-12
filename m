Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1935E549;
	Sat, 12 Sep 2026 10:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209525; cv=none; b=qnxqzfmwDC7c0N081TM4MuqskAS804m5ZxHbKZ+5Cm8k1sI5V/U1fjLql48OCfftLQNYHaezkypBxsEUljNx27/8KPFTYp6oC1AcajvXggSfY4LuJ7T5Z6dbtuTe8H3rrwtU9ovcLahZQm8s+NIKEwlSRm3oWiIPmeGA3I5O0lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209525; c=relaxed/simple;
	bh=HhjTiq8W2PX0E4U3JAujW9hNcAR43bbQhBn6Y9Z1gBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvBtscvHLUYAWFcJM2467RB0v8QIIeAGZ5WOVp8WlStNkV7zjy9N+mqIcp9uT8/8ERFUTZYZsRpu2gmIQ4AVt2LQbFuxChS42HfeSE0PQUmkVNwQmAwzWQXnGMf7xjjMRg/dfwN/g/X5vyyToV0PwM9Tg/jyjP4pfGL4LWcCYCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZ7H7wtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZ7H7wtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAAA1F000FF;
	Sat, 12 Sep 2026 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209523;
	bh=6wpHqf/nrezjB/NJ38UNQz+VrFsyD1A4cxjLi58Omrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZ7H7wtdMDJLvB+e+DU/ogt050iGJESgl3ZL+/jpzTGv+u9AKJVtS67450N8yc6RW
	 ukRre6KeDD5FBlgjPt0BYVmNvHcExWsbwazIxqbUCG3Bi7GOLPwj0VH+p5p2QhxAja
	 scEnTA5/Ck/EwhMFjpgO5KfgwE/knBDSVWXEed1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0839/1518] misc: pci_endpoint_test: Check SUCCESS bit for doorbell status
Date: Sat, 12 Sep 2026 08:50:08 +0200
Message-ID: <20260912065642.418753525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 37ddcce6904c20c6a7debe4751f6a82f218c3bae ]

The pci-epf driver sets STATUS_DOORBELL_ENABLE_SUCCESS as the final step of
pci_epf_test_enable_doorbell(), and STATUS_DOORBELL_DISABLE_SUCCESS as the
final step of pci_epf_test_disable_doorbell(). A missing SUCCESS bit
therefore unambiguously means that the operation did not complete, whereas
the FAIL bit is only set on an explicit failure path.

The host side test in pci_endpoint_test_doorbell() currently keys off
the FAIL bit. That covers explicit failures but misses two cases.

The first case is when the wait for the completion IRQ times out. No IRQ
arrives, the Endpoint never updates STATUS, and neither SUCCESS nor FAIL
is set. The enable path already handles this correctly because it also
fails when the wait times out without an IRQ. The disable path does not
have that extra guard and would wrongly treat the timeout as success.

The second is a buggy EPC that raises two IRQs in response to a single
DOORBELL_ENABLE command. The second wait_for_completion_timeout()
returns immediately with 'left' non zero, but the endpoint has not yet
written STATUS, so SUCCESS is clear and FAIL is also clear. The current
FAIL only check treats this as success.

So check the SUCCESS bit instead. That matches the Endpoint's contract
because SUCCESS is the last write on the success path, and it correctly
reports failure for both timeouts and the spurious IRQ case without
relying on the FAIL bit being set.

Fixes: eefb83790a0d ("misc: pci_endpoint_test: Add doorbell test case")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730122045.1382749-5-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 1c0fd185114fc..fdce31f9fa43d 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -859,6 +859,7 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 	struct pci_dev *pdev = test->pdev;
 	struct device *dev = &pdev->dev;
 	int irq_type = test->irq_type;
+	int ret = 0;
 	enum pci_barno bar;
 	u32 data, status;
 	u32 addr;
@@ -900,8 +901,11 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 
 	status = pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_STATUS);
 
-	if (!left || !(status & STATUS_DOORBELL_SUCCESS))
+	if (!left || !(status & STATUS_DOORBELL_SUCCESS)) {
 		dev_err(dev, "Failed to trigger doorbell in endpoint\n");
+		/* Store error code, but continue to disable doorbell. */
+		ret = -EINVAL;
+	}
 
 	pci_endpoint_test_writel(test, PCI_ENDPOINT_TEST_COMMAND,
 				 COMMAND_DISABLE_DOORBELL);
@@ -915,10 +919,7 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 		return -EINVAL;
 	}
 
-	if (!(status & STATUS_DOORBELL_SUCCESS))
-		return -EINVAL;
-
-	return 0;
+	return ret;
 }
 
 static long pci_endpoint_test_ioctl(struct file *file, unsigned int cmd,
-- 
2.53.0



