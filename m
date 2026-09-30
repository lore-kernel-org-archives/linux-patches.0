Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71423AF66E;
	Wed, 30 Sep 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790870; cv=none; b=TSW0JGJ57MH/QyXqK6L9+1i1iYppdkPu9iSdfgs3YpoeIh0VzkHAFfTZjaA7kIj3pJItLiU6bZoU3sdKRVKD0aCFvV0uBT2TBYbPBl7CyzevJsE8bvcL4DsZOIM1JDJSBxb/NcT3bDgHLPV/fqk78GgGsvtGV63pEiz91YYSnOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790870; c=relaxed/simple;
	bh=eRXjl10Dllx4nK00fhrMFBoXCtYJGI5NaIVTy3K/GYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWpxyPAE3ncToVUFbnkHDnb86LskDlsL8M2eZUDCFbD341u3cQWQbbGBJqVDCYG2O7WZZebAgjU1vlux6TDNoY4wBYsATSEYjPAWa6v2sqCoFqTTdOE0KRE4DWABpTDprfD8oIJfLWeYKn6yKoLAc5vAUJGtzT/r/QN4YMP43LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+qKuzRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+qKuzRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7871F000FF;
	Wed, 30 Sep 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790869;
	bh=C7j8NrtA6/34rin1wPchEWJlvZlKt2EDK145FmqM490=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+qKuzRFhqw1elik2MN8BB3mThvI1gEKw1XZ7cHhzi1slPVkfREtBITHr9a5y6pdu
	 vCC3woi1s3my0EpsFzIQfP2h0jEwYSfd8ut7yMEiEJRmMp4eI5rUr4UFMXkpuTQnXK
	 suFo5AUstEHknh9Y5XEZQFwVHxUk02EjS5Po3DEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Dan Williams (nvidia)" <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/752] ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach
Date: Wed, 30 Sep 2026 17:19:33 +0200
Message-ID: <20260930152400.395891833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 19ce7cb7512b5..4b3aae4d9bef0 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -628,6 +628,10 @@ static int acpi_pci_root_add(struct acpi_device *device,
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



