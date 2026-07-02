Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA59033A9C4;
	Thu,  2 Jul 2026 16:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009823; cv=none; b=ljy1CebudoL1eQNN5HOUBJ3ImeXTzVN6R8mfBuOp1cdgTnYoTjVSBLVPseZawS9NBm00V6h5gBPofaawuv/dUG5YFXrLzAi8GYOieah/bEGmumF1+2OTWc+C+mJ4Jce3HANs3XICjzm1/ts+hDYjJGlywF24WZ7Jki57iB0wYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009823; c=relaxed/simple;
	bh=eK4HnVILiQjWuL2i5w0IWopR1nM4E84zbmcFPa7B/nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDbIb7SO45Cg54a9lMpc2T46LUlBeQT4RHXYw0/6xHn1dsn5uDKqR1bxJjudqMwM0GzyUWy7xhBpGDcehXKHCfOJgzk03/DHyAV3KIGnScrfW/68+YXv0IKImOWxrsBYpd0J81TKK+weHPB+Qa6EVxKKjEbpI+HLEH68sQpdBOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcOLhZYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcOLhZYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A5E1F00A3D;
	Thu,  2 Jul 2026 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009820;
	bh=zLVat3jzMIZRp0xuX3+HFWfwG2ekvtWbcU49873dioE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcOLhZYAY2TKqpcM+Ta8KdTIvRn5KeOMZZaWqSKNia9SeSS+XVHuOSnvOu8ptgfEs
	 3tYD4r/MAYI/j37ceg9d1t9AmEhcPo2pQ98KrAf7GO9l3oPLYkjYnxAx6ux+p5b3bM
	 WBInJiURyhZOC+WZpuHC0dg3wEhr8nWygf0D9POA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 93/95] crypto: qat - Return pointer directly in adf_ctl_alloc_resources
Date: Thu,  2 Jul 2026 18:20:36 +0200
Message-ID: <20260702155111.166143835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 5ce9891ea928208a915411ce8227f8c3e37e5ad9 ]

Returning values through arguments is confusing and that has
upset the compiler with the recent change to memdup_user:

../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:308:26: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  308 |                  ctl_data->device_id);
      |                          ^~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:294:39: note: ‘ctl_data’ was declared here
  294 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_stop’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:386:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:273:48: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  273 |         ret = adf_ctl_is_device_in_use(ctl_data->device_id);
      |                                        ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:261:39: note: ‘ctl_data’ was declared here
  261 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_config’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:382:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:192:54: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  192 |         accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
      |                                              ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:185:39: note: ‘ctl_data’ was declared here
  185 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~

Fix this by returning the pointer directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: d237230728c5 ("crypto: qat - remove unused character device and IOCTLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   31 +++++++++++-----------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -82,19 +82,14 @@ err_chrdev_unreg:
 	return -EFAULT;
 }
 
-static int adf_ctl_alloc_resources(struct adf_user_cfg_ctl_data **ctl_data,
-				   unsigned long arg)
+static struct adf_user_cfg_ctl_data *adf_ctl_alloc_resources(unsigned long arg)
 {
 	struct adf_user_cfg_ctl_data *cfg_data;
 
 	cfg_data = memdup_user((void __user *)arg, sizeof(*cfg_data));
-	if (IS_ERR(cfg_data)) {
+	if (IS_ERR(cfg_data))
 		pr_err("QAT: failed to copy from user cfg_data.\n");
-		return PTR_ERR(cfg_data);
-	}
-
-	*ctl_data = cfg_data;
-	return 0;
+	return cfg_data;
 }
 
 static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
@@ -173,13 +168,13 @@ out_err:
 static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
 				    unsigned long arg)
 {
-	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
+	int ret = 0;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
 	if (!accel_dev) {
@@ -254,9 +249,9 @@ static int adf_ctl_ioctl_dev_stop(struct
 	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	if (adf_devmgr_verify_id(ctl_data->device_id)) {
 		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
@@ -288,9 +283,9 @@ static int adf_ctl_ioctl_dev_start(struc
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	ret = -ENODEV;
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);


