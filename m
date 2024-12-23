Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D12EAE6;
	Mon, 23 Dec 2024 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969772; cv=none; b=L1GgGBF/FDtCGJyNf06EluMBK04+ux/uMmtKYWYFQgIOf731OiHBpjgqcQf9IvHyaDhkG3auOx0n9hQ7mRFPZNegvNzx7tYzSMKRYLUHZgZP7F9Ox5MB2GzM2SeR2QBB0U2BMA6cxysiqaMpvhU/FzsedgurRuZVekhrCJRZE5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969772; c=relaxed/simple;
	bh=vPcpSzNwUokAxg+KG05mgZh2qQcldibrB28cVAsa/x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kzz4wC1aIrJJUlFj0huzkJRouBGh1AekdqpTcS9qoFd1LVddeu+aNRCFxlbYUOvWBZX7xsYEoMmM/5qFaM9B69b6atUnSSCSVlJRPSRwhuXm5s6GjhaqqnNs695abwTQF0o5if8Ji9j3I9H7fd7fawCmbtDLL1EiYdNiwOeHvhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/zYk6Pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/zYk6Pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D09EC4CED3;
	Mon, 23 Dec 2024 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969771;
	bh=vPcpSzNwUokAxg+KG05mgZh2qQcldibrB28cVAsa/x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/zYk6Puko2g6dqDXyfPgSf3Qt3nzT+WdHqQ1fwytZLxPduz/fO+tBu30g3WfOjIS
	 markolNFV8hMCss1xl4S7rg1u984L1/pC8jxHAMjioOtaawx+nf2Eaeupw8DD7lvw9
	 4LL59HhL8LfgilURuW3Wp5nE7A3PKnAgKc3mmESM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/160] p2sb: Factor out p2sb_read_from_cache()
Date: Mon, 23 Dec 2024 16:57:00 +0100
Message-ID: <20241223155409.000918054@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 9244524d60ddea55f4df54c51200e8fef2032447 ]

To prepare for the following fix, factor out the code to read the P2SB
resource from the cache to the new function p2sb_read_from_cache().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241128002836.373745-2-shinichiro.kawasaki@wdc.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 360c400d0f56 ("p2sb: Do not scan and remove the P2SB device when it is unhidden")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 31f38309b389..aa34b8a69bc1 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -171,6 +171,22 @@ static int p2sb_cache_resources(void)
 	return ret;
 }
 
+static int p2sb_read_from_cache(struct pci_bus *bus, unsigned int devfn,
+				struct resource *mem)
+{
+	struct p2sb_res_cache *cache = &p2sb_resources[PCI_FUNC(devfn)];
+
+	if (cache->bus_dev_id != bus->dev.id)
+		return -ENODEV;
+
+	if (!p2sb_valid_resource(&cache->res))
+		return -ENOENT;
+
+	memcpy(mem, &cache->res, sizeof(*mem));
+
+	return 0;
+}
+
 /**
  * p2sb_bar - Get Primary to Sideband (P2SB) bridge device BAR
  * @bus: PCI bus to communicate with
@@ -187,8 +203,6 @@ static int p2sb_cache_resources(void)
  */
 int p2sb_bar(struct pci_bus *bus, unsigned int devfn, struct resource *mem)
 {
-	struct p2sb_res_cache *cache;
-
 	bus = p2sb_get_bus(bus);
 	if (!bus)
 		return -ENODEV;
@@ -196,15 +210,7 @@ int p2sb_bar(struct pci_bus *bus, unsigned int devfn, struct resource *mem)
 	if (!devfn)
 		p2sb_get_devfn(&devfn);
 
-	cache = &p2sb_resources[PCI_FUNC(devfn)];
-	if (cache->bus_dev_id != bus->dev.id)
-		return -ENODEV;
-
-	if (!p2sb_valid_resource(&cache->res))
-		return -ENOENT;
-
-	memcpy(mem, &cache->res, sizeof(*mem));
-	return 0;
+	return p2sb_read_from_cache(bus, devfn, mem);
 }
 EXPORT_SYMBOL_GPL(p2sb_bar);
 
-- 
2.39.5



