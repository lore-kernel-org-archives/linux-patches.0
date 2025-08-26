Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE22BE653;
	Tue, 26 Aug 2025 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207229; cv=none; b=Cvo41zPRTTcNsSeSPj5EXOQxII41RiU6xD33zsiuFt/D/07M+JiCPTk9UitQOogT5cwRhi3U11cgHijveftiqL9NOorzvvypYtUNMADvSpzFvRQjnLAURaa0rVPuBgi/nRB3wBjSUbWwWjd8cz3mURW+R9suA4c4iJ3GAeT8myA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207229; c=relaxed/simple;
	bh=i3Qs1dUAlYUbGZroFSSqX/Gcx47v8Awa6uJADGfi4yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvXCi6JzCIzNBanp1Xebq517Y48B4Y2pMjY1W60w1rmRYZVaaSsE+ueUahD2fFRJAC+HIM8+DMVEzOAANuQdz0B9iMzdgiMQBaR2gOvDn3lcv3N6TzhIBOPxIWUFVaWwDEUuxGLwilIIDR0Nykzt0ki069HMiK9Lo5KohGTLiF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIExuzxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIExuzxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBA9C4CEF1;
	Tue, 26 Aug 2025 11:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207229;
	bh=i3Qs1dUAlYUbGZroFSSqX/Gcx47v8Awa6uJADGfi4yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIExuzxrGrZCfbaulwumarIxJl30JB7ofU3gHGBML3qIeqjVOqe+V3mQCvJI62z/J
	 MROfDTdGOueB6DVcaW/uzw3hJoPota4XIWpA2t3D8l/UNDnw2U5ERzvEKnkMRaEXT1
	 gFoF2/AxMa4HvLdjbyUTt8tORI04bCqo7+XoqeYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.16 100/457] PCI: endpoint: Fix configfs group removal on driver teardown
Date: Tue, 26 Aug 2025 13:06:24 +0200
Message-ID: <20250826110939.847426291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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
@@ -338,6 +338,7 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
+	WARN_ON(!list_empty(&driver->epf_group));
 	mutex_unlock(&pci_epf_mutex);
 }
 


