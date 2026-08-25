Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2922EEE93;
	Tue, 25 Aug 2026 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664691; cv=none; b=PiembdKkwxxu0w++LOvI7hVRubnVsVjCctZPasPzVF9AXOUIPf2NM+QvIx7s8B7ZYT3y54GpEQlOfv7zHAJU1FS0kKg3ffY79h1/goRtiRw37E9MJYDJYYaUhHEwS5oiA1mcGdfRuc2YRluMg/9i9/YRuXwZkqEkLjxQwJk5mUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664691; c=relaxed/simple;
	bh=gEGxDWd0xGrnVWS4UYIDqmFUxuVWjD6GhBX46j/YLc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyYlBv045Vz68bwVFaDZmoPXSaeRdpZIpRABSLyj6ZPlsoY/beqTEJCov0m8jowRNHpcuZtQy8ltn35MOXmpZ1Y1UBJcjoKlu5YXPXVN5IkDPO+1+JONQBHuOnWleLvYIFrObrrtlMAaSx3VSoiErLhqvQKU6vNsu3QTuSp4pT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNYfHmFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNYfHmFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21971F000E9;
	Tue, 25 Aug 2026 13:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664690;
	bh=I2bMGehkQmQWcQMtn7nmwjK5OP6sNzkvRymSL4uCSJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNYfHmFPSPuoXqBp8Ziv9zv+CTdwGe5yLsdRqxIpTIWWZdTjIryszzuzcqk2m9Utg
	 VBAkENhWrC6uxPVrMDjYe28gMTLfPCP2tCLx6IuAIbDTMhB+ZHInJgAq8ku9f1NU29
	 4CL5h2CS2huL0l0kpIH/YHFHLgSycKXm8RVGshdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yifei Gao <gyf161023@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 55/82] nvmet: pci-epf: put CQ ref on create_cq mapping failure
Date: Tue, 25 Aug 2026 15:25:42 +0200
Message-ID: <20260825132543.682718954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit 659ae9d02cb5d72c76f74fff7441eb8fb64d8f5c upstream.

nvmet_pci_epf_create_cq() calls nvmet_cq_create(), which takes a
reference on the controller and installs the completion queue. If the
subsequent PCI address-space mapping fails or returns a too-small partial
mapping, the function jumps to err_internal / err_unmap_queue without
calling nvmet_cq_put(). The matching put in nvmet_pci_epf_delete_cq() is
gated on NVMET_PCI_EPF_Q_LIVE, which is only set after the mapping
succeeds, so teardown never releases these references. A remote PCI host
that drives Create IO CQ commands with a failing PRP1/pci_addr therefore
leaks the CQ and a controller reference on each attempt.

Drop the CQ reference on the mapping-failure paths. The err_internal and
err_unmap_queue labels are only reachable after nvmet_cq_create() has
succeeded, so this pairs the create/put correctly.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/pci-epf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1339,6 +1339,7 @@ err_unmap_queue:
 	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &cq->pci_map);
 err_internal:
 	status = NVME_SC_INTERNAL | NVME_STATUS_DNR;
+	nvmet_cq_put(&cq->nvme_cq);
 err:
 	if (test_and_clear_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
 		nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);


