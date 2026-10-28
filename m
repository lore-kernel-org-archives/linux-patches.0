Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211516;
	b=k+P3Sh/gNQr1dnM+VQ3RAd/HyYSFcI9c+zUG0ywbKP/5sdyWTpZxMlq7VQ8Iz3/iLzUo
	 T5RPeb/ezNXcufIfo1Qlx6OhZwYbvtoguwfXeeADFFJUAl0uUoRrwWK2ySjCpntvSLF2I
	 G+9Z5+mpd1xEa6iFZeoeE0eTkOTjmZCrI3Xwx83/nk83mU+JAuplO8N5m8qipTDy0vzBu
	 aXaMEHbTqAKMQL8GzWuc+XMBe9GIgLBmRIG45kClgPlEuR0jrC4Spg068/D8J64pkVid1
	 O+BX29BKdTlRhm5e1cFVybAOL34MMrRqo3ShfWINEZoIUnjMEWgqrqQXeuQzYuppu1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=It6+mrTasha3AW3ae+rHjqdZ41qnrFIyihuzwSvh424=;
	b=4X3xAHPwmeMclnMZRpuy15jsqPckh0Xjx2Tdbb4OSnUu3SSkKSfPOphAGBQSrggcFRGz
	 4HCpoR8HsQTynilehnsq6sPLxfr4CQZ6MPe4BDe0EAYzJp3jGrxgjBQfqWsSjdzNb54+r
	 GD2abB4srjbAj3ljLCfNag4RbBAw09xfyy7mEcB6ao8l5g/QJisXeLM9faJx0GOvVu130
	 MWWpDeZfweR/h5tBFoZVXoJnzL2OoIiAc/4lAeyMIWevZFZaSR/R5xKCrE0C035Uoseb+
	 /DNGnS2tPgfJhzIMDvmMD4wuGXH9STQvH27IYoJWOcRIjWbvRGoHr9eDql7oDdNIAGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDkkjZOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC50B606A31A;
	Wed, 28 Oct 2026 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDkkjZOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EFE1F01825;
	Wed, 28 Oct 2026 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211515;
	bh=It6+mrTasha3AW3ae+rHjqdZ41qnrFIyihuzwSvh424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDkkjZOvd7RoM0f6yxnLqGENp7AZhiFopicJFtstWHsP1uY9HhxGy9BMIUcexsrvj
	 NB5c4Vj0p+qw0qU/ZkQaI6KBtJkyaEL0+QyZVh9aDLgpPZQHbESkfuy56GOPv4tTeW
	 8Kned7px6UF3co/2yCMebnE/Dg0/SqdAiC8V2N4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.15 404/571] mtd: fix use-after-free in mtd release
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028170017.597745443@linuxfoundation.org>
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

commit e9714c22c1a8238a85d069b1517941fc723312f7 upstream.

I case of partition device_unregister() in mtd_device_release()
calls mtd_release() which frees mtd_info structure for partition.
All code after device_unregister in mtd_device_release thus
uses already freed memory.

Move part of code to mtd_release() and restict mtd->dev cleanup
to non-partion object.
For partition object such cleanup have no sense as partition
mtd_info is removed.

Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230731115836.542747-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -92,6 +92,9 @@ static void mtd_release(struct device *d
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 	dev_t index = MTD_DEVT(mtd->index);
 
+	idr_remove(&mtd_idr, mtd->index);
+	of_node_put(mtd_get_of_node(mtd));
+
 	if (mtd_is_partition(mtd))
 		release_mtd_partition(mtd);
 
@@ -102,6 +105,7 @@ static void mtd_release(struct device *d
 static void mtd_device_release(struct kref *kref)
 {
 	struct mtd_info *mtd = container_of(kref, struct mtd_info, refcnt);
+	bool is_partition = mtd_is_partition(mtd);
 
 	debugfs_remove_recursive(mtd->dbg.dfs_dir);
 
@@ -110,11 +114,13 @@ static void mtd_device_release(struct kr
 
 	device_unregister(&mtd->dev);
 
-	/* Clear dev so mtd can be safely re-registered later if desired */
-	memset(&mtd->dev, 0, sizeof(mtd->dev));
-
-	idr_remove(&mtd_idr, mtd->index);
-	of_node_put(mtd_get_of_node(mtd));
+	/*
+	 *  Clear dev so mtd can be safely re-registered later if desired.
+	 *  Should not be done for partition,
+	 *  as it was already destroyed in device_unregister().
+	 */
+	if (!is_partition)
+		memset(&mtd->dev, 0, sizeof(mtd->dev));
 
 	module_put(THIS_MODULE);
 }


