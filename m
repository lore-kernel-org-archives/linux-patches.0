Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D434F4D06;
	Tue, 13 Oct 2026 12:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893553; cv=none; b=kIionxJ48LYbm+1I391TXmWBWUbcdpwQ99lxYtHN4aCY6ZrHINjBO7s1r8cFAG2Tx9GIAxx+J+s7YXVF7NgzJHdqKQTFpyOYwoedf5xI5hCzYQlYym+0FvOor4hICdnPfyeqzef6Gb0cw9lXXZEmk/HL6hvydX3gCss60avWJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893553; c=relaxed/simple;
	bh=HRU8nFCdfOh5HRjI6MdDgxfOFibiAYoIAo5u1OO51JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDJa8aKHYiyLwwRFeBehHfE7CzQjACNofKyPznQCF+4wqAXF/wSqgB7rxI+eoJHQ+tcAO8+qYsFGEdE6gIVRHmVeCuJNMbjEyXFV7UqFsUobYGQV+kThNHvIl2NPHROOzxqXpkewAWWuZm4as3aEJAQbj34WRz8iX02p2zqtU3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsJu6MoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsJu6MoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6871F000FF;
	Tue, 13 Oct 2026 12:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893552;
	bh=9NiVndRo9yz6SdMuchig2PYDIBozrRs01dIBRZqzI0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsJu6MoUDGZpGVblnn54WiYC3Gdo65qfPe0FB4fgh2hXyS5y0l+KWjqZm7odYXuTx
	 soPPWflJb56CZIVUdnP7qTfwsYuNG+mOr0uxgFcYfXp6jFoqrz/DxuZpyOA+Sk4Hs6
	 SkQxtQAOhIZqTOHjCOY17+exyL5zEbOd+DN3x0FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/621] bnxt_en: Handle partially initialized auxiliary devices
Date: Tue, 13 Oct 2026 13:34:20 +0200
Message-ID: <20261013112927.148146221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 1cb8553c02e93e5a150cebd42f9ee3db0ece4707 ]

bnxt_aux_devices_init() calls auxiliary_device_init() before all fields
used by bnxt_aux_dev_release() are initialized.  After
auxiliary_device_init() succeeds, later errors must unwind with
auxiliary_device_uninit(), which invokes the release callback.

The release callback assumes that aux_priv->id, aux_priv->edev,
edev->net and edev->ulp_tbl are all populated.  If allocation fails
after auxiliary_device_init(), the release path can otherwise dereference
or clear partially initialized state.

Allocate and attach the bnxt_en_dev and ULP table before calling
auxiliary_device_init(), so the release callback only sees a fully
initialized auxiliary private object.  If auxiliary_device_init() itself
fails, free those allocations directly because device_initialize() has not
run and the release callback will not be invoked.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 194fad5b2781 ("bnxt_en: Refactor bnxt_rdma_aux_device_init/uninit functions")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260711163716.3996929-1-ruoyuw560@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 39 ++++++++++---------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index b0ca7d194771a..1078b5ac39a5c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -558,6 +558,18 @@ void bnxt_aux_devices_init(struct bnxt *bp)
 		if (!aux_priv)
 			goto next_auxdev;
 
+		edev = kzalloc_obj(*edev);
+		if (!edev)
+			goto aux_priv_free;
+		aux_priv->edev = edev;
+		bnxt_set_edev_info(edev, bp);
+
+		ulp = kzalloc_obj(*ulp);
+		if (!ulp)
+			goto edev_free;
+		edev->ulp_tbl = ulp;
+		aux_priv->id = idx;
+
 		aux_dev = &aux_priv->aux_dev;
 		aux_dev->id = bp->auxdev_id;
 		aux_dev->name = bnxt_aux_devices[idx].name;
@@ -565,37 +577,26 @@ void bnxt_aux_devices_init(struct bnxt *bp)
 		aux_dev->dev.release = bnxt_aux_dev_release;
 
 		rc = auxiliary_device_init(aux_dev);
-		if (rc) {
-			kfree(aux_priv);
-			goto next_auxdev;
-		}
+		if (rc)
+			goto ulp_free;
 		bp->aux_priv[idx] = aux_priv;
 
 		/* From this point, all cleanup will happen via the .release
 		 * callback & any error unwinding will need to include a call
 		 * to auxiliary_device_uninit.
 		 */
-		edev = kzalloc_obj(*edev);
-		if (!edev)
-			goto aux_dev_uninit;
-
-		aux_priv->edev = edev;
-		bnxt_set_edev_info(edev, bp);
-
-		ulp = kzalloc_obj(*ulp);
-		if (!ulp)
-			goto aux_dev_uninit;
-
-		edev->ulp_tbl = ulp;
 		bp->edev[idx] = edev;
 		if (idx == BNXT_AUXDEV_RDMA)
 			bp->ulp_num_msix_want = bnxt_set_dflt_ulp_msix(bp);
-		aux_priv->id = idx;
 		bnxt_auxdev_set_state(bp, idx, BNXT_ADEV_STATE_INIT);
 
 		continue;
-aux_dev_uninit:
-		auxiliary_device_uninit(aux_dev);
+ulp_free:
+		kfree(ulp);
+edev_free:
+		kfree(edev);
+aux_priv_free:
+		kfree(aux_priv);
 next_auxdev:
 		if (idx == BNXT_AUXDEV_RDMA)
 			bp->flags &= ~BNXT_FLAG_ROCE_CAP;
-- 
2.53.0



