Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4276B15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEwLMn/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BD5C433CC;
	Mon, 23 Oct 2023 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061229;
	bh=FxBGBMlwWFHnzRR6imJpJinept2aF9H8lnCpCl8mNhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEwLMn/jwHsxmPHaksJdAC1tiMa5Nknt/D3kURx1lv1Mx+axLlqHxXfrBjDkkSm/y
	 1AaW8PgFs+ipWVNmTXZFXXaz+i3sxoFqW1a42z/T44ReTgRFLtlS5JfVTb0bMHnk/E
	 36qJRuvaq+DpWADvVYJK+cVM//a6X5lFJiI5VRZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Yi Zhang <yi.zhang@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 116/137] nvme-rdma: do not try to stop unallocated queues
Date: Mon, 23 Oct 2023 12:57:53 +0200
Message-ID: <20231023104824.691983368@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

commit 3820c4fdc247b6f0a4162733bdb8ddf8f2e8a1e4 upstream.

Trying to stop a queue which hasn't been allocated will result
in a warning due to calling mutex_lock() against an uninitialized mutex.

 DEBUG_LOCKS_WARN_ON(lock->magic != lock)
 WARNING: CPU: 4 PID: 104150 at kernel/locking/mutex.c:579

 Call trace:
  RIP: 0010:__mutex_lock+0x1173/0x14a0
  nvme_rdma_stop_queue+0x1b/0xa0 [nvme_rdma]
  nvme_rdma_teardown_io_queues.part.0+0xb0/0x1d0 [nvme_rdma]
  nvme_rdma_delete_ctrl+0x50/0x100 [nvme_rdma]
  nvme_do_delete_ctrl+0x149/0x158 [nvme_core]

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/rdma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -645,6 +645,9 @@ static void __nvme_rdma_stop_queue(struc
 
 static void nvme_rdma_stop_queue(struct nvme_rdma_queue *queue)
 {
+	if (!test_bit(NVME_RDMA_Q_ALLOCATED, &queue->flags))
+		return;
+
 	mutex_lock(&queue->queue_lock);
 	if (test_and_clear_bit(NVME_RDMA_Q_LIVE, &queue->flags))
 		__nvme_rdma_stop_queue(queue);


