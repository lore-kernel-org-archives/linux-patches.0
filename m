Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516C254B1F;
	Thu, 17 Apr 2025 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916168; cv=none; b=aaZ9Agwj1b/N5QR0GJrXtCykmCrkrCiIXzVqA1jUTJPaJZ8AWq5PVrOaIKmv3Oj9cbkIRTlawS2OXNrsP5+LLQgpuIJ+xRHLOOUVzfu8g/bedDG0lZ+QdwFPbqfHCnr/ktsZ1WIYGBlfgLp5wR8egk0JHge3WoFLxLmf+RKfzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916168; c=relaxed/simple;
	bh=P6LcDrEvwwZvK7tDoJ3QxATENxUovHpoZLk6wdGxdEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGswqaGJQ2ek5IOvtRswup7mmR9QlBAI55ZoiokonAs8G71nDsQQAUoURfBUjFgxnkiI4v0a2vs4IDlxs96FukmvGCMIaURe9+1Jz+yD+Z0R1BxUGzELQ0XwNEIhWeGqNlVuDwV0VWceqtR0f22PGuc8Iy0IvQ46Z1gKzqkBhtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc89yfiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc89yfiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD711C4CEEA;
	Thu, 17 Apr 2025 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916168;
	bh=P6LcDrEvwwZvK7tDoJ3QxATENxUovHpoZLk6wdGxdEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bc89yfiOuMtH+jyFGPoAvH6sWcnTJT59pWuouUAbQoFOmcSqLKRjC8Z8OJXu/Ju2Y
	 bVz+IsVzLmnAxlv4u/AyPZcwJlJRlk3QBybbxqrj2XvoqmjoAe2Cz9c8wRVgd7Yrwh
	 MVNQkLSNHYL5tACOSn2r7m8FR5V9GgjPZ08WkiNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 366/393] PCI: Fix reference leak in pci_register_host_bridge()
Date: Thu, 17 Apr 2025 19:52:55 +0200
Message-ID: <20250417175122.324751526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 804443c1f27883926de94c849d91f5b7d7d696e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -908,6 +908,7 @@ static int pci_register_host_bridge(stru
 	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
 	struct resource *res, *next_res;
+	bool bus_registered = false;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -971,6 +972,7 @@ static int pci_register_host_bridge(stru
 	name = dev_name(&bus->dev);
 
 	err = device_register(&bus->dev);
+	bus_registered = true;
 	if (err)
 		goto unregister;
 
@@ -1057,12 +1059,15 @@ static int pci_register_host_bridge(stru
 unregister:
 	put_device(&bridge->dev);
 	device_del(&bridge->dev);
-
 free:
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
 	pci_bus_release_domain_nr(parent, bus->domain_nr);
 #endif
-	kfree(bus);
+	if (bus_registered)
+		put_device(&bus->dev);
+	else
+		kfree(bus);
+
 	return err;
 }
 


