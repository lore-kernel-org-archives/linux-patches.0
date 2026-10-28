Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210828;
	b=YpJW8nSfgIeWreCpMt6NI/8Y033CVTVgAFx68pQMXcMD0u4p+gaUz1oAIxjeb0KzCEQR
	 MPp6CDcFwhqoFH58eHRlR/n/qV4lyKvgMFUfC2m4fgrpujCaUOAAqSDcliiOWkfh0lrT6
	 ZTnx+/H6argeEZ5aZFNkFLe9p2XAxtWNl6SMNXSXq3yzu7gOxWXnYIy3JL7ObaH8eCTWq
	 +73cxLAJ8BsiYb7v5/mSCFrIzoJ9CHPKgrdiXcTPcWcj7W4Ee+XrmCodsHJUUglBhgOii
	 Xd5rniXRXhAQcJfa7vF7zmO8DZi3bpE+JFBZmnCdyNXHv7LIkSEqvtCQNFheJJTa4XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iP54dAg2rGG1cDudCiWCSjd5pPz5h7mqC7MBJpNVpj4=;
	b=CXSJioFxvk7XUeW9JM88vVArS95W1EOuixbgRXCjl5miZP4RQsLf1DChEXiA6CEgFp9F
	 /2DldU3ivjcHECXU7VHWQPqn1hf+5OGAytSMPtA9Rnsn9hBaS+GZblEa5NJk6cfPIOWjS
	 hK5XW4XQJ3HUM2vZUcIAjTtD+fxLuJJiC5ibH/pI2v2gqk4tP1t7Fd5OpwpMqlboV6Kry
	 f+IWj/pfh1AeVbHGsrbibTliUXzxQKOV3CrbsSuwT6wApjcibpz1NVOraC+EAGpK/pjJi
	 qUAqKaQHa6Uz5Nj+vP/tWJy0hneWfJGKSR6LnBh5k3nZybcu3fFWgl1FCDQjCh1Fc9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgRcWu0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9339E606A31A;
	Wed, 28 Oct 2026 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgRcWu0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FAD1F01825;
	Wed, 28 Oct 2026 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210828;
	bh=iP54dAg2rGG1cDudCiWCSjd5pPz5h7mqC7MBJpNVpj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgRcWu0NhfXsvW2U3nWyO3iR5qbbFlIXrZ8OnA9/TuaFVKGzEF4oAHQvmI956oeQb
	 XbJBbpSFX+DZ9mlW7C9PoCM9yp9WRLdQe3IThc7fMt3OCdnjs/nCKHbFf+O3R6nf4u
	 oG5CwXbilYBrhyCwplPDiFUZ43X3F/cvgaIUdjf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/571] mtd: call external _get and _put in right order
Date: Wed, 28 Oct 2026 17:55:09 +0100
Message-ID: <20261028170011.861454826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 79c4a56250216991f1d965ee26dcd273376e4e91 ]

MTD provider provides mtd_info object to mtd subsystem.
With kref patch the mtd_info object can be alive after
provider released mtd device.
Fix calling order in _get and _put functions to allow
mtd provider to safely alloc and release mtd object.

Execute:
1) call external _get
2) get_module
3) add internal kref
in the get function and opposite order in the put one.

The _put_device callback should be the last in put
as the master struct memory may be freed in this callback.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230620131905.648089-3-alexander.usyskin@intel.com
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 2891150478133..5333d24b8c972 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1157,21 +1157,20 @@ int __get_mtd_device(struct mtd_info *mtd)
 	struct mtd_info *master = mtd_get_master(mtd);
 	int err;
 
-	if (!try_module_get(master->owner))
-		return -ENODEV;
-
-	kref_get(&mtd->refcnt);
-
 	if (master->_get_device) {
 		err = master->_get_device(mtd);
-
-		if (err) {
-			kref_put(&mtd->refcnt, mtd_device_release);
-			module_put(master->owner);
+		if (err)
 			return err;
-		}
 	}
 
+	if (!try_module_get(master->owner)) {
+		if (master->_put_device)
+			master->_put_device(master);
+		return -ENODEV;
+	}
+
+	kref_get(&mtd->refcnt);
+
 	while (mtd->parent) {
 		if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER) || mtd->parent != master)
 			kref_get(&mtd->parent->refcnt);
@@ -1240,13 +1239,14 @@ void __put_mtd_device(struct mtd_info *mtd)
 		mtd = parent;
 	}
 
-	if (master->_put_device)
-		master->_put_device(master);
+	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
+		kref_put(&master->refcnt, mtd_device_release);
 
 	module_put(master->owner);
 
-	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
-		kref_put(&master->refcnt, mtd_device_release);
+	/* must be the last as master can be freed in the _put_device */
+	if (master->_put_device)
+		master->_put_device(master);
 }
 EXPORT_SYMBOL_GPL(__put_mtd_device);
 
-- 
2.53.0



