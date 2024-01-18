Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B4C1B96D;
	Thu, 18 Jan 2024 10:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575232; cv=none; b=H9erdKAhBH5lZeOtp/CY/3T1fnVqq6YzqlQAHyWCUfzH+EsVA8WCKOXpkSCs1fP/tnGkqrFEAQutac8b1vxtFhW7DwzTirTcU2yfxUqngnek5ywUEx7Qieicq9dycnX7qgpXx5OiSVCNLFhBNTC3GPp9Yc1qeAhYHt+IcLbHATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575232; c=relaxed/simple;
	bh=7Wrle3jrxzV0JFli55jKQiIo9tElEd+k89iO4R6Q/EY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=AOwz8wJcAaOzWT0ozjGKEc7I8i3Ny4/r8dfpkx5RQNDra0HwXZAUA94SLAdaThwnSnLEwWH4j2E+WXw3c4t5gKLcdTFPJF66ZXrAm/SCeLHArCMiZr0CkD/tnNf6qmtI6Z7DW5s3Kbyvm+93ikc148bUxaFKpqikHnNFkG80FYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK5Gr8wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK5Gr8wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15520C43394;
	Thu, 18 Jan 2024 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575232;
	bh=7Wrle3jrxzV0JFli55jKQiIo9tElEd+k89iO4R6Q/EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KK5Gr8wjQuQI0HSWpk7txC8f4f+RBHVjdJBu8ukhlqWdxySNRF9eS2821DgNooPLe
	 TPGJo/F21Tm+1yFAKBmihzyFkRcSdpomtiq1Nl/LKTw4pyNl3+Hz7G9bi2p7aEvouH
	 uGGd0RnlSo7hSO/xcAOsrEFdpfGXvMGlY3ob/KeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitao Hu <yaoma@linux.alibaba.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/150] nvme: fix deadlock between reset and scan
Date: Thu, 18 Jan 2024 11:47:59 +0100
Message-ID: <20240118104322.623475554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitao Hu <yaoma@linux.alibaba.com>

[ Upstream commit 839a40d1e730977d4448d141fa653517c2959a88 ]

If controller reset occurs when allocating namespace, both
nvme_reset_work and nvme_scan_work will hang, as shown below.

Test Scripts:

    for ((t=1;t<=128;t++))
    do
    nsid=`nvme create-ns /dev/nvme1 -s 14537724 -c 14537724 -f 0 -m 0 \
    -d 0 | awk -F: '{print($NF);}'`
    nvme attach-ns /dev/nvme1 -n $nsid -c 0
    done
    nvme reset /dev/nvme1

We will find that both nvme_reset_work and nvme_scan_work hung:

    INFO: task kworker/u249:4:17848 blocked for more than 120 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
    message.
    task:kworker/u249:4  state:D stack:    0 pid:17848 ppid:     2
    flags:0x00000028
    Workqueue: nvme-reset-wq nvme_reset_work [nvme]
    Call trace:
    __switch_to+0xb4/0xfc
    __schedule+0x22c/0x670
    schedule+0x4c/0xd0
    blk_mq_freeze_queue_wait+0x84/0xc0
    nvme_wait_freeze+0x40/0x64 [nvme_core]
    nvme_reset_work+0x1c0/0x5cc [nvme]
    process_one_work+0x1d8/0x4b0
    worker_thread+0x230/0x440
    kthread+0x114/0x120
    INFO: task kworker/u249:3:22404 blocked for more than 120 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
    message.
    task:kworker/u249:3  state:D stack:    0 pid:22404 ppid:     2
    flags:0x00000028
    Workqueue: nvme-wq nvme_scan_work [nvme_core]
    Call trace:
    __switch_to+0xb4/0xfc
    __schedule+0x22c/0x670
    schedule+0x4c/0xd0
    rwsem_down_write_slowpath+0x32c/0x98c
    down_write+0x70/0x80
    nvme_alloc_ns+0x1ac/0x38c [nvme_core]
    nvme_validate_or_alloc_ns+0xbc/0x150 [nvme_core]
    nvme_scan_ns_list+0xe8/0x2e4 [nvme_core]
    nvme_scan_work+0x60/0x500 [nvme_core]
    process_one_work+0x1d8/0x4b0
    worker_thread+0x260/0x440
    kthread+0x114/0x120
    INFO: task nvme:28428 blocked for more than 120 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
    message.
    task:nvme            state:D stack:    0 pid:28428 ppid: 27119
    flags:0x00000000
    Call trace:
    __switch_to+0xb4/0xfc
    __schedule+0x22c/0x670
    schedule+0x4c/0xd0
    schedule_timeout+0x160/0x194
    do_wait_for_common+0xac/0x1d0
    __wait_for_common+0x78/0x100
    wait_for_completion+0x24/0x30
    __flush_work.isra.0+0x74/0x90
    flush_work+0x14/0x20
    nvme_reset_ctrl_sync+0x50/0x74 [nvme_core]
    nvme_dev_ioctl+0x1b0/0x250 [nvme_core]
    __arm64_sys_ioctl+0xa8/0xf0
    el0_svc_common+0x88/0x234
    do_el0_svc+0x7c/0x90
    el0_svc+0x1c/0x30
    el0_sync_handler+0xa8/0xb0
    el0_sync+0x148/0x180

