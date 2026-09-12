Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45703345EB5;
	Sat, 12 Sep 2026 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242664; cv=none; b=Okm5GJR/ZaDMUYRECIFywHtnni3PDW2u71AtgCDbIdD3BXdriBnqayAvV4++kb8opobCgEmILIWRi6xly3T45P0u/kPgzAtD5gKr93jAd0QWQQR8Mv1BXkdJ4INE5lNxXEwcMT8tf37bC41jPcX7Wy+pPVD/fSHmm2+/mZAepD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242664; c=relaxed/simple;
	bh=zmZIWy54c1mzrW4TkosrvR8/SBJlwallOr1ks9eapG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhQ9J+r1q5kDdh0GQ2+YzpAcciu/iJ7JAtQTkRHQQLEOc11XMf6o6o/G5lyVKX/mi5KcZ50H8r8ZkOgPFR1mX0LnbM2ygEivB0pLkrHpniWnL4WxIsU5NWdbFG0CbXr1zpU2OB99IZTJ7Ag9xohA8iCkQMHbsLdC93V6BAIfdt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSD3M9cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSD3M9cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B6B1F000FF;
	Sat, 12 Sep 2026 19:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242663;
	bh=8HIWbjA+TIYhmUpBjqZT8fhocF1XfUL+l+c9KmQXnlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSD3M9cuMMO1EEKCg0mFt0MgT5Rrt7N1law4y9ZomhGs2fCrTpdSEuFWI8QUn3JPb
	 JIeKb32EfZtDd1efsU7b4UbrK9l1xanm/3XKD926B0LlAcTxvogFEE2c3ZTKYnyd4C
	 76BNS1Z1kce4T+DZ6Xyfd9I5qCP0hMaGDb0xtJPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/798] ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root
Date: Sat, 12 Sep 2026 09:01:52 +0200
Message-ID: <20260912065528.234457092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d972ea057a035..326c3169320ce 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -609,7 +609,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		dev_err(&device->dev,
 			"Bus %04x:%02x not present in PCI namespace\n",
 			root->segment, (unsigned int)root->secondary.start);
-		device->driver_data = NULL;
 		result = -ENODEV;
 		goto remove_dmar;
 	}
@@ -645,6 +644,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (hotadd)
 		dmar_device_remove(handle);
 end:
+	device->driver_data = NULL;
 	kfree(root);
 	return result;
 }
@@ -668,6 +668,7 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_unlock_rescan_remove();
 
+	device->driver_data = NULL;
 	kfree(root);
 }
 
-- 
2.53.0



