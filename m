Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671632517AB;
	Tue, 29 Apr 2025 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947390; cv=none; b=Z9WsMy49/h/mZgPEkCYBA23dHe7SMsaFFy+ICCIPE/fXFOePbID0A/QnVLtFzRtIzqxlQfibg7X0QuiuowHQeqeTqGzZqN0/whoHGEFxglQ9Fe5n1WC2/WXsoPheTKmDHddYdF+WR9dLNXXaL88VsVOO4WUAOLohIFyEfMRyrT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947390; c=relaxed/simple;
	bh=qLkos9oujeK89+QgcbIVNVN6KicJpS8xlQKgvcUcQl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaIioiS+XIPNqKw4ifPaqctXKGoTL1zJDGTGUxoyvBrmsy+MCqcqAIB/zSF2wlBVj1DVX1+U3A6KrYYyNE+6q4C9DiBKlRlbA7QmnRN2mFnDgGm4n+13ItEykqKjlig12DHwisxBuRNcLDUY9Hp9miSCUCaVdhEMMy/5VU3PP4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpORfH7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpORfH7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96A0C4CEE3;
	Tue, 29 Apr 2025 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947390;
	bh=qLkos9oujeK89+QgcbIVNVN6KicJpS8xlQKgvcUcQl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpORfH7v/dLPuQmJKZDZrBwb0szhTIW2BB7OQJ/qTQoKjMY2nYdzkEUuJy3ucuAjN
	 1k/R+Hi7VkcKkv3kso5jZOB/hUXnjT+jD62y5jCpuTnf3IvxvCKz5oivXFMqEkoUxJ
	 Waw2Xkf8ozgLlvWXaJQ19gunmL93aOu+aCmuLK8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/286] PCI: Fix reference leak in pci_register_host_bridge()
Date: Tue, 29 Apr 2025 18:42:09 +0200
Message-ID: <20250429161117.196644688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 012ca242bedf4..7f3d10957eca7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -883,6 +883,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
 	struct resource *res, *next_res;
+	bool bus_registered = false;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -944,6 +945,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	name = dev_name(&bus->dev);
 
 	err = device_register(&bus->dev);
+	bus_registered = true;
 	if (err)
 		goto unregister;
 
@@ -1024,12 +1026,15 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



