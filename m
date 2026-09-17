Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969204E535C;
	Thu, 17 Sep 2026 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664179; cv=none; b=G69ObLyUJ+jU0X+Ft21kL/HVeo6dT7pxphvJzst4yjBhW3tnzPlraLsxkEZq1hK7aLtCVc9V6h+Av/DEQ5HnpOwEjJAyz3hSxSA0EERcaI7yt4Eykl96U6V3OQGrCoO2ZcluS+YXcB4J7qL2wgzIlNHvOZnNnItQTvN0mltHtBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664179; c=relaxed/simple;
	bh=z9xPQLKsYgaBB8IiAAK4jU3A+Uke61fwu58HE+plqW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfizEqQfi1wV1ow5C1Cfg/z34dX6aAqwPTUGYIUdzB8Eve7BH4S1dqfsWqHjD44v8e4vgTj9YGOTJeInHvXP1oqoQkw2JUi8GLWLnnTqN1oDCRMfe982jd9I8r4ifd+ugBqebRkSMoNM7fCqXFMVahsabxjNV9+nta4gph03aWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXyFsVcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXyFsVcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0621F00893;
	Thu, 17 Sep 2026 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664178;
	bh=+yMeFjHojmGT1m3fVUWwiP84TS5VeVokNq5EfQhACYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXyFsVcOII96XVWrj0NPfTpRTTEUSd5SNq0jxssdlX4MLZzom1rvSAVSOR8VGcBRF
	 KEvnd6wnuKb6vRCh16xRPDdkxE9teK6Jo1/KVAez2rvG2AbC36n8FaZ9xkrzBsQcrP
	 Euy7ADirhIRCgINYkVEoEXORS0u8ClvPL+IBnnhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Dan Williams (nvidia)" <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0284/1250] ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach
Date: Thu, 17 Sep 2026 16:01:19 +0100
Message-ID: <20260917151559.831758549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 3a59c3b772e5dc0cedecce8e7fbf7c2d6245b643 ]

PCI root bridges enumerated by acpi_pci_root_add() can be the _DEP
supplier for other ACPI consumers, most notably ACPI0017 CXL root
devices whose probe path depends on acpi_pci_find_root() succeeding.
Once the root bus has been added, those consumers can safely be
enumerated, so notify them by clearing the dependency.

Call acpi_dev_clear_dependencies() at the end of acpi_pci_root_add(),
after pci_bus_add_devices(), following the same pattern used by other
ACPI suppliers such as the EC (drivers/acpi/ec.c) and the ACPI PCI
Link device (drivers/acpi/pci_link.c). The clear is intentionally
done only on the success path; on the error paths the supplier did
not attach and consumers must keep dep_unmet set.

This is a prerequisite for honoring _DEP on ACPI0016 host bridges,
which matters on architectures where the probe order of acpi_pci_root
relative to cxl_acpi is not guaranteed (e.g. RISC-V).

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Suggested-by: Dan Williams (nvidia) <djbw@kernel.org>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260526025118.38935-2-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 32b868bd8487b..34b53dc892b21 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -759,6 +759,10 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	pci_lock_rescan_remove();
 	pci_bus_add_devices(root->bus);
 	pci_unlock_rescan_remove();
+
+	/* Clear _DEP dependencies to allow consumers to enumerate */
+	acpi_dev_clear_dependencies(device);
+
 	return 1;
 
 remove_dmar:
-- 
2.53.0



