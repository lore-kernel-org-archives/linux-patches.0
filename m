Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C869431716E;
	Tue, 21 Jul 2026 19:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661520; cv=none; b=cI/TM2EzVY77FfZYzRuLi8WqOxybh8Z8obnyEmUGtDg0pyJpS2Y3gDKVhVU9kBCLNcnkK7MhtU/GatzEj44Wzj5yZJ8AqCjH1tYgOMtS7Zta+0c8lCsW3CaDMnZb3wploM0G2fNflxFBmzrPcThq+YH05ZhUHKF1IuHeOp/G0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661520; c=relaxed/simple;
	bh=CyD2srPFEjyW4HUhGe/yvKni6OEAlmz+ZpE8ZTZuO4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy15887hm6wDy/m9IEi7KTcw5kNqkazvsntm4Xk9nXzSUfXABuuoshBYNPNEr+cyelziHg0Wv8gNBKZetqJ5c7k+JyhMkVimbKAMOYTezjmWQpRu8Jt1FkXoTGO364UU5YWv6hsHSUc0S+kawRQeAE2Vat/yIg1kK7BaTH9N5XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5hx8F41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5hx8F41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351DF1F000E9;
	Tue, 21 Jul 2026 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661518;
	bh=qizm/3WXW4BggC8bi6YB6YBr3hmCV9osIbQ84/AQS4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5hx8F41/foAZKGZmFVqCP4zAepO+8yq34MhgvkaRttFRMT1Mnd03mk1ZEIazLYUm
	 VLIlBnpj2wrDWqSR+6Z1myrw6cqxpkjNlhgm8MdiWnvos72+Dro6JSGiFpyid8dsrJ
	 IvvXZkLNtNLWbIOsfZcl6ndJQB4w9PI6kMo0T6nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0090/1276] crypto: qat - fix heartbeat error injection
Date: Tue, 21 Jul 2026 17:08:53 +0200
Message-ID: <20260721152448.111931630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fc2fea0d3ada7d..971f94e4d87059 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -91,7 +91,6 @@ void adf_exit_aer(void);
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



