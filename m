Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63A44CF37;
	Sat, 28 Feb 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301293; cv=none; b=NGumTSZivYiIqgQ/AuETauhFLvhx/f7NMKi9ZX+iGNMrMF+l/Q4yJ1FIBwMboljSaLGSF4BJJu4XEW+Ze21Yu50KoKyFQJAQIuZ/zJ82Qz8DMV8uFdB9jCztdsZcWbsrfhpeUW9V0WfjJDBM9DdGPRneODYXNozcUbimswCNk/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301293; c=relaxed/simple;
	bh=bGfKsjF47pXSCxClllNTdVYvw3RznaUXJ4RcPFqd6Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHL1wHnYYa6sJpVN4vigEhMoZ5MYHRxciIZu6CKEufUkfNO0a9Xy+ySc+wymdreDp4A3hWBVk19M94lGls0Y73pV1w3Waosg40slCDY67PU/USorTfgLB+JjEPbHmdDHtqTOMM6IR5ManQzO2BXr3K7zRaBAocI/ZJkPyFm4yEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pb6efao6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pb6efao6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122C4C116D0;
	Sat, 28 Feb 2026 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301292;
	bh=bGfKsjF47pXSCxClllNTdVYvw3RznaUXJ4RcPFqd6Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pb6efao68YP1I6D/y7KcB/hkwmqYTxFzmn/Bx+kBA+XUSRfFK17MjvqRhgq+jTxcz
	 EUV2SgudEWy8ezWHSUxgAg4BpeKEf4Fy6miu2p3JSymRf4MkpYGtvHY3Z1dpgP3jPG
	 DyLauwBTGgwH13HWZa6+mRqR8HfB7n6qkZumyCiGi5YISgAa4MJCPzcZLRJtdpzlbC
	 QQF+5IjB3AIk/kAy3twu6cArNnkRyY4n88lxJHP8f71M9h5A3Pfw24svfsbcZicli3
	 zWB9MFJtUp5ZeFcUdmJQffYBybOvTD6g3m7AtsGj5sDqdX5QeeCtCXQqGA23wyLQ3C
	 T078PFa6xFfgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	stable@vger.kernel.org,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/752] PCI: Use resource_set_range() that correctly sets ->end
Date: Sat, 28 Feb 2026 12:43:08 -0500
Message-ID: <20260228174750.1542406-477-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 11721c45a8266a9d0c9684153d20e37159465f96 ]

__pci_read_base() sets resource start and end addresses when resource
is larger than 4G but pci_bus_addr_t or resource_size_t are not capable
of representing 64-bit PCI addresses. This creates a problematic
resource that has non-zero flags but the start and end addresses do not
yield to resource size of 0 but 1.

Replace custom resource addresses setup with resource_set_range()
that correctly sets end address as -1 which results in resource_size()
returning 0.

For consistency, also use resource_set_range() in the other branch that
does size based resource setup.

Fixes: 23b13bc76f35 ("PCI: Fail safely if we can't handle BARs larger than 4GB")
Link: https://lore.kernel.org/all/20251207215359.28895-1-ansuelsmth@gmail.com/T/#m990492684913c5a158ff0e5fc90697d8ad95351b
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20251208145654.5294-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7d4f0db5ac265..23833fd7265e2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -287,8 +287,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if ((sizeof(pci_bus_addr_t) < 8 || sizeof(resource_size_t) < 8)
 		    && sz64 > 0x100000000ULL) {
 			res->flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
-			res->start = 0;
-			res->end = 0;
+			resource_set_range(res, 0, 0);
 			pci_err(dev, "%s: can't handle BAR larger than 4GB (size %#010llx)\n",
 				res_name, (unsigned long long)sz64);
 			goto out;
@@ -297,8 +296,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if ((sizeof(pci_bus_addr_t) < 8) && l) {
 			/* Above 32-bit boundary; try to reallocate */
 			res->flags |= IORESOURCE_UNSET;
-			res->start = 0;
-			res->end = sz64 - 1;
+			resource_set_range(res, 0, sz64);
 			pci_info(dev, "%s: can't handle BAR above 4GB (bus address %#010llx)\n",
 				 res_name, (unsigned long long)l64);
 			goto out;
-- 
2.51.0

