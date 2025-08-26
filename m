Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659C4352FFA;
	Tue, 26 Aug 2025 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218133; cv=none; b=DgkHQdzlcEG3SiQ96mmhC0GtDH5hcIF6s+wnYYGsOQt/V03Fl341d+iTUzb1yC4HrkQkMcUY1YQVZP9NCOLSmaaLh0hlvnBU1jhq3Vo7dgpy1uppgBQ/e57cEQyHpUhuWxt9lgspE9s5VBWzj4cqbfPHLcRxz5zoFSOWnvxHCG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218133; c=relaxed/simple;
	bh=oNAmdMhgWXxkzTOGs2OVJEbXPZS6PTw0OYzK+dhfPbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+AZ3Zf9AtX8HIxTHGtB8DBAGK4ZJvJtZ2zd4wB7EV6RzzI4TjBmJIh6bMx2Mxo0QUq/spmylaq5qdmR+4Ew3lJylkGPwU6l/RaXKrB9B7qrRjI//emqlphmr9s6fHiGYPgdCcLn/6miTlPZ6j6yeICRttM0DwVIzBjdHpxbzgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUim6kb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUim6kb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC46C113CF;
	Tue, 26 Aug 2025 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218132;
	bh=oNAmdMhgWXxkzTOGs2OVJEbXPZS6PTw0OYzK+dhfPbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUim6kb5w20+4mFcVt3wsswwuVtNbvAly7inDNnMuPC1bS1tLl0k5Ncf5PVx/C4iy
	 we8WozrnacBfm0K2kSk2WoFfr2m2VDrJ8fVAlWeYjd66gaawyM+BMrjlnMWykxFU2G
	 LTuA0C5er3zMpsI5G+jYHAyt9cvIZ0vqu1RFiA/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.10 374/523] PCI: endpoint: Fix configfs group removal on driver teardown
Date: Tue, 26 Aug 2025 13:09:44 +0200
Message-ID: <20250826110933.690235110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 910bdb8197f9322790c738bb32feaa11dba26909 upstream.

An endpoint driver configfs attributes group is added to the
epf_group list of struct pci_epf_driver by pci_epf_add_cfs() but an
added group is not removed from this list when the attribute group is
unregistered with pci_ep_cfs_remove_epf_group().

Add the missing list_del() call in pci_ep_cfs_remove_epf_group()
to correctly remove the attribute group from the driver list.

With this change, once the loop over all attribute groups in
pci_epf_remove_cfs() completes, the driver epf_group list should be
empty. Add a WARN_ON() to make sure of that.

Fixes: ef1433f717a2 ("PCI: endpoint: Create configfs entry for each pci_epf_device_id table entry")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250624114544.342159-3-dlemoal@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-ep-cfs.c   |    1 +
 drivers/pci/endpoint/pci-epf-core.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/pci/endpoint/pci-ep-cfs.c
+++ b/drivers/pci/endpoint/pci-ep-cfs.c
@@ -464,6 +464,7 @@ void pci_ep_cfs_remove_epf_group(struct
 	if (IS_ERR_OR_NULL(group))
 		return;
 
+	list_del(&group->group_entry);
 	configfs_unregister_default_group(group);
 }
 EXPORT_SYMBOL(pci_ep_cfs_remove_epf_group);
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -147,6 +147,7 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
+	WARN_ON(!list_empty(&driver->epf_group));
 	mutex_unlock(&pci_epf_mutex);
 }
 


