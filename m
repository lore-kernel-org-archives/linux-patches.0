Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827020;
	b=pyvUfCtDPfCmOOuQZlYWgxK6fJARr9RjaljJPkd7l6QH5ZvH8RWb0HVSket/HFPSuK3P
	 pFuiZcvPMHR51LhvVS2M9n5pJwE3vbPwsEP+1I3Nx6Jmxm4zPOuoMcBhL1FAkkVTdEN/W
	 WfaQH92Hx/1a4EkuLiAoH2LSCVOmvWqt9EBdr0jAfzRjplgRBmVZSOjqrm40UyneuXoa5
	 BwrNF3KLmtnOl668GUGeNc6BWsFR8O4AtwtxzG0q63tpuESz1A56brTPDQaWXl64PQZd5
	 uz9N6vf6OdwQqic0INMX7qEQhPxFCiBzurpyZziDM0UEN/j68eNcvp60ssQXTqTdb0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOa2QTCuRtzKxhkNPbxE+1nXJ+rjs8ylpw0AG6Qrazg=;
	b=reg8TehodKOMV28s0mO7QH4iUG6exIePpgBRXOGKJsmTb9fI/TF4Y38U+WGv34+J6AZG
	 ATF2VsU9MA7xDGVS9ffKzC6QbwcvAcDow+1S/Ui8a/AhqxujWmKf+CRnlFLwhnd8EZJ95
	 tyzxJ4rpZLevm88FaHgLJUV2ACqxvncU/w24s8XkLdebxV1O5WdQDbsk14x9utjEfp1YA
	 BcQWZ54YpmKrq+7wJfmX+Zfjs5ypv29OZmcgeGLckx/Zdrpb8Wwm+HvnFPi8zT3L91aDD
	 8t5JJ7OSl9Uzg3vGNkna2tdht9lJQR0/pIx4iZb9lxPFypHaaRFwkBQEmHdqsNZH+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEV6684T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FC607490E;
	Wed,  4 Nov 2026 21:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEV6684T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AA21F00A16;
	Wed,  4 Nov 2026 21:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827019;
	bh=VOa2QTCuRtzKxhkNPbxE+1nXJ+rjs8ylpw0AG6Qrazg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEV6684TKpOmp5sh7q75PKQMX1OmU4sOhKqBayjz5pT9V17p5TIcLdc6Sh3aTPKpJ
	 QczMq8IbVlSnulhDwL2G3/GVSpY1QP3x4VP7bGwwVJw8rSUMB4tJo85O8ExReVUUtN
	 SQI7yZHY+3GHQlMAh+7Ya83PklFMPoDhdiKH9jcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 7.3 147/547] RDMA/irdma: avoid use-after-free in icrdma_remove
Date: Wed,  4 Nov 2026 16:05:31 -0500
Message-ID: <20261104211042.343602107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 8a8088b899e4cdfe558428cd6113d45df81625be upstream.

icrdma_remove() dereferences iwdev after calling
irdma_ib_unregister_device():

  irdma_ib_unregister_device(iwdev)
    -> ib_unregister_device(&iwdev->ibdev)
      -> __ib_unregister_device()
        -> ib_dealloc_device()

irdma registers irdma_ib_dealloc_device() as the dealloc_driver
callback in its ib_device_ops. The RDMA core explicitly documents
ib_unregister_device() that when ops.dealloc_driver is used, ib_dev
will be freed upon return from the function.

The ib_device is embedded in struct irdma_device and iwdev itself was
allocated by ib_alloc_device(irdma_device, ibdev). Consequently, once
irdma_ib_unregister_device() returns, iwdev must no longer be
dereferenced.

However, icrdma_remove() currently accesses iwdev->rf afterwards when
deinitializing interrupts, destroying ah_tbl_lock, and freeing rf.
Although the final ib_device storage is released with kfree_rcu(), the
object lifetime has already ended and callers must not rely on the RCU
grace period to continue dereferencing iwdev.

Save iwdev->rf before unregistering the RDMA device and use the saved
pointer for the remaining cleanup.

This issue was found by manual code inspection.

Fixes: 8498a30e1b94 ("RDMA/irdma: Register auxiliary driver and implement private channel OPs")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260914122840.1709743-1-lgs201920130244@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/icrdma_if.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/irdma/icrdma_if.c
+++ b/drivers/infiniband/hw/irdma/icrdma_if.c
@@ -318,14 +318,15 @@ static void icrdma_remove(struct auxilia
 		container_of(aux_dev, struct iidc_rdma_core_auxiliary_dev, adev);
 	struct iidc_rdma_core_dev_info *cdev_info = idc_adev->cdev_info;
 	struct irdma_device *iwdev = auxiliary_get_drvdata(aux_dev);
-	u8 rdma_ver = iwdev->rf->rdma_ver;
+	struct irdma_pci_f *rf = iwdev->rf;
+	u8 rdma_ver = rf->rdma_ver;
 
 	ice_rdma_update_vsi_filter(cdev_info, iwdev->vsi_num, false);
 	irdma_ib_unregister_device(iwdev);
-	icrdma_deinit_interrupts(iwdev->rf, cdev_info);
-	mutex_destroy(&iwdev->rf->ah_tbl_lock);
+	icrdma_deinit_interrupts(rf, cdev_info);
+	mutex_destroy(&rf->ah_tbl_lock);
 
-	kfree(iwdev->rf);
+	kfree(rf);
 
 	pr_debug("INIT: Gen[%d] func[%d] device remove success\n",
 		 rdma_ver, PCI_FUNC(cdev_info->pdev->devfn));


