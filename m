Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BFE52F7C;
	Tue, 23 Jan 2024 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969929; cv=none; b=QNgayzPpRmJ3XbxjAvl4e/1hqjRqxXNfYDwS1XjdkbfYq+PcG00BvYPKg1Gb3VXNn+v5WBK29VbEicRZXM1oxycH/4UICVHPuqzoSjQ9uKjKvkWop5lBr/vtDz/oeakbHuY7HKQN1dYXx6iarNFmLBMEOVZiHrX/nphFoEh3Cfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969929; c=relaxed/simple;
	bh=VooucQcIgDapA7yu2x4XtrcljtZUlAx7HN1gwSd+9KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojl8d4zGHFqrr8BXdFw4OUsHaqeLqLX7h6r10xgbIpeKyvXV0iVhQLQlMU1EFxBth+KKGGkbsbpb5CPlrg+DpFPBVvErgs4xn65GUx9RtsBJRa6KtzQpWx16OEoLSbqjNz4k3nu7u4VOaUbb+mnx4s/chWxFupkzdjEJB59tKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAHXxeye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAHXxeye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC8DC433C7;
	Tue, 23 Jan 2024 00:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969929;
	bh=VooucQcIgDapA7yu2x4XtrcljtZUlAx7HN1gwSd+9KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAHXxeye7C94TcCZRTsaXeMHz9EPXHGCiFLDum0Vib/HzaHLd3oWDj63yIEzxrx47
	 UH5wTGYLZSelPmlO30Xy02ZJXLfFd1PLybhYE+6h1oH0qRK1NcXGWnZv5m+ambn9Gd
	 foZsJfSQIv8ZKmHLlFVCtF9Fjajgvw/66e4j5Rng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 504/641] PCI: Avoid potential out-of-bounds read in pci_dev_for_each_resource()
Date: Mon, 22 Jan 2024 15:56:48 -0800
Message-ID: <20240122235833.844032233@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index dea043bc1e38..bc80960fad7c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2130,14 +2130,14 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma);
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



