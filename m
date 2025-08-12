Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209B61FFE;
	Tue, 12 Aug 2025 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023242; cv=none; b=gZ5eDWw3CDMj1HqXDP8ZVu5R8kXNKorxwAzF6N5985vQTG4ZYtO9TXu5qN5N9FNopw5ygNS9VGtvRjEMZFPOnVlK3HbyIItn2QmF92jSgiPp+Hj+MGbgmsBSLgt/STt2uzRDRqNMkk5889XeH36eXA+Vdc1/BnVJfBtc8mn65mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023242; c=relaxed/simple;
	bh=u445zBUL80Y5T3DT7UepT60W6nCzIAjIk7SgwQxoBCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjHj9sUrficFtGP59Y+yx/66VUYW1sxl5Y209Yc7pG3kyygcFRnSylhDJU+oMYYnr9IdyrnSnaQWmEuEARdIpC9V2VGsWqA10bU3KxJvJ2LF33GRyzRvDRjFd/lqx22yFQDYAT58EKb68vEpchwlz0JXvf1GhWFIBv0eUA6OwnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt/jIyeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt/jIyeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D25FC4CEF1;
	Tue, 12 Aug 2025 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023241;
	bh=u445zBUL80Y5T3DT7UepT60W6nCzIAjIk7SgwQxoBCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt/jIyeIcqTaXOEltQvIsBVnMmISgxMZ9robKxvO/ogONfZ/Zo5/tyilTN1prenW1
	 N/w+sioeaDAxKTQFmMRVBnbGVmDFR1azoLcsF9lGKhf5NDZFT8Bz8PxmpoTAUWZ1Cf
	 +h/jPnrOi4+rPrFAJ3g+I9oBJ+Gq5k930q5eLewE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 022/627] nvmet: pci-epf: Do not complete commands twice if nvmet_req_init() fails
Date: Tue, 12 Aug 2025 19:25:17 +0200
Message-ID: <20250812173420.161896428@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

[ Upstream commit 746d0ac5a07d5da952ef258dd4d75f0b26c96476 ]

Have nvmet_req_init() and req->execute() complete failed commands.

Description of the problem:
nvmet_req_init() calls __nvmet_req_complete() internally upon failure,
e.g., unsupported opcode, which calls the "queue_response" callback,
this results in nvmet_pci_epf_queue_response() being called, which will
call nvmet_pci_epf_complete_iod() if data_len is 0 or if dma_dir is
different from DMA_TO_DEVICE. This results in a double completion as
nvmet_pci_epf_exec_iod_work() also calls nvmet_pci_epf_complete_iod()
when nvmet_req_init() fails.

Steps to reproduce:
On the host send a command with an unsupported opcode with nvme-cli,
For example the admin command "security receive"
$ sudo nvme security-recv /dev/nvme0n1 -n1 -x4096

This triggers a double completion as nvmet_req_init() fails and
nvmet_pci_epf_queue_response() is called, here iod->dma_dir is still
in the default state of "DMA_NONE" as set by default in
nvmet_pci_epf_alloc_iod(), so nvmet_pci_epf_complete_iod() is called.
Because nvmet_req_init() failed nvmet_pci_epf_complete_iod() is also
called in nvmet_pci_epf_exec_iod_work() leading to a double completion.
This not only sends two completions to the host but also corrupts the
state of the PCI NVMe target leading to kernel oops.

This patch lets nvmet_req_init() and req->execute() complete all failed
commands, and removes the double completion case in
nvmet_pci_epf_exec_iod_work() therefore fixing the edge cases where
double completions occurred.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index a4295a5b8d28..6f1651183e32 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1242,8 +1242,11 @@ static void nvmet_pci_epf_queue_response(struct nvmet_req *req)
 
 	iod->status = le16_to_cpu(req->cqe->status) >> 1;
 
-	/* If we have no data to transfer, directly complete the command. */
-	if (!iod->data_len || iod->dma_dir != DMA_TO_DEVICE) {
+	/*
+	 * If the command failed or we have no data to transfer, complete the
+	 * command immediately.
+	 */
+	if (iod->status || !iod->data_len || iod->dma_dir != DMA_TO_DEVICE) {
 		nvmet_pci_epf_complete_iod(iod);
 		return;
 	}
@@ -1604,8 +1607,13 @@ static void nvmet_pci_epf_exec_iod_work(struct work_struct *work)
 		goto complete;
 	}
 
+	/*
+	 * If nvmet_req_init() fails (e.g., unsupported opcode) it will call
+	 * __nvmet_req_complete() internally which will call
+	 * nvmet_pci_epf_queue_response() and will complete the command directly.
+	 */
 	if (!nvmet_req_init(req, &iod->sq->nvme_sq, &nvmet_pci_epf_fabrics_ops))
-		goto complete;
+		return;
 
 	iod->data_len = nvmet_req_transfer_len(req);
 	if (iod->data_len) {
@@ -1643,10 +1651,11 @@ static void nvmet_pci_epf_exec_iod_work(struct work_struct *work)
 
 	wait_for_completion(&iod->done);
 
-	if (iod->status == NVME_SC_SUCCESS) {
-		WARN_ON_ONCE(!iod->data_len || iod->dma_dir != DMA_TO_DEVICE);
-		nvmet_pci_epf_transfer_iod_data(iod);
-	}
+	if (iod->status != NVME_SC_SUCCESS)
+		return;
+
+	WARN_ON_ONCE(!iod->data_len || iod->dma_dir != DMA_TO_DEVICE);
+	nvmet_pci_epf_transfer_iod_data(iod);
 
 complete:
 	nvmet_pci_epf_complete_iod(iod);
-- 
2.39.5



