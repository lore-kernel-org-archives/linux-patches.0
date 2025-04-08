Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ACC266583;
	Tue,  8 Apr 2025 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111162; cv=none; b=ROLmpkysXKcSsupLFmEOiGwgMQnOv1/i63abHKf54KdsF2wNlEck/POAvys9U5hzpwvpH606EtgJL3vTHmCdn9hAqBR32bUx6myIbsRj8tOxdakEjLt9r/B8OCM3VXAclSUYdp1R3kBDfyGqq/uK1URot+L5Sui5UgBKwdarKKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111162; c=relaxed/simple;
	bh=RRoUmBMQ+EX/khmYJ7xaESlPsBpEo1Aifa5PI9SUik0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l08GHG+N8ihezg5LvnzpHc1CgGFrHwAKlYH7G0EN1Hd/zvbjzIRQmMhCiemggQEClHg3U7/H3XZ7OK70SdzZn3Vk3hgzJEuMit73Ih0M2hdj0dIv5Pacdt7X25jlsq6rlV/ONv/3yJJ1VEiq6ZQVV6E1Cisk0HFctayRHn4LcTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYfPGmWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYfPGmWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EEEC4CEE5;
	Tue,  8 Apr 2025 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111162;
	bh=RRoUmBMQ+EX/khmYJ7xaESlPsBpEo1Aifa5PI9SUik0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYfPGmWGyfknaBLBJAJn3fVmGbZZKqru+RauPnfsbIM2PCttfokCDMn0he3uJSyOa
	 /Cp3bVcQUhutvDaPxrxJbw4/lFrvhBUj8I2mebd0laSiCSutLPFlb1XTIJ92L6krvP
	 F7sKI2Wyt9J3gEOEHqmkgdPSJKdVwbR5EcXWC8tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 330/731] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:43:47 +0200
Message-ID: <20250408104921.951332446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6e8d06e5096c80cbf41313b4a204f43071ca42be ]

This put_device() was accidentally left over from when we changed the code
from using device_register() to calling device_add().  Delete it.

Link: https://lore.kernel.org/r/55b24870-89fb-4c91-b85d-744e35db53c2@stanley.mountain
Fixes: 9885440b16b8 ("PCI: Fix pci_host_bridge struct device release/free handling")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 246744d8d268a..0154b48bfbd7b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -996,10 +996,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	/* Temporarily move resources off the list */
 	list_splice_init(&bridge->windows, &resources);
 	err = device_add(&bridge->dev);
-	if (err) {
-		put_device(&bridge->dev);
+	if (err)
 		goto free;
-	}
+
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
 	pci_set_bus_of_node(bus);
-- 
2.39.5



