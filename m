Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4186023EAB2;
	Mon, 23 Mar 2026 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277627; cv=none; b=TS3hNO06qVEq2egCXV2CsCqMub1htxDE9+ECIhyUsATXtHWzsDrMmeMpRpxAjRK1Swf3Vc1VCgnUHfF3hyORaOpYwLAN5viv+fCWT+EaOwbqQQBv7g/pUMSwE3RnpX8S1fcNoGfM3mU4/m+8MFbpCUcqpEiBOtYjQAZ9ulbobR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277627; c=relaxed/simple;
	bh=YAkFAIPja/bHBwdBvVG2t6q5N6vBkHuyL8Aiay7lYtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uh1KMs56m1pv2rK+54k6lMYsswsYo0ZKBAUEKtdmgNrg8fcvSxvGGZ8TAki0qPfgMLKOIJNwwNzkTLGvIGuS/M41eCHOwnw5mDjOofSXhzPLtWBMTD6ijUMpXi5FqA74esRVbsrkfjlGss6zhs5JrONEvFPL/k7dauYfmba1Wlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPzs4g2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPzs4g2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EAAC4CEF7;
	Mon, 23 Mar 2026 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277627;
	bh=YAkFAIPja/bHBwdBvVG2t6q5N6vBkHuyL8Aiay7lYtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPzs4g2C2R2vFmNghoYzAbFU1cUHqbeGrGqsdxl7ZgZRJueuUB9HvbqOEAPBaP/dq
	 QSwNY8hH16HNNgUyqTtNCDUvWp7bV262LwaKbGbHL9Toig+afUWtapMckNd1YtWSRK
	 BwNBSi++UoG6WrFV4M6UuCKMr30sEYhae5xC3YoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/567] PCI: Update BAR # and window messages
Date: Mon, 23 Mar 2026 14:39:10 +0100
Message-ID: <20260323134534.525791528@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay12@gmail.com>

[ Upstream commit 65f8e0beac5a495b8f3b387add1f9f4470678cb5 ]

The PCI log messages print the register offsets at some places and BAR
numbers at other places. There is no uniformity in this logging mechanism.
It would be better to print names than register offsets.

Add a helper function that aids in printing more meaningful information
about the BAR numbers like "VF BAR", "ROM", "bridge window", etc.  This
function can be called while printing PCI log messages.

[bhelgaas: fold in Lukas' static array suggestion from
https: //lore.kernel.org/all/20211106115831.GA7452@wunner.de/]
Link: https://lore.kernel.org/r/20211106112606.192563-2-puranjay12@gmail.com
Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 11721c45a826 ("PCI: Use resource_set_range() that correctly sets ->end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d7d7913eb0ee9..e3612e0e35639 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -850,6 +850,66 @@ struct resource *pci_find_resource(struct pci_dev *dev, struct resource *res)
 }
 EXPORT_SYMBOL(pci_find_resource);
 
+/**
+ * pci_resource_name - Return the name of the PCI resource
+ * @dev: PCI device to query
+ * @i: index of the resource
+ *
+ * Return the standard PCI resource (BAR) name according to their index.
+ */
+const char *pci_resource_name(struct pci_dev *dev, unsigned int i)
+{
+	static const char * const bar_name[] = {
+		"BAR 0",
+		"BAR 1",
+		"BAR 2",
+		"BAR 3",
+		"BAR 4",
+		"BAR 5",
+		"ROM",
+#ifdef CONFIG_PCI_IOV
+		"VF BAR 0",
+		"VF BAR 1",
+		"VF BAR 2",
+		"VF BAR 3",
+		"VF BAR 4",
+		"VF BAR 5",
+#endif
+		"bridge window",	/* "io" included in %pR */
+		"bridge window",	/* "mem" included in %pR */
+		"bridge window",	/* "mem pref" included in %pR */
+	};
+	static const char * const cardbus_name[] = {
+		"BAR 1",
+		"unknown",
+		"unknown",
+		"unknown",
+		"unknown",
+		"unknown",
+#ifdef CONFIG_PCI_IOV
+		"unknown",
+		"unknown",
+		"unknown",
+		"unknown",
+		"unknown",
+		"unknown",
+#endif
+		"CardBus bridge window 0",	/* I/O */
+		"CardBus bridge window 1",	/* I/O */
+		"CardBus bridge window 0",	/* mem */
+		"CardBus bridge window 1",	/* mem */
+	};
+
+	if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS &&
+	    i < ARRAY_SIZE(cardbus_name))
+		return cardbus_name[i];
+
+	if (i < ARRAY_SIZE(bar_name))
+		return bar_name[i];
+
+	return "unknown";
+}
+
 /**
  * pci_wait_for_pending - wait for @mask bit(s) to clear in status word @pos
  * @dev: the PCI device to operate on
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 485f917641e11..dae7b98536f7a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -281,6 +281,8 @@ void __pci_bus_assign_resources(const struct pci_bus *bus,
 				struct list_head *fail_head);
 bool pci_bus_clip_resource(struct pci_dev *dev, int idx);
 
+const char *pci_resource_name(struct pci_dev *dev, unsigned int i);
+
 void pci_reassigndev_resource_alignment(struct pci_dev *dev);
 void pci_disable_bridge_window(struct pci_dev *dev);
 struct pci_bus *pci_bus_get(struct pci_bus *bus);
-- 
2.51.0



