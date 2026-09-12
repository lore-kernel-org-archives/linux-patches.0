Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446634250E;
	Sat, 12 Sep 2026 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223624; cv=none; b=Qd9iQJjetJSadx5U9np54SMjdTpEBJFr56imkleybBSRlm4WQOXv/G3pF4eKcpv/H1pfFfkj8DJ6b3xW02Ai0qBFkWwFUXyefvWC2SLF5/083NQddTA0DMrbT8HEMEHaShvWJb1pS3O/pABMzt3HSHtzX3eUp3cSRT5NeLWDcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223624; c=relaxed/simple;
	bh=KTEP5A7wzv8MPUrBKVoYUVi2+UJsdfMFGqqDKwJz8uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPs895yC2fa4JcTbT4TCdrYmK6f9WLXzFpL4QlPiubwgZE+mdZLKjHqHgcVmmqdKqjOATSAGRNAp8qIXCS1xuliQsV+Zo6PGgxPOBR1tFaK3odxYYa/srh7cbeeQVEzRjDPOSQmNhDmLpSN1L+iUuu+GDMqAauR6oUAmwr6s4TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoIxexRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoIxexRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D3E1F000FF;
	Sat, 12 Sep 2026 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223623;
	bh=ZO+OZpny7ieXgytNwnwImNl2fiWSe2fpJVKOD26N2UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoIxexRuTBTgtYWhRvSMQG32ff0fnfpCZvRoe5lVC0dQrsDJcDNHQ/HcjM3bSy19d
	 9u8QiL1KwyCfBpsWf4bjZBWsyCY/PZ/4C/LEKzkkMzN6KZ/Bih3oG9ZfHWjNIwrxXD
	 UHWDnwKwae5ITySwVmjJrt9wURtx26nnksu8PV4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0828/1424] ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root
Date: Sat, 12 Sep 2026 08:54:20 +0200
Message-ID: <20260912065625.850626445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 84030804a7633..e9ec4eb16051b 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -735,7 +735,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		dev_err(&device->dev,
 			"Bus %04x:%02x not present in PCI namespace\n",
 			root->segment, (unsigned int)root->secondary.start);
-		device->driver_data = NULL;
 		result = -ENODEV;
 		goto remove_dmar;
 	}
@@ -771,6 +770,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (hotadd)
 		dmar_device_remove(handle);
 end:
+	device->driver_data = NULL;
 	kfree(root);
 	return result;
 }
@@ -794,6 +794,7 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_unlock_rescan_remove();
 
+	device->driver_data = NULL;
 	kfree(root);
 }
 
-- 
2.53.0



