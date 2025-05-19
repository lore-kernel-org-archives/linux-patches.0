Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75408220F30;
	Mon, 19 May 2025 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689704; cv=none; b=Z/iuJgKOTlH4Kmn0qOGFEAlJj/mnxL6UZFKREo1xRdCu64SpzbGJW5Vkx8vB6dEdvRguwRBh3yCFOuEF8dN4JaPClWn4Qs8ARUvy39p9+cRi0NOMCjjuxlYibsQQsbXxtAiqngWntY6WTyZGuhAcvFCzLGSZQHs57lDBEzWZMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689704; c=relaxed/simple;
	bh=8eoPs6kGfUHklSE/0zBqDnlRCHuVPwGUq6nnsbtYVDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GvKKGs71ZyQ3PkT8tP0CRKLq6JUU3faPIIstVuPU9KoMXKl0tiCgEpt7c33fwtkNj0cXa6L7v+A4IZE/QFFxjalM8E1g+CdkD+2sjwRCFA1UzB3Q3S84N8IVFgwdfh7IrfzMu6zcePLd5vPOuORgghsV8mCbF6sEIonWjIRQZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjeR1hnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjeR1hnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035E1C4CEE4;
	Mon, 19 May 2025 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689704;
	bh=8eoPs6kGfUHklSE/0zBqDnlRCHuVPwGUq6nnsbtYVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjeR1hnFebAsewwGL2PEGUKuNNRyhVyFks2g0B0VzYfWgj+h8rWlaD2K1LM1EqCOy
	 fDZchaa9zySwf0r1+HD2pQYK41XEFx/bV0Fm6zh+b4xYVlEXHLiUrTn/72vVrkWg7l
	 bke4+iA0cNqKAnIpvMeEhNipuozfCdyVnpHiraEm6d0yBQOA9biLUnVquwHhIv9lpw
	 WK+S/z7JUR/nQlM80Ixrh7WNOeJ3nQ9AvZhdpbONIEd+wFh/ptsQS1uOd4+I8w/ACR
	 YuMRueaeio7K2CDYYBY5uEwZYGFBb8pK2ISGulfTAZlO10dA4OGGDNke20gtSa1PKN
	 CMKbDZbe8Humg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 08/23] nvmet: pci-epf: cleanup nvmet_pci_epf_raise_irq()
Date: Mon, 19 May 2025 17:21:15 -0400
Message-Id: <20250519212131.1985647-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

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
index bc1daa9aede9d..80d857798bddd 100644
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

