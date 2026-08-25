Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF54047FB0E;
	Tue, 25 Aug 2026 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664941; cv=none; b=ASLV4tHSe9/hEwuAd9zPk9Jlrc8GlVxk0xNny9kBbOuuMTY4/B1ltNcTni0wQnvfXFi0iwzPDreUnt6RyhvHASAX7ikArruHfZpTc4wc15uLeg15NYLcWQI7zG4mt7apc+5gx18tGfIK7j5gVJUQNITVZ5tiqf64lnnZPeF9K2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664941; c=relaxed/simple;
	bh=3fWgk49jVguAKCDEAeBY5KHlr7Y8FGqxKUMl7wAFoC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMBYh9Gu4xsrF1T617B/rJ8HUeZCnsDq7IeGySMAAi0lpCQ8WLw4ppyqZduj6lpCGnXNRAO9tQvExS8exOjX/3EYT1hujjSKausBXr1Ik/49tqL2AK0M5LhutPotis3IrxOUQd6ipn6X/9Q9iDXx7PvaVjR76sgYbmGcqqz6oZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9OAS7Ez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9OAS7Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3421F000E9;
	Tue, 25 Aug 2026 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664939;
	bh=LK3VWz7Puq8zIDIK178zadUUfDc27v06xi/FT77IOso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9OAS7Eze8bHglmzoaaNJKff9tqbflMCtsOBb5qTZOtoNNLX0Iq0YGkV7YN6mykul
	 NRYWUGTz5hm1V5pWpsrvN3/rU8lyFokIThXbFwUNgqunz2Zd76OQgamtWr//bOlEXY
	 zTqrGcze49vJNEc83AdjGPlb95e0IY4DE5EGnvqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 057/101] nvmet: pci-epf: fix use-after-free in nvmet_pci_epf_exec_iod_work()
Date: Tue, 25 Aug 2026 15:25:35 +0200
Message-ID: <20260825132544.231747229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit c9e9bb757971485b4e8414b1744507af186d72c9 upstream.

nvmet_pci_epf_exec_iod_work() submits an I/O command with req->execute()
and then waits for the command to complete and transfers the data back
to the host. This wait is not needed for commands that do not transfer
data from the device to the host. To decide whether that wait is needed,
it reads iod->data_len and iod->dma_dir after calling req->execute().

However, once req->execute() is called, the command may complete
asynchronously on another CPU. For commands that do not require a
device-to-host data transfer, nvmet_pci_epf_queue_response() calls
nvmet_pci_epf_complete_iod() directly, which can free the iod before it
reads iod->data_len and iod->dma_dir, resulting in the KFENCE use-after-
free:

 BUG: KFENCE: use-after-free read in nvmet_pci_epf_exec_iod_work+0x288/0x798 [nvmet_pci_epf]

 Use-after-free read at 0x00000000fdfa6d03 (in kfence-#63):
  nvmet_pci_epf_exec_iod_work+0x288/0x798 [nvmet_pci_epf]
  process_one_work+0x15c/0x4f0
  worker_thread+0x18c/0x30c
  kthread+0x130/0x140
  ret_from_fork+0x10/0x20

 kfence-#63: 0x00000000e3de0e71-0x00000000c938ad62, size=712, cache=kmalloc-1k

 allocated by task 10 on cpu 0 at 73.995480s (0.005122s ago):
  mempool_kmalloc+0x1c/0x28
  mempool_alloc_noprof+0x40/0x9c
  nvmet_pci_epf_poll_sqs_work+0xd4/0x344 [nvmet_pci_epf]
  process_one_work+0x15c/0x4f0
  worker_thread+0x18c/0x30c
  kthread+0x130/0x140
  ret_from_fork+0x10/0x20

 freed by task 131 on cpu 3 at 73.995521s (0.008385s ago):
  mempool_kfree+0x10/0x20
  mempool_free+0x44/0x64
  nvmet_pci_epf_free_iod+0x88/0x98 [nvmet_pci_epf]
  nvmet_pci_epf_cq_work+0xfc/0x280 [nvmet_pci_epf]
  process_one_work+0x15c/0x4f0
  worker_thread+0x18c/0x30c
  kthread+0x130/0x140
  ret_from_fork+0x10/0x20

Fix this by referring to iod->data_len and iod->dma_dir before calling
req->execute(). The remaining iod accesses such as iod->status are only
reached on the device-to-host read path. In this case,
nvmet_pci_epf_queue_response() signals iod->done instead of freeing the
iod, so the iod stays valid.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/pci-epf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1594,6 +1594,7 @@ static void nvmet_pci_epf_exec_iod_work(
 	struct nvmet_pci_epf_iod *iod =
 		container_of(work, struct nvmet_pci_epf_iod, work);
 	struct nvmet_req *req = &iod->req;
+	bool no_wait;
 	int ret;
 
 	if (!iod->ctrl->link_up) {
@@ -1638,14 +1639,16 @@ static void nvmet_pci_epf_exec_iod_work(
 		}
 	}
 
-	req->execute(req);
-
 	/*
 	 * If we do not have data to transfer after the command execution
 	 * finishes, nvmet_pci_epf_queue_response() will complete the command
 	 * directly. No need to wait for the completion in this case.
 	 */
-	if (!iod->data_len || iod->dma_dir != DMA_TO_DEVICE)
+	no_wait = !iod->data_len || iod->dma_dir != DMA_TO_DEVICE;
+
+	req->execute(req);
+
+	if (no_wait)
 		return;
 
 	wait_for_completion(&iod->done);


