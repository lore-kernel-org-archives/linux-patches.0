Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235BB30F7E8;
	Sat, 12 Sep 2026 07:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199304; cv=none; b=g1o8ML2ndXe2drFNtQ01TmU9yuScmdeNDYs4WfUkFN2Q/W+kTz7SRa4mvV84RUbRUz/Iuh1FSw0bnxDqZdMYGb+fCXrYE9MAYmIfzasIiJR+xp1+kHlC75FH9t0o6Zpk/O55FDYO8Ous9gWSBQvY/b67g+DXi8HY7b/05+W4izg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199304; c=relaxed/simple;
	bh=hcMzpol+aLuQM3BuPP6srdLQUxQxZUjK2Xgl8qJlIVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt20RpEXf3CfBhIarcNxkhqmZH879YMN798HZAGMIFJUMquzuzeeARgvPILiiKbtvSejts0qqTy8hE4c3xNMKzYDU819A7JBCcZlRndNRXepbeCK7dFjcfxLh6vB4LLcolZzmhGMQhjDgkSNWgTglcaRrr+lBtWVjus7xje8zCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXGUbt89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXGUbt89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEC71F000FF;
	Sat, 12 Sep 2026 07:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199303;
	bh=EK8ucq5K9W2GYoCyWKiv8cZnaFf/6JGZkgDtMyZfsn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXGUbt89zda5vHggTJAO36h9oL28dzXW7wu7SaLVb3ou9IIoiEDBl7AQkUu/dF++P
	 eu5RuslP4us4A2CFbWT22Ax3uqQpGtb2UZOIiGkuUZBG0mw6KNKKbVfs9yE9wMPKMp
	 P7QzluHdzLsBuK/EH4tOZyNES9oPXE528ZkT9EtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0558/1815] ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root
Date: Sat, 12 Sep 2026 08:38:28 +0200
Message-ID: <20260912065701.982545254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 8a742141f7ab84975aa758b775567ef4740ef0cf ]

acpi_pci_root_add() assigns the freshly allocated root to
device->driver_data before dmar_device_add() and pci_acpi_scan_root().
Both failure paths reach the end: label where root is kfree()'d, but
only the pci_acpi_scan_root() path clears driver_data first.

When dmar_device_add() fails during a hot-add, root is freed while
device->driver_data still points at it.  The ACPI core does not clear
driver_data on attach failure, so a later acpi_pci_find_root() call may
dereference this dangling pointer.

acpi_pci_root_remove() has the same problem: it frees root without
clearing device->driver_data, leaving a dangling pointer behind after
the root bridge is removed.

Move the NULL assignment to the shared end: label so every error path in
acpi_pci_root_add() clears driver_data before freeing root, and clear it
in acpi_pci_root_remove() as well, so the object is never left reachable
through driver_data after being freed.

Fixes: db89b4f0dbab ("ACPI: catch calls of acpi_driver_data on pointer of wrong type")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260526025118.38935-1-cp0613@linux.alibaba.com
Link: https://sashiko.dev/#/patchset/20260707121258.11640-1-cp0613@linux.alibaba.com
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://patch.msgid.link/20260715135048.3278-1-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4c06c3ffd0cbb..408ba12362a79 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -725,7 +725,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		dev_err(&device->dev,
 			"Bus %04x:%02x not present in PCI namespace\n",
 			root->segment, (unsigned int)root->secondary.start);
-		device->driver_data = NULL;
 		result = -ENODEV;
 		goto remove_dmar;
 	}
@@ -765,6 +764,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (hotadd)
 		dmar_device_remove(handle);
 end:
+	device->driver_data = NULL;
 	kfree(root);
 	return result;
 }
@@ -788,6 +788,7 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_unlock_rescan_remove();
 
+	device->driver_data = NULL;
 	kfree(root);
 }
 
-- 
2.53.0



