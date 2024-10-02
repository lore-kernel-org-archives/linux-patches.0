Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B71D095D;
	Wed,  2 Oct 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879920; cv=none; b=NJSf/iFppVf4aawW31pEavxNEFMZUpKLdZr8j8IJUn4J1aG0/2ZEhaB+x0N+nhAdYGJCMBDfGbB9uWcfw1rN69yXM8ZSC+BhyLBjdLDSffrnkGvIkkfudvDdBMTwSzL0Pw19uI36x662kgzJKVbu4Iock+soe7XK/AwrMkIMdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879920; c=relaxed/simple;
	bh=LgPzmxJPapMGuvk5N2ReX9RlrFbQhInLo0o8CKV9CEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcEiFZnqmhhY83hnbOypwb0J/npBRoX4HDGUCnHHrU2+zRghJsLhznzp6dAHu7wmPAr5qzCVGWgDQrAsB0BSO9q8YqVdqeiuxBkzfRVw/W1WiTLK+Lf/jfH/GxwF4AEOlDyhEePhkielJg40suyQVAjQWp3oXFT3UHMjx7Irt54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5ZWpx7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5ZWpx7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2555C4CEC2;
	Wed,  2 Oct 2024 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879920;
	bh=LgPzmxJPapMGuvk5N2ReX9RlrFbQhInLo0o8CKV9CEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5ZWpx7i4E44+kEo2syYg0vNAvG/n+Oqn3EwojZZW5QRqHLFm+Xe5uwq4bdlUbnuq
	 Jl2ggBZKIZrOyKk+s3uhjLeJdStw56im6D3mChdo3ztn6xv2iX5n03NUUoDe19rzsl
	 tiGTm//w3qYJ5sZoN1BGmPAWj5K7WKGF8kzsrBAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/538] PCI: Wait for Link before restoring Downstream Buses
Date: Wed,  2 Oct 2024 14:58:42 +0200
Message-ID: <20241002125803.426101031@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 3e40aa29d47e231a54640addf6a09c1f64c5b63f ]

__pci_reset_bus() calls pci_bridge_secondary_bus_reset() to perform the
reset and also waits for the Secondary Bus to become again accessible.
__pci_reset_bus() then calls pci_bus_restore_locked() that restores the PCI
devices connected to the bus, and if necessary, recursively restores also
the subordinate buses and their devices.

The logic in pci_bus_restore_locked() does not take into account that after
restoring a device on one level, there might be another Link Downstream
that can only start to come up after restore has been performed for its
Downstream Port device. That is, the Link may require additional wait until
it becomes accessible.

Similarly, pci_slot_restore_locked() lacks wait.

Amend pci_bus_restore_locked() and pci_slot_restore_locked() to wait for
the Secondary Bus before recursively performing the restore of that bus.

Fixes: 090a3c5322e9 ("PCI: Add pci_reset_slot() and pci_reset_bus()")
Link: https://lore.kernel.org/r/20240808121708.2523-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 53e9e9788bd54..da52f98d8f7f3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5875,8 +5875,10 @@ static void pci_bus_restore_locked(struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "bus reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
@@ -5910,8 +5912,10 @@ static void pci_slot_restore_locked(struct pci_slot *slot)
 		if (!dev->slot || dev->slot != slot)
 			continue;
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "slot reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
-- 
2.43.0



