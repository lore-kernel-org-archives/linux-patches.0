Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76F40B112;
	Tue, 21 Jul 2026 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655801; cv=none; b=H9Eh0VDY3C2FYdIbOthDTp+65JK8nY+fKMYVKJ/3rVQxk+Ii3KotDdaSerGWOG+GSmCvhdkkyCMnWhCAfF6bRQybZyZq6m0TQsEYtYwn0HZ5xnwqhccgR4jFjMm8Icqij70/zEqD2baMBdcqV2ZDvKSj+bSkiNmkEXf6+Ltw8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655801; c=relaxed/simple;
	bh=xL5A6c3hG5l/YPrtmF6+H4NEAbUIXAIDhXnLCAqukv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWukFRYCO+eVyx9C0PH3KwMRQ4rzAaT/nNni/0OJA8OgfEm85n2Mz+G+pagVssaVz8IwjcQkBFJTBtZZx63fKg7n54iDLjK51EBXkQh9+RCTd/W9T6rzaoGUuNGUuEMd+xRjrV7+nbHTmY7v5ugfIt3Du8L2hDFcEgje2PsMFjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXMagQdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXMagQdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C411F000E9;
	Tue, 21 Jul 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655799;
	bh=Z5V/o8izt2qVD0W2bDgv6rOG76dETDigHcjn2mbSKdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXMagQdi6oshHucUweatukYN6XFL2v0MwIHPQQnPCWGAYjPcxknATm/QOtM+A6DfQ
	 W03FRv0m4j3kgm5im0i0YPE5wAG+ZPqDQ7J6D6p4DCgJVzpqJNEY0uZIFf3sx71dEg
	 RhDPSl+lh3RgSkMrB38n1JfRounaG6bainNdzDgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0103/1611] crypto: qat - fix heartbeat error injection
Date: Tue, 21 Jul 2026 17:03:39 +0200
Message-ID: <20260721152517.161758009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit 2e96024632b386c86860aa78639940fc96d6fcc9 ]

The current implementation of the heartbeat error injection uses
adf_disable_arb_thd() to stop a specific accelerator engine thread
from processing requests. This does not reliably prevent the device
from generating responses.

Fix the error injection by disabling the device arbiter through
exit_arb() instead. This properly simulates a device failure by
stopping all arbitration, which results in missing responses for
sent requests.

Remove the now unused adf_disable_arb_thd() function and its
declaration.

Fixes: e2b67859ab6e ("crypto: qat - add heartbeat error simulator")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_common_drv.h     |  1 -
 .../qat/qat_common/adf_heartbeat_inject.c     |  6 ++---
 .../intel/qat/qat_common/adf_hw_arbiter.c     | 25 -------------------
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index a2b9491c26b139..63e1f1c8358e27 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -90,7 +90,6 @@ void adf_exit_aer(void);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
-int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr);
 
 int adf_dev_get(struct adf_accel_dev *accel_dev);
 void adf_dev_put(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
index a3b474bdef6c83..023c5f1e78b075 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
@@ -64,10 +64,8 @@ int adf_heartbeat_inject_error(struct adf_accel_dev *accel_dev)
 	if (ret)
 		return ret;
 
-	/* Configure worker threads to stop processing any packet */
-	ret = adf_disable_arb_thd(accel_dev, rand_ae, rand_thr);
-	if (ret)
-		return ret;
+	/* Disable arbiter to stop processing any packet */
+	hw_device->exit_arb(accel_dev);
 
 	/* Change HB counters memory to simulate a hang */
 	adf_set_hb_counters_fail(accel_dev, rand_ae, rand_thr);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
index f93d9cca70cee4..dd9a31c20bc9c9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
@@ -99,28 +99,3 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 		csr_ops->write_csr_ring_srv_arb_en(csr, i, 0);
 }
 EXPORT_SYMBOL_GPL(adf_exit_arb);
-
-int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr)
-{
-	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	const u32 *thd_2_arb_cfg;
-	struct arb_info info;
-	u32 ae_thr_map;
-
-	if (ADF_AE_STRAND0_THREAD == thr || ADF_AE_STRAND1_THREAD == thr)
-		thr = ADF_AE_ADMIN_THREAD;
-
-	hw_data->get_arb_info(&info);
-	thd_2_arb_cfg = hw_data->get_arb_mapping(accel_dev);
-	if (!thd_2_arb_cfg)
-		return -EFAULT;
-
-	/* Disable scheduling for this particular AE and thread */
-	ae_thr_map = *(thd_2_arb_cfg + ae);
-	ae_thr_map &= ~(GENMASK(3, 0) << (thr * BIT(2)));
-
-	WRITE_CSR_ARB_WT2SAM(csr, info.arb_offset, info.wt2sam_offset, ae,
-			     ae_thr_map);
-	return 0;
-}
-- 
2.53.0



