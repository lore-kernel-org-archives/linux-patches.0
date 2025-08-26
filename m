Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F90350D4F;
	Tue, 26 Aug 2025 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216627; cv=none; b=sGGbcxOKngwPdmO9I9560cimot3XJFX2iO78KCPaLOPKbdhBh+YJ1UTtwhISq+xc2Hb9sSjmgia+pHmXvsqf2vAHzV5i+fA0FNmoURFWVOXoj9Q59lGu+OsnbDclKjc9e4FRbHy3HOz+RS0XCFLDvKhatMX2FXYwYu0tP27PdDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216627; c=relaxed/simple;
	bh=vfauPPBk3wbvwfVs7n0sLkoNqXu+IpBf8oCkqoJnljI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E43a69laGGzFGygrGc2rrUTrE7uV9XlhMXLIkM0XLGDQX7D+Ve+LfdO3XymYycW35XmcHg3NuFAyjAhBVdjLkLMfc95ut4H6XY5/IDR5Skcb5+1bb58PKbn1Bj+1zV3R/mXxvBfwEQzn4Sw+DLJD2bfB1Xj9yXZyzVtIG68fsKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkAY2M3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkAY2M3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131CAC4CEF1;
	Tue, 26 Aug 2025 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216627;
	bh=vfauPPBk3wbvwfVs7n0sLkoNqXu+IpBf8oCkqoJnljI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkAY2M3RpzqWve5rgaCljAb1ukMwJR3TFHQ1cmPXJQcoV+mv4XOT4D8ueAVlsHgsq
	 gtRiZtV/4FVmMx6CN+tTQGCk/tCzOy4rb9kwu/wifl9jzN75/WM5s1N1a42sFvzgHO
	 tap52TXYkhcnQ9wPSqR6qvZhYV8axdWGSEo7/9uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.15 483/644] PCI: endpoint: Fix configfs group removal on driver teardown
Date: Tue, 26 Aug 2025 13:09:34 +0200
Message-ID: <20250826110958.454926893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -658,6 +658,7 @@ void pci_ep_cfs_remove_epf_group(struct
 	if (IS_ERR_OR_NULL(group))
 		return;
 
+	list_del(&group->group_entry);
 	configfs_unregister_default_group(group);
 }
 EXPORT_SYMBOL(pci_ep_cfs_remove_epf_group);
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -343,6 +343,7 @@ static void pci_epf_remove_cfs(struct pc
 	mutex_lock(&pci_epf_mutex);
 	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
 		pci_ep_cfs_remove_epf_group(group);
+	WARN_ON(!list_empty(&driver->epf_group));
 	mutex_unlock(&pci_epf_mutex);
 }
 


