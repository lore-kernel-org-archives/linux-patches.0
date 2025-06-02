Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47761DE881;
	Mon,  2 Jun 2025 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872745; cv=none; b=NDfgBUUB8BItcNjllR04HnnldIx1+HTe2xh5aQvM+IY1gKM9DNcpEolnESKkj+CXZWpYxYGALUy3fBqjqNd8TosUfjwTjd1Fhg5fUPaBD4Igjh5reVQSFFZwdVA41hlixSo9fd1wLkRx1eq8MjiIH2L1vUkkqd3mGG/2h6s1cqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872745; c=relaxed/simple;
	bh=pcrUTpmtHO1yEzfLra4bvEZeNeUo4NXj7eKLJzx8kVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fedSagiCWqnL3zJFmIrmo0/AekHcDOXYF3cg8z/nEeHtofOAZGh192xD9oLcdS5WGQqeAtZUJ5uHlJiMbNB6aAVvjHlRgBVSKQzWWvYpBQPL9+qHGlEiGrW5xzOLJKlv0K8x52xYawKrcEI9h5iGLmhC9e75Cg3T9G8kIZ0kDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xr7iw01I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xr7iw01I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23582C4CEEB;
	Mon,  2 Jun 2025 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872745;
	bh=pcrUTpmtHO1yEzfLra4bvEZeNeUo4NXj7eKLJzx8kVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xr7iw01IQS5PyRc0l/Y+RPAkxyYLySEpG7K6K2gstOprMyBjRHrYu505EL0MQKySE
	 l23FRjXLVvHs4bYbqIzpOpOWkUvIHsFNboTBCzZ/YrrRWRHDYOFuAVDqVehYkNyIzo
	 TUHgM7dx7dnjNhvkIWTcNFzzk2zNkW6JpNIZR1V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 55/73] nvmet: pci-epf: cleanup nvmet_pci_epf_raise_irq()
Date: Mon,  2 Jun 2025 15:47:41 +0200
Message-ID: <20250602134243.862899182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 4236e600bf902202214aa6277e84c4738c56f762 ]

There is no point in taking the controller irq_lock and calling
nvmet_pci_epf_should_raise_irq() for a completion queue which does not
have IRQ enabled (NVMET_PCI_EPF_Q_IRQ_ENABLED flag is not set).
Move the test for the NVMET_PCI_EPF_Q_IRQ_ENABLED flag out of
nvmet_pci_epf_should_raise_irq() to the top of nvmet_pci_epf_raise_irq()
to return early when no IRQ should be raised.

Also, use dev_err_ratelimited() to avoid a message storm under load when
raising IRQs is failing.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index fbc167f47d8a6..17c0e5ee731a4 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -596,9 +596,6 @@ static bool nvmet_pci_epf_should_raise_irq(struct nvmet_pci_epf_ctrl *ctrl,
 	struct nvmet_pci_epf_irq_vector *iv = cq->iv;
 	bool ret;
 
-	if (!test_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
-		return false;
-
 	/* IRQ coalescing for the admin queue is not allowed. */
 	if (!cq->qid)
 		return true;
@@ -625,7 +622,8 @@ static void nvmet_pci_epf_raise_irq(struct nvmet_pci_epf_ctrl *ctrl,
 	struct pci_epf *epf = nvme_epf->epf;
 	int ret = 0;
 
-	if (!test_bit(NVMET_PCI_EPF_Q_LIVE, &cq->flags))
+	if (!test_bit(NVMET_PCI_EPF_Q_LIVE, &cq->flags) ||
+	    !test_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
 		return;
 
 	mutex_lock(&ctrl->irq_lock);
@@ -656,7 +654,9 @@ static void nvmet_pci_epf_raise_irq(struct nvmet_pci_epf_ctrl *ctrl,
 	}
 
 	if (ret)
-		dev_err(ctrl->dev, "Failed to raise IRQ (err=%d)\n", ret);
+		dev_err_ratelimited(ctrl->dev,
+				    "CQ[%u]: Failed to raise IRQ (err=%d)\n",
+				    cq->qid, ret);
 
 unlock:
 	mutex_unlock(&ctrl->irq_lock);
-- 
2.39.5



