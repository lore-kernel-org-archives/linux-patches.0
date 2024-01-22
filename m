Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1B6745F0;
	Tue, 23 Jan 2024 02:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975506; cv=none; b=nnVWHCEbxWWxScbam7mNHT4eUW6HDZcgs0EL5d/gnechSkHEnunC9mRgy9ZesmuNMYLV+61kGq0NmP0spZqjDiQGO/8eXYTahz77MBLkRJGCQ8H1kljOiotpmhsUzMO1k2xM14YmmJg7keemFdTZi228ADOzJcOLJYElaDM4hx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975506; c=relaxed/simple;
	bh=2vatRWI28wmbIcaHzb8mSBPtB9bysN9b75iWVV2ewrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRgCy0gAysPwl2yRivQW0LB/8w3xRzKPXuWUe7xiDG6WpLnIr4sD+Qhi6wyrTCTpqHgDumD/4iU4STWXoi3Hhavi/3wnxaXyZlxwyPHpelYUBrEDigw8z0zlqgdCU7R8bKz8gYLvPNIJaCkgYxnBWqbLelK2LdBJokHyKyT/oY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4eqJauU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4eqJauU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6107AC433F1;
	Tue, 23 Jan 2024 02:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975506;
	bh=2vatRWI28wmbIcaHzb8mSBPtB9bysN9b75iWVV2ewrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4eqJauU5JI7+gnWqPZ6WoOEmG+C6+UsOrsdBjvdXrPSsqHB2cA9ZMebai/BcPtpS
	 xeJs7Rd8/AgNWhCCLS0684vMXpPj8BCDwpNP0zFgGdtPcrdKdX+DxxLPwmlgvckmom
	 ijJtqNIJdz2TifHcx5X5ukS6Nws0Xi/Q5WD0Do3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 458/583] PCI: Avoid potential out-of-bounds read in pci_dev_for_each_resource()
Date: Mon, 22 Jan 2024 15:58:29 -0800
Message-ID: <20240122235825.983987675@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3171e46d677a668eed3086da78671f1e4f5b8405 ]

Coverity complains that pointer in the pci_dev_for_each_resource() may be
wrong, i.e., might be used for the out-of-bounds read.

There is no actual issue right now because we have another check afterwards
and the out-of-bounds read is not being performed. In any case it's better
code with this fixed, hence the proposed change.

As Jonas pointed out "It probably makes the code slightly less performant
as res will now be checked for being not NULL (which will always be true),
but I doubt it will be significant (or in any hot paths)."

Fixes: 09cc90063240 ("PCI: Introduce pci_dev_for_each_resource()")
Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Closes: https://lore.kernel.org/r/20230509182122.GA1259567@bhelgaas
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://lore.kernel.org/r/20231030114218.2752236-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1596b1205b8d..3af5f2998551 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2101,14 +2101,14 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma);
 	(pci_resource_end((dev), (bar)) ? 				\
 	 resource_size(pci_resource_n((dev), (bar))) : 0)
 
-#define __pci_dev_for_each_res0(dev, res, ...)				\
-	for (unsigned int __b = 0;					\
-	     res = pci_resource_n(dev, __b), __b < PCI_NUM_RESOURCES;	\
+#define __pci_dev_for_each_res0(dev, res, ...)				  \
+	for (unsigned int __b = 0;					  \
+	     __b < PCI_NUM_RESOURCES && (res = pci_resource_n(dev, __b)); \
 	     __b++)
 
-#define __pci_dev_for_each_res1(dev, res, __b)				\
-	for (__b = 0;							\
-	     res = pci_resource_n(dev, __b), __b < PCI_NUM_RESOURCES;	\
+#define __pci_dev_for_each_res1(dev, res, __b)				  \
+	for (__b = 0;							  \
+	     __b < PCI_NUM_RESOURCES && (res = pci_resource_n(dev, __b)); \
 	     __b++)
 
 #define pci_dev_for_each_resource(dev, res, ...)			\
-- 
2.43.0



