Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31B512D1F1;
	Mon, 23 Dec 2024 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970200; cv=none; b=Dsv1ptswqY5Qlp18z2JSjUhtr3H/aRWTmwt5afx9/PhiEwG50aqCdsywS/SJa7aEnxN4LwmxyoqO6jRi1VUfY1GWzqkjkPGGkpJ5Uitw6zjklgXNqc2RFkQLWO82/8Kses5kqjDUSmYh7Br94QIJ02Hwt4gMQaBTTbptS8V+kro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970200; c=relaxed/simple;
	bh=/KrBNUcoRigN3ec2UMScbe9+t+bOPlxFqMstLqvpr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4A6wdkZJ1JaiyXnUcHCaWeV6BzHwU4E9IhgcOugCrISJ5Td4nZVIh/Ipp46Uv32LPecCT2kY3JSNLqpov62QeP141IuT9pTAeVdy/zLuAte9zg0cPzg0tjDLyn7OzaLSabVzeDq9Ub0B301mEC0FmbCMv1rQTWOs0o4jbDauq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNpMQn2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNpMQn2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B71C4CED3;
	Mon, 23 Dec 2024 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970200;
	bh=/KrBNUcoRigN3ec2UMScbe9+t+bOPlxFqMstLqvpr1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNpMQn2DWTmaTg1SeJu9TnRu4mfhbewI35mWpKuYHWKx4ANzFitqUoPZ4OULE2AHs
	 kh6+m+aOOhqF2gyi2u1JM3tWC5hz8K4XZOeJZPcgZhJlD+SpL4DCJgnp3yAlj1q4RH
	 jZzfRgQHfX3ao0akoNayNS45awYpGhJFgl6brmaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/116] p2sb: Factor out p2sb_read_from_cache()
Date: Mon, 23 Dec 2024 16:58:04 +0100
Message-ID: <20241223155400.107652643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 687e341e3206..d6ee4b34f911 100644
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



