Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8840A24E4BF;
	Tue, 29 Apr 2025 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950339; cv=none; b=CWTDDw2Q0KYPmN4xv9p17f1MGUnLvbNOLDmZ4pk3t43EZQXu1gwKk/P4Kcpi20hxwh6IKqSaXnaOR147O4PbXUTFwmJzlCDFUYfrWIqYhvWRJvF7rbIpy/lB5FzdXHiKB8Qqge7ZKBM6DeXz99beomYay29/x181utqj6NN9tnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950339; c=relaxed/simple;
	bh=r/BfWwW3mtkgU5ksuOY4XnoKfUxe8VOdN0yWimA2TaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCZZTAZHOIQNeFUv+/jm5ymA5bs7GLlRZUw0H6BCZzPWbRs4V7hbnfLB9HM6cfdBCekT/14q5pMcv5OkNoSeEZILPnTdk7k8zUwgaRVafkfVY/GxSAzf6QvI1HYE5pA9uxBEhQOPrsT6WKfwIEFzWEzp6xPDlyyyG8mmjvCpHHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16We9fjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16We9fjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CC6C4CEE3;
	Tue, 29 Apr 2025 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950339;
	bh=r/BfWwW3mtkgU5ksuOY4XnoKfUxe8VOdN0yWimA2TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16We9fjv0xCL1O7aAbnX8bJ0V9s/3bFJJ9QWa1FSq1CnFWP2jviuD0HWzNt6d9tVa
	 v7WSvuVAtA4A5X+6iqYO5JXPqDh0CFRIIBnjtHiHTlbFzTKyHd10ZXEugi0OMtbw9e
	 3ZHvikbcUfagj9MeKn+N0pagcrTiwN5VzA0Z0KR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/204] PCI: Fix reference leak in pci_register_host_bridge()
Date: Tue, 29 Apr 2025 18:42:03 +0200
Message-ID: <20250429161100.847233849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 804443c1f27883926de94c849d91f5b7d7d696e9 ]

If device_register() fails, call put_device() to give up the reference to
avoid a memory leak, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250225021440.3130264-1-make24@iscas.ac.cn
Fixes: 37d6a0a6f470 ("PCI: Add pci_register_host_bridge() interface")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
[bhelgaas: squash Dan Carpenter's double free fix from
https://lore.kernel.org/r/db806a6c-a91b-4e5a-a84b-6b7e01bdac85@stanley.mountain]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8e5d818c29a98..b7cec139d816b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -885,6 +885,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
 	struct resource *res, *next_res;
+	bool bus_registered = false;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -948,6 +949,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	name = dev_name(&bus->dev);
 
 	err = device_register(&bus->dev);
+	bus_registered = true;
 	if (err)
 		goto unregister;
 
@@ -1031,12 +1033,15 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 unregister:
 	put_device(&bridge->dev);
 	device_del(&bridge->dev);
-
 free:
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
 	pci_bus_release_domain_nr(bus, parent);
 #endif
-	kfree(bus);
+	if (bus_registered)
+		put_device(&bus->dev);
+	else
+		kfree(bus);
+
 	return err;
 }
 
-- 
2.39.5



