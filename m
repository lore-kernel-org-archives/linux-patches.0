Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA50D332610;
	Sat, 12 Sep 2026 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198653; cv=none; b=mGdNgybWZxTWJXvKhcaMdXZGgym3v7aMAp4TplFuAkSH3WNzOZCukFTE+yZbmNf6HSqFJlwGsbmyqVuYO/Tm1FYBi3yu/Ao4SoPwzZlHKANyjRj4km+w5ILSMctD0xYe5x/H/jrbfIrf2hT8co8zheYc1ZxydEDV/y6MAn4Ysao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198653; c=relaxed/simple;
	bh=OQrurZhHjPy/cM24JP1UMQ8WdHBpZp7YveKtLnpK2O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3TnQn0pZE64xxqnHtZ1IH/Td8ifZFfIsm5jbjwjzXF4rpgWUbxnLAndcUHS41m/1DZ0tWMqgejjrYxAun1XeGHzyipxLLf9SfLIafknz1iwuby3heM9CaUxwWWnu2AQVmN9kSmgqX2MGO7l/kFnFXXvjwRzgcar4iMWIhEfJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7U3Mbpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7U3Mbpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418BE1F000FF;
	Sat, 12 Sep 2026 07:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198652;
	bh=/Y6h1ok6p/YqOB5sCTu0BtWKJeZK8jJ80FcHU/OaLyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7U3MbpyxQJ2VpKfme8qgdwvsOev+pFA0XWhO2wFnEZOViQAV7rG5m7zAFFsEZd5h
	 eaiGD4DVtN9SU5awV6s3VTGARvc6sxKgsUI03MEWucV9US0CbQ/V3tpOElNwHr+/tS
	 1dRhYikgJymnpzcavKk0i8XOZxIdh2JVhoXL7F4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0426/1815] PCI: keystone: Fix OF node reference leak in init
Date: Sat, 12 Sep 2026 08:36:16 +0200
Message-ID: <20260912065658.896246184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 3260336defeb292a91de29e4d1d93469e3cec663 ]

of_find_matching_node() returns a device node with its reference count
incremented. ks_pcie_init() only uses the returned node to decide whether
to register the ARM external abort fault handler, but never drops the
reference.

Store the lookup result in a temporary variable and release it with
of_node_put() once the existence check has been made.

Fixes: bc10d0ad540d ("PCI: keystone: Add support to build as a loadable module")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260630202938.1877632-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 278d2dba1db08..f1b27aed488de 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1389,13 +1389,17 @@ static int ks_pcie_fault(unsigned long addr, unsigned int fsr,
 
 static int __init ks_pcie_init(void)
 {
+	struct device_node *np;
 	/*
 	 * PCIe access errors that result into OCP errors are caught by ARM as
 	 * "External aborts"
 	 */
-	if (of_find_matching_node(NULL, ks_pcie_of_match))
+	np = of_find_matching_node(NULL, ks_pcie_of_match);
+	if (np) {
+		of_node_put(np);
 		hook_fault_code(17, ks_pcie_fault, SIGBUS, 0,
 				"Asynchronous external abort");
+	}
 
 	return platform_driver_register(&ks_pcie_driver);
 }
-- 
2.53.0



