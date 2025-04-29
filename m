Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722325393E;
	Tue, 29 Apr 2025 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949311; cv=none; b=Ssy1Qzm0TtcSx+DMI+CST8+yu7gh/DdwtRs5O3nFHGZgxiqJ/E5/wpbOiBb4kkoFN6hu2jdtLl0rH0GtWeNpFD9qJBgMcJmn6Jopt1nvX/rvM+HDCVbhB1npcaVL+UniJrrfRrwWZUubqMWe1WgU/yOeER64Alr/dm850NTrk6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949311; c=relaxed/simple;
	bh=tImWCEdNCZsqm+yWvBhVYK1ZIPabTW0Zk1ZdBfzhkHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGmP4BfgrRdabYu02kpOkkSWblovgJlDthJmXK08WtBnxpMJpfIsDbnBROhxFG3ojSQHR9nrr15KZMkyq5mK+2UTYVcWTEGpCnFkKgSy6VGmvZSIfe9Il0DGV1D37Qr+MEtv0g7umzdFKCmcppxnePmOtkYczN5cYD3DbmeYmC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P19Uz/ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P19Uz/ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ABAC4CEE3;
	Tue, 29 Apr 2025 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949311;
	bh=tImWCEdNCZsqm+yWvBhVYK1ZIPabTW0Zk1ZdBfzhkHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P19Uz/okFir107swtRe/TiWAZDapFe3nQBC/WvaHZ6O8vIt8uh5Mxmsk7Lobem5lN
	 AJVzVQaV862hg3nySk0RelAL6Vuf0u+jtXro+i8gcBxiGI1Wxf5dwoJ3qadS9iHZH4
	 HKVSR28JYRyr3EfbdGkbbpXCLPTH1rYSRGZJpS6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/373] PCI: Fix reference leak in pci_register_host_bridge()
Date: Tue, 29 Apr 2025 18:42:34 +0200
Message-ID: <20250429161134.516673855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f70d7dec3fdde..940336fa73743 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -888,6 +888,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
 	struct resource *res, *next_res;
+	bool bus_registered = false;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -951,6 +952,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



