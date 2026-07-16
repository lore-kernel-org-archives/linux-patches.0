Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D563FE357;
	Thu, 16 Jul 2026 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210738; cv=none; b=bXr973wCABOwvxvrGXmkrVQxYgd4hloKTOcRgTxk002BfezhnDN/uiOg1Sp3wo7jKkV/w4XP2NmK6zwxSMxjALBPIG1c+Gq4y9Cd9cfVRQAR5ExuAhmslg+XfcUA6NyB5D4ganEucS6hdXTgtQzrvyWgmwc2Py76ScAr5arMUIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210738; c=relaxed/simple;
	bh=wPpLvBL0565jIWCembNMkBRKRsJ4GeO+rlYpPtyW4PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuRRFiUU3Oyzp3ww/smOUk/FirIdy/mNTKO4lk829+pK7JNTZIx/lBrM5FYLP3evLrVMKu3El35GXKop7VqEDTDpCIEgN9lsdALHMYfAzdacTsDW/lujMnYyJivN0jWB4Wl/A0XjS2lRqVrdUENAPE63DdgLj4XBzxC3PW7XYG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0VxdgAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0VxdgAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691D01F000E9;
	Thu, 16 Jul 2026 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210736;
	bh=xnh92M1QRlzbdCTRn73sqNhIXw+IzswqEB9I+59ZEYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0VxdgAZSsT0qI4Rrh6SZOvQ/h8OVvbkI29gEt2TmHTNNNtaGUov4BRnV6SG5SGoE
	 n9ZOeinGjl0JCae7MwZwGas5NFPajvKv8BmtMSr/Ah3aQ64BwgLMNpDwk3FxEIXJg6
	 vPD3hgLwIgoAAewrS4OLxlgFlmYyRwV0iXlL4Vik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 161/480] staging: media: ipu7: fix double-free and use-after-free in error paths
Date: Thu, 16 Jul 2026 15:28:28 +0200
Message-ID: <20260716133048.193645275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit d3a9a8cf2d7fd61a2f63df61f6cbc0a9bb007cc0 upstream.

In both ipu7_isys_init() and ipu7_psys_init(), pdata is allocated and
then passed to ipu7_bus_initialize_device(), which stores it in
adev->pdata. The ipu7_bus_release() function frees adev->pdata when the
device's reference count drops to zero.

Two error paths incorrectly call kfree(pdata) after the device teardown
has already freed it:

1. When ipu7_mmu_init() fails: put_device() is called, which drops the
   reference count to zero and triggers ipu7_bus_release() ->
   kfree(pdata). The subsequent kfree(pdata) is a double-free.

2. When ipu7_bus_add_device() fails: it calls auxiliary_device_uninit()
   internally, which calls put_device() -> ipu7_bus_release() ->
   kfree(pdata). The subsequent kfree(pdata) is again a double-free.

Note that the kfree(pdata) when ipu7_bus_initialize_device() itself
fails is correct, because in that case auxiliary_device_init() failed
and the release function was never set up, so pdata must be freed
manually.

Additionally, the error code was not saved before calling put_device(),
causing ERR_CAST() to dereference the already-freed adev pointer when
constructing the return value. Fix this by saving the error from
dev_err_probe() before put_device() and returning ERR_PTR() instead.

Remove the redundant kfree(pdata) calls and fix the use-after-free in
the return values of the two affected error paths.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Cc: stable@vger.kernel.org
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu7/ipu7.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index c771e763f8c5..310e3f24e571 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2169,21 +2169,18 @@ ipu7_isys_init(struct pci_dev *pdev, struct device *parent,
 	isys_adev->mmu = ipu7_mmu_init(dev, base, ISYS_MMID,
 				       &ipdata->hw_variant);
 	if (IS_ERR(isys_adev->mmu)) {
-		dev_err_probe(dev, PTR_ERR(isys_adev->mmu),
-			      "ipu7_mmu_init(isys_adev->mmu) failed\n");
+		ret = dev_err_probe(dev, PTR_ERR(isys_adev->mmu),
+				    "ipu7_mmu_init(isys_adev->mmu) failed\n");
 		put_device(&isys_adev->auxdev.dev);
-		kfree(pdata);
-		return ERR_CAST(isys_adev->mmu);
+		return ERR_PTR(ret);
 	}
 
 	isys_adev->mmu->dev = &isys_adev->auxdev.dev;
 	isys_adev->subsys = IPU_IS;
 
 	ret = ipu7_bus_add_device(isys_adev);
-	if (ret) {
-		kfree(pdata);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return isys_adev;
 }
@@ -2216,21 +2213,18 @@ ipu7_psys_init(struct pci_dev *pdev, struct device *parent,
 	psys_adev->mmu = ipu7_mmu_init(&pdev->dev, base, PSYS_MMID,
 				       &ipdata->hw_variant);
 	if (IS_ERR(psys_adev->mmu)) {
-		dev_err_probe(&pdev->dev, PTR_ERR(psys_adev->mmu),
-			      "ipu7_mmu_init(psys_adev->mmu) failed\n");
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(psys_adev->mmu),
+				    "ipu7_mmu_init(psys_adev->mmu) failed\n");
 		put_device(&psys_adev->auxdev.dev);
-		kfree(pdata);
-		return ERR_CAST(psys_adev->mmu);
+		return ERR_PTR(ret);
 	}
 
 	psys_adev->mmu->dev = &psys_adev->auxdev.dev;
 	psys_adev->subsys = IPU_PS;
 
 	ret = ipu7_bus_add_device(psys_adev);
-	if (ret) {
-		kfree(pdata);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return psys_adev;
 }
-- 
2.55.0