The reason for the hang is that nvme_reset_work occurs while nvme_scan_work
is still running. nvme_scan_work may add new ns into ctrl->namespaces
list after nvme_reset_work frozen all ns->q in ctrl->namespaces list.
The newly added ns is not frozen, so nvme_wait_freeze will wait forever.
Unfortunately, ctrl->namespaces_rwsem is held by nvme_reset_work, so
nvme_scan_work will also wait forever. Now we are deadlocked!

PROCESS1                         PROCESS2
==============                   ==============
nvme_scan_work
  ...                            nvme_reset_work
  nvme_validate_or_alloc_ns        nvme_dev_disable
    nvme_alloc_ns                    nvme_start_freeze
     down_write                      ...
     nvme_ns_add_to_ctrl_list        ...
     up_write                      nvme_wait_freeze
    ...                              down_read
    nvme_alloc_ns                    blk_mq_freeze_queue_wait
     down_write

Fix by marking the ctrl with say NVME_CTRL_FROZEN flag set in
nvme_start_freeze and cleared in nvme_unfreeze. Then the scan can check
it before adding the new namespace (under the namespaces_rwsem).

Signed-off-by: Bitao Hu <yaoma@linux.alibaba.com>
Reviewed-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c38e234723ec..d4564a2517eb 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3652,6 +3652,14 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 		goto out_unlink_ns;
 
 	down_write(&ctrl->namespaces_rwsem);
+	/*
+	 * Ensure that no namespaces are added to the ctrl list after the queues
+	 * are frozen, thereby avoiding a deadlock between scan and reset.
+	 */
+	if (test_bit(NVME_CTRL_FROZEN, &ctrl->flags)) {
+		up_write(&ctrl->namespaces_rwsem);
+		goto out_unlink_ns;
+	}
 	nvme_ns_add_to_ctrl_list(ns);
 	up_write(&ctrl->namespaces_rwsem);
 	nvme_get_ctrl(ctrl);
@@ -4562,6 +4570,7 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		blk_mq_unfreeze_queue(ns->queue);
 	up_read(&ctrl->namespaces_rwsem);
+	clear_bit(NVME_CTRL_FROZEN, &ctrl->flags);
 }
 EXPORT_SYMBOL_GPL(nvme_unfreeze);
 
@@ -4595,6 +4604,7 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
 
+	set_bit(NVME_CTRL_FROZEN, &ctrl->flags);
 	down_read(&ctrl->namespaces_rwsem);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		blk_freeze_queue_start(ns->queue);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 13f71461f5f1..ba62d42d2a8b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -256,6 +256,7 @@ enum nvme_ctrl_flags {
 	NVME_CTRL_STOPPED		= 3,
 	NVME_CTRL_SKIP_ID_CNS_CS	= 4,
 	NVME_CTRL_DIRTY_CAPABILITY	= 5,
+	NVME_CTRL_FROZEN		= 6,
 };
 
 struct nvme_ctrl {
-- 
2.43.0



