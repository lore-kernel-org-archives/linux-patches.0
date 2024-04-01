Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ACE1C0DE7;
	Mon,  1 Apr 2024 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990902; cv=none; b=IVQ3+Q0bTa14LoRu4KmJW+Gkrd3VHKDVESyH5uyMd3Jtn1v33uA/ynkQsFvWPilqNVXYcY+qQPDggsrvsIWjEUaUBO8UeT5Tghx0bYT6q/L02HHo7he+tPpcFRHcrZbsTd7/S07fVhcLufHjV6QGqAATKKJzYynUlDiOdnJKGjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990902; c=relaxed/simple;
	bh=Prt8DmzcFDskio+QCEBYPET610Yxwzok4xLRmQjmx7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrRiuJPjiwTaFgs00v7yf/kswtNzsMDALveTmkE3mA4Jppu8EuxM8TWCQ7biIkxBUrWaYmfZbl63jsNVGSOna3uXymx8DMJxuSbo41mgxZm77uqMyNrY9IHSJszko59upeP6JXF0wb3ejmDA7og6dMrvvvPAM0LfleqATeSsJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4FjY9e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4FjY9e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D847C433C7;
	Mon,  1 Apr 2024 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990902;
	bh=Prt8DmzcFDskio+QCEBYPET610Yxwzok4xLRmQjmx7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4FjY9e2tBZ6NpJzCoHjeMLJzQQ4cLoJVT5IP8y/9sx+SdQnMpio8lrnKNsYxgEi2
	 TOsbxx89t4iaH2OfVCqKj3Q6uPTXtHkQ0sMIlnCfJkcW+6FQYzxYWOdT28d1c7NE5B
	 htaHb7INJIXG4Q8rGmzC01Hix/3PDYDcDEtXa7jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/272] vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
Date: Mon,  1 Apr 2024 17:44:52 +0200
Message-ID: <20240401152533.827966700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit a65f35cfd504e5135540939cffd4323083190b36 ]

vfio_msi_disable() releases all previously allocated state
associated with each interrupt before disabling MSI/MSI-X.

vfio_msi_disable() iterates twice over the interrupt state:
first directly with a for loop to do virqfd cleanup, followed
by another for loop within vfio_msi_set_block() that removes
the interrupt handler and its associated state using
vfio_msi_set_vector_signal().

Simplify interrupt cleanup by iterating over allocated interrupts
once.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/837acb8cbe86a258a50da05e56a1f17c1a19abbe.1683740667.git.reinette.chatre@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: fe9a7082684e ("vfio/pci: Disable auto-enable of exclusive INTx IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bffb0741518b9..6a9c6a143cc3a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -426,10 +426,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	for (i = 0; i < vdev->num_ctx; i++) {
 		vfio_virqfd_disable(&vdev->ctx[i].unmask);
 		vfio_virqfd_disable(&vdev->ctx[i].mask);
+		vfio_msi_set_vector_signal(vdev, i, -1, msix);
 	}
 
-	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
-
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	pci_free_irq_vectors(pdev);
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
-- 
2.43.0



