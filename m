Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F3422A81D;
	Tue, 29 Apr 2025 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946589; cv=none; b=RwUk9r56+33Ouw47escYm1QddAUVQk699WcUzZ0RQrqbDpZb/AmW1qQl+PCFxJfWDhU+HW/kQ6poTH2uJV4yoVzVOrcfvrUjwC8Z46hSP54evX0kAT0tMb7im0Ybz8ZOR9RPGqYUgak9vm9pLV9XTsG19dfSz9ILH2C89427QJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946589; c=relaxed/simple;
	bh=sBuDtDvAN7iEFAzc3KaObJKEtYtjbMLmq/B3C0hKasY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIgEvGJbOY1dVzg4P4Hc2qLoQovzIFoW9Yv/geHLvl0p+2Uh8rKk9khU0Jn1G4uWbLm4hopBl3678MSwvBP7iP2c39214r97TvzQU0ycGK/k4WgzMIRqh9kAf0KiDdtx5avWSMIR1919mE92JbN/TjB15WzasXz7vnUtybch5ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOGvPwzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOGvPwzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B436DC4CEE3;
	Tue, 29 Apr 2025 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946589;
	bh=sBuDtDvAN7iEFAzc3KaObJKEtYtjbMLmq/B3C0hKasY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOGvPwzXM290alcfrjUdUNwAZbPhxXaucOHv7ol7Cgta1vo6cjm4QnsiE2p+isehx
	 m6W+mZrBVr8EVbZ1tR+Ad/4X1qkpCeZtARXSTJUT0Cj2RjmlNlRfUc38ZUO4N5ODla
	 sxgIHTOhPn+FkfwGhfC1SyYz06jJAk8UC6xavnUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 287/311] nvmet: pci-epf: cleanup link state management
Date: Tue, 29 Apr 2025 18:42:04 +0200
Message-ID: <20250429161132.761928673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

[ Upstream commit ad91308d3bdeb9d90ef4a400f379ce461f0fb6a7 ]

Since the link_up boolean field of struct nvmet_pci_epf_ctrl is always
set to true when nvmet_pci_epf_start_ctrl() is called, assign true to
this field in nvmet_pci_epf_start_ctrl(). Conversely, since this field
is set to false when nvmet_pci_epf_stop_ctrl() is called, set this field
to false directly inside that function.

While at it, also add information messages to notify the user of the PCI
link state changes to help troubleshoot any link stability issues
without needing to enable debug messages.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 5c4c4c1f535d4..bc1daa9aede9d 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2109,11 +2109,18 @@ static int nvmet_pci_epf_create_ctrl(struct nvmet_pci_epf *nvme_epf,
 
 static void nvmet_pci_epf_start_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 {
+
+	dev_info(ctrl->dev, "PCI link up\n");
+	ctrl->link_up = true;
+
 	schedule_delayed_work(&ctrl->poll_cc, NVMET_PCI_EPF_CC_POLL_INTERVAL);
 }
 
 static void nvmet_pci_epf_stop_ctrl(struct nvmet_pci_epf_ctrl *ctrl)
 {
+	dev_info(ctrl->dev, "PCI link down\n");
+	ctrl->link_up = false;
+
 	cancel_delayed_work_sync(&ctrl->poll_cc);
 
 	nvmet_pci_epf_disable_ctrl(ctrl, false);
@@ -2340,10 +2347,8 @@ static int nvmet_pci_epf_epc_init(struct pci_epf *epf)
 	if (ret)
 		goto out_clear_bar;
 
-	if (!epc_features->linkup_notifier) {
-		ctrl->link_up = true;
+	if (!epc_features->linkup_notifier)
 		nvmet_pci_epf_start_ctrl(&nvme_epf->ctrl);
-	}
 
 	return 0;
 
@@ -2359,7 +2364,6 @@ static void nvmet_pci_epf_epc_deinit(struct pci_epf *epf)
 	struct nvmet_pci_epf *nvme_epf = epf_get_drvdata(epf);
 	struct nvmet_pci_epf_ctrl *ctrl = &nvme_epf->ctrl;
 
-	ctrl->link_up = false;
 	nvmet_pci_epf_destroy_ctrl(ctrl);
 
 	nvmet_pci_epf_deinit_dma(nvme_epf);
@@ -2371,7 +2375,6 @@ static int nvmet_pci_epf_link_up(struct pci_epf *epf)
 	struct nvmet_pci_epf *nvme_epf = epf_get_drvdata(epf);
 	struct nvmet_pci_epf_ctrl *ctrl = &nvme_epf->ctrl;
 
-	ctrl->link_up = true;
 	nvmet_pci_epf_start_ctrl(ctrl);
 
 	return 0;
@@ -2382,7 +2385,6 @@ static int nvmet_pci_epf_link_down(struct pci_epf *epf)
 	struct nvmet_pci_epf *nvme_epf = epf_get_drvdata(epf);
 	struct nvmet_pci_epf_ctrl *ctrl = &nvme_epf->ctrl;
 
-	ctrl->link_up = false;
 	nvmet_pci_epf_stop_ctrl(ctrl);
 
 	return 0;
-- 
2.39.5



