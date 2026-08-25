Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D42848123A;
	Tue, 25 Aug 2026 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665248; cv=none; b=sk0RWZTwuPMByG5QXovO2iCaeZRo91pj2ZbF7IU465kcYvFs/t7eBgi7YVDSiclzxgNkWjrpXZrCSV145ktwl1do7atErrbG/zjiFH6wm5eM1BcRLMzSaWyf3DMHf361OHvxRHxnr39WMwF7KSyR/EJH+jWs13Dr/uqHy9u0G0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665248; c=relaxed/simple;
	bh=NqAMKJhwOZcBVaUshZpYMy+tn5P1YLKn5ZcCZ/mZapI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRlODjJSuyKAKHoj8m4fnhTEfstYfxYMG+tYRcx6KNJYKttQRlbvsOuz6CxoddNXvHgzmxojV0u0zinb6zM7csChDLvxE/+YEuM4too31uIL8cqORPhymNgxvwUX9dNRoqbdGeVJV+zUSzvXE8/JKfLvoE6T/h0HiJgP1rU18VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHy/g8s4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHy/g8s4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E110E1F000E9;
	Tue, 25 Aug 2026 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665247;
	bh=qSqWoiFPyWogUSnkx05V6kdRM7gJX4Gq/DEYQprhhMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHy/g8s4GPOTD+f2Z3AYI4+uzVUS4pPO3Evn1gpB1i0tzXdXipeoC5sLn7uZVua/K
	 esFbKWlxD2Nl8+nYh7r4fkw+GP930YfP7rRkxSkgbj7wOt9FxUcpIBXQa0aKrX02nf
	 W4jvos0f0LGi4mQwS24oYjrbtDD7/56kBD5eCidg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yifei Gao <gyf161023@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 56/94] nvmet: pci-epf: put CQ ref on create_cq mapping failure
Date: Tue, 25 Aug 2026 15:25:52 +0200
Message-ID: <20260825132544.091426200@linuxfoundation.org>
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
@@ -1338,6 +1338,7 @@ err_unmap_queue:
 	nvmet_pci_epf_mem_unmap(ctrl->nvme_epf, &cq->pci_map);
 err_internal:
 	status = NVME_SC_INTERNAL | NVME_STATUS_DNR;
+	nvmet_cq_put(&cq->nvme_cq);
 err:
 	if (test_and_clear_bit(NVMET_PCI_EPF_Q_IRQ_ENABLED, &cq->flags))
 		nvmet_pci_epf_remove_irq_vector(ctrl, cq->vector);


