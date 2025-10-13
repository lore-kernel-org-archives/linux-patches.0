Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD0130BBAE;
	Mon, 13 Oct 2025 15:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369614; cv=none; b=VvAYWJtwjeJogm3jtjvsQBbLaa43NXpYYYx7D1zHbx3icbfn7CrILmLzgQJ0U4gm4scUc8WhX/otarj667n9HWyGvK4BMZXZOhUS4Sa0zlEn+uS1IdFrTwh11vg9LfGVI51aomZ1A01VlmNVjnc7oaVyPmcmRbaHVA41NuRSeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369614; c=relaxed/simple;
	bh=L1atPx3C+FZX9uxu4qs/kHqIuuCB4MvOGTrdBwWOGjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIux+Ol6AjpfP9WbI8Gei5zUhE0fTZhtC3oq1pWeZR7dNa7OwObu67ytobCRqCLTimQBydDEY6px7KBOUD3ZUI9JriQIfB27UyrppUVUplFjlqYXtlhPWlm0cbXicc1xbaAdM+BAO4YudM1+Bu6H6iLcyQEnAlq/+WHsYmfEM98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0c77wXvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c77wXvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF189C4CEE7;
	Mon, 13 Oct 2025 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369614;
	bh=L1atPx3C+FZX9uxu4qs/kHqIuuCB4MvOGTrdBwWOGjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0c77wXvnfisFSK3gpSxtNGYZ137D72CK8X60cQIVTLAmxBbHeg4N0PdLA0+hj+UtK
	 tUiJM/zWFZ7Jojpph866nwwPJTUQ5O3EHbGKnpypupbBL7n7EP9pdXCI4hmgXs37ON
	 GXkxSWGsq7uBqaHQd/xGlbeQFOR4xOQ4ybQxNTSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 275/563] PCI/ACPI: Fix pci_acpi_preserve_config() memory leak
Date: Mon, 13 Oct 2025 16:42:16 +0200
Message-ID: <20251013144421.236393380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

[ Upstream commit fac679df7580979174c90303f004b09cdc6f086f ]

pci_acpi_preserve_config() leaks memory by returning early without freeing
the ACPI object on success. Fix that by always freeing the obj, which is
not needed by the caller.

Fixes: 9d7d5db8e78e ("PCI: Move PRESERVE_BOOT_CONFIG _DSM evaluation to pci_register_host_bridge()")
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250825214642.142135-1-nirmoyd@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index ddb25960ea47d..9369377725fa0 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -122,6 +122,8 @@ phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle)
 
 bool pci_acpi_preserve_config(struct pci_host_bridge *host_bridge)
 {
+	bool ret = false;
+
 	if (ACPI_HANDLE(&host_bridge->dev)) {
 		union acpi_object *obj;
 
@@ -135,11 +137,11 @@ bool pci_acpi_preserve_config(struct pci_host_bridge *host_bridge)
 					      1, DSM_PCI_PRESERVE_BOOT_CONFIG,
 					      NULL, ACPI_TYPE_INTEGER);
 		if (obj && obj->integer.value == 0)
-			return true;
+			ret = true;
 		ACPI_FREE(obj);
 	}
 
-	return false;
+	return ret;
 }
 
 /* _HPX PCI Setting Record (Type 0); same as _HPP */
-- 
2.51.0



