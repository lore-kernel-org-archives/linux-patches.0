Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8706FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB460C433EF;
	Mon, 16 Jan 2023 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888828;
	bh=3umGfoUesU0Bpc2kWu35atFs2Nf2q8EV/o6o+K/LdK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8fq2G2HZuIWI2xqF2+bXIwOumVkuwLSTVxjInHOO5bow5qHnGcVVDzbEj77U0EaG
	 y1sOnLrXRojhppLngUDQicols8Qz5LRLN325ZeXcPuqN52op63lXMEe2P/AB0ubGux
	 M4VEtYGDkidiqYmssBdukPU9g41os4/VzWU5E8qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/338] hwrng: geode - Fix PCI device refcount leak
Date: Mon, 16 Jan 2023 16:50:28 +0100
Message-Id: <20230116154827.625114929@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 9f6ec8dc574efb7f4f3d7ee9cd59ae307e78f445 ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. We add a new struct
'amd_geode_priv' to record pointer of the pci_dev and membase, and then
add missing pci_dev_put() for the normal and error path.

Fixes: ef5d862734b8 ("[PATCH] Add Geode HW RNG driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/geode-rng.c | 36 +++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index e1d421a36a13..207272979f23 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -51,6 +51,10 @@ static const struct pci_device_id pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
+struct amd_geode_priv {
+	struct pci_dev *pcidev;
+	void __iomem *membase;
+};
 
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
@@ -90,6 +94,7 @@ static int __init mod_init(void)
 	const struct pci_device_id *ent;
 	void __iomem *mem;
 	unsigned long rng_base;
+	struct amd_geode_priv *priv;
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
@@ -97,17 +102,26 @@ static int __init mod_init(void)
 			goto found;
 	}
 	/* Device not found. */
-	goto out;
+	return err;
 
 found:
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
+
 	rng_base = pci_resource_start(pdev, 0);
 	if (rng_base == 0)
-		goto out;
+		goto free_priv;
 	err = -ENOMEM;
 	mem = ioremap(rng_base, 0x58);
 	if (!mem)
-		goto out;
-	geode_rng.priv = (unsigned long)mem;
+		goto free_priv;
+
+	geode_rng.priv = (unsigned long)priv;
+	priv->membase = mem;
+	priv->pcidev = pdev;
 
 	pr_info("AMD Geode RNG detected\n");
 	err = hwrng_register(&geode_rng);
@@ -116,20 +130,26 @@ static int __init mod_init(void)
 		       err);
 		goto err_unmap;
 	}
-out:
 	return err;
 
 err_unmap:
 	iounmap(mem);
-	goto out;
+free_priv:
+	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
+	return err;
 }
 
 static void __exit mod_exit(void)
 {
-	void __iomem *mem = (void __iomem *)geode_rng.priv;
+	struct amd_geode_priv *priv;
 
+	priv = (struct amd_geode_priv *)geode_rng.priv;
 	hwrng_unregister(&geode_rng);
-	iounmap(mem);
+	iounmap(priv->membase);
+	pci_dev_put(priv->pcidev);
+	kfree(priv);
 }
 
 module_init(mod_init);
-- 
2.35.1



