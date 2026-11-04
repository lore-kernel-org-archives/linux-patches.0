Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831375;
	b=2UPL8DdLbZRouoLtDswEavEkQ0cVK9vmEtXo6EtD3q3GjMiqgeDRd64dDcHY7g0uEd3N
	 1tRm9DcIYc/sK7095AH4r5Naw1Sew+XN4H88gpWmbuZpM/sCg5FAhMC++ka0bYwCDaofl
	 6aMEO6tpvo6KX9RUv2eIoEBBRO0xSIS39Nuj7L03fNuAICnRUGw3V5a3hTDsuM424mmXb
	 V4Yj7XGzSJGUY/zrfo+ZTa8opJKJs1hrPIch8tqu9vuwYTv81VaVpnRXYJyOGdnpU5+KL
	 kZ75j+QejLsKWSKA5iHvd7I96OwiqoVrkQpINktURkq+QLXcdI2AEQpw/QWlk46/IaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gYmle7aS2t1xk0848mDhicu4RHtjxI4haqd96du4XZY=;
	b=lvNuR50hWPC2GyGXlae1zYx35H7N1+9wmoxWXhQWbG0eT4TBqCqdZcFZacP0091k4CZ3
	 PLXJGsBAlZmlU6KpyKWeMXLHQzjzkCFxfm3F+frSgygdjNjk9ydcl2HO50xtU6Q7qYgVY
	 c1s15taKUR87CGz8ybKlCtyVlOfNMWcyfiE43qr4Yia+FAmKUrgSuv3q39gKSwmaDDmhV
	 fyCLw0R/E78I9QK27eYk1nnopvX9+aFXZ8jmzijW659VofqF74V/CYalX4h/HNCecAlDt
	 0TT2CwWaV30Ts+hWljlS+BQLq4FlabahUzQ840j7pR9f8w92TN1MDnMl5TcD/aY5Hag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCMKmXJS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7774A606A337;
	Wed,  4 Nov 2026 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCMKmXJS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115391F000C1;
	Wed,  4 Nov 2026 22:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831375;
	bh=gYmle7aS2t1xk0848mDhicu4RHtjxI4haqd96du4XZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCMKmXJS0H8PV6FtbI+/y15Xy8OHpUT6ginMVk5Dqc+Fvruf/K9oRaEB6MiP/7ewZ
	 WwFDwtfyr6JA+YBBndrlnRiW8msGb7umcdf8VcMAFZ50QZcARCkkrND5zaTCR88K7p
	 OncLuAjHsKEfACKffiI750tVZmxyG6viQwagJQjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 0666/1005] RDMA/irdma: avoid use-after-free in icrdma_remove
Date: Wed,  4 Nov 2026 16:06:39 -0500
Message-ID: <20261104211102.318041315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -319,14 +319,15 @@ static void icrdma_remove(struct auxilia
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


