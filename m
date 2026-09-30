Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B2D3B776D;
	Wed, 30 Sep 2026 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794386; cv=none; b=iVZjSAMm+aYX0sCdzQdZyt/HPOeqxcLpcrnN9dNaMOghSGznFGH8whZgXqfL1T38JZfp8wGsJe0hnRyezCDtE7zcNKzLWPA9/Sa34jh0P3i7MWUNOyy6oCOmOaLzz3vkM3frznObCPbLsEj9A6fsD+kJPBR0COiFEg3Jz3eDNR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794386; c=relaxed/simple;
	bh=P51FoTLI+BWHQbL5LtR2rwW22WwLmwxCP9GmvQvNxPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APYTRxUsaoRHaQBqsD7aahpfmqRHV3gDZ95XNUDLzYdJYERpcgy1eq7frLpbWfyZ+dHrcJYsI4ZUFAZXC8UdNhn0Orb6ya3inoRvccihVA4IoCuM2Ar5EnZnFO1xnMZPOgYVrqfghBTOWpIeng9iwlW+b0DC/wT8BytlrmtKoW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUJhc9Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUJhc9Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7081F000FF;
	Wed, 30 Sep 2026 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794384;
	bh=odwqegOxpCpZwPprQzvY+K7J6qm6aIENszeANU2o3ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUJhc9UyzLKpjS6YwUs5nPxDo4YNdAdDYonwx3ZwjgjUV2Peiq12/NN554Zvk7Ggu
	 QtpVvcvKfnMHqc0d+EQ9PnmXmdaqicApTF88D9Hj9IuXoSB84nCkFAY2hDnPT55suK
	 2CrPiIGyxgcLhROZYCiY1XsLGHWhQlxIQbr4xXIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Dan Williams (nvidia)" <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0154/1193] ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach
Date: Wed, 30 Sep 2026 17:13:58 +0200
Message-ID: <20260930152437.626972234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9ec4eb16051b..80c12398218f1 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -764,6 +764,10 @@ static int acpi_pci_root_add(struct acpi_device *device,
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



