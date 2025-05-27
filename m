Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F7D17B425;
	Tue, 27 May 2025 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366289; cv=none; b=Yvh84xhzXp8XTJ5XVOP2B+UHubYfP9gvKsxnn1LdApPXpzA9erV0kF6LhaZMKopiKfs/JNtGlS9Tnc+ds5E7lkJVvgJtpRogSv6MVpNr8hz4Eh59FFifMH9p83XK1qnYf5bvSA/V0fcRDI7lGE9v36A5q4MMcRCBMsh/3rQWO8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366289; c=relaxed/simple;
	bh=1s4Zoka+gVD5E/fsWLvyn63z+vFVo5bZEU7DMZTQt30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7V/EmPrsaelBYy5ZY5W0rpdRUrJl1Rfx7i99hIk5fUjI6S+D1po/iR7zFATLCqa/i+wdJfurE0maLb9fPZwx+Mkq5kwG+Nns3r2M9eusMnAQTfnRSs++EksMv2qYvyMKh5BhD+QXPnEm78tE1m+9WlEHZ3R4Yd49qrkVMHDieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saDttqGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saDttqGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2097C4CEE9;
	Tue, 27 May 2025 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366289;
	bh=1s4Zoka+gVD5E/fsWLvyn63z+vFVo5bZEU7DMZTQt30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saDttqGbRsAHuOetyqOD0fuyB9Iyjc+emksoVwnvBsRobHuh081a4jBsreOjtliwM
	 tSBO0Ei9iE98/SzQldBDKW9H0wBNP7zWfWN+VfLmqN14FhKrnuuZf+Gf+wQgFjrPqK
	 8fBUUZp9wYx5RAgrSyG8rD/q5qyCgIpvrRLYJwCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 008/783] nvmet: pci-epf: clear completion queue IRQ flag on delete
Date: Tue, 27 May 2025 18:16:45 +0200
Message-ID: <20250527162513.385712508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

[ Upstream commit 85adf2094abb9084770dc4ab302aaa9c5d26dd2d ]

The function nvmet_pci_epf_delete_cq() unconditionally calls
nvmet_pci_epf_remove_irq_vector() even for completion queues that do not
have interrupts enabled. Furthermore, for completion queues that do
have IRQ enabled, deleting and re-creating the completion queue leaves
the flag NVMET_PCI_EPF_Q_IRQ_ENABLED set, even if the completion queue
is being re-created with IRQ disabled.

Fix these issues by calling nvmet_pci_epf_remove_irq_vector() only if
NVMET_PCI_EPF_Q_IRQ_ENABLED is set and make sure to always clear that
flag.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 81957b6e84986..fbc167f47d8a6 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1344,7 +1344,8 @@ static u16 nvmet_pci_epf_delete_cq(struct nvmet_ctrl *tctrl, u16 cqid)
 
 	cancel_delayed_work_sync(&cq->work);
 	nvmet_pci_epf_drain_queue(cq);
-	nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);
+	if (test_and_clear_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
+		nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);
 	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &cq->pci_map);
 
 	return NVME_SC_SUCCESS;
-- 
2.39.5



