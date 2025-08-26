Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42BC29D292;
	Tue, 26 Aug 2025 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208427; cv=none; b=a+1tA+0Pb/x5YpRsnUhtf5jJoW7v6LJB8NMziCtEmOLmD1knO16DpplOs3NDCX56gfFYKm2i20WLcqvsT50ZtTbgJoNVyEvWGvBW7HEW51Sj6ujlPH17Wh2UtnfNMpWvwsWolyUkGtSuW0L5ZFK0IDU/X9VExMg7OBMXLBhyM3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208427; c=relaxed/simple;
	bh=mt57IDL936qb85nFr10b/C94eIMFNXDoNiQ38owuLyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TroIJdjM9Vor278lU/+bK0uBnq9ny4cFuwVPzZ1ZB0xHrl3POS23TXqSBSPB0658TT2i5aTn4xhnqs2tnlodgwOCVTG4Tq4ixVL8GqJvh07Am9iR1Mpcfk5pRZ+NFqKUBsYvyRCmmrSmyLAoAOPQjTRW845H9COdOb98wX0t9EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpf3xC62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpf3xC62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC54C4CEF1;
	Tue, 26 Aug 2025 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208427;
	bh=mt57IDL936qb85nFr10b/C94eIMFNXDoNiQ38owuLyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xpf3xC62ulkkPkCN+dtAdLgqT+rSObxEEXwMDuvmg02Y6bww6A/K2VDg74dQ8QPCs
	 hDl0O1PLSh3+mBYD8H4I7myd/cQrZdH4w35rQal5toQtyB8tCEX7wkvEen7m9TFfAO
	 NoS/1ElxqsAmI54LICQRPbb0irc9mcy5NRN0YLaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 076/322] PCI: endpoint: Fix configfs group removal on driver teardown
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826110917.482013908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -691,6 +691,7 @@ void pci_ep_cfs_remove_epf_group(struct
 	if (IS_ERR_OR_NULL(group))
 		return;
 
+	list_del(&group->group_entry);
 	configfs_unregister_default_group(group);
 }
 EXPORT_SYMBOL(pci_ep_cfs_remove_epf_group);
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -334,6 +334,7 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
+	WARN_ON(!list_empty(&driver->epf_group));
 	mutex_unlock(&pci_epf_mutex);
 }
 


