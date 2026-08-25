Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7B5480DCB;
	Tue, 25 Aug 2026 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665246; cv=none; b=tZcftOKYP8ykkLqoqJtNVk6oKFrELBP1h3FICXJXCW3v5DD/XQ8SumfsSMnc8j/N9XeMQKZWS7ofdlv4O3H9ftwxLuJa/wyCYNvvTJcOaQpWHuAx6ABIvokNEC/7reNrAXbg6XgcDZz4L7GsWAqrucR1pLuudB30xmNDo89+cnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665246; c=relaxed/simple;
	bh=lGcq1wyi7H/MC+MlMggdKO6InFImmia7jlbFOgmfA3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql0KIkX5BtzLvAK7qeyIyKwMJb6dDUPvO9pnkeb9BAufhFz3nb5WrWutAsZGoYQnZpo7tLYCNwvnKOeYkxVopebdZ8bGTsWtJxr1WhsigbRaeWd50a3hs58I3SnYld9RQYRalqSSxgbB+HsXt09uJ67i0ahWjq9kMW5+AWw5EcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCsbU0CT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCsbU0CT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAF61F00A3E;
	Tue, 25 Aug 2026 13:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665244;
	bh=f1ZldV5JZsUZyahRrZSH+7oPZX6KKEsBcvzvUhfpUOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCsbU0CTj4PVl8qc2VVti0HunC4959vZZIIUHjIVpwlB/1MAZn5yuC3Cso5jFm7yF
	 qjmqG1HM1XEkVtJhp6NQTPOzbvehgDyzL16aCwA7vwXMirI7U78Ob2QaQqnawr+HUa
	 JjJgqFYT3whoiYBVRvuZrFE2L0Pcar6eb0F49XF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 55/94] nvmet: pci-epf: fix use-after-free in nvmet_pci_epf_exec_iod_work()
Date: Tue, 25 Aug 2026 15:25:51 +0200
Message-ID: <20260825132544.055959110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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
@@ -1595,6 +1595,7 @@ static void nvmet_pci_epf_exec_iod_work(
 	struct nvmet_pci_epf_iod *iod =
 		container_of(work, struct nvmet_pci_epf_iod, work);
 	struct nvmet_req *req = &iod->req;
+	bool no_wait;
 	int ret;
 
 	if (!iod->ctrl->link_up) {
@@ -1639,14 +1640,16 @@ static void nvmet_pci_epf_exec_iod_work(
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


