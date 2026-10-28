Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211522;
	b=BlDJHO7z7iK4SlXSdPxX8Lx5qc9HoxIgnUxDcRkUaM4k2t16SMiXYuVp6owXW10JApqt
	 6jf75kEtIRslt9GvEKpehmO1Tv3xk95Tj9lo6mAvqVbCgO2R1WDmBWFP2i2eo/MzOZuGT
	 pZd29x92a7Icyzsp3ziySp0l+LT2NUpwRVr22J1eAwW2xtwZUdOnqFlzK5LLi7QYqFDvU
	 AYk+kALa0Z+ceR17tYmADsJ92ZJswKFxYV1e4GK0pi/0RoSUA+k/VNuchDOJkXBZv9B4d
	 MYTtuftGLJwqWdMsriw14167B5VdUkcJCaKQOXptPts6msHpOw1V3qBXpJ2sOBhP9zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5pP99jXXM8c63mYdseTcadOhP73EDMDe/gpeIFskLR4=;
	b=aPtftOjRQxWojhSoatmgQPT8hL8tlKK2FaKIhLclCHD1Emz3boL8dPT4pebYBBap6nz6
	 7MFpD8L8K9671+kbDs4rq/4k0WS/YRCFJlAMHheOxhhQO3FKf39i05tZ3pk2K3pftWNYE
	 oUsKHdDxsPCpcLq/kSocfMOVNMqannr4pr6UB0R9nkrUAejVsQi2GRf4yGluMcXzp93qY
	 h5uAxW9/nQfuYufMy38r0IAqIiGheqTOTTYSAB9ahmt/naIBlTsdf0rPFeU9BEUK6STZA
	 SBmno0GmjGddLYAhj0mh9hoiyMBvk1qSajKPZ3j23gN5tRAWVQXjO41mBTfFM6VvABw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJIMMREG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22EE606A31C;
	Wed, 28 Oct 2026 18:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJIMMREG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB211F01825;
	Wed, 28 Oct 2026 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211521;
	bh=5pP99jXXM8c63mYdseTcadOhP73EDMDe/gpeIFskLR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJIMMREGRQ9LQaVCp/xFvBVEqnfIvZWYjhTlCs+HCBpRnDfvL2D8fLOErOunINqJA
	 BsbDuTsUcPD5huJG07i+NLrIL0X5WmO+caQu1iGBIb3T5Eq5a+FwRzRK2o1B5kQbRI
	 JwIk4to2eKo0MRIUtYyCigy8NMVGxbDxr5rv+zfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomas.winkler@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 405/571] mtd: Clean refcounting with MTD_PARTITIONED_MASTER
Date: Wed, 28 Oct 2026 17:59:12 +0100
Message-ID: <20261028170017.621276350@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 264725e35fbc3b67e053a405e022393a6017e6da upstream.

The logic is way too convoluted, let's clean the kref_get/put section to
clarify what this block does when using CONFIG_MTD_PARTITIONED_MASTER:
- Iterate through all the parent mtd devices
- Grab a reference over them all but the master
- Only grab the master whith CONFIG_MTD_PARTITIONED_MASTER
Same logic must apply in the put path, otherwise it would be broken.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/linux-mtd/20230731090903.770277-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1175,14 +1175,15 @@ int __get_mtd_device(struct mtd_info *mt
 		return -ENODEV;
 	}
 
-	kref_get(&mtd->refcnt);
-
-	while (mtd->parent) {
-		if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER) || mtd->parent != master)
-			kref_get(&mtd->parent->refcnt);
+	while (mtd) {
+		if (mtd != master)
+			kref_get(&mtd->refcnt);
 		mtd = mtd->parent;
 	}
 
+	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
+		kref_get(&master->refcnt);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__get_mtd_device);
@@ -1238,10 +1239,12 @@ void __put_mtd_device(struct mtd_info *m
 {
 	struct mtd_info *master = mtd_get_master(mtd);
 
-	while (mtd != master) {
+	while (mtd) {
+		/* kref_put() can relese mtd, so keep a reference mtd->parent */
 		struct mtd_info *parent = mtd->parent;
 
-		kref_put(&mtd->refcnt, mtd_device_release);
+		if (mtd != master)
+			kref_put(&mtd->refcnt, mtd_device_release);
 		mtd = parent;
 	}
 


